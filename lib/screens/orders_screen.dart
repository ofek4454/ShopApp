import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/costum_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var isLoading = false;
  var isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Orders>(context).loadOrders(context).catchError((error) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Error while loading'),
                  content: Text(error.toString()),
                  actions: [
                    FlatButton(
                      child: Text('close'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ));
      }).then((_) {
        setState(() {
          isLoading = false;
        });
      });
      isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: CustomDrawer(OrdersScreen.routeName),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ordersData.items.length == 0
              ? Center(
                  child: Text('no order placed yet!',
                      style: TextStyle(fontSize: 30)),
                )
              : ListView.builder(
                  itemCount: ordersData.items.length,
                  itemBuilder: (ctx, i) => OrderItem(ordersData.items[i])),
    );
  }
}
