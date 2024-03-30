import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_painter/image_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../../core/util/functions/string_manipulations_and_search.dart';
import '../../../../account/presentation/providers/account.dart';
import '../../providers/chat.dart';

import '../../../../../core/util/builders/custom_alret_dialog.dart';
import '../../../../../core/util/builders/image_picker.dart';

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
  // Future<Uint8List> fileToUint8List(File image) async {
  //   return await image.readAsBytes();
  // }
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

////////////////////////////////////////////////////////////////////////////////
///
///


class ImagePreviwScreen extends StatefulWidget {
   ImagePreviwScreen(
      {required this.image, required this.orderId, Key? key}) : super(key: key);

   File  image;
  final String orderId;


  @override
  State<ImagePreviwScreen> createState() => _ImagePreviwScreenState();
}

class _ImagePreviwScreenState extends State<ImagePreviwScreen> {

  Future <void>  cropImage(BuildContext context) async {
    if (widget.image != null){
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath:widget.image.path ,
          aspectRatioPresets:
          [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ] ,

          uiSettings: [
            AndroidUiSettings(
              toolbarColor: Colors.black12,
              toolbarTitle: '',
              cropGridColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(title: 'Crop')
          ]);

      setState(() {
        widget.image = File(cropped!.path);
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
        actions:<Widget> [
          IconButton(
              color: Colors.white,
              onPressed: ()  =>  cropImage(context),
              //navigateToImageEdite(context,image),
              icon: const Icon(Icons.crop_rotate)),
          IconButton(
              color: Colors.white,
              onPressed: ()async {
                final newImage = await  Navigator.push<File>(context,
                  MaterialPageRoute(builder: (context) => imagePainte(image: widget.image,orderId: widget.orderId,)) );
                setState(() {
                  widget.image = newImage! ;
                });
              },
              //navigateToImageEdite(context,image),
              icon: Icon(Icons.edit))
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: PhotoView(
              imageProvider: FileImage(widget.image),
              initialScale: PhotoViewComputedScale.contained * 1.0,
              minScale: PhotoViewComputedScale.contained * 0.5,
              maxScale: PhotoViewComputedScale.contained * 3.0,
            ),
          ),
          PositionedDirectional(
            width: MediaQuery.of(context).size.width,
            bottom: 10,
            child: ImageSenderWithCaption(image: widget.image, orderId: widget.orderId),
          ),
        ],
      ),
    );
  }
}

class imagePainte extends StatelessWidget {
  imagePainte({required this.image,required this.orderId , Key? key})  : super(key: key);
  final File image;
  final String orderId;
  final _imageKey = GlobalKey<ImagePainterState>();
  Future<File?> uint8ListToFile(Uint8List? uint8List) async {
    if (uint8List == null) {
      return null;
    }

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String tempFileName = 'image_$timestamp.jpg'; // Example filename: image_1646257878000.jpg
    File tempFile = File('$tempPath/$tempFileName');

    await tempFile.writeAsBytes(uint8List);

    return tempFile;
  }

  Future<void> _capturePaintedImage(BuildContext context) async {
    final paintedImage = await _imageKey.currentState?.exportImage();
    final File ?  BackePaintedImage = await uint8ListToFile(paintedImage);
    if (paintedImage != null) {
      Navigator.of(context).pop(BackePaintedImage);
    }

  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.black12,
          body: Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                Expanded(
                  child: ImagePainter.file(
                    File(image.path),
                    key: _imageKey,
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
                            backgroundColor: Colors.black12 ,
                            shape:  const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8))),
                            //  side: BorderSide(color: Colors.yellow.withAlpha(5)),
                          ),
                          child: const Text('Cancel', style:TextStyle(
                              color: Colors.white
                          ) ,)

                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            _capturePaintedImage(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black12 ,
                            shape:  const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8))),
                            //  side: BorderSide(color: Colors.yellow.withAlpha(5)),
                          ),
                          child: const Text('Done', style:TextStyle(
                              color: Colors.white
                          ) ,)

                      ),
                    ),
                  ],
                )

              ],
            ),
    )

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
    //Navigator.pushNamed(context, '/chat-screen');
    // Navigator.popUntil(context, ModalRoute.withName('/chat-screen'));
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
