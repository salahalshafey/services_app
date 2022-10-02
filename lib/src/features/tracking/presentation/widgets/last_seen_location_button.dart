import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/util/builders/custom_snack_bar.dart';
import '../../../../core/util/functions/general_functions.dart';
import '../../../../core/util/widgets/custom_card.dart';

class LastSeenLocationButton extends StatelessWidget {
  const LastSeenLocationButton({
    required this.isSharingLocation,
    required this.lastSeenLocation,
    required this.serviceGiverName,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final bool isSharingLocation;
  final LatLng lastSeenLocation;
  final String serviceGiverName;
  final GoogleMapController Function() controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      right: 10,
      width: 40,
      height: 40,
      child: CustomCard(
        color: Colors.white.withOpacity(0.85),
        elevation: 2,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.location_on,
            color: Colors.black54,
          ),
          tooltip: 'go to ${getFirstName(serviceGiverName)} current location',
          onPressed: () async {
            await controller()
                .animateCamera(CameraUpdate.newLatLng(lastSeenLocation));

            await controller().showMarkerInfoWindow(const MarkerId('marker1'));

            if (!isSharingLocation) {
              showCustomSnackBar(
                context: context,
                content: '${getFirstName(serviceGiverName)} '
                    'is not currently sharing his location!!!',
              );
            }
          },
        ),
      ),
    );
  }
}
