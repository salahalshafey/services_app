import '../repositories/chat_repository.dart';

class SendTextMessageUsecase {
  final ChatRepository repository;

  SendTextMessageUsecase(this.repository);

  Future<void> call(
    String orderId,
    String textMessage,
    String senderId,
  ) =>
      repository.sendTextMessage(
        orderId,
        textMessage,
        senderId,
      );
}
