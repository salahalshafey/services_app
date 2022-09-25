import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/service_giver.dart';

class ServiceGiverModel extends ServiceGiver {
  const ServiceGiverModel({
    required String id,
    required String name,
    required String image,
    required String phoneNumber,
    required List<String> services,
    required double rating,
    required double cost,
    required String city,
    required String area,
    required LatLng location,
    required DateTime registrationDate,
  }) : super(
          id: id,
          name: name,
          image: image,
          phoneNumber: phoneNumber,
          services: services,
          rating: rating,
          cost: cost,
          city: city,
          area: area,
          location: location,
          registrationDate: registrationDate,
        );

  factory ServiceGiverModel.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    return ServiceGiverModel(
      id: document.id,
      name: document.data()['name'],
      image: document.data()['image'],
      phoneNumber: document.data()['phone_number'],
      services: (document.data()['services'] as List<dynamic>)
          .map((serviceId) => serviceId as String)
          .toList(),
      rating: (document.data()['rating'] as num).toDouble(),
      cost: (document.data()['cost'] as num).toDouble(),
      city: document.data()['city'],
      area: document.data()['area'],
      location: (document.data()['location'] as GeoPoint).toLatLng(),
      registrationDate:
          (document.data()['registration_date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'image': image,
      'phone_number': phoneNumber,
      'services': services,
      'rating': rating,
      'cost': cost,
      'city': city,
      'area': area,
      'location': location.toGeoPoint(),
      'registration_date': Timestamp.fromDate(registrationDate),
    };
  }
}

extension on GeoPoint {
  LatLng toLatLng() => LatLng(latitude, longitude);
}

extension on LatLng {
  GeoPoint toGeoPoint() => GeoPoint(latitude, longitude);
}
