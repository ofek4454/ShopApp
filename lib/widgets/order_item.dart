import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as providers;

class OrderItem extends StatefulWidget {
  final providers.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy HH:mm').format(widget.order.date)),
            trailing: IconButton(
                icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                }),
          ),
          if (isExpanded)
            Divider(
              height: 10,
              endIndent: 10,
              indent: 10,
              thickness: 2,
              color: Colors.black38,
            ),
          if (isExpanded)
            Container(
              margin: EdgeInsets.only(top: 5),
              height: min(100 + widget.order.products.length * 20.0, 180),
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (ctx, index) {
                  return LayoutBuilder(
                    builder: (ctx, constraints) => Card(
                      elevation: 7,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: Container(
                          height: constraints.maxWidth * 0.15,
                          width: constraints.maxWidth * 0.15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(widget
                                  .order.products[index].product.imageUrl),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        title: Text(widget.order.products[index].product.title),
                        subtitle: Text(
                            '${widget.order.products[index].quantity} x \$${widget.order.products[index].product.price}'),
                        trailing: Text(
                            '\$${(widget.order.products[index].product.price * widget.order.products[index].quantity).toStringAsFixed(2)}'),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
