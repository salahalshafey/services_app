import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/util/widgets/custom_card.dart';

class GoToLocationButton extends StatelessWidget {
  const GoToLocationButton({
    required this.positionOfButtonFromTop,
    required this.icon,
    required this.location,
    required this.markerId,
    required this.controller,
    required this.hideMidRoadMarker,
    Key? key,
  }) : super(key: key);

  final double positionOfButtonFromTop;
  final IconData icon;
  final LatLng location;
  final String markerId;
  final GoogleMapController Function() controller;
  final void Function() hideMidRoadMarker;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: positionOfButtonFromTop,
      right: 10,
      width: 40,
      height: 40,
      child: CustomCard(
        color: Colors.white.withOpacity(0.85),
        elevation: 2,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            icon,
            color: Colors.black54,
          ),
          tooltip: 'Go to $markerId location',
          onPressed: () async {
            await controller().animateCamera(CameraUpdate.newLatLng(location));

            await controller().showMarkerInfoWindow(MarkerId(markerId));

            hideMidRoadMarker();
          },
        ),
      ),
    );
  }
}
