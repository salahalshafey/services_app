import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../location/location_service.dart';
import '../../theme/map_styles.dart';
import 'custom_snack_bar.dart';

Future<LatLng?> myLocationPicker({
  required BuildContext context,
  String currentLocationChoiceTitle = 'Get Current Location',
  String mapChoiceTitle = 'Get Location From The Map',

  ///controls a state (basicly loading) from outside this function
  void Function(bool state)? loadingState,
  LatLng initialMapPosition = const LatLng(29.9309179, 31.2987633),
  double mapZoom = 8,
}) async {
  final currentLocationChoice = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
            child: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please Choose',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(Icons.location_on),
                    label: Text(
                      currentLocationChoiceTitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.map),
                    label: Text(
                      mapChoiceTitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ));

  if (currentLocationChoice == null) {
    return null;
  }

  LatLng? theLocation;
  if (currentLocationChoice) {
    _showLoadingState(loadingState, true);
    theLocation = (await LocationServiceImpl().currentLocation)?.toLatLng();
    if (theLocation == null) {
      showCustomSnackBar(
        context: context,
        content:
            'Please turn on device location, so we can send your location.',
      );
      _showLoadingState(loadingState, false);
    }
  } else {
    theLocation = await Navigator.of(context).push<LatLng?>(
      MaterialPageRoute(
          builder: (ctx) => MapScreen(
                initialMapPosition: initialMapPosition,
                mapZoom: mapZoom,
              )),
    );
    if (theLocation == null) {
      showCustomSnackBar(
        context: context,
        content: "You didn't sellect a location from the map.",
      );
    }
  }

  return theLocation;
}

void _showLoadingState(void Function(bool)? loadingState, bool state) {
  if (loadingState == null) {
    return;
  }
  loadingState(state);
}

extension on LocationData {
  LatLng toLatLng() => LatLng(latitude!, longitude!);
}

class MapScreen extends StatefulWidget {
  const MapScreen({
    this.initialMapPosition = const LatLng(29.9309179, 31.2987633),
    this.mapZoom = 8,
    Key? key,
  }) : super(key: key);

  final LatLng initialMapPosition;
  final double mapZoom;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  late GoogleMapController _controller;

  void _selectLocation(LatLng position) async {
    setState(() {
      _pickedLocation = position;
    });

    // wait for setState() to finish then showMarkerInfoWindow
    await Future.delayed(const Duration(milliseconds: 300));
    _controller.showMarkerInfoWindow(const MarkerId('m1'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        title: const FittedBox(child: Text('Long Press To Select a Location')),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: _pickedLocation == null
                ? 'Please select a location'
                : 'Send this location',
            onPressed: _pickedLocation == null
                ? null
                : () {
                    Navigator.of(context).pop(_pickedLocation);
                  },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.initialMapPosition,
          zoom: widget.mapZoom,
        ),
        style: Theme.of(context).brightness == Brightness.light
            ? GOOGLE_MAPS_RETRO_STYLE
            : GOOGLE_MAPS_DARKE_STYLE,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          _controller = controller;
        },
        onLongPress: _selectLocation,
        onTap: (_) {
          setState(() {
            _pickedLocation = null;
          });
        },
        trafficEnabled: true,
        myLocationEnabled: true,
        markers: _pickedLocation == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLocation!,
                  infoWindow: InfoWindow(
                    title: 'Send this location',
                    snippet: '              🚩',
                    onTap: () => Navigator.of(context).pop(_pickedLocation),
                  ),
                ),
              },
      ),
    );
  }
}
