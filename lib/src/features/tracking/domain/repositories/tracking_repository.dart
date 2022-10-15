import '../entities/previous_locations_info.dart';
import '../entities/tracking_info.dart';

abstract class TrackingRepository {
  Stream<TrackingInfo> getTrackingLive(String orderId);
  Future<PreviousLocationsInfo> getPreviousLocationsInfo(String orderId);
  // sendLocation()

}
