import '../entities/service.dart';
import '../repositories/services_repository.dart';

class GetAllServicesUsecase {
  final ServicesRepository repository;

  GetAllServicesUsecase(this.repository);

  Future<List<Service>> call() => repository.getAllServices();
}
