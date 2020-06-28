import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/costum_drawer.dart';
import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class ManageProductsScreen extends StatelessWidget {
  
  static const routeName = '/manage-products';

  @override
  Widget build(BuildContext context) {
    var _productsData = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('manage products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      drawer: CustomDrawer(routeName),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: ListView.builder(
          itemCount: _productsData.products.length,
          itemBuilder: (ctx, index) => Column(
            children: <Widget>[
              ProductItem.list(_productsData.products[index]),
              Divider(color: Colors.black.withOpacity(0.6),),
            ],
          ),
        ),
      ),
    );
  }
}
