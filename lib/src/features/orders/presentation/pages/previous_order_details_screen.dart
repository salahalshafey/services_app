import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/functions/string_manipulations_and_search.dart';
import '../../../tracking/presentation/pages/tracking_info_screen.dart';
import '../../domain/entities/order.dart';

import '../providers/orders.dart';

import '../../../../core/util/widgets/custom_text_button.dart';
import '../../../../core/util/widgets/image_container.dart';

import '../../../chat/presentation/pages/chat_screen.dart';

import '../widgets/order_details_header.dart';
import '../widgets/description.dart';
import '../widgets/order_details.dart';

class PreviousOrderDetailScreen extends StatelessWidget {
  static const routName = '/previous-order-details-screen';

  const PreviousOrderDetailScreen({Key? key}) : super(key: key);

  void _goToChatScreen(BuildContext context, Order order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          orderId: order.id,
          otherPersonName: order.serviceGiverName,
          otherPersonImage: order.serviceGiverImage,
          otherPersonPhoneNumber: order.serviceGiverPhoneNumber,
          readOnly: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    final order = Provider.of<Orders>(context).getOrderById(orderId);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Order is ${wellFormatedString(order.status)}'),
            const SizedBox(width: 10),
            order.status == 'finished'
                ? const Icon(Icons.check_circle_outline, color: Colors.blue)
                : const Icon(Icons.not_interested, color: Colors.red),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        children: [
          OrderDetailsHeader(
            order.serviceGiverImage,
            order.serviceGiverName,
            order.serviceName,
            order.serviceGiverPhoneNumber,
            canCallOtherPerson: false,
          ),
          const SizedBox(height: 30),
          ImageContainer(
            image: order.image,
            imageSource: From.network,
            radius: 150,
            showImageScreen: true,
            imageTitle: 'Image Of The Problem.',
            imageCaption: order.description,
            borderRadius: BorderRadius.circular(25),
            showHighlight: true,
            containingShadow: true,
            fit: BoxFit.cover,
            showLoadingIndicator: true,
          ),
          const SizedBox(height: 30),
          Description(
            icon: const Icon(
              Icons.description,
              size: 40,
              color: Colors.green,
            ),
            title: 'Description Of The Problem',
            description: order.description,
          ),
          const SizedBox(height: 30),
          CustomTextButton(
            text: 'See Chat With ${order.serviceGiverName}',
            iconActive: Icons.chat_rounded,
            iconDeActive: Icons.chat_bubble_outline_rounded,
            onPressed: () => _goToChatScreen(context, order),
          ),
          CustomTextButton(
            text:
                'See How ${firstName(order.serviceGiverName)} Came To You On The Map',
            iconActive: Icons.timeline_outlined,
            iconDeActive: Icons.timeline_outlined,
            onPressed: () {
              Navigator.of(context).pushNamed(
                TrackingInfoScreen.routName,
                arguments: {
                  'orderId': orderId,
                },
              );
            },
          ),
          const SizedBox(height: 30),
          OrderDetails(
            cost: order.cost,
            status: order.status,
            date: order.date,
            dateOfFinishedOrCanceled: order.dateOfFinishedOrCanceled!,
            reasonIfCanceled: order.reasonIfCanceled,
          ),
        ],
      ),
    );
  }
}
