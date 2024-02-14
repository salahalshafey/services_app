import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../../../../../core/util/functions/string_manipulations_and_search.dart';
import 'location_sender.dart';
import 'image_sender.dart';
import 'audio_sender.dart';
import 'text_sender.dart';

class MessageSender extends StatefulWidget {
  const MessageSender(this.orderId, {Key? key}) : super(key: key);
  final String orderId;

  @override
  State<MessageSender> createState() => _MessageSenderState();
}

class _MessageSenderState extends State<MessageSender>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _emojiShowing = false;
  var _isSendButtonLoading = false;
  var _textDirection = TextDirection.ltr;
  late final _primaryColor = Theme.of(context).primaryColor;

  late final AnimationController _slideController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  void _emojiShowingState(bool state) {
    setState(() {
      _emojiShowing = state;
    });
  }

  void _toggoleEmojiShoing() async {
    if (!_emojiShowing) {
      _focusNode.unfocus();

      await Future.delayed(const Duration(milliseconds: 200));

      _emojiShowingState(true);
    } else {
      _emojiShowingState(false);

      _focusNode.requestFocus();
    }
  }

  void _forwardAnimations() {
    _slideController.forward();
    //
    //
    //
  }

  void _reverseAnimations() {
    _slideController.reverse();
    //
    //
    //
  }

  void changeTextDirectionToLtr() {
    setState(() {
      _textDirection = TextDirection.ltr;
    });
  }

  void sendButtonLoadingState(bool state) {
    setState(() {
      _isSendButtonLoading = state;
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Container(
      // color: Colors.grey.shade200,
      padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          Stack(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onTap: () {
                        _emojiShowingState(false);
                      },
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: isPortrait ? 6 : 2,
                      cursorHeight: 30,
                      cursorColor: Theme.of(context).primaryColor,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        filled: true,
                        //fillColor: Colors.white,
                        contentPadding: EdgeInsets.only(
                          left: 50,
                          right: 5,
                          bottom: 10,
                          top: 10,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        hintText: 'Send a message...',
                      ),
                      textDirection: _textDirection,
                      onChanged: (value) {
                        if (value.trim().isNotEmpty) {
                          _forwardAnimations();
                        } else {
                          _reverseAnimations();
                        }
                        if (firstCharIsArabic(value)) {
                          setState(() {
                            _textDirection = TextDirection.rtl;
                          });
                        } else {
                          setState(() {
                            _textDirection = TextDirection.ltr;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 60, height: 55),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: IconButton(
                  onPressed: _toggoleEmojiShoing,
                  tooltip: _emojiShowing ? 'Show Keyboard' : 'Pick Emoji',
                  icon: Icon(
                    _emojiShowing ? Icons.keyboard : Icons.tag_faces,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                    size: 30,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  children: [
                    LocationSender(
                      widget.orderId,
                      sendButtonLoadingState,
                      _slideController,
                    ),
                    ImageSender(
                      widget.orderId,
                      _slideController,
                    ),
                    const SizedBox(width: 10),
                    if (_isSendButtonLoading)
                      const SizedBox(
                        width: 55,
                        height: 55,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_controller.text.trim().isEmpty)
                      AudioSender(
                        widget.orderId,
                        sendButtonLoadingState,
                      )
                    else
                      TextSender(
                        widget.orderId,
                        sendButtonLoadingState,
                        changeTextDirectionToLtr,
                        _controller,
                        _slideController,
                      ),
                  ],
                ),
              ),
            ],
          ),
          ShowEmojiPicker(
            emojiShowing: _emojiShowing,
            setEmojiShwing: _emojiShowingState,
            isPortrait: isPortrait,
            controller: _controller,
            primaryColor: _primaryColor,
          ),
        ],
      ),
    );
  }
}

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
