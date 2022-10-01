import 'package:services_app/src/features/tracking/domain/entities/tracking_info.dart';

abstract class TrackingRepository {
  Stream<TrackingInfo> getTrackingLive(String orderId);
  // getTracingOnce()
  // sendLocation()

}
