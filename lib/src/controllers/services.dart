import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../backend_services/firestore.dart';
import '../backend_services/internet_service.dart';

import '../exceptions/internet_exception.dart';

class Service {
  const Service({required this.id, required this.name, required this.image});

  final String id;
  final String name;
  final String image;

  Service.fromDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document)
      : id = document.id,
        name = document.data()['name'],
        image = document.data()['image'];
}

class Services with ChangeNotifier {
  List<Service> _services = [];
  bool _dataFetchedFromBackend = false;

  Future<void> getAndFetchServicesOnce() async {
    if (!_dataFetchedFromBackend) {
      try {
        await getAndFetchServices();
        _dataFetchedFromBackend = true;
      } catch (error) {
        rethrow;
      }
    }
  }

  Future<void> getAndFetchServices() async {
    final hasNetwork = await InternetService.hasNetwork();
    if (!hasNetwork) {
      throw InternetException('You are currently offline.');
    }

    try {
      final servicesDocs = (await Firestore.getSrevices()).docs;
      _services = servicesDocs
          .map((document) => Service.fromDocumentSnapshot(document))
          .toList();

      notifyListeners();
    } catch (error) {
      throw InternetException('Something Went Wrong!!!');
    }
  }

  List<Service> get services => [..._services];

  Service getServiceById(String serviceId) =>
      _services.firstWhere((service) => service.id == serviceId);

  bool get dataFetchedFromBackend => _dataFetchedFromBackend;
}
