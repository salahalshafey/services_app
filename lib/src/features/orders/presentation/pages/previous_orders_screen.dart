import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../account/presentation/providers/account.dart';
import '../providers/orders.dart';

import '../../../main_and_drawer_screens/pages/main_drawer.dart';
import '../widgets/previous_orders_item.dart';

class PreviousOrdersScreen extends StatelessWidget {
  const PreviousOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Account>(context).id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Orders'),
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

            final orders =
                Provider.of<Orders>(context).previousAndCanceledOrders;
            if (orders.isEmpty) {
              return const Center(
                child: Text('There is no orders!!!'),
              );
            }
            return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                itemCount: orders.length,
                itemBuilder: (ctx, index) => PreviousOrdersItem(orders[index]));
          }),
      drawer: const MainDrawer(),
    );
  }
}
