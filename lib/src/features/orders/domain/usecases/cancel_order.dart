import '../repositories/orders_repository.dart';

class CancelOrderUsecase {
  final OrdersRepository repository;

  CancelOrderUsecase(this.repository);

  Future<void> call(
          String orderId, String reasonOfCancel, DateTime dateOfCancel) =>
      repository.cancelOrder(orderId, reasonOfCancel, dateOfCancel);
}
