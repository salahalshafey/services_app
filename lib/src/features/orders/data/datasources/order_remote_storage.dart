import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/error/exceptions_without_message.dart';

abstract class OrderRemoteStorage {
  Future<String> upload(String fileName, File file);
  Future<void> delete(String fileName);
}

const folderName = 'orders';

class OrderFirebaseStorageImpl implements OrderRemoteStorage {
  @override
  Future<String> upload(String fileName, File file) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('$folderName/$fileName');

      await ref.putFile(file);

      final downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<void> delete(String fileName) async {
    try {
      await FirebaseStorage.instance
          .ref()
          .child('$folderName/$fileName')
          .delete();
    } catch (error) {
      throw ServerException();
    }
  }
}
