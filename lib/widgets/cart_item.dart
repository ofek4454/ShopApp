import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/Cart.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final int quantity;

  CartItem({this.product, this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_){Provider.of<Cart>(context , listen: false).removeItem(product.id);},
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: LayoutBuilder(
        builder: (ctx, constraints) => Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: Container(
              height: constraints.maxWidth * 0.15,
              width: constraints.maxWidth * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            title: Text(product.title),
            subtitle: Text('$quantity x \$${product.price}'),
            trailing: Text('\$${(product.price * quantity)}'),
          ),
        ),
      ),
    );
  }
}
