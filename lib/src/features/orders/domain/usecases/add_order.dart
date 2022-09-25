import 'dart:io';

import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class AddOrderUsecase {
  final OrdersRepository repository;

  AddOrderUsecase(this.repository);

  Future<Order> call(Order order, File image) =>
      repository.addOrder(order, image);
}
