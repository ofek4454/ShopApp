import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {

  static const routeName = '/product_detail_screen';
  
  @override
  Widget build(BuildContext context) {
    final _productId = ModalRoute.of(context).settings.arguments as String;
    final _product = Provider.of<ProductsProvider>(context , listen: false).getProductById(_productId);

    return Scaffold(
      appBar: AppBar(title: Text(_product.title)),
    );
  }
}