import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/services_givers.dart';
import '../../../services/presentation/providers/services.dart';

import '../widgets/service_givers_map.dart';

class ServiceGiversScreen extends StatefulWidget {
  static const routName = '/servic-giver';

  const ServiceGiversScreen({Key? key}) : super(key: key);

  @override
  State<ServiceGiversScreen> createState() => _ServiceGiversScreenState();
}

class _ServiceGiversScreenState extends State<ServiceGiversScreen> {
  String? _serviceId;
  late String _serviceName;
  late final ServicesGivers _serviceGivers;
  late Future<void> _getAndFetchServicesGivers;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_serviceId == null) {
      _serviceId = ModalRoute.of(context)!.settings.arguments as String;
      _serviceName = Provider.of<Services>(context, listen: false)
          .getServiceById(_serviceId!)
          .name;
      _serviceGivers = Provider.of<ServicesGivers>(context, listen: false);
      _getAndFetchServicesGivers =
          _serviceGivers.getAndFetchServicesGivers(_serviceId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_serviceName),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getAndFetchServicesGivers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()), //
            );
          }
          if (_serviceGivers.getServiceGivers.isEmpty) {
            return const Center(
              child: Text('There is no data!!!'),
            );
          }

          return ServiceGiversMap(_serviceName);
        },
      ),
    );
  }
}

/* return ListView.builder(
                itemCount: serviceGivers.length,
                itemBuilder: (ctx, index) =>
                    ServiceGiverItem(serviceGivers[index], serviceName),
              );*/
