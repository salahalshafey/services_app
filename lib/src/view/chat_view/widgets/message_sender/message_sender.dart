import 'package:flutter/material.dart';

import '../../../general_custom_widgets/general_functions.dart';
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
  var _isSendButtonLoading = false;
  var _textDirection = TextDirection.ltr;

  late final AnimationController _slideController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

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
      child: Stack(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
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
                    contentPadding: EdgeInsets.all(10),
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
    );
  }
}
