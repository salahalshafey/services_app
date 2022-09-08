import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../controllers/chat.dart';
import '../../../../controllers/my_account.dart';

import '../../../general_custom_widgets/custom_alret_dialoge.dart';
import '../../../general_custom_widgets/general_functions.dart';
import '../../../general_custom_widgets/image_picker.dart';

class ImageSender extends StatelessWidget {
  const ImageSender(this.orderId, this.slideController, {Key? key})
      : super(key: key);

  final String orderId;
  final AnimationController slideController;

  Animation<Offset> get _offsetAnimation => Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, 1),
      ).animate(CurvedAnimation(
        parent: slideController,
        curve: Curves.linear,
      ));

  Future<void> _sendImageMessage(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final image = await myImagePicker(context);

    if (image == null) {
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ImagePreviwScreen(image: File(image.path), orderId: orderId),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: IconButton(
        onPressed: () => _sendImageMessage(context),
        tooltip: 'Send Image',
        icon: Icon(
          Icons.camera_alt,
          color: Colors.grey.shade700,
          size: 30,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
///
///

class ImagePreviwScreen extends StatelessWidget {
  const ImagePreviwScreen(
      {required this.image, required this.orderId, Key? key})
      : super(key: key);

  final File image;
  final String orderId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: PhotoView(
              imageProvider: FileImage(image),
              initialScale: PhotoViewComputedScale.contained * 1.0,
              minScale: PhotoViewComputedScale.contained * 0.5,
              maxScale: PhotoViewComputedScale.contained * 3.0,
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 10,
            child: ImageSenderWithCaption(image: image, orderId: orderId),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////
///
///

class ImageSenderWithCaption extends StatefulWidget {
  const ImageSenderWithCaption(
      {required this.image, required this.orderId, Key? key})
      : super(key: key);

  final File image;
  final String orderId;

  @override
  State<ImageSenderWithCaption> createState() => _ImageSenderWithCaptionState();
}

class _ImageSenderWithCaptionState extends State<ImageSenderWithCaption> {
  final _controller = TextEditingController();
  var _isLoading = false;
  var _textDirection = TextDirection.ltr;

  void _isLoadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  Future<void> _sendImageWithCaption() async {
    FocusScope.of(context).unfocus();

    final caption =
        _controller.value.text.trim().isEmpty ? null : _controller.value.text;

    final currentUser = Provider.of<MyAccount>(context, listen: false);
    try {
      _isLoadingState(true);
      await Chat.sendFileMessage(
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
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                filled: true,
                fillColor: Colors.white,
                hintText: 'Add a caption...',
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              ),
              textDirection: _textDirection,
              onChanged: (value) {
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
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    minimumSize: MaterialStateProperty.all(const Size(55, 55)),
                  ),
                ),
        ],
      ),
    );
  }
}
