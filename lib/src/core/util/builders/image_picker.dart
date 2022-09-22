import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/////// Don't forget to get image_picker package by using this command: flutter pub add image_picker////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

Future<XFile?> myImagePicker(BuildContext context) async {
  final choiceCamera = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
            child: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please Choose',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.camera),
                    label: const Text('Gallery'),
                  ),
                ],
              ),
            ),
          ));

  if (choiceCamera == null) {
    return null;
  }
  return ImagePicker().pickImage(
    source: choiceCamera ? ImageSource.camera : ImageSource.gallery,
    imageQuality: 50,
    maxWidth: 960,
  );
}
