import '../../../../core/error/exceptions_without_message.dart';
import '../../../../core/network/network_info.dart';

import '../../domain/entities/service.dart';
import '../../domain/repositories/services_repository.dart';
import '../datasources/service_remote_data_source.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServiceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ServicesRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<List<Service>> getAllServices() async {
    if (await networkInfo.isNotConnected) {
      throw OfflineException();
    }

    return remoteDataSource.getAllServices();
  }
}
