import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/Cart.dart';
import '../screens/product_detail_screen.dart';
import '../providers/products_provider.dart';
import '../widgets/details_page_body.dart';
import '../screens/edit_product_screen.dart';
import '../providers/auth.dart';

enum BuildType {
  Row,
  Grid,
}

class ProductItem extends StatefulWidget {
  BuildType type;
  Product _product;

  ProductItem.grid() {
    type = BuildType.Grid;
  }

  ProductItem.list(this._product) {
    type = BuildType.Row;
  }

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  var isLoading = false;

  Widget buildToGrid() {
    final scaffold = Scaffold.of(context);
    final _product = Provider.of<Product>(context, listen: false);
    final _cart = Provider.of<Cart>(context, listen: false);
    final _auth = Provider.of<Auth>(context, listen: false);
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
          child: Hero(
            tag: _product.id,
            child: FadeInImage(
              image: NetworkImage(_product.imageUrl),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 500),
              fadeInCurve: Curves.fastOutSlowIn,
              placeholder: AssetImage('assets/images/placeHolder.jpg'),
              imageErrorBuilder: (context, error, stackTrace) =>
                  Center(child: Text('error while loading image')),
            ),
            //  Image.network(
            //   _product.imageUrl,
            //   fit: BoxFit.cover,
            //   errorBuilder: (context, error, stackTrace) => Center(
            //     child: Text('error while loading image'),
            //   ),
            //   loadingBuilder: (ctx, child, loadingProgress) {
            //     if (loadingProgress == null) return child;
            //     return Center(
            //       child: CircularProgressIndicator(
            //         value: loadingProgress.expectedTotalBytes != null
            //             ? loadingProgress.cumulativeBytesLoaded /
            //                 loadingProgress.expectedTotalBytes
            //             : null,
            //       ),
            //     );
            //   },
            // ),
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
                scaffold.removeCurrentSnackBar();
                scaffold.showSnackBar(
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
              builder: (ctx, product, child) {
                return isLoading
                    ? CircularProgressIndicator()
                    : IconButton(
                        icon: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await product.toggleFavoriteStatus(
                                _auth.token, _auth.userId);
                            scaffold.hideCurrentSnackBar();
                            scaffold.showSnackBar(SnackBar(
                              content: Text(product.isFavorite
                                  ? 'added to wishList successfully!'
                                  : 'removed from wishList successfully!'),
                            ));
                            setState(() {
                              isLoading = false;
                            });
                          } catch (error) {
                            scaffold.hideCurrentSnackBar();
                            scaffold.showSnackBar(SnackBar(
                              content: Text(
                                  'Something went wrong, Please try again'),
                            ));
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        color: Theme.of(ctx).accentColor,
                        iconSize: 30,
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildToList() {
    final scaffold = Scaffold.of(context);
    final productsData = Provider.of<ProductsProvider>(context, listen: false);
    return ListTile(
      title: Text(widget._product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget._product.imageUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName,
                  arguments: widget._product);
            },
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final prodIndex =
                  productsData.getProductIndex(widget._product.id);
              try {
                await productsData.deleteProduct(widget._product.id);
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text('Product deleted successfully!'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        productsData.insertProduct(
                          widget._product,
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
    switch (widget.type) {
      case BuildType.Grid:
        return buildToGrid();
        break;
      case BuildType.Row:
        return buildToList();
        break;
    }
  }
}
