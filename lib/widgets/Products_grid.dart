import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products_provider.dart';

class Products_grid extends StatelessWidget {

  final bool _showAll;

  Products_grid(this._showAll);

  @override
  Widget build(BuildContext context) {
    final _productsData = Provider.of<ProductsProvider>(context);
    final _products = _showAll ? _productsData.products : _productsData.favorites;

    return GridView.builder(
      padding: EdgeInsets.all(5),
      itemCount: _products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 9 / 10,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: _products[index],
        child: ProductItem(),
      ),
    );
  }
}
