import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ServiceGiver extends Equatable {
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

  @override
  List<Object?> get props => [id];
}
