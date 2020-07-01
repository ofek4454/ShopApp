import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/costum_drawer.dart';
import '../providers/products_provider.dart';
import '../widgets/product_item.dart';
import './edit_product_screen.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage-products';

  Future<void> _refresh(ProductsProvider productsProvider) async {
    await productsProvider.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    var _productsData = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('manage products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: CustomDrawer(routeName),
      body: RefreshIndicator(
        onRefresh: () => _refresh(_productsData),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListView.builder(
            itemCount: _productsData.products.length,
            itemBuilder: (ctx, index) => Column(
              children: <Widget>[
                ProductItem.list(_productsData.products[index]),
                Divider(
                  color: Colors.black.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
