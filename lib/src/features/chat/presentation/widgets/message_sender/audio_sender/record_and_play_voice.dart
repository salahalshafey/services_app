// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../../core/util/builders/custom_alret_dialog.dart';
import '../../../../../../core/util/functions/date_time_and_duration.dart';

import '../../../../../account/presentation/providers/account.dart';
import '../../../providers/chat.dart';
import '../../../providers/recording_provider.dart';
import '../../../providers/text_field_filled_color.dart';
import 'audio_player.dart';

class RecordAndPlayVoice extends StatefulWidget {
  const RecordAndPlayVoice(this.orderId, {super.key});

  final String orderId;

  @override
  State<RecordAndPlayVoice> createState() => _RecordAndPlayVoiceState();
}

class _RecordAndPlayVoiceState extends State<RecordAndPlayVoice> {
  @override
  void initState() {
    // _initTheRecorder();

    super.initState();
  }

  @override
  void dispose() {
    //  _recorder.closeRecorder();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordingProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        bottom: 10,
        left: 10,
        right: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // recording state or audio player
          StreamBuilder(
            stream: provider.recorderOnProgress,
            builder: (context, snapshot) {
              if (snapshot.hasData & provider.isRecording) {
                final currentDuration =
                    DateTime.now().difference(provider.lastRecordingTime) +
                        provider.lastRecordingDuration;

                final decibelsProgress = provider
                    .getCurrentdecibelsProgress(snapshot.data!.decibels ?? 0);

                return RecordInfo(
                  duration: currentDuration,
                  decibelsProgress: decibelsProgress,
                );
              }

              return provider.recorderFilePath != null
                  ? AudioPlayerWidget(
                      recorderFilePath: provider.recorderFilePath!)
                  : const SizedBox(height: 55);
            },
          ),

          // recorder | pause button and delete recorder button and save button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.ltr,
            children: [
              IconButton(
                onPressed: provider.deleteRecording,
                icon: const Icon(Icons.delete, size: 30),
              )
              /* .animate(
                    target: (provider.recorderFilePath != null &&
                            !provider.isRecording)
                        ? 1
                        : 0,
                  )
                  .scaleXY(begin: 0, end: 1, duration: 250.ms)
                  .fade(begin: 0, end: 1)*/
              ,
              ElevatedButton(
                onPressed: provider.toggoleAudioRecording,
                style: ButtonStyle(
                    fixedSize: const MaterialStatePropertyAll(Size(70, 70)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000))),
                    padding:
                        const MaterialStatePropertyAll(EdgeInsets.all(8.0)),
                    elevation: const MaterialStatePropertyAll(0),
                    backgroundColor: MaterialStatePropertyAll(
                        getTextFieldFilledColor(context))),
                child: AnimatedSwitcher(
                  duration: 300.ms,
                  child: provider.micOrPauseIcon,
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                ),
              ),

              /*  AnimatedSwitcher(
                duration: 300.ms,
                child: IconButton(
                  icon: provider.micOrPauseIcon,
                  onPressed: provider.toggoleAudioRecording,
                ),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
              ),*/
              ElevatedButton(
                onPressed: () async {
                  final path = await provider.stopTheRecorder();

                  final currentUser =
                      Provider.of<Account>(context, listen: false);
                  try {
                    // widget.sendButtonLoadingState(true);
                    await Provider.of<Chat>(context, listen: false)
                        .sendFileMessage(
                      widget.orderId,
                      File(path),
                      'audio',
                      null,
                      currentUser.id,
                    );
                  } catch (error) {
                    // widget.sendButtonLoadingState(false);
                    showCustomAlretDialog(
                      context: context,
                      title: 'Error',
                      titleColor: Colors.red,
                      content: error.toString(),
                    );
                    return;
                  }

                  // widget.sendButtonLoadingState(false);
                },
                child: const Icon(Icons.send),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)))),
                  minimumSize: MaterialStateProperty.all(const Size(55, 55)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/////////////////////// widgets used upove /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

class RecordInfo extends StatelessWidget {
  const RecordInfo(
      {super.key, required this.duration, required this.decibelsProgress});

  final Duration duration;
  final List<double> decibelsProgress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formatedDuration(duration),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Recording",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ).animate(
            onComplete: (controller) {
              controller.repeat(reverse: true);
            },
          ).fade(
            duration: 1.seconds,
            delay: 0.5.seconds,
            begin: 1,
            end: 0,
          ),
          AudioWaveProgress(decibelsProgress: decibelsProgress),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////
////////////////////////////////////////////

class AudioWaveProgress extends StatelessWidget {
  const AudioWaveProgress({super.key, required this.decibelsProgress});

  final List<double> decibelsProgress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 40,
      child: Row(
        textDirection: TextDirection.rtl, // define the direction of the wave
        mainAxisSize: MainAxisSize.min,
        children: decibelsProgress
            .map((decibels) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0.1),
                  width: 0.8,
                  height: decibels < 0 ? 0 : decibels / 2,
                  color: Colors.red,
                ))
            .toList(),
      ),
    );
  }
}
