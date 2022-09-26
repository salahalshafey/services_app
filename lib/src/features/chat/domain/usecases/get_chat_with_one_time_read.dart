import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetChatWithOneTimeReadUsecase {
  final ChatRepository repository;

  GetChatWithOneTimeReadUsecase(this.repository);

  Future<List<Message>> call(String orderId) =>
      repository.getChatWithOneTimeRead(orderId);
}
