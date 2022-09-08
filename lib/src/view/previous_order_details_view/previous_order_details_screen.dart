import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/orders.dart';

class PreviousOrderDetailScreen extends StatelessWidget {
  static const routName = '/previous-order-details-screen';

  const PreviousOrderDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    final order = Provider.of<Orders>(context).getOrderById(orderId);

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: Center(child: Text(order.description)),
    );
  }
}
