import 'dart:io';

class ApiConstants {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5113/api';
    }
    return 'http://localhost:5113/api';
  }

  static const String register = '/Auth/register';
  static const String login = '/Auth/login';
  static const String books = '/Books';
  static const String sessions = '/Sessions';
}
