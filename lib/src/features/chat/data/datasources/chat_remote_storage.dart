import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:services_app/src/core/error/exceptions.dart';

abstract class ChatRemoteStorage {
  Future<String> upload(String orderId, String fileName, File file);
}

const folderName = 'chat';

class ChatFirebaseStorageImpl implements ChatRemoteStorage {
  @override
  Future<String> upload(String orderId, String fileName, File file) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('$folderName/$orderId/$fileName');

      await ref.putFile(file);

      final downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (error) {
      throw ServerException();
    }
  }
}
