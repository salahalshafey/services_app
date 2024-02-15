import 'dart:convert';

//import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/error/exceptions_without_message.dart';
import '../models/response_location_of_roads_api.dart';
import 'package:http/http.dart' as http;

import 'api_keys.dart';

abstract class TrackingMapsService {
  Future<List<ResponseLocationOfRoadsAPI>> getRoadsLocations(
      List<LatLng> locations);
}

//final googleMapsAPIkey = FlutterConfig.get('google_maps_API_key') as String;

class TrackingGoogleMapsImpl implements TrackingMapsService {
  @override
  Future<List<ResponseLocationOfRoadsAPI>> getRoadsLocations(
      List<LatLng> locations) async {
    try {
      final responses = await Future.wait(
        _devideTo100OrLessLocations(locations).map(
          (devided100OrLessLocations) =>
              _get100OrLessRoadsLocations(devided100OrLessLocations),
        ),
      );

      for (int i = 1; i < responses.length; i++) {
        responses[i].first.originalIndex = null;
      }

      int index = 0;
      return responses.fold<List<ResponseLocationOfRoadsAPI>>(
        [],
        (previousValue, element) => previousValue + element,
      ).map((response) {
        if (response.originalIndex != null) {
          response.originalIndex = index++;
          return response;
        }
        return response;
      }).toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<ResponseLocationOfRoadsAPI>> _get100OrLessRoadsLocations(
      List<LatLng> locations) async {
    final url = Uri.parse(
      "https://roads.googleapis.com/v1/snapToRoads"
      "?interpolate=true"
      "&path=${_locationsToPath(locations)}"
      "&key=$googleMapsAPIKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> responseLocations =
          responseJson['snappedPoints'] ?? [];

      return responseLocations
          .map((map) => ResponseLocationOfRoadsAPI.fromJson(map))
          .toList();
    } else {
      throw ServerException();
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Helper Functions ///////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

List<List<LatLng>> _devideTo100OrLessLocations(List<LatLng> locations) {
  List<List<LatLng>> devidedTo100OrLessLocations = [];
  for (int i = 0; i < locations.length; i += 99) {
    final to100OrLessLocations = locations.sublist(
      i,
      (i + 100) > locations.length ? locations.length : i + 100,
    );
    devidedTo100OrLessLocations.add(to100OrLessLocations);
  }

  return devidedTo100OrLessLocations;
}

String _locationsToPath(List<LatLng> locations) {
  String path = '';
  if (locations.isEmpty) {
    return path;
  }

  for (final location in locations) {
    path += '${location.latitude}%2C${location.longitude}%7C';
  }

  return path.substring(0, path.length - 3);
}
