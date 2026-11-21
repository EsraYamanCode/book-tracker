import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OpenLibraryService {
  static Future<String?> findCoverUrl(String title, {String? author}) async {
    try {
      var query = 'title=${Uri.encodeComponent(title.trim())}';
      if (author != null && author.trim().isNotEmpty) {
        query += '&author=${Uri.encodeComponent(author.trim())}';
      }

      final res = await http
          .get(Uri.parse('https://openlibrary.org/search.json?$query&limit=3'))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final docs = jsonDecode(res.body)['docs'] as List<dynamic>?;
        if (docs != null && docs.isNotEmpty) {
          for (var doc in docs) {
            final coverId = doc['cover_i'];
            if (coverId != null) {
              return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
            }
          }
        }
      }
      debugPrint('OpenLibrary: kapak bulunamadı veya HTTP ${res.statusCode}');
    } catch (e) {
      debugPrint('OpenLibrary: Hata oluştu: $e');
    }
    return null;
  }
}
