import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

import '../../../../../core/util/functions/general_functions.dart';

import 'message_bubble.dart';

class AudioMessage extends StatefulWidget {
  const AudioMessage({
    required this.audio,
    required this.date,
    required this.currentUserImage,
    required this.otherPersonImage,
    required this.isMe,
    Key? key,
  }) : super(key: key);

  final String audio;
  final DateTime date;
  final String currentUserImage;
  final String otherPersonImage;
  final bool isMe;

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  final audioPlayer = AudioPlayer();

  late StreamSubscription<PlayerState> playerStateSubscription;
  late StreamSubscription<void> onPlayerCompleteSubscription;
  late StreamSubscription<Duration> durationChangedSubscription;
  late StreamSubscription<Duration> positionChangeSubscription;
  late StreamSubscription<int> proximitySensorSubscription;

  final color = Colors.grey.shade800;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double playbackRate = 1;

  void togglePlaybackRate() {
    if (playbackRate == 1) {
      audioPlayer.setPlaybackRate(1.5);
      setState(() {
        playbackRate = 1.5;
      });
    } else if (playbackRate == 1.5) {
      audioPlayer.setPlaybackRate(2);
      setState(() {
        playbackRate = 2;
      });
    } else {
      audioPlayer.setPlaybackRate(1);
      setState(() {
        playbackRate = 1;
      });
    }
  }

  @override
  void initState() {
    audioPlayer.setSourceUrl(widget.audio);

    playerStateSubscription = audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    onPlayerCompleteSubscription = audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        position = Duration.zero;
        isPlaying = false;
      });
    });

    durationChangedSubscription =
        audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    positionChangeSubscription =
        audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    listenSensor();

    super.initState();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    proximitySensorSubscription = ProximitySensor.events.listen((int event) {
      if (event > 0) /*isNear */ {
        isSpeakerOn(false);
      } else {
        isSpeakerOn(true);
      }
    });
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    onPlayerCompleteSubscription.cancel();
    durationChangedSubscription.cancel();
    positionChangeSubscription.cancel();
    proximitySensorSubscription.cancel();

    audioPlayer.dispose();
    super.dispose();
  }

  void isSpeakerOn(bool state) {
    audioPlayer.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(
          isSpeakerphoneOn: state,
          contentType: AndroidContentType.speech,
          stayAwake: true,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.gain,
        ),
        iOS: AudioContextIOS(
          defaultToSpeaker: state,
          category: AVAudioSessionCategory.playAndRecord,
          options: [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.isMe && isPlaying)
            TogglePlaybackRateButton(
              playbackRate: playbackRate,
              togglePlaybackRate: togglePlaybackRate,
              color: color,
            ),
          if (widget.isMe && !isPlaying)
            CircleAvatar(
              backgroundImage: AssetImage(widget.currentUserImage),
              radius: 23,
            ),
          IconButton(
            color: color,
            onPressed: () async {
              if (isPlaying) {
                await audioPlayer.pause();
              } else {
                await audioPlayer.resume();
              }
            },
            splashRadius: 5,
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 40),
          ),
          Stack(
            children: [
              Slider(
                inactiveColor: Colors.grey.shade400,
                activeColor: color,
                thumbColor: color,
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  await audioPlayer.seek(Duration(seconds: value.toInt()));
                  await audioPlayer.resume();
                },
              ),
              Positioned(
                left: 25,
                bottom: 0,
                child: Text(formatedDuration(isPlaying ? position : duration)),
              ),
              Positioned(
                right: 3,
                bottom: 0,
                child: dateBuilder(date: widget.date, color: Colors.black54),
              ),
            ],
          ),
          if (!widget.isMe && isPlaying)
            TogglePlaybackRateButton(
              playbackRate: playbackRate,
              togglePlaybackRate: togglePlaybackRate,
              color: color,
            ),
          if (!widget.isMe && !isPlaying)
            CircleAvatar(
              backgroundImage: NetworkImage(widget.otherPersonImage),
              radius: 23,
            ),
        ],
      ),
    );
  }
}

class TogglePlaybackRateButton extends StatelessWidget {
  const TogglePlaybackRateButton({
    required this.playbackRate,
    required this.togglePlaybackRate,
    required this.color,
    Key? key,
  }) : super(key: key);
  final double playbackRate;
  final void Function() togglePlaybackRate;
  final Color color;

  String get playingRate {
    if (playbackRate == 1 || playbackRate == 2) {
      return playbackRate.toInt().toString() + '×';
    }
    return playbackRate.toString() + '×';
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: togglePlaybackRate,
      child: Text(
        playingRate,
        style: const TextStyle(fontSize: 14),
      ),
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(color),
        minimumSize: MaterialStateProperty.all(const Size(50, 30)),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        shape: MaterialStateProperty.all(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)))),
      ),
    );
  }
}
