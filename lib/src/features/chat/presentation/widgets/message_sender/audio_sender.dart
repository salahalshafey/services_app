import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../account/presentation/providers/account.dart';
import '../../providers/chat.dart';

import '../../../../../core/util/builders/custom_alret_dialog.dart';
import '../../../../../core/util/builders/custom_snack_bar.dart';

class AudioSender extends StatefulWidget {
  const AudioSender(this.orderId, this.sendButtonLoadingState, {Key? key})
      : super(key: key);

  final String orderId;
  final void Function(bool state) sendButtonLoadingState;

  @override
  State<AudioSender> createState() => _AudioSenderState();
}

class _AudioSenderState extends State<AudioSender> {
  final recorder = FlutterSoundRecorder();

  @override
  void initState() {
    initTheRecorder();
    super.initState();
  }

  Future<void> initTheRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      showCustomSnackBar(
        context: context,
        content: 'We need microphone permission to send the recorder.',
      );
      return;
    }

    await recorder.openRecorder();
  }

  Future<void> startTheRecorder() async {
    await recorder.startRecorder(
      toFile: 'audio.aac',
    );
  }

  Future<void> stopAndSendTheRecorder() async {
    final path = await recorder.stopRecorder();

    final currentUser = Provider.of<Account>(context, listen: false);
    try {
      widget.sendButtonLoadingState(true);
      await Provider.of<Chat>(context, listen: false).sendFileMessage(
        widget.orderId,
        File(path!),
        'audio',
        null,
        currentUser.id,
      );
    } catch (error) {
      widget.sendButtonLoadingState(false);
      showCustomAlretDialog(
        context: context,
        title: 'Error',
        titleColor: Colors.red,
        content: error.toString(),
      );
      return;
    }

    widget.sendButtonLoadingState(false);
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressMoveUpdate: (details) {
        details.localPosition;
      },
      onLongPress: startTheRecorder,
      onLongPressEnd: (_) => stopAndSendTheRecorder(),
      child: ElevatedButton(
        onPressed: () {
          showCustomSnackBar(
            context: context,
            content: 'Hold to record, release to send.',
            snackBarCenterd: false,
          );
        },
        child: const Icon(Icons.keyboard_voice),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)))),
          minimumSize: MaterialStateProperty.all(const Size(55, 55)),
        ),
      ),
    );
  }
}
