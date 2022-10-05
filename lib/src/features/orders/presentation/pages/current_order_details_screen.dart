import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../tracking/presentation/widgets/service_giver_location_button.dart';
import '../../domain/entities/order.dart';

import '../providers/orders.dart';

import '../../../../core/util/widgets/image_container.dart';

import '../../../chat/presentation/pages/chat_screen.dart';
import '../widgets/cancel_the_order_button.dart';
import '../../../../core/util/widgets/custom_text_button.dart';
import '../widgets/order_cost.dart';
import '../widgets/description.dart';
import '../widgets/order_details_header.dart';

class CurrentOrderDetailScreen extends StatelessWidget {
  static const routName = '/current-order-details-screen';

  const CurrentOrderDetailScreen({Key? key}) : super(key: key);

  void _goToChatScreen(BuildContext context, Order order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          orderId: order.id,
          otherPersonName: order.serviceGiverName,
          otherPersonImage: order.serviceGiverImage,
          otherPersonPhoneNumber: order.serviceGiverPhoneNumber,
          readOnly: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    final order = Provider.of<Orders>(context).getOrderById(orderId);

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        children: [
          OrderDetailsHeader(
            order.serviceGiverImage,
            order.serviceGiverName,
            order.serviceName,
            order.serviceGiverPhoneNumber,
            canCallOtherPerson: true,
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
            text: 'Chat With ${order.serviceGiverName}',
            iconActive: Icons.chat_rounded,
            iconDeActive: Icons.chat_bubble_outline_rounded,
            onPressed: () => _goToChatScreen(context, order),
          ),
          ServiceGiverLocationButton(
            orderId: orderId,
            serviceGiverName: order.serviceGiverName,
          ),
          const SizedBox(height: 30),
          OrderCost(order.cost),
          const SizedBox(height: 50),
          CancelTheOrderButton(orderId)
        ],
      ),
    );
  }
}
