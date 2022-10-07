// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/util/widgets/back_button_with_image.dart';

AppBar appBarBuilder(
  BuildContext context,
  String otherPersonName,
  String otherPersonImage,
  String otherPersonPhoneNumber,
  bool readOnly,
) {
  return AppBar(
    leadingWidth: 80,
    leading: BackButtonWithImage(networkImage: otherPersonImage),
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
