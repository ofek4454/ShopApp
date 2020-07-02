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
                '\$${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Spacer(),
            OrderButton(totalAmount: totalAmount, products: products),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.totalAmount,
    @required this.products,
  }) : super(key: key);

  final double totalAmount;
  final List<CartItem> products;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      textColor: Theme.of(context).primaryColor,
      onPressed: (isLoading || widget.products.length <= 0)
          ? null
          : () async {
              try {
                setState(() {
                  isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false)
                    .addOrder(widget.totalAmount, widget.products);
                setState(() {
                  isLoading = false;
                });
                Provider.of<Cart>(context, listen: false).clearCart();
              } catch (error) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Something went wrong'),
                ));
              }
            },
      child: isLoading
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            )
          : Text(
              'place order!'.toUpperCase(),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
    );
  }
}
