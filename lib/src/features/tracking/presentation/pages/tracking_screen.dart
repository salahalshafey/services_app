import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/widgets/back_button_with_image.dart';
import '../../../orders/presentation/providers/orders.dart';
import '../providers/tracking.dart';

import '../widgets/service_giver_location_map.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  static const routName = '/tracking-screen';

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    final order = Provider.of<Orders>(context).getOrderById(orderId);

    final serviceGiverName = order.serviceGiverName;
    final serviceName = order.serviceName;
    final serviceGiverImage = order.serviceGiverImage;

    final trackingInfo = Provider.of<Tracking>(context);
    final lastSeenLocation = trackingInfo.lastSeenLocation;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: BackButtonWithImage(networkImage: serviceGiverImage),
        title: Text('$serviceGiverName ($serviceName)'),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.share_location,
                color: trackingInfo.isServiceGiverSharingLocation
                    ? Colors.green
                    : Colors.red,
              ),
              trackingInfo.isServiceGiverSharingLocation
                  ? const Icon(Icons.check, size: 18, color: Colors.green)
                  : const Icon(Icons.not_interested,
                      size: 18, color: Colors.red),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: lastSeenLocation == null
          ? Center(
              child: Text(
                "$serviceGiverName is currently offline, we couldn't get his location",
              ),
            )
          : ServiceGiverLocationMap(
              isSharingLocation: trackingInfo.isServiceGiverSharingLocation,
              lastSeenLocation: lastSeenLocation,
              serviceGiverName: serviceGiverName,
            ),
    );
  }
}
