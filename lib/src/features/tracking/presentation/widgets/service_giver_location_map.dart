import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/util/builders/custom_snack_bar.dart';
import '../../../../core/util/functions/general_functions.dart';
import '../../../../core/util/widgets/custom_card.dart';

import '../../domain/entities/location_info.dart';

// ignore: must_be_immutable
class ServiceGiverLocationMap extends StatelessWidget {
  ServiceGiverLocationMap({
    required this.isSharingLocation,
    required this.lastSeenLocation,
    required this.serviceGiverName,
    this.onMapCreated,
    Key? key,
  }) : super(key: key);

  final bool isSharingLocation;
  final LocationInfo lastSeenLocation;
  final String serviceGiverName;
  final void Function(GoogleMapController)? onMapCreated;

  late GoogleMapController _controller;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target:
                LatLng(lastSeenLocation.latitude, lastSeenLocation.longitude),
            zoom: 16,
          ),
          onMapCreated: (controller) {
            if (onMapCreated != null) {
              onMapCreated!(controller);
            }
            _onMapCreated(controller);
          },
          markers: {
            Marker(
              markerId: const MarkerId('marker1'),
              position:
                  LatLng(lastSeenLocation.latitude, lastSeenLocation.longitude),
              infoWindow: InfoWindow(
                title: 'Last seen',
                snippet: pastOrFutureTimeFromNow(lastSeenLocation.time),
                onTap: () {},
              ),
              // rotation: lastSeenLocation!.heading,
            ),
          }, //_markers,
          myLocationEnabled: true,
        ),
        Positioned(
          top: 80,
          right: 10,
          child: CustomCard(
            color: Colors.white.withOpacity(0.8),
            elevation: 2,
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.location_on,
                color: Colors.black54,
              ),
              tooltip:
                  'go to ${getFirstName(serviceGiverName)} current location',
              onPressed: () async {
                await _controller.animateCamera(CameraUpdate.newLatLng(
                  LatLng(lastSeenLocation.latitude, lastSeenLocation.longitude),
                ));

                await _controller
                    .showMarkerInfoWindow(const MarkerId('marker1'));

                if (!isSharingLocation) {
                  showCustomSnackBar(
                    context: context,
                    content:
                        '${getFirstName(serviceGiverName)} is not currently sharing his location!!!',
                  );
                }
              },
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          right: 10,
          child: FloatingActionButton(
            tooltip: 'last seen ${getFirstName(serviceGiverName)} speed',
            onPressed: null,
            backgroundColor: Colors.white.withOpacity(0.8),
            foregroundColor: Colors.black54,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(fromMeterPerSecToKPerH(lastSeenLocation.speed)),
                const Text('km/h'),
              ],
            ),
          ),
        )
      ],
    );
  }
}
