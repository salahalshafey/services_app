import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/services_givers.dart';
import '../../../services/presentation/providers/services.dart';

import '../widgets/service_givers_map.dart';

class ServiceGiversScreen extends StatelessWidget {
  static const routName = '/servic-giver';

  const ServiceGiversScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serviceId = ModalRoute.of(context)!.settings.arguments as String;
    final serviceName = Provider.of<Services>(context, listen: false)
        .getServiceById(serviceId)
        .name;
    final serviceGivers = Provider.of<ServicesGivers>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(serviceName),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: serviceGivers.getAndFetchServicesGiver(serviceId),
          builder: (context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()), //
              );
            }
            if (serviceGivers.getServiceGivers.isEmpty) {
              return const Center(
                child: Text('There is no data!!!'),
              );
            }

            return ServiceGiversMap(serviceName);
          }),
    );
  }
}

/* return ListView.builder(
                itemCount: serviceGivers.length,
                itemBuilder: (ctx, index) =>
                    ServiceGiverItem(serviceGivers[index], serviceName),
              );*/
