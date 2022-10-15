import 'package:google_maps_flutter/google_maps_flutter.dart';

class ResponseLocationOfRoadsAPI {
  final LatLng location;
  int? originalIndex;
  final String placeId;

  ResponseLocationOfRoadsAPI({
    required this.location,
    required this.originalIndex,
    required this.placeId,
  });

  factory ResponseLocationOfRoadsAPI.fromJson(Map<String, dynamic> json) {
    return ResponseLocationOfRoadsAPI(
      location: LatLng(
        json['location']['latitude'],
        json['location']['longitude'],
      ),
      originalIndex: json['originalIndex'],
      placeId: json['placeId'],
    );
  }

  @override
  String toString() {
    return 'ResponseLocationOfRoadsAPI(location: $location, originalIndex: $originalIndex, placeId: $placeId)\n';
  }
}
