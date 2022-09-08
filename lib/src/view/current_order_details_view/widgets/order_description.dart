import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../general_custom_widgets/custom_card.dart';
import '../../general_custom_widgets/general_functions.dart';
import '../../general_custom_widgets/linkify_text.dart';

class OrderDescription extends StatelessWidget {
  const OrderDescription(
    this.description, {
    Key? key,
  }) : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(25),
      elevation: 5,
      onTap: () {},
      child: Column(
        children: [
          Row(
            // textDirection: TextDirection.rtl, // for arabic languge
            children: const [
              Icon(
                Icons.description,
                size: 40,
                color: Colors.green,
              ),
              SizedBox(width: 10),
              Text(
                'Order Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          LinkifyText(
            text: description,
            textDirection: firstCharIsArabic(description)
                ? TextDirection.rtl
                : TextDirection.ltr,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            linkStyle: const TextStyle(
              fontSize: 16,
              color: Colors.blue,
              decoration: TextDecoration.underline,
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
        ],
      ),
    );
  }
}
