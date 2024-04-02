import 'package:flutter/material.dart';

Color getTextFieldFilledColor(BuildContext context) {
  final useMaterial3 = Theme.of(context).useMaterial3;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  if (useMaterial3 && isDark) {
    return const Color.fromRGBO(68, 70, 78, 1);
  }

  if (!useMaterial3 && isDark) {
    return const Color.fromRGBO(68, 68, 68, 1);
  }

  if (useMaterial3 && !isDark) {
    return const Color.fromRGBO(225, 226, 236, 1);
  }

  if (!useMaterial3 && !isDark) {}
  return const Color.fromRGBO(240, 240, 240, 1);
}
