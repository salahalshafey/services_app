import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../../../core/util/builders/image_picker.dart';
import 'image_previw_screen.dart';

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
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey.shade700
              : Colors.grey.shade300,
          size: 30,
        ),
      ),
    );
  }
}
