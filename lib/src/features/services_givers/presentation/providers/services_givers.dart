import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/error/error_exceptions_with_message.dart';
import '../../../../core/error/exceptions_without_message.dart';
import '../../domain/entities/service_giver.dart';
import '../../domain/usecases/get_all_sevice_givers.dart';

class ServicesGivers with ChangeNotifier {
  ServicesGivers({required this.getAllServiceGivers});

  final GetAllServiceGiversUsecase getAllServiceGivers;

  List<ServiceGiver> _serviceGivers = [];

  Future<void> getAndFetchServicesGivers(String serviceId) async {
    try {
      _serviceGivers = await getAllServiceGivers(serviceId);

      notifyListeners();
    } on OfflineException {
      throw ErrorMessage('You are currently offline.');
    } on ServerException {
      throw ErrorMessage('Something Went Wrong!!!');
    }
  }

  List<ServiceGiver> get getServiceGivers => [..._serviceGivers];

  ServiceGiver getServiceGiverById(String serviceGiverId) => _serviceGivers
      .firstWhere((serviceGiver) => serviceGiver.id == serviceGiverId);

  LatLng get locationOfHighestRating {
    int indexOfHighestRating = 0;
    for (int i = 0; i < _serviceGivers.length; i++) {
      if (_serviceGivers[i].rating >
          _serviceGivers[indexOfHighestRating].rating) {
        indexOfHighestRating = i;
      }
    }
    return _serviceGivers[indexOfHighestRating].location;
  }

  /// return List of two element, the first is [String] represent the distance,
  ///
  /// the second is [LatLng] represent location of closest one
  /// if null this means that there is no service givers
  List<Object>? distanceAndlocationToClosestServiceGiver(LatLng userLocation) {
    if (_serviceGivers.isEmpty) {
      return null;
    }
    double shortestDistance =
        _distance(userLocation, _serviceGivers[0].location);
    int indexOfshortestDistance = 0;

    for (int i = 1; i < _serviceGivers.length; i++) {
      final distance = _distance(userLocation, _serviceGivers[i].location);
      if (distance < shortestDistance) {
        shortestDistance = distance;
        indexOfshortestDistance = i;
      }
    }

    final locationOfClosest = _serviceGivers[indexOfshortestDistance].location;

    if (shortestDistance >= 950) {
      return ['${(shortestDistance / 1000).round()} km', locationOfClosest];
    }
    if (shortestDistance >= 50) {
      return ['${(shortestDistance / 100).round() * 100} m', locationOfClosest];
    }
    return ['50 m', locationOfClosest];
  }

  double _distance(LatLng l1, LatLng l2) {
    final lat1 = l1.latitude;
    final lon1 = l1.longitude;
    final lat2 = l2.latitude;
    final lon2 = l2.longitude;
    const p = 0.017453292519943295; // PI / 180
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;

    return 12742000 * asin(sqrt(a)); // 2 * R * 1000; R = 6371 km
  }
}
