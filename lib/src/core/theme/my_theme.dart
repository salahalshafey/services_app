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
          backgroundColor: MaterialStatePropertyAll(primaryColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(useMaterial3 ? 20 : 10)),
          ),
          textStyle: const MaterialStatePropertyAll(TextStyle(
            fontSize: 17,
          )),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
          padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(primaryColor),
          textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
            fontSize: 17,
          )),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(useMaterial3 ? 20 : 10)),
          ),
          side: MaterialStatePropertyAll(BorderSide(color: primaryColor)),
          padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: const MaterialStatePropertyAll(TextStyle(
            fontSize: 17,
          )),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(useMaterial3 ? 20 : 10)),
          ),
          foregroundColor: MaterialStatePropertyAll(primaryColor),
          padding: const MaterialStatePropertyAll(
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
          backgroundColor: MaterialStatePropertyAll(primaryColor),
          textStyle: const MaterialStatePropertyAll(TextStyle(
            fontSize: 17,
          )),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(useMaterial3 ? 20 : 10)),
          ),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
          padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(primaryColor),
          textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
            fontSize: 17,
          )),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(useMaterial3 ? 20 : 10)),
          ),
          side: MaterialStatePropertyAll(BorderSide(color: primaryColor)),
          padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: const MaterialStatePropertyAll(TextStyle(
            fontSize: 17,
          )),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(useMaterial3 ? 20 : 10)),
          ),
          foregroundColor: MaterialStatePropertyAll(primaryColor),
          padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
        ),
      ),
    );
  }
}
