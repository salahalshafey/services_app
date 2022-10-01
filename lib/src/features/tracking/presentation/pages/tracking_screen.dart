import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:services_app/src/core/util/functions/general_functions.dart';
import 'package:services_app/src/features/tracking/presentation/providers/tracking.dart';

import '../../../orders/presentation/providers/orders.dart';
import '../../domain/entities/location_info.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  static const routName = '/tracking-screen';

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late GoogleMapController _controller;
  LocationInfo? lastSeenLocation;

  void _onMapCreated(
      GoogleMapController controller, LocationInfo? lastSeenLocation) async {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    final order = Provider.of<Orders>(context).getOrderById(orderId);
    final serviceGiverName = order.serviceGiverName;

    final trackingInfo = Provider.of<Tracking>(context);
    lastSeenLocation = trackingInfo.lastSeenLocation;

    return Scaffold(
      appBar: AppBar(
        title: trackingInfo.isServiceGiverSharingLocation
            ? FittedBox(
                child: Text(
                    '${getFirstName(serviceGiverName)} is currently sharing his location'))
            : FittedBox(
                child: Text(
                    '${getFirstName(serviceGiverName)} is currently not sharing his location'),
              ),
        actions: [
          IconButton(
            tooltip: 'go to ${getFirstName(serviceGiverName)} current location',
            onPressed: () async {
              await _controller.animateCamera(CameraUpdate.newLatLng(
                lastSeenLocation == null
                    ? const LatLng(29.9309179, 31.2987633)
                    : LatLng(lastSeenLocation!.latitude,
                        lastSeenLocation!.longitude),
              ));

              await _controller.showMarkerInfoWindow(const MarkerId('marker1'));
            },
            icon: const Icon(Icons.track_changes),
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: lastSeenLocation == null
              ? const LatLng(29.9309179, 31.2987633)
              : LatLng(lastSeenLocation!.latitude, lastSeenLocation!.longitude),
          zoom: 16,
        ),
        onMapCreated: (controller) =>
            _onMapCreated(controller, lastSeenLocation),
        markers: {
          Marker(
            markerId: const MarkerId('marker1'),
            position: lastSeenLocation == null
                ? const LatLng(0.0, 0.0)
                : LatLng(
                    lastSeenLocation!.latitude, lastSeenLocation!.longitude),
            infoWindow: InfoWindow(
              title: 'Last seen',
              snippet: formatedDate(lastSeenLocation!.time) +
                  ' at ' +
                  time24To12HoursFormat(lastSeenLocation!.time.hour,
                      lastSeenLocation!.time.minute),
              onTap: () {},
            ),
            //  rotation: lastSeenLocation!.heading,
          ),
        }, //_markers,
        myLocationEnabled: true,
      ),
    );
  }
}
