import 'package:flutter/material.dart';

import '../../../../core/error/error_exceptions_with_message.dart';
import '../../../../core/error/exceptions_without_message.dart';
import '../../domain/entities/location_info.dart';
import '../../domain/entities/previous_locations_info.dart';
import '../../domain/usecases/get_previous_locations_info.dart';
import '../../domain/usecases/get_tracking_live.dart';

class Tracking with ChangeNotifier {
  Tracking({
    required this.getTrackingStream,
    required this.getPreviousLocationsInfo,
  });

  final GetTrackingLiveUsecase getTrackingStream;
  final GetPreviousLocationsInfoUsecase getPreviousLocationsInfo;

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
      throw ErrorMessage('You are currently offline.');
    } on ServerException {
      throw ErrorMessage('Something went wrong, please try again later.');
    } catch (error) {
      throw ErrorMessage('An unexpected error happened.');
    }
  }

  Future<PreviousLocationsInfo> getInfoAboutServiceGiverPreviousLocations(
      String orderId,
      {List<LocationInfo>? previousLocations}) async {
    try {
      return await getPreviousLocationsInfo(
        orderId,
        previousLocations: previousLocations,
      );
    } on OfflineException {
      throw ErrorMessage('You are currently offline.');
    } on ServerException {
      throw ErrorMessage('Something went wrong, please try again later.');
    } on EmptyDataException {
      throw ErrorMessage('There is no data!!!');
    } catch (error) {
      throw ErrorMessage('An unexpected error happened.');
    }
  }

  bool get isServiceGiverSharingLocation => _isServiceGiverSharingLocation;

  LocationInfo? get lastSeenLocation => _lastSeenLocation;

  List<LocationInfo> get previousLocations => _previousLocations;
}
