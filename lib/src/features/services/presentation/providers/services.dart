import 'package:flutter/material.dart';

import '../../../../core/error/error_exceptions_with_message.dart';
import '../../../../core/error/exceptions_without_message.dart';
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
      throw ErrorMessage('You are currently offline.');
    } on ServerException {
      throw ErrorMessage('Something Went Wrong!!!');
    }
  }

  List<Service> get services => [..._services];

  Service getServiceById(String serviceId) =>
      _services.firstWhere((service) => service.id == serviceId);

  bool get dataFetchedFromBackend => _dataFetchedFromBackend;
}
