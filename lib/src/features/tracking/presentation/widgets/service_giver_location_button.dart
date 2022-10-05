import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/functions/general_functions.dart';
import '../../../../core/util/widgets/custom_text_button.dart';

import '../providers/tracking.dart';

import '../pages/tracking_screen.dart';

class ServiceGiverLocationButton extends StatelessWidget {
  const ServiceGiverLocationButton({
    required this.orderId,
    required this.serviceGiverName,
    Key? key,
  }) : super(key: key);

  final String orderId;
  final String serviceGiverName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Provider.of<Tracking>(context, listen: false)
            .listenToServiceGiverLocations(orderId),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final isSharing = Provider.of<Tracking>(context, listen: false)
              .isServiceGiverSharingLocation;

          return CustomTextButton(
            text: snapshot.hasError
                ? "Couldn't get ${firstName(serviceGiverName)} location, ${snapshot.error}"
                : 'See Where is ${firstName(serviceGiverName)} On The Map',
            iconActive: Icons.location_on,
            iconDeActive: Icons.location_off,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(TrackingScreen.routName, arguments: orderId);
            },
            isActive: snapshot.hasError ? false : isSharing,
          );
        });
  }
}
