import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/exceptions.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getAllUserOrders(String userId);
  Future<String> addOrder(OrderModel order);
  Future<void> updateImage(String docId, String newImage);
  Future<void> cancelOrder(
      String orderId, String reasonOfCancel, DateTime dateOfCancel);
  Future<void> removeOrder(String orderId);
}

class OrderFirestoreImpl implements OrderRemoteDataSource {
  OrderFirestoreImpl();

  @override
  Future<List<OrderModel>> getAllUserOrders(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('orders')
          .where('user_id', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return response.docs
          .map((document) => OrderModel.fromFirestore(document))
          .toList();
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<String> addOrder(OrderModel order) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('orders')
          .add(order.toFirestore());

      return response.id;
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateImage(String docId, String newImage) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(docId)
          .update({'image': newImage});
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<void> cancelOrder(
      String orderId, String reasonOfCancel, DateTime dateOfCancel) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
        'status': 'canceled',
        'reason_if_canceled': reasonOfCancel,
        'date_of_finished_or_canceled': dateOfCancel
      });
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<void> removeOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .delete();
    } catch (error) {
      throw ServerException();
    }
  }
}
