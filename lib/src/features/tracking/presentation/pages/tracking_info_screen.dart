import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services_app/src/core/util/functions/general_functions.dart';
import 'package:services_app/src/features/tracking/presentation/providers/tracking.dart';
import 'package:services_app/src/features/tracking/presentation/widgets/tracking_info_map.dart';

import '../../../orders/presentation/providers/orders.dart';
import '../../domain/entities/location_info.dart';
import '../../domain/entities/previous_locations_info.dart';

class TrackingInfoScreen extends StatelessWidget {
  const TrackingInfoScreen({Key? key}) : super(key: key);
  static const routName = '/tracking-info-screen';
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final orderId = arguments['orderId'] as String;
    final previousLocations =
        arguments['previousLocations'] as List<LocationInfo>?;

    final order =
        Provider.of<Orders>(context, listen: false).getOrderById(orderId);
    final serviceGiverName = order.serviceGiverName;

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
              "tracking info on ${firstName(serviceGiverName)}'s journey to you"),
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<Tracking>(context, listen: false)
            .getInfoAboutServiceGiverPreviousLocations(
          orderId,
          previousLocations: previousLocations,
        ),
        builder: (context, AsyncSnapshot<PreviousLocationsInfo> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          return TrackingInfoMap(previousLocationsInfo: snapshot.data!);
        },
      ),
    );
  }
}
