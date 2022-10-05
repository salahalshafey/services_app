import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/functions/general_functions.dart';

import '../../../orders/presentation/providers/orders.dart';
import '../providers/tracking.dart';

import '../widgets/service_giver_location_map.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  static const routName = '/tracking-screen';

  String not(bool isSharing) => isSharing ? ' ' : ' not ';

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    final order = Provider.of<Orders>(context).getOrderById(orderId);
    final serviceGiverName = order.serviceGiverName;

    final trackingInfo = Provider.of<Tracking>(context);
    final lastSeenLocation = trackingInfo.lastSeenLocation;

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            '${firstName(serviceGiverName)} is'
            '${not(trackingInfo.isServiceGiverSharingLocation)}'
            'currently sharing his location',
          ),
        ),
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
