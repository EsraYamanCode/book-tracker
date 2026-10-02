import 'package:sayfa/core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/book_model.dart';

class BookRepository {
  final ApiClient _client;
  BookRepository(this._client);

  Future<List<BookModel>> getBooks() async {
    final data = await _client.get(ApiConstants.books) as List<dynamic>;
    return data.map((item) => BookModel.fromJson(item)).toList();
  }

  Future<BookModel> createBook({
    required String title,
    required String author,
    required String coverColorHex,
    String? coverImageUrl,
  }) async {
    final data = await _client.post(ApiConstants.books, {
      'title': title,
      'author': author,
      'coverColorHex': coverColorHex,
      'coverImageUrl': coverImageUrl,
    });
    return BookModel.fromJson(data);
  }

  Future<void> deleteBook(int bookId) =>
      _client.delete('${ApiConstants.books}/$bookId');
}
