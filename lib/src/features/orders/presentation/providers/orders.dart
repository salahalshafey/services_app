import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/error/error_exceptions_with_message.dart';
import '../../../../core/error/exceptions_without_message.dart';

import '../../data/models/order_model.dart';
import '../../domain/entities/order.dart';

import '../../domain/usecases/add_order.dart';
import '../../domain/usecases/cancel_order.dart';
import '../../domain/usecases/get_all_user_orders.dart';
import '../../domain/usecases/remove_order.dart';

class Orders with ChangeNotifier {
  Orders({
    required this.getAllUserOrders,
    required this.addUserOrder,
    required this.canceUserOrder,
    required this.removeOrder,
  });

  final GetAllUserOrdersUsecase getAllUserOrders;
  final AddOrderUsecase addUserOrder;
  final CancelOrderUsecase canceUserOrder;
  final RemoveOrderUsecase removeOrder;

  List<Order> _orders = [];
  //  List<Order> _currentOrders = [];
  //  List<Order> _previousOrders = [];
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
    try {
      _orders = await getAllUserOrders(userId);
      notifyListeners();
    } on OfflineException {
      throw ErrorMessage('You are currently offline.');
    } on ServerException {
      throw ErrorMessage('Something went wrong, please try again later.');
    } catch (error) {
      throw ErrorMessage('An unexpected error happened.');
    }
  }

  List<Order> get previousAndCanceledOrders =>
      _orders.where((order) => order.status != 'not finished').toList();

  List<Order> get currentOrders =>
      _orders.where((order) => order.status == 'not finished').toList();

  Future<String> addOrder(Order order, File image) async {
    try {
      order = await addUserOrder(order, image);

      _orders.insert(0, OrderModel.fromOrder(order));
      notifyListeners();

      return order.id;
    } on OfflineException {
      throw ErrorMessage('You are currently offline.');
    } on ServerException {
      throw ErrorMessage('Something went wrong, please try again later.');
    } catch (error) {
      throw ErrorMessage('An unexpected error happened.');
    }
  }

  Future<void> cancelOrder(String orderId, String reasonOfCancel) async {
    try {
      final currentDate = DateTime.now();
      await canceUserOrder(orderId, reasonOfCancel, currentDate);

      final orderIndex = _orders.indexWhere((order) => order.id == orderId);
      final canceledOrder = _orders[orderIndex].copyWith(
        status: 'canceled',
        reasonIfCanceled: reasonOfCancel,
        dateOfFinishedOrCanceled: currentDate,
      );
      _orders[orderIndex] = OrderModel.fromOrder(canceledOrder);
      notifyListeners();
    } on OfflineException {
      throw ErrorMessage('You are currently offline.');
    } on ServerException {
      throw ErrorMessage('Something went wrong, please try again later.');
    } catch (error) {
      throw ErrorMessage('An unexpected error happened.');
    }
  }

  Order getOrderById(String orderId) =>
      _orders.firstWhere((order) => order.id == orderId);

  Future<void> removeOrderById(String orderId) async {
    try {
      await removeOrder(orderId);

      _orders.removeWhere((order) => order.id == orderId);
      notifyListeners();
    } on OfflineException {
      throw ErrorMessage(
          'You are currently offline, order did not get deleted!!!');
    } on ServerException {
      throw ErrorMessage('Something Went Wrong, order did not get deleted!!!');
    } catch (error) {
      throw ErrorMessage('An unexpected error happened.');
    }
  }
}
