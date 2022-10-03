import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/util/widgets/image_container.dart';

class OrderDetailsHeader extends StatelessWidget {
  const OrderDetailsHeader(
    this.serviceGiverImage,
    this.serviceGiverName,
    this.serviceName,
    this.serviceGiverPhoneNumber, {
    required this.canCallOtherPerson,
    Key? key,
  }) : super(key: key);

  final String serviceGiverImage;
  final String serviceGiverName;
  final String serviceName;
  final String serviceGiverPhoneNumber;
  final bool canCallOtherPerson;

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
          tooltip: '${can(canCallOtherPerson)}Call $serviceGiverName',
          onPressed: !canCallOtherPerson
              ? null
              : () {
                  launchUrl(Uri.parse('tel:$serviceGiverPhoneNumber'));
                },
          color: Colors.green,
          disabledColor: Colors.grey,
          icon: const Icon(
            Icons.call,
            size: 30,
          ),
        )
      ],
    );
  }
}

String can(bool canCall) => canCall ? '' : "Can't ";
