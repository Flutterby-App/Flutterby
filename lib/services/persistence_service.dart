import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  static const _keySelectedWidget = 'flutterby_selected_widget';
  static const _keyThemeMode = 'flutterby_theme_dark';
  static const _keyPropertyValues = 'flutterby_property_values';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Selected widget ---

  static String? getSelectedWidget() {
    return _prefs?.getString(_keySelectedWidget);
  }

  static Future<void> setSelectedWidget(String id) async {
    await _prefs?.setString(_keySelectedWidget, id);
  }

  // --- Theme ---

  static bool? getIsDark() {
    return _prefs?.getBool(_keyThemeMode);
  }

  static Future<void> setIsDark(bool isDark) async {
    await _prefs?.setBool(_keyThemeMode, isDark);
  }

  // --- Property values ---

  static Map<String, Map<String, dynamic>>? getPropertyValues() {
    final json = _prefs?.getString(_keyPropertyValues);
    if (json == null) return null;
    try {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      return decoded.map(
        (key, value) => MapEntry(key, Map<String, dynamic>.from(value as Map)),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> setPropertyValues(
    Map<String, Map<String, dynamic>> values,
  ) async {
    final json = jsonEncode(values);
    await _prefs?.setString(_keyPropertyValues, json);
  }
}
