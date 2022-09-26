import 'package:equatable/equatable.dart';

class Message extends Equatable {
  const Message({
    required this.messageId,
    required this.message,
    required this.messageType,
    this.captionOfImage,
    required this.date,
    required this.senderId,
  });

  final String messageId;
  final String message;
  final String messageType;
  final String? captionOfImage;
  final DateTime date;
  final String senderId;

  Message copyWith({
    String? messageId,
    String? message,
    String? messageType,
    String? captionOfImage,
    DateTime? date,
    String? senderId,
  }) =>
      Message(
        messageId: messageId ?? this.messageId,
        message: message ?? this.message,
        messageType: messageType ?? this.messageType,
        captionOfImage: captionOfImage ?? this.captionOfImage,
        date: date ?? this.date,
        senderId: senderId ?? this.senderId,
      );

  @override
  List<Object?> get props => [messageId];
}
