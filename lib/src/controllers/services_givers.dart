import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../backend_services/firestore.dart';
import '../backend_services/internet_service.dart';

import '../exceptions/internet_exception.dart';

class ServicesGivers with ChangeNotifier {
  List<ServiceGiver> _serviceGivers = [];

  Future<void> getAndFetchServicesGiver(String serviceId) async {
    final hasNetwork = await InternetService.hasNetwork();
    if (!hasNetwork) {
      throw InternetException('You are currently offline.');
    }

    late List<QueryDocumentSnapshot<Map<String, dynamic>>> servicesGiversDocs;
    try {
      servicesGiversDocs = (await Firestore.getSrevicesGivers(serviceId)).docs;
    } catch (error) {
      throw InternetException('Something Went Wrong!!!');
    }

    _serviceGivers = servicesGiversDocs
        .map((document) => ServiceGiver.fromDocumentSnapshot(document))
        .toList();

    notifyListeners();
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

class ServiceGiver {
  const ServiceGiver({
    required this.id,
    required this.name,
    required this.image,
    required this.phoneNumber,
    required this.services,
    required this.rating,
    required this.cost,
    required this.city,
    required this.area,
    required this.location,
    required this.registrationDate,
  });

  final String id;
  final String name;
  final String image;
  final String phoneNumber;
  final List<String> services;
  final double rating;
  final double cost;
  final String city;
  final String area;
  final LatLng location;
  final DateTime registrationDate;

  ServiceGiver.fromDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document)
      : id = document.id,
        name = document.data()['name'],
        image = document.data()['image'],
        phoneNumber = document.data()['phone_number'],
        services = (document.data()['services'] as List<dynamic>)
            .map((serviceId) => serviceId as String)
            .toList(),
        rating = (document.data()['rating'] as num).toDouble(),
        cost = (document.data()['cost'] as num).toDouble(),
        city = document.data()['city'],
        area = document.data()['area'],
        location = (document.data()['location'] as GeoPoint).toLatLng(),
        registrationDate =
            (document.data()['registration_date'] as Timestamp).toDate();
}

extension on GeoPoint {
  LatLng toLatLng() => LatLng(latitude, longitude);
}
