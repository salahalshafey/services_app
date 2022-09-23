import 'package:location/location.dart';

abstract class LocationService {
  Future<LocationData?> get currentLocation;
}

class LocationServiceImpl implements LocationService {
  @override
  Future<LocationData?> get currentLocation async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return null;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return null;
        }
      }

      _locationData = await location.getLocation();
    } catch (error) {
      return null;
    }

    return _locationData;
  }
}
