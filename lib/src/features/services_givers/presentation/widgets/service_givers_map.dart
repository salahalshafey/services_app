import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/util/builders/custom_alret_dialoge.dart';

import '../providers/services_givers.dart';
import 'service_giver_dialog.dart';

class ServiceGiversMap extends StatefulWidget {
  const ServiceGiversMap(this.serviceName, {Key? key}) : super(key: key);

  final String serviceName;

  @override
  State<ServiceGiversMap> createState() => _ServiceGiversMapState();
}

class _ServiceGiversMapState extends State<ServiceGiversMap> {
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) async {
    final servicesGivers = Provider.of<ServicesGivers>(context, listen: false);

    ////// create The Markers /////////////
    setState(() {
      _markers = servicesGivers.getServiceGivers
          .map(
            (serviceGiver) => Marker(
              markerId: MarkerId(serviceGiver.id),
              position: serviceGiver.location,
              infoWindow: InfoWindow(
                title: serviceGiver.name,
                snippet:
                    'City: ${serviceGiver.city}, Cost: ${serviceGiver.cost}',
                onTap: () => serviceGiverDialog(
                    context, widget.serviceName, serviceGiver),
              ),
            ),
          )
          .toSet();
    });

    ///////// Show Alret Dialog Of Distance Of Closest Person And animateCamera to his location /////////////
    final currentLocation = await LocationServiceImpl().currentLocation;
    if (currentLocation != null) {
      final distanceAndlocationToCloses = servicesGivers
          .distanceAndlocationToClosestServiceGiver(currentLocation.toLatLng());
      if (distanceAndlocationToCloses == null) {
        return;
      }

      final distanceToClosest = distanceAndlocationToCloses.first as String;
      showCustomAlretDialog(
        context: context,
        title: 'Awesome!!',
        content:
            'The Closest ${widget.serviceName} is about $distanceToClosest far away',
      );

      final locationToClosest = distanceAndlocationToCloses.last as LatLng;
      _goToLocation(controller, locationToClosest);
    }
  }

  void _goToLocation(GoogleMapController controller, LatLng location) =>
      controller.animateCamera(CameraUpdate.newLatLng(location));

  @override
  Widget build(BuildContext context) {
    final _locationOfHighestRating =
        Provider.of<ServicesGivers>(context, listen: false)
            .locationOfHighestRating;

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _locationOfHighestRating,
        zoom: 11,
      ),
      onMapCreated: _onMapCreated,
      markers: _markers, //_markers,
      myLocationEnabled: true,
    );
  }
}

extension on LocationData {
  LatLng toLatLng() => LatLng(latitude!, longitude!);
}
