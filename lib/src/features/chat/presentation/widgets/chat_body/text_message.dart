import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/util/functions/string_manipulations_and_search.dart';
import '../../../../../core/util/widgets/linkify_text.dart';
import 'message_bubble.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({required this.message, required this.date, Key? key})
      : super(key: key);

  final String message;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 130,
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      width: message.length + 100.0,
      padding: const EdgeInsets.only(top: 3, right: 3, left: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableLinkifyText(
            text: message,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14,
            ),
            textDirection: getDirectionalityOf(message),
            linkStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: 15,
            ),
            onOpen: (link, linkType) {
              if (linkType == TextType.phoneNumber) {
                launchUrl(Uri.parse('tel:$link'));
              } else if (linkType == TextType.email) {
                launchUrl(Uri.parse('mailto:$link'));
              } else if (link.startsWith('www.')) {
                launchUrl(
                  Uri.parse('https:$link'),
                  mode: LaunchMode.externalApplication,
                );
              } else {
                launchUrl(
                  Uri.parse(link),
                  mode: LaunchMode.externalApplication,
                );
              }
            },
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.bottomRight,
            child: dateBuilder(date: date, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
