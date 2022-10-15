import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/models/road_info_model.dart';

class PreviousLocationsInfo {
  /// total distance in meter
  final double totalDistance;
  final LatLng locationOfMidDistance;
  final DateTime startTime;
  final DateTime endTime;
  final List<RoadInfo> roads;

  const PreviousLocationsInfo({
    required this.totalDistance,
    required this.locationOfMidDistance,
    required this.startTime,
    required this.endTime,
    required this.roads,
  });
}

class RoadInfo {
  /// average speed in km/h
  final double averageSpeed;
  final SpeedRange speedRange;
  final Duration duration;
  final List<LatLng> locations;

  const RoadInfo({
    required this.averageSpeed,
    required this.speedRange,
    required this.duration,
    required this.locations,
  });
}
