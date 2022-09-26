import 'dart:io';

import '../repositories/chat_repository.dart';

class SendFileMessageUsecase {
  final ChatRepository repository;

  SendFileMessageUsecase(this.repository);

  Future<void> call(
    String orderId,
    File file,
    String messageType,
    String? captionOfImage,
    String senderId,
  ) =>
      repository.sendFileMessage(
        orderId,
        file,
        messageType,
        captionOfImage,
        senderId,
      );
}
