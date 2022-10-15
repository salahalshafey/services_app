import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services_app/src/features/tracking/presentation/providers/tracking.dart';
import 'package:services_app/src/features/tracking/presentation/widgets/tracking_info_map.dart';

import '../../domain/entities/previous_locations_info.dart';

class TrackingInfoScreen extends StatelessWidget {
  const TrackingInfoScreen({Key? key}) : super(key: key);
  static const routName = '/tracking-info-screen';
  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('tracking info.'),
      ),
      body: FutureBuilder(
        future: Provider.of<Tracking>(context, listen: false)
            .getInfoAboutServiceGiverPreviousLocations(orderId),
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
