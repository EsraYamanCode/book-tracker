import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class ApiClient {
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (withAuth) {
      final token = await _storage.read(key: 'jwt_token');
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Uri _uri(String path) => Uri.parse('${ApiConstants.baseUrl}$path');

  dynamic _decodeOrThrow(http.Response response, {List<int> okCodes = const [200, 201]}) {
    if (okCodes.contains(response.statusCode)) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    }
    String message = 'Bir hata oluştu.';
    if (response.body.isNotEmpty) {
      try {
        final error = jsonDecode(response.body);
        message = error['message'] ?? message;
      } catch (_) {}
    }
    throw ApiException(message);
  }

  Future<dynamic> get(String path) async {
    final response = await http.get(_uri(path), headers: await _headers());
    return _decodeOrThrow(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body, {bool withAuth = true}) async {
    final response = await http.post(_uri(path), headers: await _headers(withAuth: withAuth), body: jsonEncode(body));
    return _decodeOrThrow(response);
  }

  Future<void> delete(String path) async {
    final response = await http.delete(_uri(path), headers: await _headers());
    _decodeOrThrow(response, okCodes: [200, 204]);
  }
}