import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

class AuthRepository {
  final _storage = const FlutterSecureStorage();
  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'jwt_token', value: data['token']);
      await _storage.write(key: 'user_email', value: data['email']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Giriş başarısız oldu.');
    }
  }

  Future<void> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'jwt_token', value: data['token']);
      await _storage.write(key: 'user_email', value: data['email']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Kayıt başarısız oldu.');
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }
}
