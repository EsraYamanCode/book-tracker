import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService._();
  static final PreferencesService instance = PreferencesService._();

  static const String _keyAmbianceIndex = 'selected_ambiance_index';
  static const String _keyLanguageCode = 'selected_language_code';

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  int get ambianceIndex => _prefs.getInt(_keyAmbianceIndex) ?? 0;

  Future<void> setAmbianceIndex(int index) async {
    await _prefs.setInt(_keyAmbianceIndex, index);
  }

  String get languageCode => _prefs.getString(_keyLanguageCode) ?? 'tr';

  Future<void> setLanguageCode(String code) async {
    await _prefs.setString(_keyLanguageCode, code);
  }
}