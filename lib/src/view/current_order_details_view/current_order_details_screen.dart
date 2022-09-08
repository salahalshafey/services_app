import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services_app/src/view/general_custom_widgets/custom_snack_bar.dart';

import '../../controllers/orders.dart';

import '../chat_view/chat_screen.dart';
import '../general_custom_widgets/image_container.dart';
import 'widgets/cancel_the_order_button.dart';
import 'widgets/custom_text_button.dart';
import 'widgets/order_cost.dart';
import 'widgets/order_description.dart';
import 'widgets/order_details_header.dart';

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
          ),
          const SizedBox(height: 30),
          ImageContainer(
            image: order.image,
            imageSource: From.network,
            radius: 150,
            imageTitle: 'Image Of The Problem.',
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(25),
            showHighlight: true,
            containingShadow: true,
            showImageScreen: true,
            showLoadingIndicator: true,
          ),
          const SizedBox(height: 30),
          OrderDescription(order.description),
          const SizedBox(height: 30),
          CustomTextButton(
            text: 'Chat With ${order.serviceGiverName}',
            iconActive: Icons.chat_rounded,
            iconDeActive: Icons.chat_bubble_outline_rounded,
            onPressed: () => _goToChatScreen(context, order),
          ),
          CustomTextButton(
            text: // first name
                'See Where is ${order.serviceGiverName.split(RegExp(r' +')).first} On The Map',
            iconActive: Icons.location_on,
            iconDeActive: Icons.location_off,
            onPressed: () {
              showCustomSnackBar(context: context, content: 'content');
            },
            isActive: true,
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
