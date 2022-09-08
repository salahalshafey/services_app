import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  /// upload to FirebaseStorage and return DownloadURL

  static Future<String> upload(
    String folderName,
    String fileName,
    File file,
  ) async {
    final ref = FirebaseStorage.instance.ref().child('$folderName/$fileName');

    try {
      await ref.putFile(file);
    } catch (error) {
      rethrow;
    }

    return ref.getDownloadURL();
  }

  static Future<void> delete(String folderName, String fileName) =>
      FirebaseStorage.instance.ref().child('$folderName/$fileName').delete();
}
