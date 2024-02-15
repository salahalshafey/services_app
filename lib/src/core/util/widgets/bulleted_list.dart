import 'package:flutter/material.dart';
import 'text_well_formatted.dart';

class BulletedList extends StatelessWidget {
  const BulletedList({
    super.key,
    this.bullet,
    required this.text,
    this.bulletMargin,
    this.textDirection,
  });

  final Widget? bullet;
  final Widget text;
  final EdgeInsetsGeometry? bulletMargin;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    double charHeight = 14;
    if (text is TextWellFormattedWitouthBulleted) {
      final fontSize = (text as TextWellFormattedWitouthBulleted).fontSize;
      charHeight = "C".charHeight(fontSize);
    }

    if (text is Text) {
      final fontSize = (text as Text).style?.fontSize;
      charHeight = "C".charHeight(fontSize);
    }

    if (text is SelectableText) {
      final fontSize = (text as SelectableText).style?.fontSize;
      charHeight = "C".charHeight(fontSize);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: textDirection,
      children: [
        Padding(
          padding: bulletMargin ??
              EdgeInsets.only(
                right: 10,
                left: 20,
                top: charHeight - 7 < 0 ? 0 : charHeight - 7,
              ),
          child: bullet ??
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
        ),
        Expanded(child: text),
      ],
    );
  }
}

/// calculate the the acual height of the text
///
///

extension on String {
  double charHeight(double? fontSize) {
    // text style that used inside SelectableLinkifyText
    TextStyle textStyle = TextStyle(
      fontSize: fontSize,
    );

    // Create a TextPainter
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: this, style: textStyle),
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
    );

    // Layout constraints, if any
    textPainter.layout();

    return textPainter.height;
  }
}
