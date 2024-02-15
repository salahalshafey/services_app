import 'package:flutter/material.dart';

/// snackBar that showen on the center or bottom of screen with grey opacity color
void showCustomSnackBar({
  required BuildContext context,
  required String content,
  int durationInSec = 4,
  bool snackBarCenterd = true,
  TextAlign textAlign = TextAlign.center,
}) {
  final screenHeight = MediaQuery.of(context).size.height;

  final distanceFromBottom = (screenHeight - 50) / 2;
  final distanceFromLeftOrRight =
      (MediaQuery.of(context).size.width - _widthOfSnackBar(content)) / 2;

  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      key: UniqueKey(),
      duration: Duration(seconds: durationInSec),
      content: Text(
        content,
        textAlign: textAlign,
        style: const TextStyle(color: Colors.black),
      ),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      margin: EdgeInsets.only(
        bottom: snackBarCenterd ? distanceFromBottom : 0.0,
        left: distanceFromLeftOrRight,
        right: distanceFromLeftOrRight,
      ),
      padding: const EdgeInsets.all(12),
      dismissDirection: DismissDirection.none,
      backgroundColor: Colors.grey.shade300.withOpacity(0.9),
    ),
  );
}

void showMySnackBar({
  required BuildContext context,
  required String content,
  int? durationInSec,
  SnackBarAction? action,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      key: UniqueKey(),
      duration: Duration(seconds: durationInSec ?? 4),
      content: Text(content),
      action: action,
    ),
  );
}

double _widthOfSnackBar(String content) {
  final width = content.length * 8.5;

  if (width < 100) {
    return 100;
  }
  if (width > 300) {
    return 300;
  }
  return width;
}
