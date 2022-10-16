import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/location_info.dart';

class LocationInfoModel extends LocationInfo {
  const LocationInfoModel({
    required double latitude,
    required double longitude,
    required double speed,
    required DateTime time,
    required double heading,
  }) : super(
          latitude: latitude,
          longitude: longitude,
          speed: speed,
          time: time,
          heading: heading,
        );

  factory LocationInfoModel.fromJson(Map<String, dynamic> json) {
    return LocationInfoModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      speed: (json['speed'] as num).toDouble(),
      time: (json['time'] as Timestamp).toDate(),
      heading: (json['heading'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'time': time,
      'heading': heading,
    };
  }
}
