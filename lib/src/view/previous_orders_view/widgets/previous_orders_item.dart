import 'package:flutter/material.dart';

import '../../../controllers/orders.dart';

import '../../general_custom_widgets/custom_card.dart';
import '../../previous_order_details_view/previous_order_details_screen.dart';

class PreviousOrdersItem extends StatelessWidget {
  const PreviousOrdersItem(this.order, {Key? key}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      margin: const EdgeInsets.all(6),
      elevation: 5,
      onTap: () => Navigator.of(context)
          .pushNamed(PreviousOrderDetailScreen.routName, arguments: order.id),
      child: ListTile(
        leading: const Icon(
          Icons.account_circle_outlined,
          size: 50,
        ),
        title: Text(
          order.serviceGiverName,
        ),
        subtitle: Text(order.serviceName),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$' + order.cost.toString(),
              style: const TextStyle(color: Colors.blue, fontSize: 17),
            ),
            Text(
              '${order.date.day}/${order.date.month}/${order.date.year}',
              style: const TextStyle(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
