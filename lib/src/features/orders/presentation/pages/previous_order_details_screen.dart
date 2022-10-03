import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/order.dart';

import '../../../../core/util/widgets/custom_text_button.dart';
import '../../../../core/util/widgets/image_container.dart';

import '../providers/orders.dart';

import '../../../chat/presentation/pages/chat_screen.dart';
import '../widgets/order_cost.dart';
import '../widgets/order_description.dart';
import '../widgets/order_details_header.dart';

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
      appBar: AppBar(title: Text('Order is ${order.status}')),
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
          OrderDescription(order.description),
          const SizedBox(height: 30),
          CustomTextButton(
            text: 'See Chat With ${order.serviceGiverName}',
            iconActive: Icons.chat_rounded,
            iconDeActive: Icons.chat_bubble_outline_rounded,
            onPressed: () => _goToChatScreen(context, order),
          ),
          /* ServiceGiverLocationButton(
            orderId: orderId,          //// put button that goes to previuos 
                                       //// locations details screen
            serviceGiverName: order.serviceGiverName,
          ),*/
          const SizedBox(height: 30),
          OrderCost(order.cost),
          const SizedBox(height: 50),
          //CancelTheOrderButton(orderId)
          //// put info about the finished order
          //// like date and reason if the order is canceld
        ],
      ),
    );
  }
}
