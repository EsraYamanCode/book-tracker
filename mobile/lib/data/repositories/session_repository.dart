import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

class SessionRepository {
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // 1. Okuma Seansını Kaydetme
  Future<void> createSession({
    required int bookId,
    required int durationSeconds,
    bool isCompleted = false,
  }) async {
    final headers = await _getHeaders();
    final now = DateTime.now().toUtc();
    final start = now.subtract(Duration(seconds: durationSeconds));
    final url = Uri.parse('${ApiConstants.baseUrl}/sessions/book/$bookId/log');

    final body = jsonEncode({
      'durationSeconds': durationSeconds,
      'startTime': start.toIso8601String(),
      'endTime': now.toIso8601String(),
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      // Eğer controller route'u sadece "api" ise bir de /book/$bookId/log deneyelim:
      if (response.statusCode == 404) {
        final fallbackUrl = Uri.parse(
          '${ApiConstants.baseUrl}/book/$bookId/log',
        );
        final fallbackResponse = await http.post(
          fallbackUrl,
          headers: headers,
          body: body,
        );
        if (fallbackResponse.statusCode == 200 ||
            fallbackResponse.statusCode == 201) {
          if (isCompleted) {
            await completeBook(bookId, headers, fallback: true);
          }
          return;
        }
      }

      String message = 'Oturum kaydedilemedi.';
      if (response.body.isNotEmpty) {
        try {
          final error = jsonDecode(response.body);
          message = error['message'] ?? message;
        } catch (_) {}
      }
      throw Exception(message);
    }

    // Kullanıcı "Kitabı tamamen bitirdim" onay kutusunu seçtiyse:
    if (isCompleted) {
      await completeBook(bookId, headers);
    }
  }

  // 2. Kitabı Tamamlandı Olarak İşaretleme
  Future<void> completeBook(
    int bookId,
    Map<String, String> headers, {
    bool fallback = false,
  }) async {
    final path = fallback
        ? '/book/$bookId/complete'
        : '/sessions/book/$bookId/complete';
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}$path'),
      headers: headers,
    );
  }

  // Kitabın oturum istatistiklerini backend'den çeker
  Future<Map<String, dynamic>> getBookStats(int bookId) async {
    final headers = await _getHeaders();

    // 1. Controller sessions altındaysa:
    var url = Uri.parse('${ApiConstants.baseUrl}/sessions/book/$bookId');
    var response = await http.get(url, headers: headers);

    // 2. Eğer controller sadece api altındaysa fallback:
    if (response.statusCode == 404) {
      url = Uri.parse('${ApiConstants.baseUrl}/book/$bookId');
      response = await http.get(url, headers: headers);
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final sessions = data['sessions'] as List<dynamic>?;
      final sessionCount =
          (data['sessionCount'] as int?) ?? (sessions?.length ?? 0);
      final lastSession = (sessions != null && sessions.isNotEmpty)
          ? sessions.first['formattedDuration'] as String? ?? '-'
          : '-';

      return {
        'sessionCount': sessionCount + 1, // Sıradaki oturum numarası (#2 gibi)
        'totalTime': data['formattedTotalTime'] as String? ?? '0 dk',
        'lastSessionTime': lastSession,
      };
    } else {
      throw Exception('Oturum bilgileri alınamadı (${response.statusCode})');
    }
  }
}
