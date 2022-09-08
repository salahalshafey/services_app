import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../backend_services/cloud_storage.dart';
import '../backend_services/firestore.dart';
import '../backend_services/google_maps_platform.dart';
import '../backend_services/internet_service.dart';

import '../exceptions/internet_exception.dart';

class Chat {
  static Stream<List<Message>> getChatWithRealTimeChanges(
      String orderId) async* {
    final hasNetwork = await InternetService.hasNetwork();
    if (!hasNetwork) {
      throw InternetException('You are currently offline.');
    }

    try {
      await for (final chat in Firestore.getChatRealTime(orderId)) {
        yield chat.docs
            .map((document) => Message.fromFiretore(document))
            .toList();
      }
    } catch (error) {
      throw InternetException('Something Went Wrong!!!');
    }
  }

  static Future<List<Message>> getChatWithOneTimeRead(String orderId) async {
    final hasNetwork = await InternetService.hasNetwork();
    if (!hasNetwork) {
      throw InternetException('You are currently offline.');
    }

    try {
      final messageDocs = (await Firestore.getChatOneTime(orderId)).docs;
      return messageDocs
          .map((document) => Message.fromFiretore(document))
          .toList();
    } catch (error) {
      throw InternetException('Something Went Wrong!!!');
    }
  }

  static Future<void> sendTextMessage(
      String orderId, String textMessage, String senderId) async {
    final hasNetwork = await InternetService.hasNetwork();
    if (!hasNetwork) {
      throw InternetException('You are currently offline.');
    }

    try {
      await Firestore.addMessage(
        orderId,
        Message(
          messageId: '',
          message: textMessage,
          messageType: 'text',
          date: DateTime.now(),
          senderId: senderId,
        ).toFirestore(),
      );
    } catch (error) {
      throw InternetException('Something Went Wrong!!!');
    }
  }

  static Future<void> sendFileMessage(
    String orderId,
    File file,
    String messageType,
    String? captionOfImage,
    String senderId,
  ) async {
    final hasNetwork = await InternetService.hasNetwork();
    if (!hasNetwork) {
      throw InternetException('You are currently offline.');
    }

    try {
      final downloadURL = await CloudStorage.upload(
          'chat/$orderId', DateTime.now().toString(), file);

      await Firestore.addMessage(
        orderId,
        Message(
          messageId: '',
          message: downloadURL,
          messageType: messageType,
          captionOfImage: captionOfImage,
          date: DateTime.now(),
          senderId: senderId,
        ).toFirestore(),
      );
    } catch (error) {
      throw InternetException('Something Went Wrong!!!');
    }
  }

  static Future<void> sendLocationMessage(
      String orderId, LatLng location, String senderId) async {
    final hasNetwork = await InternetService.hasNetwork();
    if (!hasNetwork) {
      throw InternetException('You are currently offline.');
    }

    final locationString = '${location.latitude},${location.longitude}';
    final geoCodingData =
        await GoogleMapsPlatform.getGeoCodingData(locationString);

    try {
      await Firestore.addMessage(
        orderId,
        Message(
          messageId: '',
          message: locationString,
          messageType: 'location',
          captionOfImage: geoCodingData,
          date: DateTime.now(),
          senderId: senderId,
        ).toFirestore(),
      );
    } catch (error) {
      throw InternetException('Something Went Wrong!!!');
    }
  }
}

class Message {
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

  Message.fromFiretore(QueryDocumentSnapshot<Map<String, dynamic>> document)
      : messageId = document.id,
        message = document.data()['message'],
        messageType = document.data()['message_type'],
        captionOfImage = document.data()['caption_of_image'],
        date = (document.data()['date'] as Timestamp).toDate(),
        senderId = document.data()['sender_id'];

  Map<String, dynamic> toFirestore() => {
        'message': message,
        'message_type': messageType,
        'caption_of_image': captionOfImage,
        'date': date,
        'sender_id': senderId,
      };

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
}
