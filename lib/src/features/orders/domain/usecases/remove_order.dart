import '../repositories/orders_repository.dart';

class RemoveOrderUsecase {
  final OrdersRepository repository;

  RemoveOrderUsecase(this.repository);

  Future<void> call(String orderId) => repository.removeOrder(orderId);
}
