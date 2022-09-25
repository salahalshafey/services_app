import 'package:flutter/material.dart';

import '../../../../core/util/widgets/build_rating.dart';
import '../../../../core/util/widgets/image_container.dart';

import '../../../orders/presentation/pages/request_service_screen.dart';

import '../../domain/entities/service_giver.dart';

void serviceGiverDialog(
    BuildContext context, String serviceName, ServiceGiver serviceGiver) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      child: Container(
        height: 500,
        padding: const EdgeInsets.all(15),
        child: ListView(
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
              radius: 60,
              imageTitle: serviceGiver.name + ' ($serviceName)',
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
              showImageScreen: true,
              showHighlight: true,
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
            _lineOfData(
              'Cost',
              '\$' + serviceGiver.cost.toStringAsFixed(2),
              Colors.blue,
            ),
            const SizedBox(height: 10),
            _lineOfData('City', serviceGiver.city, Colors.grey),
            const SizedBox(height: 10),
            _lineOfData('Area', serviceGiver.area, Colors.grey),
            Container(
              height: 100,
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).popAndPushNamed(
                      RequestServiceScreen.routName,
                      arguments: {
                        'serviceGiver': serviceGiver,
                        'serviceName': serviceName,
                      },
                    ),
                    child: const Text('REQUEST'),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'DISCARD',
                      // style: TextStyle(
                      //   fontSize: 17, fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Row _lineOfData(String title, String data, Color colorOfData) {
  return Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      Expanded(
        child: Text(
          data,
          style: TextStyle(
            color: colorOfData,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}
