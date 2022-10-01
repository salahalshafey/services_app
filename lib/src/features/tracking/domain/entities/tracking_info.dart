import 'package:equatable/equatable.dart';

import 'location_info.dart';

class TrackingInfo extends Equatable {
  final bool isServiceGiverSharingLocation;
  final LocationInfo? lastSeenLocation;
  final List<LocationInfo> previousLocations;

  const TrackingInfo({
    required this.isServiceGiverSharingLocation,
    required this.lastSeenLocation,
    required this.previousLocations,
  });

  TrackingInfo copyWith({
    bool? isServiceGiverSharingLocation,
    LocationInfo? lastSeenLocation,
    List<LocationInfo>? previousLocations,
  }) =>
      TrackingInfo(
        isServiceGiverSharingLocation:
            isServiceGiverSharingLocation ?? this.isServiceGiverSharingLocation,
        lastSeenLocation: lastSeenLocation ?? this.lastSeenLocation,
        previousLocations: previousLocations ?? this.previousLocations,
      );

  @override
  List<Object?> get props => [
        isServiceGiverSharingLocation,
        lastSeenLocation,
        previousLocations,
      ];

  @override
  bool? get stringify => true;
}
