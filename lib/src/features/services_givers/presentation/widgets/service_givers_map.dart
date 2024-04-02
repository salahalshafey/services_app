import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/theme/map_styles.dart';
import '../../../../core/util/builders/custom_alret_dialog.dart';

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
        icon: Icon(
          Icons.details_rounded,
          color: Theme.of(context).primaryColor,
        ),
        titleColor: Theme.of(context).primaryColor,
        content:
            'The Closest ${widget.serviceName} is about $distanceToClosest far away',
      );

      final locationToClosest = distanceAndlocationToCloses.last as LatLng;
      await Future.delayed(const Duration(milliseconds: 500));
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
      style: Theme.of(context).brightness == Brightness.light
          ? GOOGLE_MAPS_RETRO_STYLE
          : GOOGLE_MAPS_DARKE_STYLE,
      onMapCreated: _onMapCreated,
      markers: _markers, //_markers,
      myLocationEnabled: true,
    );
  }
}

extension on LocationData {
  LatLng toLatLng() => LatLng(latitude!, longitude!);
}
