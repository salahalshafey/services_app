import 'package:flutter/material.dart';

extension ListSeperator on List<Widget> {
  List<Widget> verticalSeperateBy(Widget seperator) => map((child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          seperator,
        ],
      )).toList();

  List<Widget> horizontalSeperateBy(Widget seperator) => map((child) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          seperator,
        ],
      )).toList();
}
