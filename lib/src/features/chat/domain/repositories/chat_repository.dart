import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../entities/message.dart';

abstract class ChatRepository {
  Stream<List<Message>> getChatWithRealTimeChanges(String orderId);

  Future<List<Message>> getChatWithOneTimeRead(String orderId);

  Future<void> sendTextMessage(
    String orderId,
    String textMessage,
    String senderId,
  );

  Future<void> sendFileMessage(
    String orderId,
    File file,
    String messageType,
    String? captionOfImage,
    String senderId,
  );

  Future<void> sendLocationMessage(
    String orderId,
    LatLng location,
    String senderId,
  );
}
