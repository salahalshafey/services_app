import 'package:flutter/material.dart';

import '../../../../core/util/widgets/build_rating.dart';
import '../../../../core/util/widgets/image_container.dart';

import '../../../services_givers/domain/entities/service_giver.dart';

import '../widgets/request_service_form.dart';

class RequestServiceScreen extends StatelessWidget {
  static const routName = '/request-service';
  const RequestServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final serviceGiver = data['serviceGiver'] as ServiceGiver;
    final serviceName = data['serviceName'] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Service'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Text(
            serviceName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ImageContainer(
            image: serviceGiver.image,
            imageSource: From.network,
            radius: 80,
            imageTitle: serviceGiver.name + ' ($serviceName)',
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200, width: 2.0),
            showHighlight: true,
            showImageScreen: true,
          ),
          const SizedBox(height: 20),
          Text(
            serviceGiver.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          BuildRating(serviceGiver.rating),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cost',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                '\$' + serviceGiver.cost.toStringAsFixed(2),
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          RequestServiceForm(serviceGiver.id, serviceName),
        ],
      ),
    );
  }
}
