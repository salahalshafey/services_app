import 'package:flutter/material.dart';

import '../../../../core/error/exceptions.dart';

import '../../domain/entities/location_info.dart';
import '../../domain/usecases/get_tracking_live.dart';

class Tracking with ChangeNotifier {
  Tracking({required this.getTrackingStream});

  final GetTrackingLiveUsecase getTrackingStream;

  bool _isServiceGiverSharingLocation = false;
  LocationInfo? _lastSeenLocation;
  List<LocationInfo> _previousLocations = [];

  Stream<bool> listenToServiceGiverLocations(String orderId) async* {
    try {
      await for (final tracking in getTrackingStream(orderId)) {
        _isServiceGiverSharingLocation = tracking.isServiceGiverSharingLocation;
        _lastSeenLocation = tracking.lastSeenLocation;
        _previousLocations = tracking.previousLocations;
        notifyListeners();

        yield true;
      }
    } on OfflineException {
      throw Error('You are currently offline.');
    } on ServerException {
      throw Error('Something went wrong, please try again later.');
    } catch (error) {
      throw Error('An unexpected error happened.');
    }
  }

  bool get isServiceGiverSharingLocation => _isServiceGiverSharingLocation;

  LocationInfo? get lastSeenLocation => _lastSeenLocation;

  List<LocationInfo> get previousLocations => _previousLocations;
}