import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../account/presentation/providers/account.dart';

import '../providers/orders.dart';

import '../../../main_and_drawer_screens/pages/main_drawer.dart';

import '../widgets/current_orders_item.dart';

class CurrentOrdersScreen extends StatelessWidget {
  const CurrentOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Account>(context).id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Orders'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false)
              .getAndFetchUserOrdersOnce(userId),
          builder: (context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              /*&&  !services.dataFetchedFromBackend*/
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            final orders = Provider.of<Orders>(context).currentOrders;
            if (orders.isEmpty) {
              return const Center(
                child: Text('There Is No Current Orders!!!'),
              );
            }
            return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                itemCount: orders.length,
                itemBuilder: (ctx, index) => CurrentOrdersItem(orders[index]));
          }),
      drawer: const MainDrawer(),
    );
  }
}
