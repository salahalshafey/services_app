import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../classes/pair_class.dart';

class LinkifyText extends StatefulWidget {
  const LinkifyText({
    required this.text,
    required this.style,
    required this.textAlign,
    required this.textDirection,
    required this.linkStyle,
    required this.onOpen,
    super.key,
  });

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextDirection textDirection;
  final TextStyle linkStyle;
  final void Function(String link, TextType linkType) onOpen;

  @override
  State<LinkifyText> createState() => _LinkifyTextState();
}

class _LinkifyTextState extends State<LinkifyText> {
  int? _enteredSpanIndex;

  TapGestureRecognizer _customTapGestureRecognizerOf(int enteredSpanIndex) {
    return TapGestureRecognizer()
      ..onTapDown = (details) {
        setState(() {
          _enteredSpanIndex = enteredSpanIndex;
        });
      }
      ..onTapCancel = () {
        setState(() {
          _enteredSpanIndex = null;
        });
      }
      ..onTapUp = (_) {
        setState(() {
          _enteredSpanIndex = null;
        });
      };
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;

    return Text.rich(
      TextSpan(
        children: getLinksInText(widget.text).map((inlineText) {
          final currentSpanIndex = i++;

          if (inlineText.second == TextType.url) {
            return TextSpan(
              recognizer: _customTapGestureRecognizerOf(currentSpanIndex)
                ..onTap =
                    () => widget.onOpen(inlineText.first, inlineText.second),
              text: inlineText.first,
              style: widget.linkStyle.copyWith(
                backgroundColor: _enteredSpanIndex == currentSpanIndex
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.5)
                    : null,
              ),
            );
          }

          if (inlineText.second == TextType.email) {
            return TextSpan(
              recognizer: _customTapGestureRecognizerOf(currentSpanIndex)
                ..onTap =
                    () => widget.onOpen(inlineText.first, inlineText.second),
              text: inlineText.first,
              style: widget.linkStyle.copyWith(
                backgroundColor: _enteredSpanIndex == currentSpanIndex
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.5)
                    : null,
              ),
            );
          }

          if (inlineText.second == TextType.phoneNumber) {
            return TextSpan(
              recognizer: _customTapGestureRecognizerOf(currentSpanIndex)
                ..onTap =
                    () => widget.onOpen(inlineText.first, inlineText.second),
              text: inlineText.first,
              style: widget.linkStyle.copyWith(
                backgroundColor: _enteredSpanIndex == currentSpanIndex
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.5)
                    : null,
              ),
            );
          }

          return TextSpan(
            text: inlineText.first,
            style: widget.style,
          );
        }).toList(),
      ),
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
    );
  }
}

class SelectableLinkifyText extends StatefulWidget {
  const SelectableLinkifyText({
    required this.text,
    required this.style,
    this.textAlign,
    required this.textDirection,
    required this.linkStyle,
    required this.onOpen,
    super.key,
  });

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextDirection textDirection;
  final TextStyle linkStyle;
  final void Function(String link, TextType linkType) onOpen;

  @override
  State<SelectableLinkifyText> createState() => _SelectableLinkifyTextState();
}

class _SelectableLinkifyTextState extends State<SelectableLinkifyText> {
  int? _enteredSpanIndex;

  TapGestureRecognizer _customTapGestureRecognizerOf(int enteredSpanIndex) {
    return TapGestureRecognizer()
      ..onTapDown = (details) {
        setState(() {
          _enteredSpanIndex = enteredSpanIndex;
        });
      }
      ..onTapCancel = () {
        setState(() {
          _enteredSpanIndex = null;
        });
      }
      ..onTapUp = (_) {
        setState(() {
          _enteredSpanIndex = null;
        });
      };
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;

    return SelectableText.rich(
      TextSpan(
        children: getLinksInText(widget.text).map((inlineText) {
          final currentSpanIndex = i++;

          if (inlineText.second == TextType.url) {
            return TextSpan(
              recognizer: _customTapGestureRecognizerOf(currentSpanIndex)
                ..onTap =
                    () => widget.onOpen(inlineText.first, inlineText.second),
              text: inlineText.first,
              style: widget.linkStyle.copyWith(
                backgroundColor: _enteredSpanIndex == currentSpanIndex
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.5)
                    : null,
              ),
            );
          }

          if (inlineText.second == TextType.email) {
            return TextSpan(
              recognizer: _customTapGestureRecognizerOf(currentSpanIndex)
                ..onTap =
                    () => widget.onOpen(inlineText.first, inlineText.second),
              text: inlineText.first,
              style: widget.linkStyle.copyWith(
                backgroundColor: _enteredSpanIndex == currentSpanIndex
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.5)
                    : null,
              ),
            );
          }

          if (inlineText.second == TextType.phoneNumber) {
            return TextSpan(
              recognizer: _customTapGestureRecognizerOf(currentSpanIndex)
                ..onTap =
                    () => widget.onOpen(inlineText.first, inlineText.second),
              text: inlineText.first,
              style: widget.linkStyle.copyWith(
                backgroundColor: _enteredSpanIndex == currentSpanIndex
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.5)
                    : null,
              ),
            );
          }

          return TextSpan(
            text: inlineText.first,
            style: widget.style,
          );
        }).toList(),
      ),
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
    );
  }
}

List<Pair<String, TextType>> getLinksInText(String text) {
  final urlMatcher = RegExp(
      r"(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})");
  final emailMatcher =
      RegExp(r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,3}");
  final phoneNumberMatcher = RegExp(
      r"(\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{2,3}\)?[\s.-]?\d{3,4}[\s.-]?\d{3,5}");

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

  final phoneMatches = phoneNumberMatcher
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

enum TextType {
  url,
  phoneNumber,
  email,
  normal,
}
