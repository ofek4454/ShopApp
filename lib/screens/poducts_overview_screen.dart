import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/Products_grid.dart';
import '../providers/Cart.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';
import '../widgets/costum_drawer.dart';
import '../providers/products_provider.dart';

enum FilterValues {
  ShowAll,
  WishList,
}

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var showAll = true;
  var isLoading = false;
  var isInit = false;

  @override
  initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      setState(() {
        isLoading = true;
      });
      setState(() {
        Provider.of<ProductsProvider>(context).loadProducts().then((_) {
          isLoading = false;
        });
      });
      isInit = true;
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(showAll ? 'Products' : 'WishList'),
      centerTitle: true,
      actions: <Widget>[
        PopupMenuButton(
          onSelected: (FilterValues value) {
            setState(() {
              if (value == FilterValues.ShowAll) {
                showAll = true;
              } else if (value == FilterValues.WishList) {
                showAll = false;
              }
            });
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (ctx) => [
            PopupMenuItem(
              child: Text('all products'),
              value: FilterValues.ShowAll,
            ),
            PopupMenuItem(
              child: Text('wishList'),
              value: FilterValues.WishList,
            ),
          ],
        ),
        Consumer<Cart>(
          builder: (ctx, cart, child) => Badge(
            child: child,
            value: cart.itemCount.toString(),
          ),
          child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              }),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: CustomDrawer('/'),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Products_grid(showAll),
    );
  }
}
