import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/location_info.dart';

import '../../../../core/util/functions/general_functions.dart';

import 'last_seen_location_button.dart';
import 'service_giver_speed.dart';

class ServiceGiverLocationMap extends StatefulWidget {
  const ServiceGiverLocationMap({
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

  @override
  State<ServiceGiverLocationMap> createState() =>
      _ServiceGiverLocationMapState();
}

class _ServiceGiverLocationMapState extends State<ServiceGiverLocationMap> {
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
            target: LatLng(widget.lastSeenLocation.latitude,
                widget.lastSeenLocation.longitude),
            zoom: 16,
          ),
          onMapCreated: (controller) {
            if (widget.onMapCreated != null) {
              widget.onMapCreated!(controller);
            }
            _onMapCreated(controller);
          },
          markers: {
            Marker(
              markerId: const MarkerId('marker1'),
              position: LatLng(widget.lastSeenLocation.latitude,
                  widget.lastSeenLocation.longitude),
              infoWindow: InfoWindow(
                title: 'Last seen',
                snippet: pastOrFutureTimeFromNow(widget.lastSeenLocation.time),
                onTap: () {},
              ),
              // rotation: lastSeenLocation!.heading,
            ),
          }, //_markers,
          myLocationEnabled: true,
        ),
        LastSeenLocationButton(
          isSharingLocation: widget.isSharingLocation,
          lastSeenLocation: LatLng(
            widget.lastSeenLocation.latitude,
            widget.lastSeenLocation.longitude,
          ),
          serviceGiverName: widget.serviceGiverName,
          controller: () => _controller,
        ),
        ServiceGiverSpeed(
          speed: widget.lastSeenLocation.speed,
          name: widget.serviceGiverName,
        )
      ],
    );
  }
}
