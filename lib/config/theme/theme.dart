import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType{
  light,
  dark
}

class AppTheme {
  late SharedPreferences preferences;
  late final ThemeData lightTheme;
  late final ThemeData darkTheme;
  static late ThemeData currentTheme;

  Future<AppTheme> init(SharedPreferences preferences) async {
    this.preferences = preferences;
    final lightThemStr = await rootBundle.loadString("assets/themes/light_theme.json");
    final lightThemeJson = jsonDecode(lightThemStr);
    final darkThemeStr = await rootBundle.loadString("assets/themes/dark_theme.json");
    final darkThemeJson = jsonDecode(darkThemeStr);
    lightTheme = ThemeDecoder.decodeThemeData(lightThemeJson)!;
    darkTheme = ThemeDecoder.decodeThemeData(darkThemeJson)!;

    return this;
  }

  void initCurrentTheme(ThemeData theme){
    currentTheme = theme;
  }

  void saveTheme(ThemeType type) {
    preferences.setString("theme", type.name);
  }

  ThemeType getTheme() {
    String? theme = preferences.getString("theme");
    if (theme == null) {
      return ThemeType.light;
    }
    if(theme == ThemeType.dark.name){
      return ThemeType.dark;
    }
    if(theme == ThemeType.light.name){
      return ThemeType.light;
    }
    return ThemeType.light;
  }
}