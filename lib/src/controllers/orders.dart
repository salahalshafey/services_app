import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../backend_services/cloud_storage.dart';
import '../backend_services/firestore.dart';
import '../backend_services/internet_service.dart';

import '../exceptions/internet_exception.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];
  bool _dataFetchedFromBackend = false;

  Future<void> getAndFetchUserOrdersOnce(String userId) async {
    if (!_dataFetchedFromBackend) {
      try {
        await getAndFetchUserOrders(userId);
        _dataFetchedFromBackend = true;
      } catch (error) {
        rethrow;
      }
    }
  }

  Future<void> getAndFetchUserOrders(String userId) async {
    final hasNetwork = await InternetService.hasNetwork();
    if (!hasNetwork) {
      throw InternetException('You are currently offline.');
    }

    try {
      final ordersDocs = (await Firestore.getUserOrders(userId)).docs;
      _orders =
          ordersDocs.map((document) => Order.fromFiretore(document)).toList();

      notifyListeners();
    } catch (error) {
      throw InternetException('Something Went Wrong!!!');
    }
  }

  List<Order> get previousAndCanceledOrders =>
      _orders.where((order) => order.status != 'not finished').toList();

  List<Order> get currentOrders =>
      _orders.where((order) => order.status == 'not finished').toList();

  Future<String> addOrder(Order order, File image) async {
    final hasNetwork = await InternetService.hasNetwork();
    if (!hasNetwork) {
      throw InternetException('You are currently offline.');
    }

    try {
      final docId = (await Firestore.addOrder(order.toFirestore())).id;
      order = order.copyWith(id: docId);

      final downloadURL = await CloudStorage.upload('orders', docId, image);
      order = order.copyWith(image: downloadURL);

      /************************************************ */
      Firestore.updateImage(docId, downloadURL).catchError((_) {
        throw InternetException('Something Went Wrong!!');
        /** this is bad try to find anoter way **/
      });
      /************************************************** */
    } catch (error) {
      throw InternetException('Something Went Wrong!!!');
    }

    _orders.insert(0, order);
    notifyListeners();

    return order.id;
  }

  Future<void> cancelOrder(String orderId, String reasonOfCancel) async {
    final hasNetwork = await InternetService.hasNetwork();
    if (!hasNetwork) {
      throw InternetException('You are currently offline.');
    }

    try {
      await Firestore.cancelOrder(orderId, reasonOfCancel, DateTime.now());
    } catch (error) {
      throw InternetException('Something Went Wrong!!!');
    }

    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    _orders[orderIndex] = _orders[orderIndex].copyWith(
      status: 'canceled',
      reasonIfCanceled: reasonOfCancel,
    );
    notifyListeners();
  }

  Order getOrderById(String orderId) =>
      _orders.firstWhere((order) => order.id == orderId);

  Future<void> removeOrderById(String orderId) async {
    final hasNetwork = await InternetService.hasNetwork();
    if (!hasNetwork) {
      throw InternetException(
          'You are currently offline, order did not get deleted!!!');
    }

    try {
      await Firestore.deleteOrder(orderId);

      await CloudStorage.delete('orders', orderId);
    } catch (error) {
      throw InternetException(error
          .toString() /*'Something Went Wrong, order did not get deleted!!!'*/);
    }

    _orders.removeWhere((order) => order.id == orderId);
    notifyListeners();
  }
}

/////////////////////////////////////////////////////////////////////////////////////////
///////// orders class that handle some work ///////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

class Order {
  const Order({
    required this.id,
    required this.serviceGiverId,
    required this.serviceGiverName,
    required this.serviceGiverImage,
    required this.serviceGiverPhoneNumber,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userPhoneNumber,
    required this.serviceName,
    required this.cost,
    required this.quantity,
    required this.description,
    required this.image,
    required this.date,
    required this.status,
    this.reasonIfCanceled,
    this.dateOfFinishedOrCanceled,
  });

  final String id;
  final String serviceGiverId;
  final String serviceGiverName;
  final String serviceGiverImage;
  final String serviceGiverPhoneNumber;
  final String userId;
  final String userName;
  final String userImage;
  final String userPhoneNumber;
  final String serviceName;
  final double cost;
  final int quantity;
  final String description;
  final String image;
  final DateTime date;
  final String status;
  final String? reasonIfCanceled;
  final DateTime? dateOfFinishedOrCanceled;

  Order.fromFiretore(QueryDocumentSnapshot<Map<String, dynamic>> document)
      : id = document.id,
        serviceGiverId = document.data()['service_giver_id'],
        serviceGiverName = document.data()['service_giver_name'],
        serviceGiverImage = document.data()['service_giver_image'],
        serviceGiverPhoneNumber = document.data()['service_giver_phone_number'],
        userId = document.data()['user_id'],
        userName = document.data()['user_name'],
        userImage = document.data()['user_image'],
        userPhoneNumber = document.data()['user_phone_number'],
        serviceName = document.data()['service_name'],
        cost = (document.data()['cost'] as num).toDouble(),
        quantity = (document.data()['quantity'] as num).toInt(),
        description = document.data()['description'],
        image = document.data()['image'],
        date = (document.data()['date'] as Timestamp).toDate(),
        status = document.data()['status'],
        reasonIfCanceled = document.data()['reason_if_canceled'],
        dateOfFinishedOrCanceled =
            (document.data()['date_of_finished_or_canceled'] as Timestamp?)
                ?.toDate();

  Map<String, dynamic> toFirestore() => {
        'service_giver_id': serviceGiverId,
        'service_giver_name': serviceGiverName,
        'service_giver_image': serviceGiverImage,
        'service_giver_phone_number': serviceGiverPhoneNumber,
        'user_id': userId,
        'user_name': userName,
        'user_image': userImage,
        'user_phone_number': userPhoneNumber,
        'service_name': serviceName,
        'cost': cost,
        'quantity': quantity,
        'description': description,
        'image': image,
        'date': date,
        'status': status,
        'reason_if_canceled': reasonIfCanceled,
        'date_of_finished_or_canceled': dateOfFinishedOrCanceled,
      };

  Order copyWith({
    String? id,
    String? serviceGiverId,
    String? serviceGiverName,
    String? serviceGiverImage,
    String? serviceGiverPhoneNumber,
    String? userId,
    String? userName,
    String? userImage,
    String? userPhoneNumber,
    String? serviceName,
    double? cost,
    int? quantity,
    String? description,
    String? image,
    DateTime? date,
    String? status,
    String? reasonIfCanceled,
    DateTime? dateOfFinishedOrCanceled,
  }) =>
      Order(
        id: id ?? this.id,
        serviceGiverId: serviceGiverId ?? this.serviceGiverId,
        serviceGiverName: serviceGiverName ?? this.serviceGiverName,
        serviceGiverImage: serviceGiverImage ?? this.serviceGiverImage,
        serviceGiverPhoneNumber:
            serviceGiverPhoneNumber ?? this.serviceGiverPhoneNumber,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userImage: userImage ?? this.userImage,
        userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
        serviceName: serviceName ?? this.serviceName,
        cost: cost ?? this.cost,
        quantity: quantity ?? this.quantity,
        description: description ?? this.description,
        image: image ?? this.image,
        date: date ?? this.date,
        status: status ?? this.status,
        reasonIfCanceled: reasonIfCanceled ?? this.reasonIfCanceled,
        dateOfFinishedOrCanceled:
            dateOfFinishedOrCanceled ?? this.dateOfFinishedOrCanceled,
      );
}

////////////////////////////////////////////////////////////////////////////////
//////////////// Helper Functions Used In The Order ////////////////////////////
////////////////////////////////////////////////////////////////////////////////

