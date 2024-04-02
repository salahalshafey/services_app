import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/map_styles.dart';
import '../../../../core/util/functions/date_time_and_duration.dart';

import '../../domain/entities/location_info.dart';

import '../pages/tracking_info_screen.dart';
import 'change_map_type_button.dart';
import 'last_seen_location_button.dart';
import 'service_giver_speed.dart';
import 'share_location_info_button.dart';

class ServiceGiverLocationMap extends StatefulWidget {
  const ServiceGiverLocationMap({
    required this.orderId,
    required this.isSharingLocation,
    required this.lastSeenLocation,
    required this.previousLocations,
    required this.serviceGiverName,
    this.onMapCreated,
    Key? key,
  }) : super(key: key);

  final String orderId;
  final bool isSharingLocation;
  final LocationInfo lastSeenLocation;
  final List<LocationInfo> previousLocations;
  final String serviceGiverName;
  final void Function(GoogleMapController)? onMapCreated;

  @override
  State<ServiceGiverLocationMap> createState() =>
      _ServiceGiverLocationMapState();
}

class _ServiceGiverLocationMapState extends State<ServiceGiverLocationMap> {
  late GoogleMapController _controller;
  Uint8List? newMarkerIcon;
  MapType _mapType = MapType.normal;

  void _onMapCreated(GoogleMapController controller) async {
    _controller = controller;

    // to do in the future: change the icon according to the serviceName
    const serviceName = 'artisan';
    newMarkerIcon = (await rootBundle.load('assets/icons/$serviceName.png'))
        .buffer
        .asUint8List();
    setState(() {});
  }

  void _toggleMapeType() {
    switch (_mapType) {
      case MapType.normal:
        _mapType = MapType.satellite;
        break;
      case MapType.satellite:
        _mapType = MapType.terrain;
        break;
      case MapType.terrain:
        _mapType = MapType.hybrid;
        break;
      default:
        _mapType = MapType.normal;
    }

    setState(() {});
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
          style: Theme.of(context).brightness == Brightness.light
              ? GOOGLE_MAPS_RETRO_STYLE
              : GOOGLE_MAPS_DARKE_STYLE,
          mapType: _mapType,
          onMapCreated: (controller) {
            if (widget.onMapCreated != null) {
              widget.onMapCreated!(controller);
            }
            _onMapCreated(controller);
          },
          markers: {
            Marker(
              icon: newMarkerIcon == null
                  ? BitmapDescriptor.defaultMarker
                  : BitmapDescriptor.fromBytes(newMarkerIcon!),
              markerId: const MarkerId('marker1'),
              position: LatLng(
                widget.lastSeenLocation.latitude,
                widget.lastSeenLocation.longitude,
              ),
              infoWindow: InfoWindow(
                title: 'Last seen',
                snippet: pastOrFutureTimeFromNow(widget.lastSeenLocation.time),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(TrackingInfoScreen.routName, arguments: {
                    'orderId': widget.orderId,
                    'previousLocations': widget.previousLocations,
                    'mapType': _mapType,
                  });
                },
              ),
              onTap: () {
                setState(() {});
              },
              //rotation: widget.lastSeenLocation.heading,
            ),
          }, //_markers,
          myLocationEnabled: true,
          trafficEnabled: true,
        ),
        LastSeenLocationButton(
          isSharingLocation: widget.isSharingLocation,
          lastSeenLocation: LatLng(
            widget.lastSeenLocation.latitude,
            widget.lastSeenLocation.longitude,
          ),
          serviceGiverName: widget.serviceGiverName,
          controller: () => _controller,
          renderTheMap: () => setState(() {}),
        ),
        ShareLocationInfoButton(
          lastSeenLocation: widget.lastSeenLocation,
          serviceGiverName: widget.serviceGiverName,
        ),
        ChangeMapTypeButton(_mapType, _toggleMapeType),
        ServiceGiverSpeed(
          speed: widget.lastSeenLocation.speed,
          name: widget.serviceGiverName,
        )
      ],
    );
  }
}
