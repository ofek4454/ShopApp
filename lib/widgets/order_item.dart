import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as providers;

class OrderItem extends StatelessWidget {
  final providers.OrderItem order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(order.date)),
            trailing: IconButton(icon: Icon(Icons.expand_more), onPressed: null),
          ),
        ],
      ),
    );
  }
}
