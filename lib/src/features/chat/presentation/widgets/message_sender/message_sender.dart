import 'package:flutter/material.dart';

import '../../../../../core/util/functions/string_manipulations_and_search.dart';

import 'location_sender.dart';
import 'image_sender/image_sender.dart';
import 'audio_sender/audio_sender.dart';
import 'message_sender_widgets.dart';
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

  var _textDirection = getDirectionalityOf("");
  bool _emojiShowing = false;
  bool _isSendButtonLoading = false;

  late final _primaryColor = Theme.of(context).primaryColor;
  late final AnimationController _slideController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  void _updateTextDirection(String value) {
    setState(() {
      _textDirection = getDirectionalityOf(value);
    });
  }

  void _emojiShowingState(bool state) {
    setState(() {
      _emojiShowing = state;
    });
  }

  void _toggoleEmojiShowing() async {
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
            alignment: Alignment.center,
            children: [
              MessageSenderTextField(
                controller: _controller,
                focusNode: _focusNode,
                textDirection: _textDirection,
                isPortrait: isPortrait,
                updateTextDirection: _updateTextDirection,
                emojiShowingState: _emojiShowingState,
                forwardAnimations: _forwardAnimations,
                reverseAnimations: _reverseAnimations,
              ),
              PositionedDirectional(
                start: 0,
                child: IconButton(
                  onPressed: _toggoleEmojiShowing,
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
              PositionedDirectional(
                end: 113,
                child: LocationSender(
                  widget.orderId,
                  sendButtonLoadingState,
                  _slideController,
                ),
              ),
              PositionedDirectional(
                end: 65,
                child: ImageSender(
                  widget.orderId,
                  _slideController,
                ),
              ),
              const PositionedDirectional(
                end: 0,
                child: SlideToCancelContainer(),
              ),
              PositionedDirectional(
                end: 0,
                child: Row(
                  children: [
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
