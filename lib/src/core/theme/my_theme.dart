import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData light(Color primaryColor, {required bool useMaterial3}) {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: primaryColor,
      ),
      useMaterial3: useMaterial3,
      appBarTheme: AppBarTheme(
        color: primaryColor,
        foregroundColor: Colors.white,
      ),
      iconTheme: IconThemeData(color: primaryColor),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(primaryColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(useMaterial3 ? 20 : 10)),
          ),
          textStyle: const WidgetStatePropertyAll(TextStyle(
            fontSize: 17,
          )),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(primaryColor),
          textStyle: const WidgetStatePropertyAll(TextStyle(
            fontSize: 17,
          )),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(useMaterial3 ? 20 : 10)),
          ),
          side: WidgetStatePropertyAll(BorderSide(color: primaryColor)),
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: const WidgetStatePropertyAll(TextStyle(
            fontSize: 17,
          )),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(useMaterial3 ? 20 : 10)),
          ),
          foregroundColor: WidgetStatePropertyAll(primaryColor),
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
        ),
      ),
    );
  }

  static ThemeData dark(Color primaryColor, {required bool useMaterial3}) {
    return ThemeData.dark(useMaterial3: useMaterial3).copyWith(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: primaryColor,
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      iconTheme: IconThemeData(color: primaryColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(primaryColor),
          textStyle: const WidgetStatePropertyAll(TextStyle(
            fontSize: 17,
          )),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(useMaterial3 ? 20 : 10)),
          ),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(primaryColor),
          textStyle: const WidgetStatePropertyAll<TextStyle>(TextStyle(
            fontSize: 17,
          )),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(useMaterial3 ? 20 : 10)),
          ),
          side: WidgetStatePropertyAll(BorderSide(color: primaryColor)),
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: const WidgetStatePropertyAll(TextStyle(
            fontSize: 17,
          )),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(useMaterial3 ? 20 : 10)),
          ),
          foregroundColor: WidgetStatePropertyAll(primaryColor),
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
        ),
      ),
    );
  }
}
