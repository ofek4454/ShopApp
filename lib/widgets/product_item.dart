import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/Cart.dart';
import '../screens/product_detail_screen.dart';
import '../providers/products_provider.dart';
import '../widgets/details_page_body.dart';
import '../screens/edit_product_screen.dart';

enum BuildType {
  Row,
  Grid,
}

class ProductItem extends StatelessWidget {
  BuildType type;
  Product _product;

  ProductItem.grid() {
    type = BuildType.Grid;
  }

  ProductItem.list(this._product) {
    type = BuildType.Row;
  }

  Widget buildToGrid(BuildContext context) {
    final _product = Provider.of<Product>(context, listen: false);
    final _cart = Provider.of<Cart>(context, listen: false);
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: _product.id);
      },
      onLongPress: () {
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
          context: context,
          builder: (ctx) => ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: DetailsPageBody(product: _product),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: Image.network(
            _product.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (ctx, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            },
          ),
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
                Scaffold.of(context).removeCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('product added successfully!'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'undo'.toUpperCase(),
                      onPressed: () => _cart.removeSingleItem(_product.id),
                    ),
                  ),
                );
              },
              color: Theme.of(context).accentColor,
              iconSize: 30,
            ),
            trailing: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                icon: Icon(
                  _product.isFavorite ? Icons.favorite : Icons.favorite_border,
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

  Widget buildToList(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final productsData = Provider.of<ProductsProvider>(context, listen: false);
    return ListTile(
      title: Text(_product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_product.imageUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: _product);
            },
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final prodIndex = productsData.getProductIndex(_product.id);
              try {
                await productsData.deleteProduct(_product.id);
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text('Product deleted successfully!'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        productsData.insertProduct(
                          _product,
                          prodIndex,
                        );
                      },
                    ),
                  ),
                );
              } catch (error) {
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text('Something went wrong, Please try again!'),
                  ),
                );
              }
            },
            color: Theme.of(context).errorColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case BuildType.Grid:
        return buildToGrid(context);
        break;
      case BuildType.Row:
        return buildToList(context);
        break;
    }
  }
}
