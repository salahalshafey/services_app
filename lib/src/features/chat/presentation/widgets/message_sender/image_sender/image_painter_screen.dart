import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';

class ImagePainterScreen extends StatelessWidget {
  ImagePainterScreen({
    required this.image,
    required this.orderId,
    Key? key,
  }) : super(key: key);

  final File image;
  final String orderId;

  final _controller = ImagePainterController();

  Future<File?> _uint8ListToFile(Uint8List? uint8List) async {
    if (uint8List == null) {
      return null;
    }

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String tempFileName =
        'image_$timestamp.jpg'; // Example filename: image_1646257878000.jpg
    File tempFile = File('$tempPath/$tempFileName');

    await tempFile.writeAsBytes(uint8List);

    return tempFile;
  }

  Future<void> _capturePaintedImage(BuildContext context) async {
    final paintedImage = await _controller.exportImage();
    final File? backePaintedImage = await _uint8ListToFile(paintedImage);
    if (paintedImage != null) {
      Navigator.of(context).pop(backePaintedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            Expanded(
              child: ImagePainter.file(
                File(image.path),
                controller: _controller,
                controlsBackgroundColor: Colors.black12,
                optionColor: Colors.white,
                scalable: true,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black12,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      //  side: BorderSide(color: Colors.yellow.withAlpha(5)),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _capturePaintedImage(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black12,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      //  side: BorderSide(color: Colors.yellow.withAlpha(5)),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
