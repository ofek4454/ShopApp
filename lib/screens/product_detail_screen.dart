import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../providers/Cart.dart';
import '../widgets/badge.dart';
import '../screens/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product_detail_screen';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final _productId = ModalRoute.of(context).settings.arguments as String;
    final _product = Provider.of<ProductsProvider>(context, listen: false)
        .getProductById(_productId);
    final _cart = Provider.of<Cart>(context, listen: false);

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
      body: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Container(
                height: 300,
                width: double.infinity,
                child: ClipPath(
                  clipper: CustomShapeClipper(),
                  child: Image.network(_product.imageUrl, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: CircleAvatar(
                  radius: 25,
                  child: IconButton(
                    iconSize: 30,
                    icon: Icon(
                      _product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    onPressed: () {
                      setState(() {
                        _product.toggleFavoriteStatus();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  '\$${_product.price}',
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(height: 15),
                Text(
                  _product.description,
                  softWrap: true,
                  style: TextStyle(fontSize: 18),
                ),
                Spacer(),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  textColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('ADD TO Cart!'),
                        SizedBox(width: 15),
                        Icon(Icons.shopping_cart),
                      ],
                    ),
                  ),
                  onPressed: () => _cart.addItem(_product),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, 190);
    path.quadraticBezierTo(size.width / 2, 350, size.width, 190);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
