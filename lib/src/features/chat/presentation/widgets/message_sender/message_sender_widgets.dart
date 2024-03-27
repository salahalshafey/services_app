import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:provider/provider.dart';
import 'package:services_app/src/core/util/functions/date_time_and_duration.dart';

import '../../providers/recording_provider.dart';
import '../../providers/text_field_filled_color.dart';

class MessageSenderTextField extends StatefulWidget {
  const MessageSenderTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.textDirection,
    required this.isPortrait,
    required this.updateTextDirection,
    required this.emojiShowingState,
    required this.forwardAnimations,
    required this.reverseAnimations,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final TextDirection textDirection;
  final bool isPortrait;
  final void Function(String value) updateTextDirection;
  final void Function(bool state) emojiShowingState;
  final void Function() forwardAnimations;
  final void Function() reverseAnimations;

  @override
  State<MessageSenderTextField> createState() => _MessageSenderTextFieldState();
}

class _MessageSenderTextFieldState extends State<MessageSenderTextField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            onTap: () {
              widget.emojiShowingState(false);
            },
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: widget.isPortrait ? 6 : 2,
            cursorHeight: 30,
            cursorColor: Theme.of(context).primaryColor,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              filled: true,
              //fillColor: Colors.white,

              contentPadding: EdgeInsetsDirectional.only(
                start: 50,
                end: 5,
                bottom: 10,
                top: 10,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              hintText: 'Send a message...',
            ),
            textDirection: widget.textDirection,
            onChanged: (value) {
              if (value.trim().isNotEmpty) {
                widget.forwardAnimations();
              } else {
                widget.reverseAnimations();
              }
              widget.updateTextDirection(value);
            },
          ),
        ),
        const SizedBox(width: 60, height: 55),
      ],
    );
  }
}

/////////////////////////////////////////////////////////////
/////////////////////////////
////////

class SlideToCancelContainer extends StatelessWidget {
  const SlideToCancelContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<RecordingProvider>(
      builder: (ctx, provider, child) {
        return AnimatedContainer(
          duration: Durations.short1,
          decoration: BoxDecoration(
            color: getTextFieldFilledColor(context),
            borderRadius: BorderRadius.circular(50),
          ),
          height: 50,
          child: Row(
            children: [
              const SizedBox(width: 15),
              const RecordingIcon(),
              const SizedBox(width: 15),
              const RecordingDuration(),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Slide to cancel",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(width: 85),
                ],
              ).animate(
                onPlay: (controller) {
                  controller.loop();
                },
              ).shimmer(
                duration: 2.seconds,
                angle:
                    Directionality.of(context) == TextDirection.ltr ? pi : null,
              ),
            ],
          ),
          width: provider.recordingFromTextField ? screenWidth - 8 : 0,
        );
      },
    );
  }
}

class RecordingDuration extends StatelessWidget {
  const RecordingDuration({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordingProvider>(context);

    return StreamBuilder(
        stream: provider.recorderOnProgress,
        builder: (context, snapshot) {
          return Text(
            snapshot.hasData
                ? formatedDuration(snapshot.data!.duration)
                : "0:00",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade700,
            ),
          );
        });
  }
}

/////////////////////////////////////////////////////////////
/////////////////////////////
////////

class RecordingIcon extends StatefulWidget {
  const RecordingIcon({super.key});

  @override
  State<RecordingIcon> createState() => _RecordingIconState();
}

class _RecordingIconState extends State<RecordingIcon> {
  bool _showIcon = true;
  bool _disposed = false;

  void _toggleShowingIcon() async {
    while (!_disposed) {
      await Future.delayed(0.5.seconds);
      if (mounted) {
        setState(() {
          _showIcon = false;
        });
      }

      await Future.delayed(0.5.seconds);
      if (mounted) {
        setState(() {
          _showIcon = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _toggleShowingIcon();
  }

  @override
  void dispose() {
    _disposed = true;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.keyboard_voice,
        color: _showIcon ? Colors.red : Colors.transparent);
  }
}

/////////////////////////////////////////////////////////////
/////////////////////////////
////////

class ShowEmojiPicker extends StatelessWidget {
  const ShowEmojiPicker({
    super.key,
    required this.emojiShowing,
    required this.setEmojiShwing,
    required this.isPortrait,
    required this.controller,
    required this.primaryColor,
  });

  final bool emojiShowing;
  final void Function(bool state) setEmojiShwing;
  final bool isPortrait;
  final TextEditingController controller;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !emojiShowing,
      child: SizedBox(
        height: isPortrait ? 250 : 200,
        child: PopScope(
          canPop: !emojiShowing,
          onPopInvoked: (didPop) {
            if (!didPop) {
              setEmojiShwing(false);
            }
          },
          child: EmojiPicker(
            textEditingController: controller,
            config: Config(
              height: 256,
              checkPlatformCompatibility: true,
              emojiViewConfig: EmojiViewConfig(
                // Issue: https://github.com/flutter/flutter/issues/28894
                backgroundColor: Theme.of(context).canvasColor,
                columns: 7,
                emojiSizeMax: 28 *
                    (foundation.defaultTargetPlatform == TargetPlatform.iOS
                        ? 1.20
                        : 1.0),
              ),
              swapCategoryAndBottomBar: true,
              skinToneConfig: const SkinToneConfig(),
              categoryViewConfig: CategoryViewConfig(
                indicatorColor: primaryColor,
                iconColorSelected: primaryColor,
                backspaceColor: primaryColor,
                backgroundColor: Theme.of(context).canvasColor,
              ),
              bottomActionBarConfig: const BottomActionBarConfig(
                backgroundColor: Colors.transparent,
                buttonColor: Colors.transparent,
                buttonIconColor: Colors.grey,
              ),
              searchViewConfig: SearchViewConfig(
                backgroundColor: Theme.of(context).canvasColor,
                buttonIconColor: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
