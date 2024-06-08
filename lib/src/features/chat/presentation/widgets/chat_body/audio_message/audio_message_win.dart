import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../../../../core/util/functions/date_time_and_duration.dart';
import '../message_bubble.dart';

class AudioMessageWin extends StatefulWidget {
  const AudioMessageWin({
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
  State<AudioMessageWin> createState() => _AudioMessageWinState();
}

class _AudioMessageWinState extends State<AudioMessageWin> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // late StreamSubscription<PlayerState> _playerStateSubscription;
  // late StreamSubscription<bool> _playingSubscription;
  // late StreamSubscription<Duration?> _durationSubscription;
  // late StreamSubscription<Duration> _positionSubscription;
  // late StreamSubscription<double> _speedSubscription;

  final color = Colors.grey.shade800;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackRate = 1;

  // @override
  // void initState() {
  //   super.initState();

  //   _initTheAudioPlayer();
  // }

  @override
  void didChangeDependencies() {
    _initTheAudioPlayer();

    super.didChangeDependencies();
  }

  Future<void> _initTheAudioPlayer() async {
    try {
      await _audioPlayer.setSourceUrl(widget.audio);
      final duration = await _audioPlayer.getDuration();
      setState(() {
        _duration = duration ?? Duration.zero;
      });

      /*_playerStateSubscription =*/ _audioPlayer.onPlayerComplete.listen((_) {
        _audioPlayer.stop().then((_) {
          _audioPlayer.seek(Duration.zero);
        });
      });

      /*_playingSubscription =*/ _audioPlayer.onPlayerStateChanged
          .listen((event) {
        if (mounted) {
          setState(() {
            _isPlaying = event == PlayerState.playing;
          });
        }
      });

      /*_durationSubscription = */ _audioPlayer.onDurationChanged.listen(
        (event) {
          if (mounted) {
            setState(() {
              _duration = event;
            });
          }
        },
      );

      /*_positionSubscription =*/ _audioPlayer.onPositionChanged.listen(
        (event) {
          if (mounted && event <= _duration) {
            setState(() {
              _position = event;
            });
          }
        },
      );

      // /*_speedSubscription =*/ _audioPlayer.speedStream.listen((event) {
      //   if (mounted) {
      //     setState(() {
      //       _playbackRate = event;
      //     });
      //   }
      // });
    } catch (error) {
      //
    }
  }

  void _setPlaybackRate(double playbackRate) {
    _audioPlayer.setPlaybackRate(playbackRate);
    setState(() {
      _playbackRate = playbackRate;
    });
  }

  Future<void> _toggoleAudioPlaying() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  void _togglePlaybackRate() {
    if (_playbackRate == 1) {
      _setPlaybackRate(1.5);
    } else if (_playbackRate == 1.5) {
      _setPlaybackRate(2);
    } else {
      _setPlaybackRate(1);
    }
  }

  @override
  void dispose() {
    // _playerStateSubscription.cancel();
    // _playingSubscription.cancel();
    // _durationSubscription.cancel();
    // _positionSubscription.cancel();
    // _speedSubscription.cancel();

    _audioPlayer.dispose();

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

                  await _audioPlayer.seek(newPosition);

                  // setState(() {
                  //   _position = newPosition;
                  // });
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
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(color),
        minimumSize: const WidgetStatePropertyAll(Size(50, 30)),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)))),
      ),
    );
  }
}
