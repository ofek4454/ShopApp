import 'package:flutter/material.dart';

import '../providers/product.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final int quantity;

  CartItem({this.product, this.quantity});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
          subtitle: Text('\$${product.price} x $quantity'),
          trailing: Text('\$${(product.price * quantity)}'),
        ),
      ),
    );
  }
}
