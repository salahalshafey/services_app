import 'dart:convert';

//import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

import 'api_keys.dart';

abstract class ChatMapsService {
  String getImagePreview(String location);
  Future<String?> getGeoCodingData(String location);
}

//final googleMapsAPIkey = FlutterConfig.get('google_maps_API_key');

class ChatGoogleMapsImpl implements ChatMapsService {
  @override
  String getImagePreview(String location) =>
      "https://maps.googleapis.com/maps/api/staticmap?"
      "center=$location"
      "&zoom=15"
      "&size=400x400"
      "&maptype=roadmap"
      "&markers=color:red%7Clabel:Label%7C$location"
      "&key=$googleMapsAPIKey";

  @override
  Future<String?> getGeoCodingData(String location) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?"
      "latlng=$location"
      "&key=$googleMapsAPIKey",
    );

    Map<String, dynamic>? resevedData;
    try {
      final respons = await http.get(url);
      resevedData = json.decode(respons.body);
      if (resevedData == null) {
        return null;
      }
    } catch (error) {
      return null;
    }

    final results = resevedData['results'] as List<dynamic>;
    if (results.isEmpty) {
      return null;
    }
    if (results.length == 1) {
      return results[0]['formatted_address'];
    }

    return results[1]['formatted_address'];
  }
}
