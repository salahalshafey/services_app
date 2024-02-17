import 'package:flutter/material.dart';

import '../../../../core/util/functions/date_time_and_duration.dart';
import '../../../../core/util/functions/string_manipulations_and_search.dart';
import '../../../../core/util/widgets/custom_card.dart';

import '../../domain/entities/order.dart';

import '../pages/current_order_details_screen.dart';

class CurrentOrdersItem extends StatelessWidget {
  const CurrentOrdersItem(this.order, {Key? key}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      elevation: 5,
      onTap: () => Navigator.of(context).pushNamed(
        CurrentOrderDetailScreen.routName,
        arguments: order.id,
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(order.serviceGiverImage),
            ),
            title: Text(
              order.serviceGiverName,
            ),
            subtitle: Text(order.serviceName),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Data(
                title: 'Date',
                data: formatedDate(order.date),
              ),
              _Data(
                title: 'Time',
                data: time24To12HoursFormat(order.date),
              ),
              _Data(
                title: 'Cost',
                data: '\$' + order.cost.toString(),
                dataColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 16 + 8),
          Row(
            children: [
              Icon(
                Icons.radio_button_checked,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 10),
              Text(
                wellFormatedString(order.status),
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

class _Data extends StatelessWidget {
  const _Data(
      {required this.title, required this.data, this.dataColor, Key? key})
      : super(key: key);

  final String title;
  final String data;
  final Color? dataColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 10),
        Text(
          data,
          style: TextStyle(fontSize: 17, color: dataColor),
        ),
      ],
    );
  }
}
