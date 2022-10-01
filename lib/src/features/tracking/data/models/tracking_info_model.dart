import '../../domain/entities/tracking_info.dart';
import 'location_info_model.dart';

class TrackingInfoModel extends TrackingInfo {
  const TrackingInfoModel({
    required bool isServiceGiverSharingLocation,
    required LocationInfoModel? lastSeenLocation,
    required List<LocationInfoModel> previousLocations,
  }) : super(
          isServiceGiverSharingLocation: isServiceGiverSharingLocation,
          lastSeenLocation: lastSeenLocation,
          previousLocations: previousLocations,
        );

  factory TrackingInfoModel.fromJson(Map<String, dynamic> json) {
    return TrackingInfoModel(
      isServiceGiverSharingLocation: json['is_service_giver_sharing_location'],
      lastSeenLocation: LocationInfoModel.fromJson(json['last_seen_location']),
      previousLocations: (json['previous_locations'] as List<dynamic>)
          .map((location) => LocationInfoModel.fromJson(location))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_service_giver_sharing_location': isServiceGiverSharingLocation,
      'last_seen_location': lastSeenLocation?.toModel().toJson(),
      'previous_locations': previousLocations
          .map((location) => location.toModel().toJson())
          .toList(),
    };
  }
}
