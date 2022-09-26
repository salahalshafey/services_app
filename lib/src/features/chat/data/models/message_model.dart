import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:services_app/src/features/chat/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required String messageId,
    required String message,
    required String messageType,
    String? captionOfImage,
    required DateTime date,
    required String senderId,
  }) : super(
          messageId: messageId,
          message: message,
          messageType: messageType,
          captionOfImage: captionOfImage,
          date: date,
          senderId: senderId,
        );

  factory MessageModel.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    return MessageModel(
      messageId: document.id,
      message: document.data()['message'],
      messageType: document.data()['message_type'],
      captionOfImage: document.data()['caption_of_image'],
      date: (document.data()['date'] as Timestamp).toDate(),
      senderId: document.data()['sender_id'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        'message': message,
        'message_type': messageType,
        'caption_of_image': captionOfImage,
        'date': date,
        'sender_id': senderId,
      };
}
