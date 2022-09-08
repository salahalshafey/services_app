// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

AppBar appBarBuilder(
  BuildContext context,
  String otherPersonName,
  String otherPersonImage,
  String otherPersonPhoneNumber,
  bool readOnly,
) {
  return AppBar(
    leadingWidth: 80,
    leading: Align(
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              CircleAvatar(backgroundImage: NetworkImage(otherPersonImage)),
            ],
          ),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(4)),
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
          ),
        ),
      ),
    ),
    title: Text(otherPersonName),
    actions: [
      IconButton(
        tooltip: readOnly ? "you can't make a call" : 'Call $otherPersonName',
        onPressed: readOnly
            ? null
            : () {
                launchUrl(Uri.parse('tel:$otherPersonPhoneNumber'));
              },
        icon: Icon(
          Icons.call,
          size: 26,
          color: readOnly ? Colors.white24 : Colors.green,
        ),
      ),
    ],
  );
}
