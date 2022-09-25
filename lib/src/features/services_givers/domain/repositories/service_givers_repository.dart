import '../entities/service_giver.dart';

abstract class ServiceGiversRepository {
  Future<List<ServiceGiver>> getAllServiceGivers(String serviceId);
}
