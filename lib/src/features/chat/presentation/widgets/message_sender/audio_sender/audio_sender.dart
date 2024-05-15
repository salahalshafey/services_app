import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../../../account/presentation/providers/account.dart';
import '../../../providers/chat.dart';

import '../../../../../../core/util/builders/custom_alret_dialog.dart';
import '../../../../../../core/util/builders/custom_snack_bar.dart';
import '../../../providers/recording_provider.dart';

class AudioSender extends StatefulWidget {
  const AudioSender(this.orderId, this.sendButtonLoadingState, {Key? key})
      : super(key: key);

  final String orderId;
  final void Function(bool state) sendButtonLoadingState;

  @override
  State<AudioSender> createState() => _AudioSenderState();
}

class _AudioSenderState extends State<AudioSender> {
  late RecordingProvider provider;

  bool _isDeleted = false;
  //bool _isContinueRecordingFromBottomSheet = false;

  @override
  void didChangeDependencies() {
    provider = Provider.of<RecordingProvider>(context, listen: false);

    provider.initTheRecorder(context);

    super.didChangeDependencies();
  }

  Future<void> _startTheRecorder() async {
    _isDeleted = false;
    provider.startTheRecorder();

    provider.recordingFromTextField = true;
  }

  Future<void> _stopAndSendTheRecorder() async {
    if (_isDeleted || provider.recordingFrombottomSheet) {
      return;
    }

    final path = await provider.stopTheRecorder();

    final currentUser = Provider.of<Account>(context, listen: false);
    try {
      widget.sendButtonLoadingState(true);
      await Provider.of<Chat>(context, listen: false).sendFileMessage(
        widget.orderId,
        File(path),
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
    provider.closeTheRecorder();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<RecordingProvider>(context);

    return GestureDetector(
      onLongPressMoveUpdate: (details) {
        // trigger to continue recording on dialog
        if (details.localPosition.dy < -100 && !_isDeleted) {
          provider.recordingFrombottomSheet = true;

          // trigger to delete the recording
        } else if (details.localPosition.dx < -150 ||
            details.localPosition.dx > 150) {
          _isDeleted = true;
          provider.deleteRecording();
        }
      },
      onLongPress: _startTheRecorder,
      onLongPressEnd: (_) => _stopAndSendTheRecorder(),
      child: ElevatedButton(
        onPressed: () {
          showCustomSnackBar(
            context: context,
            content: 'Hold to record, release to send.',
            snackBarCenterd: false,
          );
        },
        child: const Icon(Icons.keyboard_voice),
        style: const ButtonStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)))),
          minimumSize: WidgetStatePropertyAll(Size(55, 55)),
        ),
      )
          .animate(target: provider.recordingFromTextField ? 1 : 0)
          .scaleXY(begin: 1, end: 1.7, duration: 50.ms),
    );
  }
}
