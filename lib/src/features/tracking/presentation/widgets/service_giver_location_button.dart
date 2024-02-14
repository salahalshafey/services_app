import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/functions/string_manipulations_and_search.dart';
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
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError) {
          return CustomTextButton(
            text: 'See Where is ${firstName(serviceGiverName)} On The Map',
            iconActive: Icons.location_on,
            iconDeActive: Icons.location_off,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(TrackingScreen.routName, arguments: orderId);
            },
            isActive: false,
          );
        }

        final isSharing = Provider.of<Tracking>(context, listen: false)
            .isServiceGiverSharingLocation;

        return CustomTextButton(
          text: 'See Where is ${firstName(serviceGiverName)} On The Map',
          iconActive: Icons.location_on,
          iconDeActive: Icons.location_off,
          onPressed: () {
            Navigator.of(context)
                .pushNamed(TrackingScreen.routName, arguments: orderId);
          },
          isActive: isSharing,
        );
      },
    );
  }
}
