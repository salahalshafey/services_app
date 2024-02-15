import 'dart:io';

import 'package:services_app/src/features/orders/data/models/order_model.dart';

import '../../../../core/error/exceptions_without_message.dart';
import '../../../../core/network/network_info.dart';

import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/order_remote_data_source.dart';
import '../datasources/order_remote_storage.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderRemoteStorage remoteStorage;
  final NetworkInfo networkInfo;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.remoteStorage,
  });

  @override
  Future<List<Order>> getAllUserOrders(String userId) async {
    if (await networkInfo.isNotConnected) {
      throw OfflineException();
    }

    return remoteDataSource.getAllUserOrders(userId);
  }

  @override
  Future<Order> addOrder(Order order, File image) async {
    if (await networkInfo.isNotConnected) {
      throw OfflineException();
    }

    try {
      final docId =
          await remoteDataSource.addOrder(OrderModel.fromOrder(order));

      final downloadURL = await remoteStorage.upload(docId, image);

      await remoteDataSource.updateImage(docId, downloadURL);

      return order.copyWith(id: docId, image: downloadURL);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> cancelOrder(
      String orderId, String reasonOfCancel, DateTime dateOfCancel) async {
    if (await networkInfo.isNotConnected) {
      throw OfflineException();
    }

    return remoteDataSource.cancelOrder(orderId, reasonOfCancel, dateOfCancel);
  }

  @override
  Future<void> removeOrder(String orderId) async {
    if (await networkInfo.isNotConnected) {
      throw OfflineException();
    }

    try {
      await remoteDataSource.removeOrder(orderId);

      await remoteStorage.delete(orderId);
    } catch (error) {
      rethrow;
    }
  }
}
