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
  bool emojiShowing = false;
  var _isSendButtonLoading = false;
  var _textDirection = TextDirection.ltr;
  late final _primaryColor = Theme.of(context).iconTheme.color!;

  late final AnimationController _slideController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  void _toggoleEmojiShoing() {
    setState(() {
      emojiShowing = !emojiShowing;
    });
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Container(
      color: Colors.grey.shade200,
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
                      onTap: () {
                        setState(() {
                          emojiShowing = false;
                        });
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
                        fillColor: Colors.white,
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
                  onPressed: () {
                    _toggoleEmojiShoing();

                    if (emojiShowing) {
                      FocusScope.of(context).unfocus();
                    } else {
                      FocusScope.of(context).requestFocus();
                    }
                  },
                  tooltip: emojiShowing ? 'Show Keyboard' : 'Pick Emoji',
                  icon: Icon(
                    emojiShowing
                        ? Icons.keyboard
                        : Icons.emoji_emotions_outlined,
                    color: Colors.grey.shade700,
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
          Offstage(
            offstage: !emojiShowing,
            child: SizedBox(
              height: isPortrait ? 250 : 200,
              child: EmojiPicker(
                textEditingController: _controller,
                config: Config(
                  columns: 7,
                  // Issue: https://github.com/flutter/flutter/issues/28894
                  emojiSizeMax: 32 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.30
                          : 1.0),
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  gridPadding: EdgeInsets.zero,
                  initCategory: Category.RECENT,
                  bgColor: const Color(0xFFF2F2F2),
                  indicatorColor: _primaryColor,
                  iconColor: Colors.grey,
                  iconColorSelected: _primaryColor,
                  backspaceColor: _primaryColor,
                  skinToneDialogBgColor: Colors.white,
                  skinToneIndicatorColor: Colors.grey,
                  enableSkinTones: true,
                  showRecentsTab: true,
                  recentsLimit: 28,
                  replaceEmojiOnLimitExceed: false,
                  noRecents: const Text(
                    'No Recents',
                    style: TextStyle(fontSize: 20, color: Colors.black26),
                    textAlign: TextAlign.center,
                  ),
                  loadingIndicator: const SizedBox.shrink(),
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  categoryIcons: const CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL,
                  checkPlatformCompatibility: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
