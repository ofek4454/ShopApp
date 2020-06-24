import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../providers/Cart.dart';

class PlaceOrderCard extends StatelessWidget {
  final double totalAmount;
  final List<CartItem> products;

  PlaceOrderCard(this.totalAmount, this.products);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Text(
              'total: ',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
              ),
            ),
            Chip(
              backgroundColor: Theme.of(context).primaryColor,
              label: Text(
                '\$$totalAmount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Spacer(),
            FlatButton(
              onPressed: () {
                Provider.of<Orders>(context, listen: false)
                    .addOrder(totalAmount, products);
                Provider.of<Cart>(context , listen: false).clearCart();
              },
              child: Text(
                'place order!'.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
