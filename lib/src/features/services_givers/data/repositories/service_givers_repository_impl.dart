import '../../../../core/error/exceptions_without_message.dart';
import '../../../../core/network/network_info.dart';

import '../../domain/entities/service_giver.dart';
import '../../domain/repositories/service_givers_repository.dart';

import '../datasources/service_giver_remote_data_source.dart';

class ServiceGiversRepositoryImpl implements ServiceGiversRepository {
  final ServiceGiverRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ServiceGiversRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<List<ServiceGiver>> getAllServiceGivers(String serviceId) async {
    if (await networkInfo.isNotConnected) {
      throw OfflineException();
    }

    return remoteDataSource.getAllServiceGivers(serviceId);
  }
}
