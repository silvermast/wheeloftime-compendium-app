import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _keyRememberBook = 'remember_last_book';
  static const String _keyLastBookId = 'last_book_id';

  SettingsService._();

  static final SettingsService instance = SettingsService._();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setRememberLastSelectedBook(bool value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(_keyRememberBook, value);
  }

  Future<bool> getRememberLastSelectedBook() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(_keyRememberBook) ?? false;
  }

  Future<void> setLastSelectedBookId(String? value) async {
    final SharedPreferences prefs = await _prefs;
    if (value == null) {
      await prefs.remove(_keyLastBookId);
    } else {
      await prefs.setString(_keyLastBookId, value);
    }
  }

  Future<String?> getLastSelectedBookId() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_keyLastBookId);
  }
}