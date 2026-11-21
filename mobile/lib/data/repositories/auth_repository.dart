import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final ApiClient _client;
  final _storage = const FlutterSecureStorage();
  final _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: ApiConstants.googleClientId,
  );

  AuthRepository(this._client);

  Future<void> login(String email, String password) async {
    final data = await _client.post(ApiConstants.login, {
      'email': email,
      'password': password,
    }, withAuth: false);
    await _storage.write(key: 'jwt_token', value: data['token']);
    await _storage.write(key: 'user_email', value: data['email']);
  }

  Future<void> register(String email, String password) async {
    final data = await _client.post(ApiConstants.register, {
      'email': email,
      'password': password,
    }, withAuth: false);
    await _storage.write(key: 'jwt_token', value: data['token']);
    await _storage.write(key: 'user_email', value: data['email']);
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _storage.deleteAll();
  }

  Future<void> deleteAccount() async {
    await _client.delete(ApiConstants.deleteAccount);
    await _storage.delete(key: 'jwt_token');
  }

  Future<String?> getToken() async => _storage.read(key: 'jwt_token');

  Future<String?> getEmail() async => _storage.read(key: 'user_email');

  Future<String?> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return null; // Kullanıcı pencereyi kapattı

    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) {
      throw ApiException(
        'Google idToken alınamadı. serverClientId (Web Client ID) doğru mu?',
      );
    }
    return idToken;
  }

  Future<void> loginWithGoogle(String idToken) async {
    final data = await _client.post(ApiConstants.googleLogin, {
      'idToken': idToken,
    }, withAuth: false);
    await _storage.write(key: 'jwt_token', value: data['token']);
    await _storage.write(key: 'user_email', value: data['email']);
  }
}
