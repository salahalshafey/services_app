import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../providers/recording_provider.dart';
import '../providers/text_field_filled_color.dart';
import '../widgets/appBar_builder.dart';
import '../widgets/chat_body/chat_body.dart';
import '../widgets/message_sender/audio_sender/record_and_play_voice.dart';
import '../widgets/message_sender/message_sender.dart';

class ChatScreen extends StatelessWidget {
  static const routName = '/chat-screen';

  const ChatScreen({
    required this.orderId,
    required this.otherPersonName,
    required this.otherPersonImage,
    required this.otherPersonPhoneNumber,
    required this.readOnly,
    Key? key,
  }) : super(key: key);

  final String orderId;
  final String otherPersonName;
  final String otherPersonImage;
  final String otherPersonPhoneNumber;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecordingProvider(),
      builder: (ctx, child) {
        return Scaffold(
          appBar: appBarBuilder(
            ctx,
            otherPersonName,
            otherPersonImage,
            otherPersonPhoneNumber,
            readOnly,
          ),
          body: Column(
            children: [
              Expanded(
                child: readOnly
                    ? ChatBodyWithOneTimeRead(
                        orderId,
                        otherPersonImage,
                        otherPersonName,
                      )
                    : Stack(
                        children: [
                          ChatBodyWithRealTimeChanges(
                            orderId,
                            otherPersonImage,
                            otherPersonName,
                          ),
                          const PositionedDirectional(
                            bottom: -50,
                            end: 5,
                            child: LockRecordingContainer(),
                          ),
                        ],
                      ),
              ),
              readOnly
                  ? const _ReadOnlyContainer('This Chat is read only')
                  : Consumer<RecordingProvider>(
                      builder: (ctx, provider, child) {
                      return Stack(
                        children: [
                          MessageSender(orderId),
                          if (provider.recordingFrombottomSheet)
                            RecordingBottomSheet(orderId),
                        ],
                      ) /*provider.recordingFrombottomSheet
                          ? RecordingBottomSheet(orderId)
                          : MessageSender(orderId)*/
                          ;
                    }),
            ],
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

class RecordingBottomSheet extends StatelessWidget {
  const RecordingBottomSheet(this.orderId, {super.key});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      color: getTextFieldFilledColor(context),
      child: RecordAndPlayVoice(orderId),
    );
  }
}

class LockRecordingContainer extends StatelessWidget {
  const LockRecordingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordingProvider>(
      builder: (ctx, provider, child) {
        return AnimatedContainer(
          duration: Durations.short1,
          decoration: BoxDecoration(
            color: getTextFieldFilledColor(ctx),
            borderRadius: BorderRadius.circular(50),
          ),
          height: provider.recordingFromTextField ? 170 : 0,
          width: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Icon(Icons.lock, color: Colors.grey.shade700),
              const SizedBox(height: 20),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Transform.rotate(
                  angle: pi / 2,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.grey.shade400,
                  ),
                ).animate(
                  onPlay: (controller) {
                    controller.loop(reverse: true);
                  },
                ).moveY(end: 5, duration: 400.ms),
              ),
            ],
          ),
        ).animate(
          onPlay: (controller) {
            controller.loop(reverse: true);
          },
        ).scaleY(
          end: 1.05,
          duration: 1.seconds,
          curve: Curves.fastOutSlowIn,
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////
//////////////////////

class _ReadOnlyContainer extends StatelessWidget {
  const _ReadOnlyContainer(
    this.title, {
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      alignment: Alignment.center,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade700
          : Colors.grey.shade300,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
