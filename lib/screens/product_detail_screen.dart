import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../providers/Cart.dart';
import '../widgets/badge.dart';
import '../screens/cart_screen.dart';
import '../widgets/details_page_body.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail_screen';

  @override
  Widget build(BuildContext context) {
    final _productId = ModalRoute.of(context).settings.arguments as String;
    final _product = Provider.of<ProductsProvider>(context, listen: false)
        .getProductById(_productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_product.title),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (ctx, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: DetailsPageBody(product: _product),
    );
  }
}
