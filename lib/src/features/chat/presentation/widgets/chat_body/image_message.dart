import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/util/functions/string_manipulations_and_search.dart';
import '../../../../../core/util/widgets/image_container.dart';
import '../../../../../core/util/widgets/linkify_text.dart';

import 'message_bubble.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    required this.image,
    this.captionOfImage,
    required this.date,
    required this.otherPersonName,
    required this.isMe,
    Key? key,
  }) : super(key: key);

  final String image;
  final String? captionOfImage;
  final DateTime date;
  final String otherPersonName;
  final bool isMe;

  double _dynamicWidth(BuildContext context) {
    if (captionOfImage == null || captionOfImage!.length < 30) {
      return 250;
    }

    final width = captionOfImage!.length * 0.3 + 241.0;
    final maxWidth = MediaQuery.of(context).size.width * 0.8;

    if (width > maxWidth) {
      return maxWidth;
    }
    return width;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _dynamicWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ImageContainer(
                image: image,
                imageSource: From.network,
                radius: _dynamicWidth(context) / 2,
                localStorageType: LocalStorage.applicationDocumentsDirectory,
                fit: BoxFit.cover,
                borderRadius: borderRadiusBuilder(isMe: isMe),
                showHighlight: true,
                showLoadingIndicator: true,
                showImageScreen: true,
                imageTitle: isMe
                    ? 'You\n${dateBuilder(color: Colors.white, date: date).data}'
                    : otherPersonName +
                        '\n${dateBuilder(color: Colors.white, date: date).data}',
                imageCaption: captionOfImage,
              ),
              if (captionOfImage == null)
                Positioned(
                  child: dateBuilder(date: date, color: Colors.white),
                  bottom: 5,
                  right: 5,
                )
            ],
          ),
          if (captionOfImage != null)
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: SelectableLinkifyText(
                text: captionOfImage!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textDirection: firstCharIsArabic(captionOfImage!)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                linkStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
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
            ),
          if (captionOfImage != null)
            Align(
              alignment: Alignment.bottomRight,
              child: dateBuilder(date: date, color: Colors.black54),
            ),
        ],
      ),
    );
  }
}
