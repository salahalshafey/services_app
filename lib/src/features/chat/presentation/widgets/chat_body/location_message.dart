import 'dart:io';

import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/datasources/maps_servcice.dart';

import '../../../../../core/util/builders/custom_snack_bar.dart';
import '../../../../../core/util/widgets/image_container.dart';

import 'message_bubble.dart';

class LocationMessage extends StatelessWidget {
  const LocationMessage({
    required this.location,
    this.geoCodingData,
    required this.date,
    required this.isMe,
    Key? key,
  }) : super(key: key);

  final String location;
  final String? geoCodingData;
  final DateTime date;
  final bool isMe;

  Coords _toCoords() {
    final l = location.split(',');
    return Coords(double.parse(l.first), double.parse(l.last));
  }

  void _openAvailableMapApp(BuildContext context) async {
    const zoom = 12;

    if (Platform.isAndroid || Platform.isIOS) {
      if ((await MapLauncher.isMapAvailable(MapType.google))!) {
        await MapLauncher.showMarker(
          mapType: MapType.google,
          coords: _toCoords(),
          title: geoCodingData ?? '',
          zoom: zoom,
        );
        return;
      }

      final availableMaps = await MapLauncher.installedMaps;
      if (availableMaps.isEmpty) {
        showCustomSnackBar(
          context: context,
          content: 'There is no Map Application on your System',
        );
        return;
      }

      await availableMaps.first.showMarker(
        coords: _toCoords(),
        title: geoCodingData ?? '',
        zoom: zoom,
      );
    }

    launchUrl(Uri.parse("https://maps.google.com/?q=$location"));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageContainer(
            image: ChatGoogleMapsImpl().getImagePreview(location),
            imageSource: From.network,
            radius: 125,
            borderRadius: borderRadiusBuilder(isMe: isMe),
            showHighlight: true,
            showLoadingIndicator: true,
            errorBuilder: (p0, p1, p2) => Image.asset(
              'assets/images/default-map-preview-image.jpg',
              fit: BoxFit.fitHeight,
            ),
            onTap: () => _openAvailableMapApp(context),
          ),
          TextButton(
            onPressed: () => _openAvailableMapApp(context),
            child: Text(
              geoCodingData ?? 'Click to go to Location LatLng($location)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll(Colors.blue.shade200)),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: dateBuilder(date: date, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
