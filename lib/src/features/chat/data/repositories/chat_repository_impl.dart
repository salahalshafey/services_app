import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:services_app/src/features/chat/data/models/message_model.dart';

import '../../../../core/error/exceptions_without_message.dart';
import '../../../../core/network/network_info.dart';

import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';

import '../datasources/chat_remote_data_source.dart';
import '../datasources/chat_remote_storage.dart';
import '../datasources/maps_servcice.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatRemoteStorage remoteStorage;
  final ChatMapsService mapsService;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.remoteStorage,
    required this.mapsService,
    required this.networkInfo,
  });

  @override
  Stream<List<Message>> getChatWithRealTimeChanges(String orderId) async* {
    if (await networkInfo.isNotConnected) {
      throw OfflineException();
    }

    yield* remoteDataSource.getChatWithRealTimeChanges(orderId);
  }

  @override
  Future<List<Message>> getChatWithOneTimeRead(String orderId) async {
    if (await networkInfo.isNotConnected) {
      throw OfflineException();
    }

    return remoteDataSource.getChatWithOneTimeRead(orderId);
  }

  @override
  Future<void> sendTextMessage(
      String orderId, String textMessage, String senderId) async {
    if (await networkInfo.isNotConnected) {
      throw OfflineException();
    }

    return remoteDataSource.addMessage(
      orderId,
      MessageModel(
        messageId: '',
        message: textMessage,
        messageType: 'text',
        date: DateTime.now(),
        senderId: senderId,
      ),
    );
  }

  @override
  Future<void> sendFileMessage(
    String orderId,
    File file,
    String messageType,
    String? captionOfImage,
    String senderId,
  ) async {
    if (await networkInfo.isNotConnected) {
      throw OfflineException();
    }

    try {
      final downloadURL =
          await remoteStorage.upload(orderId, DateTime.now().toString(), file);

      await remoteDataSource.addMessage(
        orderId,
        MessageModel(
          messageId: '',
          message: downloadURL,
          messageType: messageType,
          captionOfImage: captionOfImage,
          date: DateTime.now(),
          senderId: senderId,
        ),
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> sendLocationMessage(
      String orderId, LatLng location, String senderId) async {
    if (await networkInfo.isNotConnected) {
      throw OfflineException();
    }

    final locationString = '${location.latitude},${location.longitude}';
    final geoCodingData = await mapsService.getGeoCodingData(locationString);

    return remoteDataSource.addMessage(
      orderId,
      MessageModel(
        messageId: '',
        message: locationString,
        messageType: 'location',
        captionOfImage: geoCodingData,
        date: DateTime.now(),
        senderId: senderId,
      ),
    );
  }
}
