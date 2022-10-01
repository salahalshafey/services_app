import '../entities/tracking_info.dart';
import '../repositories/tracking_repository.dart';

class GetTrackingLiveUsecase {
  final TrackingRepository repository;

  GetTrackingLiveUsecase(this.repository);

  Stream<TrackingInfo> call(String orderId) =>
      repository.getTrackingLive(orderId);
}
