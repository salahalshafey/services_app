import 'dart:io';

import '../entities/order.dart';

abstract class OrdersRepository {
  Future<List<Order>> getAllUserOrders(String userId);
  Future<Order> addOrder(Order order, File image);
  Future<void> cancelOrder(
      String orderId, String reasonOfCancel, DateTime dateOfCancel);
  Future<void> removeOrder(String orderId);
}
