import 'dart:io';

import 'package:flutter/material.dart';

import 'audio_message_mobile.dart';
import 'audio_message_win.dart';

class AudioMessage extends StatelessWidget {
  const AudioMessage({
    super.key,
    required this.audio,
    required this.date,
    required this.currentUserImage,
    required this.otherPersonImage,
    required this.isMe,
  });

  final String audio;
  final DateTime date;
  final String currentUserImage;
  final String otherPersonImage;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return AudioMessageMobile(
        audio: audio,
        date: date,
        currentUserImage: currentUserImage,
        otherPersonImage: otherPersonImage,
        isMe: isMe,
      );
    }

    return AudioMessageWin(
      audio: audio,
      date: date,
      currentUserImage: currentUserImage,
      otherPersonImage: otherPersonImage,
      isMe: isMe,
    );
  }
}
