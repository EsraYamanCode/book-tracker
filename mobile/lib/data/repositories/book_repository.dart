import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import 'dart:convert';
import '../models/book_model.dart';

class BookRepository {
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<BookModel>> getBooks() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.books}'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => BookModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Kitaplar yüklenirken bir hata oluştu.');
    }
  }

  Future<BookModel> createBook({
    required String title,
    required String author,
    required String coverColorHex,
  }) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.books}'),
      headers: headers,
      body: jsonEncode({
        'title': title,
        'author': author,
        'coverColorHex': coverColorHex,
      }),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return BookModel.fromJson(data as Map<String, dynamic>);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Kitap eklenemedi.');
    }
  }

  Future<void> deleteBook(int bookId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.books}/$bookId'),
      headers: headers,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Kitap silinemedi.');
    }
  }
}
