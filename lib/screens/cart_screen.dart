import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Cart.dart' show Cart;
import '../widgets/place_order_card.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final _cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: Text('cart')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _cart.itemCount == 0
              ? Expanded(
                  child: Center(
                    child: Text('Cart is empty'),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _cart.itemCount,
                    itemBuilder: (ctx, index) => CartItem(
                      product: _cart.items.values.toList()[index].product,
                      quantity: _cart.items.values.toList()[index].quantity,
                    ),
                  ),
                ),
          PlaceOrderCard(_cart.totalAmount, _cart.items.values.toList())
        ],
      ),
    );
  }
}
