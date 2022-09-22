import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class LinkifyText extends StatelessWidget {
  const LinkifyText({
    required this.text,
    required this.style,
    required this.textAlign,
    required this.textDirection,
    required this.linkStyle,
    required this.onOpen,
    Key? key,
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextDirection textDirection;
  final TextStyle linkStyle;
  final void Function(String link, TextType linkType) onOpen;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: getLinksInText(text).map((inlineText) {
          if (inlineText.second == TextType.normal) {
            return TextSpan(
              text: inlineText.first,
              style: style,
            );
          } else {
            return TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => onOpen(inlineText.first, inlineText.second),
              text: inlineText.first,
              style: linkStyle,
            );
          }
        }).toList(),
      ),
      textAlign: textAlign,
      textDirection: textDirection,
    );
  }
}

class SelectableLinkifyText extends StatelessWidget {
  const SelectableLinkifyText({
    required this.text,
    required this.style,
    this.textAlign,
    required this.textDirection,
    required this.linkStyle,
    required this.onOpen,
    Key? key,
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextDirection textDirection;
  final TextStyle linkStyle;
  final void Function(String link, TextType linkType) onOpen;

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: getLinksInText(text).map((inlineText) {
          if (inlineText.second == TextType.normal) {
            return TextSpan(
              text: inlineText.first,
              style: style,
            );
          } else {
            return TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => onOpen(inlineText.first, inlineText.second),
              text: inlineText.first,
              style: linkStyle,
            );
          }
        }).toList(),
      ),
      textAlign: textAlign,
      textDirection: textDirection,
    );
  }
}

List<Pair<String, TextType>> getLinksInText(String text) {
  final urlMatcher = RegExp(
      r"(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})");
  final emailMatcher = RegExp(r"[a-z0-9]+@[a-z]+\.[a-z]{2,3}");
  final egyptPhoneNumberMatcher = RegExp(r"01[0125][0-9]{8}");

  List<Pair<Match, TextType>> allMatches = [];
  String myText = text;

  final urlMatches = urlMatcher
      .allMatches(myText)
      .map((urlMatch) => Pair(urlMatch, TextType.url));
  allMatches.addAll(urlMatches);
  myText = myText.replaceAllMapped(
      urlMatcher, (match) => ''.padLeft(match.end - match.start));

  final emailMatches = emailMatcher
      .allMatches(myText)
      .map((emailMatch) => Pair(emailMatch, TextType.email));
  allMatches.addAll(emailMatches);
  myText = myText.replaceAllMapped(
      emailMatcher, (match) => ''.padLeft(match.end - match.start));

  final phoneMatches = egyptPhoneNumberMatcher
      .allMatches(myText)
      .map((phoneMatch) => Pair(phoneMatch, TextType.phoneNumber));
  allMatches.addAll(phoneMatches);

  allMatches.sort((p1, p2) => p1.first.start.compareTo(p2.first.start));

  List<Pair<String, TextType>> links = [];
  int i = 0;
  for (final match in allMatches) {
    links.add(Pair(
      text.substring(i, match.first.start),
      TextType.normal,
    ));
    links.add(Pair(
      text.substring(match.first.start, match.first.end),
      match.second,
    ));
    i = match.first.end;
  }
  links.add(Pair(
    text.substring(i),
    TextType.normal,
  ));

  return links;
}

class Pair<T1, T2> {
  Pair(this.first, this.second);

  T1 first;
  T2 second;

  @override
  String toString() {
    return 'Pair($first, $second)';
  }

  @override
  bool operator ==(Object other) {
    if (other is Pair) {
      return first == other.first && second == other.second;
    }
    return false;
  }

  @override
  int get hashCode => '$first$second'.hashCode;
}

enum TextType {
  url,
  phoneNumber,
  email,
  normal,
}
