import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/services.dart';

import '../../../main_and_drawer_screens/pages/main_drawer.dart';
import '../widgets/services_item.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final services = Provider.of<Services>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: services.getAndFetchServicesOnce(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            /*&&  !services.dataFetchedFromBackend*/
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (services.services.isEmpty) {
            return const Center(
              child: Text('There is no data!!!'),
            );
          }

          return GridView(
            padding: const EdgeInsets.all(25),
            children: services.services
                .map((service) =>
                    ServicesItem(service.id, service.name, service.image))
                .toList(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 8 / 10,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
          );
        },
      ),
      drawer: const MainDrawer(),
    );
  }
}
