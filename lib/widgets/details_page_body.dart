import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/Cart.dart';
import '../providers/auth.dart';

class DetailsPageBody extends StatefulWidget {
  const DetailsPageBody({
    Key key,
    @required Product product,
  })  : _product = product,
        super(key: key);

  final Product _product;

  @override
  _DetailsPageBodyState createState() => _DetailsPageBodyState();
}

class _DetailsPageBodyState extends State<DetailsPageBody> {
  double setHeight() {
    var mQuery = MediaQuery.of(context);
    try {
      return mQuery.size.height -
          mQuery.viewInsets.top -
          Scaffold.of(context).appBarMaxHeight;
    } catch (e) {
      return mQuery.size.height - mQuery.viewInsets.top;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _cart = Provider.of<Cart>(context, listen: false);
    final _auth = Provider.of<Auth>(context, listen: false);
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: setHeight(),
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  ClipPath(
                    clipper: CustomShapeClipper(expand: true),
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(color: Colors.black26),
                    ),
                  ),
                  Hero(
                    tag: widget._product.id,
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      child: ClipPath(
                        clipper: CustomShapeClipper(),
                        child: Image.network(widget._product.imageUrl,
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: CircleAvatar(
                      radius: 25,
                      child: IconButton(
                        iconSize: 30,
                        icon: Icon(
                          widget._product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        onPressed: () {
                          setState(() {
                            widget._product.toggleFavoriteStatus(
                                _auth.token, _auth.userId);
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
                      '\$${widget._product.price}',
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 15),
                    Text(
                      widget._product.description,
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
                      onPressed: () => _cart.addItem(widget._product),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  final expand;

  CustomShapeClipper({this.expand = false});
  @override
  Path getClip(Size size) {
    var path = Path();
    if (expand) {
      path.lineTo(0.0, 223);
      path.quadraticBezierTo(size.width / 2, 333, size.width, 223);
      path.lineTo(size.width, 0.0);
      path.close();
    } else {
      path.lineTo(0.0, 220);
      path.quadraticBezierTo(size.width / 2, 330, size.width, 220);
      path.lineTo(size.width, 0.0);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
