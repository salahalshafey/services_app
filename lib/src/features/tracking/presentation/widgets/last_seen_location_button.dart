import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/util/builders/custom_snack_bar.dart';

import '../../../../core/util/functions/string_manipulations_and_search.dart';
import '../../../../core/util/widgets/custom_card.dart';

class LastSeenLocationButton extends StatelessWidget {
  const LastSeenLocationButton({
    required this.isSharingLocation,
    required this.lastSeenLocation,
    required this.serviceGiverName,
    required this.controller,
    required this.renderTheMap,
    Key? key,
  }) : super(key: key);

  final bool isSharingLocation;
  final LatLng lastSeenLocation;
  final String serviceGiverName;
  final GoogleMapController Function() controller;
  final void Function() renderTheMap;

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    double? top, right, left;
    if (isPortrait) {
      top = 80;
      right = 10;
      left = null;
    } else {
      top = 40;
      left = 10;
      right = null;
    }

    return Positioned(
      top: top,
      right: right,
      left: left,
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
          tooltip: 'Go to ${firstName(serviceGiverName)} last seen location',
          onPressed: () async {
            await controller()
                .animateCamera(CameraUpdate.newLatLng(lastSeenLocation));

            renderTheMap();
            await controller().showMarkerInfoWindow(const MarkerId('marker1'));

            if (!isSharingLocation) {
              showCustomSnackBar(
                context: context,
                content: '${firstName(serviceGiverName)} '
                    'is not currently sharing his location!!!',
              );
            }
          },
        ),
      ),
    );
  }
}
