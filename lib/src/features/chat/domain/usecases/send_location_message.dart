import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../repositories/chat_repository.dart';

class SendLocationMessageUsecase {
  final ChatRepository repository;

  SendLocationMessageUsecase(this.repository);

  Future<void> call(
    String orderId,
    LatLng location,
    String senderId,
  ) =>
      repository.sendLocationMessage(
        orderId,
        location,
        senderId,
      );
}
