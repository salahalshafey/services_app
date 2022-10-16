import '../entities/location_info.dart';
import '../entities/previous_locations_info.dart';
import '../repositories/tracking_repository.dart';

class GetPreviousLocationsInfoUsecase {
  final TrackingRepository repository;

  GetPreviousLocationsInfoUsecase(this.repository);

  Future<PreviousLocationsInfo> call(
    String orderId, {
    List<LocationInfo>? previousLocations,
  }) =>
      repository.getPreviousLocationsInfo(
        orderId,
        previousLocations: previousLocations,
      );
}
