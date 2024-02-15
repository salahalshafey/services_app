import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/error/exceptions_without_message.dart';
import '../../../../core/network/network_info.dart';

import '../../../../core/util/classes/pair_class.dart';

import '../../../../core/util/functions/distance_and_speed.dart';
import '../../domain/entities/location_info.dart';
import '../../domain/entities/previous_locations_info.dart';
import '../../domain/entities/tracking_info.dart';
import '../../domain/repositories/tracking_repository.dart';

import '../datasources/maps_servcice.dart';
import '../datasources/tracking_remote_data_source.dart';
import '../models/response_location_of_roads_api.dart';
import '../models/road_info_model.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDataSource remoteDataSource;
  final TrackingMapsService mapsService;
  final NetworkInfo networkInfo;

  TrackingRepositoryImpl({
    required this.remoteDataSource,
    required this.mapsService,
    required this.networkInfo,
  });
  @override
  Stream<TrackingInfo> getTrackingLive(String orderId) async* {
    if (await networkInfo.isNotConnected) {
      throw OfflineException();
    }

    yield* remoteDataSource.getTrackingLive(orderId);
  }

  @override
  Future<PreviousLocationsInfo> getPreviousLocationsInfo(
    String orderId, {
    List<LocationInfo>? previousLocations,
  }) async {
    if (await networkInfo.isNotConnected) {
      throw OfflineException();
    }

    try {
      final _previousLocations = previousLocations ??
          (await remoteDataSource.getTrackingOnce(orderId)).previousLocations;
      if (_previousLocations.isEmpty) {
        throw EmptyDataException();
      }

      final totatDistance = _totalDistanceInMeter(_previousLocations);
      final locationOfMidDistance =
          _locationOfMidDistance(_previousLocations, totatDistance);
      final startTime = _previousLocations.first.time;
      final endTime = _previousLocations.last.time;

      List<List<LocationInfo>> locationsSections =
          _breakPreviousLocationsIfGapsDetected(_previousLocations);

      final roadsInitial = await Future.wait(
        locationsSections.map((locationsSection) =>
            _getPreviousLocationsSection(locationsSection)),
      );

      final roads = roadsInitial.fold<List<RoadInfo>>(
        [],
        (previousValue, element) => previousValue + element,
      );

      return PreviousLocationsInfo(
        totalDistance: totatDistance,
        locationOfMidDistance: locationOfMidDistance,
        startTime: startTime,
        endTime: endTime,
        roads: roads,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<List<RoadInfo>> _getPreviousLocationsSection(
      List<LocationInfo> locationsOfSection) async {
    try {
      if (locationsOfSection.isEmpty) {
        return [];
      }

      final List<RoadInfoModel> roadsInitial =
          _devideLocationsIntoRangesOfSpeedWithInfo(locationsOfSection);

      final responsesRoadsLocations = await mapsService.getRoadsLocations(
        locationsOfSection
            .map((loc) => LatLng(loc.latitude, loc.longitude))
            .toList(),
      );

      return _roadsInitialIntoRoadsFinalLocations(
        roadsInitial,
        responsesRoadsLocations,
      );
    } catch (error) {
      rethrow;
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Helper Functions ///////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

LatLng _locationOfMidDistance(
    List<LocationInfo> previousLocations, double totalDistance) {
  LatLng lastLocation = LatLng(
    previousLocations.first.latitude,
    previousLocations.first.longitude,
  );
  double currentDistance = 0.0;
  final halfDistance = totalDistance / 2;

  for (int i = 1; i < previousLocations.length; i++) {
    final currentLocation = LatLng(
      previousLocations[i].latitude,
      previousLocations[i].longitude,
    );
    currentDistance +=
        distanceBetweenTwoCoordinate(lastLocation, currentLocation);
    lastLocation = currentLocation;
    if (currentDistance >= halfDistance) {
      return lastLocation;
    }
  }

  return lastLocation;
}

/// ## if the distance between two points is greater than 300 meter break it into different list
List<List<LocationInfo>> _breakPreviousLocationsIfGapsDetected(
    List<LocationInfo> previousLocations) {
  List<List<LocationInfo>> locationsSections = [];
  int startingIndex = 0;

  for (int i = 0; i < previousLocations.length - 1; i++) {
    final distance = distanceBetweenTwoCoordinate(
      LatLng(
        previousLocations[i].latitude,
        previousLocations[i].longitude,
      ),
      LatLng(
        previousLocations[i + 1].latitude,
        previousLocations[i + 1].longitude,
      ),
    );
    if (distance > 300) {
      locationsSections.add(previousLocations.sublist(startingIndex, i + 1));
      startingIndex = i + 1;
    }
  }
  locationsSections
      .add(previousLocations.sublist(startingIndex, previousLocations.length));

  return locationsSections;
}

double _totalDistanceInMeter(List<LocationInfo> previousLocations) {
  double totalDistance = 0.0;
  for (int i = 0; i < previousLocations.length - 1; i++) {
    totalDistance += distanceBetweenTwoCoordinate(
      LatLng(
        previousLocations[i].latitude,
        previousLocations[i].longitude,
      ),
      LatLng(
        previousLocations[i + 1].latitude,
        previousLocations[i + 1].longitude,
      ),
    );
  }

  return totalDistance;
}

List<RoadInfo> _roadsInitialIntoRoadsFinalLocations(
  List<RoadInfoModel> roadsInitial,
  List<ResponseLocationOfRoadsAPI> responsesRoadsLocations,
) {
  int startingIndex = 0;
  return roadsInitial.map((roadInitial) {
    final List<LatLng> locations = _getFullRangeLocations(
      responsesRoadsLocations,
      roadInitial.indexRange,
      start: startingIndex,
    );
    startingIndex = locations.length - 1 + startingIndex;

    return RoadInfo(
      averageSpeed: roadInitial.averageSpeed,
      speedRange: roadInitial.speedRange,
      duration: roadInitial.duration,
      locations: locations,
    );
  }).toList();
}

List<RoadInfoModel> _devideLocationsIntoRangesOfSpeedWithInfo(
    List<LocationInfo> locationsOfSection) {
  final List<RoadInfoModel> roadsInitial = [];
  SpeedRange lastSpeedRange = _getRange(locationsOfSection.first.speed);
  double speedSum = locationsOfSection.first.speed;
  int firstIndex = 0;

  for (int currentIndex = 1;
      currentIndex < locationsOfSection.length;
      currentIndex++) {
    final currentSpeedRange = _getRange(locationsOfSection[currentIndex].speed);
    if (currentSpeedRange != lastSpeedRange) {
      roadsInitial.add(
        RoadInfoModel(
          averageSpeed: (speedSum / (currentIndex - firstIndex)) * 3.6,
          speedRange: lastSpeedRange,
          duration: locationsOfSection[currentIndex].time.difference(
                locationsOfSection[firstIndex].time,
              ),
          indexRange: Pair(firstIndex, currentIndex),
        ),
      );

      firstIndex = currentIndex;
      lastSpeedRange = currentSpeedRange;
      speedSum = locationsOfSection[currentIndex].speed;
    } else {
      speedSum += locationsOfSection[currentIndex].speed;
    }
  }

  roadsInitial.add(
    RoadInfoModel(
      averageSpeed: (speedSum / (locationsOfSection.length - firstIndex)) * 3.6,
      speedRange: lastSpeedRange,
      duration:
          locationsOfSection[locationsOfSection.length - 1].time.difference(
                locationsOfSection[firstIndex].time,
              ),
      indexRange: Pair(firstIndex, locationsOfSection.length - 1),
    ),
  );
  return roadsInitial;
}

List<LatLng> _getFullRangeLocations(
  List<ResponseLocationOfRoadsAPI> responses,
  Pair<int, int> range, {
  required int start,
}) {
  List<LatLng> fullRangeLocations = [];
  for (int i = start; i < responses.length; i++) {
    fullRangeLocations.add(LatLng(
      responses[i].location.latitude,
      responses[i].location.longitude,
    ));
    if (responses[i].originalIndex != null &&
        responses[i].originalIndex == range.second) {
      break;
    }
  }

  return fullRangeLocations;
}

SpeedRange _getRange(double speedInMeterPerSec) {
  final speedInKPerH = speedInMeterPerSec * 3.6;
  if (speedInKPerH >= 0 && speedInKPerH < 20) {
    return SpeedRange.between0To20;
  }
  if (speedInKPerH >= 20 && speedInKPerH < 40) {
    return SpeedRange.between20To40;
  }
  if (speedInKPerH >= 40 && speedInKPerH < 80) {
    return SpeedRange.between40To80;
  }
  if (speedInKPerH >= 80 && speedInKPerH < 120) {
    return SpeedRange.between80To120;
  }
  return SpeedRange.largerThan120;
}
