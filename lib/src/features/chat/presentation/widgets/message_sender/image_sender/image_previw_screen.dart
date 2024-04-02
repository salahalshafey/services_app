import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_view/photo_view.dart';

import 'image_painter_screen.dart';
import 'image_sender_with_caption.dart';

class ImagePreviwScreen extends StatefulWidget {
  const ImagePreviwScreen({
    required this.image,
    required this.orderId,
    Key? key,
  }) : super(key: key);

  final File image;
  final String orderId;

  @override
  State<ImagePreviwScreen> createState() => _ImagePreviwScreenState();
}

class _ImagePreviwScreenState extends State<ImagePreviwScreen> {
  late File _currentImage = widget.image;

  Future<void> _cropImage() async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: _currentImage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: Colors.black12,
          toolbarTitle: '',
          cropGridColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop')
      ],
    );

    if (croppedImage != null) {
      setState(() {
        _currentImage = File(croppedImage.path);
      });
    }
  }

  Future<void> _paintImage() async {
    final paintedImage = await Navigator.push<File>(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePainterScreen(
            image: _currentImage,
            orderId: widget.orderId,
          ),
        ));

    if (paintedImage != null) {
      setState(() {
        _currentImage = paintedImage;
      });
    }
  }

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
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            onPressed: _cropImage,
            //navigateToImageEdite(context,image),
            icon: const Icon(Icons.crop_rotate),
          ),
          IconButton(
            color: Colors.white,
            onPressed: _paintImage,
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: PhotoView(
              imageProvider: FileImage(_currentImage),
              initialScale: PhotoViewComputedScale.contained * 1.0,
              minScale: PhotoViewComputedScale.contained * 0.5,
              maxScale: PhotoViewComputedScale.contained * 3.0,
            ),
          ),
          PositionedDirectional(
            width: MediaQuery.of(context).size.width,
            bottom: 10,
            child: ImageSenderWithCaption(
              image: _currentImage,
              orderId: widget.orderId,
            ),
          ),
        ],
      ),
    );
  }
}
