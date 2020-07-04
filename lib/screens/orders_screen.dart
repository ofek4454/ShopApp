import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/costum_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: CustomDrawer(OrdersScreen.routeName),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).loadOrders(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error == null) {
              return Consumer<Orders>(
                builder: (ctx, ordersData, _) {
                  if (ordersData.items.length == 0) {
                    return Center(
                      child: Text('no order placed yet!',
                          style: TextStyle(fontSize: 30)),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: ordersData.items.length,
                        itemBuilder: (ctx, i) =>
                            OrderItem(ordersData.items[i]));
                  }
                },
              );
            }
            /*else {
              Future.delayed(Duration.zero).then((_) {
                showDialog(
                    context: ctx,
                    builder: (ctx) => AlertDialog(
                          title: Text('Error while loading'),
                          content: Text(snapshot.error.toString()),
                          actions: [
                            FlatButton(
                              child: Text('close'),
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                          ],
                        ));
              });
            }*/
            return Center(
              child:
                  Text('Error while loading', style: TextStyle(fontSize: 30)),
            );
          }
        },
      ),
    );
  }
}
