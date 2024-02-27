import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

import '../../../../../core/util/functions/date_time_and_duration.dart';
import 'message_bubble.dart';

class AudioMessage extends StatefulWidget {
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
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
  late StreamSubscription<PlaybackDisposition> _playerStateSubscription;

  final color = Colors.grey.shade800;
  bool _isStarted = false;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackRate = 1;

  @override
  void didChangeDependencies() {
    _initTheAudioPlayer();

    super.didChangeDependencies();
  }

  Future<void> _initTheAudioPlayer() async {
    await _audioPlayer.openPlayer();
    await _audioPlayer
        .setSubscriptionDuration(const Duration(milliseconds: 50));

    _playerStateSubscription = _audioPlayer.onProgress!.listen((event) {
      setState(() {
        _duration = event.duration;
        _position = event.position;
      });
    });

    final duration = await _audioPlayer.startPlayer(
      fromURI: widget.audio,
      whenFinished: () {
        _audioPlayer.stopPlayer();
        setState(() {
          _isStarted = false;
          _isPlaying = false;
          _position = Duration.zero;
        });
      },
    );

    await _audioPlayer.pausePlayer();

    setState(() {
      _isStarted = true;
      _duration = duration ?? Duration.zero;
    });
  }

  Future<void> _startAudio() async {
    await _audioPlayer.startPlayer(
      fromURI: widget.audio,
      whenFinished: () {
        _audioPlayer.stopPlayer();
        setState(() {
          _isStarted = false;
          _isPlaying = false;
          _position = Duration.zero;
        });
      },
    );

    setState(() {
      _isStarted = true;
      _isPlaying = true;
    });
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pausePlayer();

    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _resumeAudio() async {
    await _audioPlayer.resumePlayer();

    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _toggoleAudioPlaying() async {
    if (_isStarted && _isPlaying) {
      await _pauseAudio();
    } else if (_isStarted && !_isPlaying) {
      await _resumeAudio();
    } else {
      await _startAudio();
    }
  }

  void _togglePlaybackRate() {
    if (_playbackRate == 1) {
      _audioPlayer.setSpeed(1.5);
      setState(() {
        _playbackRate = 1.5;
      });
    } else if (_playbackRate == 1.5) {
      _audioPlayer.setSpeed(2);
      setState(() {
        _playbackRate = 2;
      });
    } else {
      _audioPlayer.setSpeed(1);
      setState(() {
        _playbackRate = 1;
      });
    }
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _audioPlayer.closePlayer();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.isMe && _isPlaying)
            TogglePlaybackRateButton(
              playbackRate: _playbackRate,
              togglePlaybackRate: _togglePlaybackRate,
              color: color,
            ),
          if (widget.isMe && !_isPlaying)
            CircleAvatar(
              backgroundImage: AssetImage(widget.currentUserImage),
              radius: 23,
            ),
          IconButton(
            color: color,
            onPressed: _toggoleAudioPlaying,
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: 40,
            ),
          ),
          Stack(
            children: [
              Slider(
                inactiveColor: Colors.grey.shade400,
                activeColor: color,
                thumbColor: color,
                min: 0,
                max: _duration.inMilliseconds.toDouble(),
                value: _position.inMilliseconds.toDouble(),
                onChanged: (value) async {
                  final newPosition = Duration(milliseconds: value.toInt());

                  await _audioPlayer.seekToPlayer(newPosition);

                  setState(() {
                    _position = newPosition;
                  });
                },
              ),
              PositionedDirectional(
                start: 25,
                bottom: 0,
                child: Text(
                  formatedDuration(_isPlaying ? _position : _duration),
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
              PositionedDirectional(
                end: 3,
                bottom: 0,
                child: dateBuilder(date: widget.date, color: Colors.black54),
              ),
            ],
          ),
          if (!widget.isMe && _isPlaying)
            TogglePlaybackRateButton(
              playbackRate: _playbackRate,
              togglePlaybackRate: _togglePlaybackRate,
              color: color,
            ),
          if (!widget.isMe && !_isPlaying)
            CircleAvatar(
              backgroundImage: NetworkImage(widget.otherPersonImage),
              radius: 23,
            ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////
/////////
///

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
