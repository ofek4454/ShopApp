import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/costum_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: CustomDrawer(routeName),
      body: ordersData.items.length == 0
          ? Center(
              child:
                  Text('no order placed yet!', style: TextStyle(fontSize: 30)),
            )
          : ListView.builder(
              itemCount: ordersData.items.length,
              itemBuilder: (ctx, i) => OrderItem(ordersData.items[i])),
    );
  }
}
