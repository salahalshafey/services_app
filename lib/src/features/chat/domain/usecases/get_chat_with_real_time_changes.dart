import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetChatWithRealTimeChangesUsecase {
  final ChatRepository repository;

  GetChatWithRealTimeChangesUsecase(this.repository);

  Stream<List<Message>> call(String orderId) =>
      repository.getChatWithRealTimeChanges(orderId);
}
