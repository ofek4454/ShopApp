import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/Cart.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<Product>(context, listen: false);
    final _cart = Provider.of<Cart>(context ,listen: false);

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: _product.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: Image.network(_product.imageUrl, fit: BoxFit.cover),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: FittedBox(
                child: Text(
              _product.title,
              overflow: TextOverflow.fade,
              softWrap: true,
            )),
            subtitle: Text('\$${_product.price}'),
            leading: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                _cart.addItem(_product);
              },
              color: Theme.of(context).accentColor,
              iconSize: 30,
            ),
            trailing: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () {
                  product.toggleFavoriteStatus();
                },
                color: Theme.of(context).accentColor,
                iconSize: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
