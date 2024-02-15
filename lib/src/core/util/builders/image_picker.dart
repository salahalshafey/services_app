import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/////// Don't forget to get image_picker package by using this command: flutter pub add image_picker////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

Future<XFile?> myImagePicker(
  BuildContext context, {
  double maxWidth = 960,
  double? maxHeight,
  int imageQuality = 50,
  CameraDevice preferredCameraDevice = CameraDevice.rear,
  bool requestFullMetadata = true,
}) async {
  if (Platform.isWindows) {
    return ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      preferredCameraDevice: preferredCameraDevice,
      requestFullMetadata: requestFullMetadata,
    );
  }

  final choiceCamera = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.pleaseChoose,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(Icons.camera_alt),
                    label: Text(AppLocalizations.of(context)!.camera),
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.camera),
                    label: Text(AppLocalizations.of(context)!.gallery),
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
    imageQuality: imageQuality,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    preferredCameraDevice: preferredCameraDevice,
    requestFullMetadata: requestFullMetadata,
  );
}
