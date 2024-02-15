import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/error/error_exceptions_with_message.dart';
import '../../../../core/error/exceptions_without_message.dart';
import '../../data/datasources/maps_servcice.dart';
import '../../domain/entities/message.dart';

import '../../domain/usecases/get_chat_with_one_time_read.dart';
import '../../domain/usecases/get_chat_with_real_time_changes.dart';
import '../../domain/usecases/send_file_message.dart';
import '../../domain/usecases/send_location_message.dart';
import '../../domain/usecases/send_text_message.dart';

class Chat with ChangeNotifier {
  Chat({
    required this.getChatStream,
    required this.getChatOnce,
    required this.sendUserTextMessage,
    required this.sendUserFileMessage,
    required this.sendUserLocationMessage,
  });

  final GetChatWithRealTimeChangesUsecase getChatStream;
  final GetChatWithOneTimeReadUsecase getChatOnce;
  final SendTextMessageUsecase sendUserTextMessage;
  final SendFileMessageUsecase sendUserFileMessage;
  final SendLocationMessageUsecase sendUserLocationMessage;

  Stream<List<Message>> getChatWithRealTimeChanges(String orderId) async* {
    try {
      await for (final chat in getChatStream(orderId)) {
        yield chat;
      }
    } on OfflineException {
      throw ErrorMessage('You are currently offline.');
    } on ServerException {
      throw ErrorMessage('Something went wrong, please try again later.');
    } catch (error) {
      throw ErrorMessage('An unexpected error happened.');
    }
  }

  Future<List<Message>> getChatWithOneTimeRead(String orderId) async {
    try {
      return await getChatOnce(orderId);
    } on OfflineException {
      throw ErrorMessage('You are currently offline.');
    } on ServerException {
      throw ErrorMessage('Something went wrong, please try again later.');
    } catch (error) {
      throw ErrorMessage('An unexpected error happened.');
    }
  }

  Future<void> sendTextMessage(
      String orderId, String textMessage, String senderId) async {
    try {
      await sendUserTextMessage(orderId, textMessage, senderId);
    } on OfflineException {
      throw ErrorMessage('You are currently offline.');
    } on ServerException {
      throw ErrorMessage('Something went wrong, please try again later.');
    } catch (error) {
      throw ErrorMessage('An unexpected error happened.');
    }
  }

  Future<void> sendFileMessage(
    String orderId,
    File file,
    String messageType,
    String? captionOfImage,
    String senderId,
  ) async {
    try {
      await sendUserFileMessage(
          orderId, file, messageType, captionOfImage, senderId);
    } on OfflineException {
      throw ErrorMessage('You are currently offline.');
    } on ServerException {
      throw ErrorMessage('Something went wrong, please try again later.');
    } catch (error) {
      throw ErrorMessage('An unexpected error happened.');
    }
  }

  Future<void> sendLocationMessage(
      String orderId, LatLng location, String senderId) async {
    try {
      await sendUserLocationMessage(orderId, location, senderId);
    } on OfflineException {
      throw ErrorMessage('You are currently offline.');
    } on ServerException {
      throw ErrorMessage('Something went wrong, please try again later.');
    } catch (error) {
      throw ErrorMessage('An unexpected error happened.');
    }
  }

  // special case it will be changed later (make it a use case)
  String getLocationImagePreview(String location) =>
      ChatGoogleMapsImpl().getImagePreview(location);
}
