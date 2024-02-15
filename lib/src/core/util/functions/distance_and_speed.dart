import 'dart:math';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app.dart';

final _context = navigatorKey.currentContext!;

String wellFormatedDistance(double distanceInMeter) {
  if (distanceInMeter >= 1000) {
    return '${(distanceInMeter / 1000).toStringAsFixed(1)} ${AppLocalizations.of(_context)!.km}';
  }

  return '${distanceInMeter.toStringAsFixed(0)} ${AppLocalizations.of(_context)!.meter}';
}

String fromMeterPerSecToKPerH(double speed) {
  return (speed * 3.6).toStringAsFixed(0);
}

String fromKilometerPerHourToMPerSec(double speed) {
  return (speed * (5 / 18)).toStringAsFixed(0);
}

double distanceBetweenTwoCoordinate(LatLng l1, LatLng l2) {
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
