//import 'dart:convert';

import 'package:flutter_config/flutter_config.dart';
//import 'package:http/http.dart' as http;

abstract class TrackingMapsService {}

final googleMapsAPIkey = FlutterConfig.get('google_maps_API_key');

class TrackingGoogleMapsImpl implements TrackingMapsService {}
