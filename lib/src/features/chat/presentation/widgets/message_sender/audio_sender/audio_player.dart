import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../../core/util/functions/date_time_and_duration.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({
    super.key,
    required this.recorderFilePath,
  });

  final String recorderFilePath;

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final color = Colors.grey.shade800;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  // double _playbackRate = 1;

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
      final duration = await _audioPlayer.setUrl(widget.recorderFilePath);
      setState(() {
        _duration = duration ?? Duration.zero;
      });

      _audioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          _audioPlayer.stop().then((_) {
            _audioPlayer.seek(Duration.zero);
          });
        }
      });

      _audioPlayer.playingStream.listen((event) {
        if (mounted) {
          setState(() {
            _isPlaying = event;
          });
        }
      });

      _audioPlayer.durationStream.listen(
        (event) {
          if (mounted) {
            setState(() {
              _duration = event ?? Duration.zero;
            });
          }
        },
      );

      _audioPlayer.positionStream.listen(
        (event) {
          if (mounted) {
            setState(() {
              _position = event;
            });
          }
        },
      );

      /* _audioPlayer.speedStream.listen((event) {
        if (mounted) {
          setState(() {
            _playbackRate = event;
          });
        }
      });*/
    } catch (error) {
      //
    }
  }

  Future<void> _toggoleAudioPlaying() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  /*void _togglePlaybackRate() {
    if (_playbackRate == 1) {
      _audioPlayer.setSpeed(1.5);
    } else if (_playbackRate == 1.5) {
      _audioPlayer.setSpeed(2);
    } else {
      _audioPlayer.setSpeed(1);
    }
  }*/

  @override
  void dispose() {
    _audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(end: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade700
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _toggoleAudioPlaying,
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: 40,
            ),
          ),
          Expanded(
            child: Slider(
              min: 0,
              max: _duration.inMilliseconds.toDouble(),
              value: _position.inMilliseconds.toDouble(),
              onChanged: (value) async {
                final newPosition = Duration(milliseconds: value.toInt());

                await _audioPlayer.seek(newPosition);

                setState(() {
                  _position = newPosition;
                });
              },
            ),
          ),
          Text(
            formatedDuration(
              _position == Duration.zero ? _duration : _position,
            ),
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    ).animate().scale();
  }
}
