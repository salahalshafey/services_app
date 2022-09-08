import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../general_custom_widgets/image_container.dart';

class OrderDetailsHeader extends StatelessWidget {
  const OrderDetailsHeader(
    this.serviceGiverImage,
    this.serviceGiverName,
    this.serviceName,
    this.serviceGiverPhoneNumber, {
    Key? key,
  }) : super(key: key);

  final String serviceGiverImage;
  final String serviceGiverName;
  final String serviceName;
  final String serviceGiverPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ImageContainer(
          image: serviceGiverImage,
          imageSource: From.network,
          radius: 60,
          shape: BoxShape.circle,
          fit: BoxFit.fitHeight,
          showHighlight: true,
          showImageDialoge: true,
        ),
        //const SizedBox(width: 20),
        Column(
          children: [
            FittedBox(
              child: Text(
                serviceGiverName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              serviceName,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '# ' + serviceGiverPhoneNumber,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ],
        ),
        IconButton(
          tooltip: 'Call $serviceGiverName',
          onPressed: () {
            launchUrl(Uri.parse('tel:$serviceGiverPhoneNumber'));
          },
          icon: const Icon(
            Icons.call,
            color: Colors.green,
            size: 30,
          ),
        )
      ],
    );
  }
}
