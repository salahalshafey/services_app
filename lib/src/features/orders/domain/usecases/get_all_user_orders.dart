import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class GetAllUserOrdersUsecase {
  final OrdersRepository repository;

  GetAllUserOrdersUsecase(this.repository);

  Future<List<Order>> call(String userId) =>
      repository.getAllUserOrders(userId);
}
