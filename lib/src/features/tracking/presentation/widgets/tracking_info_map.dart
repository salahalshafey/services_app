import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/util/functions/date_time_and_duration.dart';
import '../../../../core/util/functions/distance_and_speed.dart';
import '../../../../core/theme/map_styles.dart';
import '../../../../core/util/builders/custom_snack_bar.dart';

import '../../data/models/road_info_model.dart';
import '../../domain/entities/previous_locations_info.dart';

import 'go_to_location_button.dart';
import 'journey_info.dart';

class TrackingInfoMap extends StatefulWidget {
  const TrackingInfoMap({
    required this.previousLocationsInfo,
    this.mapType,
    Key? key,
  }) : super(key: key);

  final PreviousLocationsInfo previousLocationsInfo;
  final MapType? mapType;

  @override
  State<TrackingInfoMap> createState() => _TrackingInfoMapState();
}

class _TrackingInfoMapState extends State<TrackingInfoMap> {
  late GoogleMapController _controller;
  Uint8List? newMarkerIcon;
  // ignore: prefer_final_fields
  late MapType _mapType = widget.mapType ?? MapType.normal;
  Marker? _midRoadMarker;

  void _onMapCreated(GoogleMapController controller) async {
    _controller = controller;

    // to do in the future: change the icon according to the serviceName
    const serviceName = 'artisan';
    newMarkerIcon = (await rootBundle.load('assets/icons/$serviceName.png'))
        .buffer
        .asUint8List();
    setState(() {});
  }

  void _hidMideRoadMarker() {
    setState(() {
      _midRoadMarker = null;
    });
  }

  void _showMideRoadMarker(RoadInfo road) async {
    final roadDistance = totalRoadDistance(road.locations);
    final midPosition = locationOfMidDistance(road.locations, roadDistance);

    _midRoadMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      markerId: const MarkerId('midRoad'),
      position: midPosition,
      infoWindow: InfoWindow(
        title: wellFormatedDistance(roadDistance),
        snippet: 'average speed: ${road.averageSpeed.toStringAsFixed(0)} km/h',
        onTap: () {
          showCustomSnackBar(
              context: context,
              content: 'it took ${wellFormatedDuration(road.duration)}');
        },
      ),
    );
    setState(() {});

    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: midPosition,
      zoom: distanceInMeterToZoomLevel(roadDistance),
    )));

    await Future.delayed(const Duration(milliseconds: 100));
    _controller.showMarkerInfoWindow(const MarkerId('midRoad'));
  }

  Duration get _totalDuration {
    final previousLocationsInfo = widget.previousLocationsInfo;
    return previousLocationsInfo.endTime.difference(
      previousLocationsInfo.startTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final previousLocationsInfo = widget.previousLocationsInfo;

    final totalDistance = previousLocationsInfo.totalDistance;
    final midLocation = previousLocationsInfo.locationOfMidDistance;

    final lastSeenLocation = previousLocationsInfo.roads.last.locations.last;
    final firstSeenLocation = previousLocationsInfo.roads.first.locations.first;

    final roads = previousLocationsInfo.roads;

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: midLocation,
            zoom: distanceInMeterToZoomLevel(totalDistance),
          ),
          style: Theme.of(context).brightness == Brightness.light
              ? GOOGLE_MAPS_RETRO_STYLE
              : GOOGLE_MAPS_DARKE_STYLE,
          mapType: _mapType,
          onMapCreated: _onMapCreated,
          onTap: (_) => _hidMideRoadMarker(),
          polylines: roads
              .map((road) => Polyline(
                    polylineId: PolylineId(road.hashCode.toString()),
                    points: road.locations,
                    color: speedRangeToColor(road.speedRange),
                    width: 7,
                    consumeTapEvents: true,
                    onTap: () => _showMideRoadMarker(road),
                  ))
              .toSet(),
          markers: {
            Marker(
              icon: BitmapDescriptor.defaultMarkerWithHue(1),
              markerId: const MarkerId('firstSeen'),
              position: firstSeenLocation,
              infoWindow: InfoWindow(
                title: 'First seen',
                snippet: wellFormattedDateTime(previousLocationsInfo.startTime),
              ),
            ),
            if (_midRoadMarker != null) _midRoadMarker!,
            Marker(
              icon: newMarkerIcon == null
                  ? BitmapDescriptor.defaultMarker
                  : BitmapDescriptor.fromBytes(newMarkerIcon!),
              markerId: const MarkerId('lastSeen'),
              position: lastSeenLocation,
              infoWindow: InfoWindow(
                title: 'Last seen',
                snippet: wellFormattedDateTime(previousLocationsInfo.endTime),
              ),
            ),
          }, //_markers,
          myLocationEnabled: true,
        ),
        GoToLocationButton(
          positionOfButtonFromTop: 75,
          icon: Icons.location_pin,
          location: firstSeenLocation,
          markerId: 'firstSeen',
          controller: () => _controller,
          hideMidRoadMarker: _hidMideRoadMarker,
        ),
        GoToLocationButton(
          positionOfButtonFromTop: 140,
          icon: Icons.location_disabled,
          location: lastSeenLocation,
          markerId: 'lastSeen',
          controller: () => _controller,
          hideMidRoadMarker: _hidMideRoadMarker,
        ),
        JourneyInfo(
          totalDistance: totalDistance,
          totalDuration: _totalDuration,
        ),
      ],
    );
  }
}

Color speedRangeToColor(SpeedRange speedRange) {
  switch (speedRange) {
    case SpeedRange.between0To20:
      return Colors.red[900]!;

    case SpeedRange.between20To40:
      return Colors.red;

    case SpeedRange.between40To80:
      return Colors.orange;

    case SpeedRange.between80To120:
      return Colors.green;

    default:
      return Colors.blue;
  }
}

double totalRoadDistance(List<LatLng> locations) {
  double totalDistance = 0.0;
  for (int i = 0; i < locations.length - 1; i++) {
    totalDistance +=
        distanceBetweenTwoCoordinate(locations[i], locations[i + 1]);
  }

  return totalDistance;
}

double distanceInMeterToZoomLevel(double distanceInMeter) {
  if (distanceInMeter == 0) {
    return 19;
  }
  return logBas2(80000000 / distanceInMeter);
}

double logBas2(num x) {
  return log(x) / log(2);
}

LatLng locationOfMidDistance(List<LatLng> locations, double totalDistance) {
  LatLng lastLocation = locations.first;
  double currentDistance = 0.0;
  final halfDistance = totalDistance / 2;

  for (int i = 1; i < locations.length; i++) {
    final currentLocation = locations[i];
    currentDistance +=
        distanceBetweenTwoCoordinate(lastLocation, currentLocation);

    if (currentDistance >= halfDistance) {
      return lastLocation;
    }

    lastLocation = currentLocation;
  }

  return lastLocation;
}
