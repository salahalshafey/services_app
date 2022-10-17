import 'package:flutter/material.dart';

import '../../../../core/util/functions/date_time_and_duration.dart';
import '../../../../core/util/functions/string_manipulations_and_search.dart';
import 'order_cost.dart';
import 'description.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({
    required this.cost,
    required this.status,
    required this.date,
    required this.dateOfFinishedOrCanceled,
    this.reasonIfCanceled,
    Key? key,
  }) : super(key: key);

  final double cost;
  final String status;
  final DateTime date;
  final DateTime dateOfFinishedOrCanceled;
  final String? reasonIfCanceled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrderCost(cost),
        const SizedBox(height: 50),
        OrderInfo(
          title: 'Order Status:',
          icon: status == 'finished'
              ? const Icon(Icons.check_circle_outline_rounded)
              : const Icon(Icons.not_interested, color: Colors.red),
          info: wellFormatedString(status),
        ),
        const SizedBox(height: 30),
        OrderInfo(
          title: 'Date Of The Order:',
          icon: const Icon(Icons.date_range),
          info: wellFormattedDateTime(date, seperateByLine: true),
        ),
        const SizedBox(height: 30),
        OrderInfo(
          title: 'Date of ${wellFormatedString(status)}:',
          icon: const Icon(Icons.date_range),
          info: wellFormattedDateTime(
            dateOfFinishedOrCanceled,
            seperateByLine: true,
          ),
        ),
        const SizedBox(height: 30),
        if (reasonIfCanceled != null)
          Description(
            title: 'Reason Of Canceling',
            description: reasonIfCanceled!,
            icon: const Icon(
              Icons.not_interested,
              color: Colors.red,
              size: 40,
            ),
          ),
      ],
    );
  }
}

class OrderInfo extends StatelessWidget {
  const OrderInfo({
    required this.title,
    required this.icon,
    required this.info,
    Key? key,
  }) : super(key: key);

  final String title;
  final Icon icon;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            icon,
            const SizedBox(width: 10),
            SizedBox(
              width: 110,
              child: Text(
                info,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
