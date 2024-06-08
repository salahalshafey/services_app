import 'package:flutter/material.dart';

import '../../../../../core/util/functions/date_time_and_duration.dart';

import 'audio_message/audio_message.dart';
import 'image_message.dart';
import 'location_message.dart';
import 'text_message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
    this.message,
    this.date,
    this.currentUserImage,
    this.otherPersonImage,
    this.otherPersonName,
    this.messageType,
    this.captionOfImage,
    this.isMe, {
    Key? key,
  }) : super(key: key);

  final String message;
  final DateTime date;
  final String currentUserImage;
  final String otherPersonImage;
  final String otherPersonName;
  final String messageType;
  final String? captionOfImage;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: !isMe
                ? Theme.of(context).primaryColor
                : Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
            borderRadius: borderRadiusBuilder(isMe: isMe),
          ),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: <Widget>[
              if (messageType == 'text')
                TextMessage(
                  message: message,
                  date: date,
                ),
              if (messageType == 'image')
                ImageMessage(
                  image: message,
                  captionOfImage: captionOfImage,
                  date: date,
                  otherPersonName: otherPersonName,
                  isMe: isMe,
                ),
              if (messageType == 'location')
                LocationMessage(
                  location: message,
                  geoCodingData: captionOfImage,
                  date: date,
                  isMe: isMe,
                ),
              if (messageType == 'audio')
                AudioMessage(
                  key: Key(message),
                  audio: message,
                  date: date,
                  currentUserImage: currentUserImage,
                  otherPersonImage: otherPersonImage,
                  isMe: isMe,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Text dateBuilder({required DateTime date, required Color color}) {
  return Text(
    formatedDate(date) + ', ' + time24To12HoursFormat(date),
    style: TextStyle(
      color: color,
      fontSize: 12,
    ),
    textAlign: TextAlign.end,
  );
}

BorderRadiusDirectional borderRadiusBuilder({required bool isMe}) {
  return BorderRadiusDirectional.only(
    topStart: const Radius.circular(20),
    topEnd: const Radius.circular(20),
    bottomStart: !isMe ? const Radius.circular(0) : const Radius.circular(20),
    bottomEnd: isMe ? const Radius.circular(0) : const Radius.circular(20),
  );
}
