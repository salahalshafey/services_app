import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/tracking_info.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../datasources/tracking_remote_data_source.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TrackingRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Stream<TrackingInfo> getTrackingLive(String orderId) async* {
    if (await networkInfo.isNotConnected) {
      throw OfflineException();
    }

    yield* remoteDataSource.getTrackingLive(orderId);
  }
}
