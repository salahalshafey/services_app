import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _settingsBox = Hive.box("app_settings");

const _languageCode = "languageCode";
const _themeIsDark = "themeIsDark";
const _color = "color";
const _useMaterial3 = "useMaterial3";

class AppSettings extends ChangeNotifier {
///////////////////////////// Locale //////////////////////////////

  Locale? get currentLocal {
    final languageCode = _settingsBox.get(_languageCode) as String?;
    if (languageCode == null) {
      return null;
    }

    return Locale(languageCode);
  }

  bool currentLanguageIsSameOf(String languageCode) {
    if (currentLocal == null) {
      return false;
    }

    return currentLocal!.languageCode == languageCode;
  }

  void setLanguage(String? languageCode) {
    _settingsBox.put(_languageCode, languageCode);

    notifyListeners();
  }

  ///////////////////////// Theme Mode /////////////////////////

  ThemeMode get themeMode {
    final themeIsDark = _settingsBox.get(_themeIsDark) as bool?;
    if (themeIsDark == null) {
      return ThemeMode.system;
    }

    return themeIsDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool? themeIsDark() {
    if (themeMode == ThemeMode.system) {
      return null;
    }

    return themeMode == ThemeMode.dark;
  }

  void setThemeMode(bool? isDark) {
    _settingsBox.put(_themeIsDark, isDark);

    notifyListeners();
  }

  /////////////////////// Color //////////////////////////////

  Color get currentColor {
    final color = _settingsBox.get(_color) as int?;
    if (color == null) {
      return Colors.blue[900]!;
    }

    return Color(color);
  }

  bool currentColorIsSameOf(Color color) {
    return currentColor.value == color.value;
  }

  void setColor(Color? color) {
    _settingsBox.put(_color, color?.value);

    notifyListeners();
  }

  /////////////////////// material3 //////////////////////////////

  bool get useMaterial3 {
    final material3 = _settingsBox.get(_useMaterial3) as bool?;

    return material3 ?? false;
  }

  void setuseMaterial3(bool? useMaterial3) {
    _settingsBox.put(_useMaterial3, useMaterial3);

    notifyListeners();
  }

  void resetAppSettings() {
    _settingsBox.put(_languageCode, null);
    _settingsBox.put(_themeIsDark, null);
    _settingsBox.put(_color, null);
    _settingsBox.put(_useMaterial3, null);

    notifyListeners();
  }
}
