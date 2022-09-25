import '../entities/service_giver.dart';
import '../repositories/service_givers_repository.dart';

class GetAllServiceGiversUsecase {
  final ServiceGiversRepository repository;

  GetAllServiceGiversUsecase(this.repository);

  Future<List<ServiceGiver>> call(String serviceId) {
    return repository.getAllServiceGivers(serviceId);
  }
}
