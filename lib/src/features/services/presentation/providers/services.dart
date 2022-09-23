import 'package:flutter/material.dart';
import 'package:services_app/src/core/error/exceptions.dart';

import '../../domain/entities/service.dart';
import '../../domain/usecases/get_all_sevices.dart';

class Services with ChangeNotifier {
  Services({required this.getAllServices});

  final GetAllServicesUsecase getAllServices;

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
    try {
      _services = await getAllServices();
      notifyListeners();
    } on OfflineException {
      throw Error('You are currently offline.');
    } on ServerException {
      throw Error('Something Went Wrong!!!');
    }
  }

  List<Service> get services => [..._services];

  Service getServiceById(String serviceId) =>
      _services.firstWhere((service) => service.id == serviceId);

  bool get dataFetchedFromBackend => _dataFetchedFromBackend;
}
