import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/exceptions_without_message.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<MessageModel>> getChatWithRealTimeChanges(String orderId);

  Future<List<MessageModel>> getChatWithOneTimeRead(String orderId);

  Future<void> addMessage(String orderId, MessageModel message);
}

class ChatFirestoreImpl extends ChatRemoteDataSource {
  @override
  Stream<List<MessageModel>> getChatWithRealTimeChanges(String orderId) async* {
    try {
      final chatStream = FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('chat')
          .orderBy('date', descending: true)
          .snapshots();

      await for (final chat in chatStream) {
        yield chat.docs
            .map((document) => MessageModel.fromFirestore(document))
            .toList();
      }
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> getChatWithOneTimeRead(String orderId) async {
    try {
      final respons = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('chat')
          .orderBy('date', descending: true)
          .get();

      return respons.docs
          .map((document) => MessageModel.fromFirestore(document))
          .toList();
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<void> addMessage(String orderId, MessageModel message) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('chat')
          .add(message.toFirestore());
    } catch (error) {
      throw ServerException();
    }
  }
}
