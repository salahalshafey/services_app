import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/util/builders/custom_alret_dialog.dart';
import '../../../../../../core/util/functions/string_manipulations_and_search.dart';

import '../../../../../account/presentation/providers/account.dart';
import '../../../providers/chat.dart';

class ImageSenderWithCaption extends StatefulWidget {
  const ImageSenderWithCaption({
    required this.image,
    required this.orderId,
    Key? key,
  }) : super(key: key);

  final File image;
  final String orderId;

  @override
  State<ImageSenderWithCaption> createState() => _ImageSenderWithCaptionState();
}

class _ImageSenderWithCaptionState extends State<ImageSenderWithCaption> {
  final _controller = TextEditingController();
  var _isLoading = false;
  var _textDirection = getDirectionalityOf("");

  void _isLoadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  Future<void> _sendImageWithCaption() async {
    FocusScope.of(context).unfocus();
    final caption =
        _controller.value.text.trim().isEmpty ? null : _controller.value.text;

    final currentUser = Provider.of<Account>(context, listen: false);
    try {
      _isLoadingState(true);
      await Provider.of<Chat>(context, listen: false).sendFileMessage(
        widget.orderId,
        widget.image,
        'image',
        caption,
        currentUser.id,
      );
    } catch (error) {
      _isLoadingState(false);
      showCustomAlretDialog(
        context: context,
        title: 'Error',
        titleColor: Colors.red,
        content: error.toString(),
      );
      return;
    }
    _isLoadingState(false);
    _controller.clear();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              cursorHeight: 21,
              cursorColor: Theme.of(context).primaryColor,
              minLines: 1,
              maxLines: isPortrait ? 6 : 2,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                filled: true,
                fillColor: Colors.white,
                hintText: 'Add a caption...',
                hintStyle: TextStyle(color: Colors.black54),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              ),
              textDirection: _textDirection,
              onChanged: (value) {
                setState(() {
                  _textDirection = getDirectionalityOf(value);
                });
              },
            ),
          ),
          const SizedBox(width: 5),
          _isLoading
              ? const SizedBox(
                  height: 55,
                  width: 55,
                  child: Center(child: CircularProgressIndicator()),
                )
              : ElevatedButton(
                  onPressed: _sendImageWithCaption,
                  child: const Icon(Icons.send, color: Colors.white),
                  style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)))),
                    minimumSize: WidgetStatePropertyAll(Size(55, 55)),
                  ),
                ),
        ],
      ),
    );
  }
}
