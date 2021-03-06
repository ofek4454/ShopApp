import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';
import '../widgets/image_preview.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageFocus = FocusNode();
  final _imageController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isInit = false;
  var values = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };
  String prodId = null;
  bool isFavorite = false;
  var isLoading = false;

  _Product prod = _Product();

  @override
  void initState() {
    super.initState();
    _imageFocus.addListener(imageListner);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      var product = ModalRoute.of(context).settings.arguments as Product;
      if (product != null) {
        values = {
          'title': product.title,
          'price': product.price.toString(),
          'description': product.description,
          'imageUrl': '',
        };
        _imageController.text = product.imageUrl;
        prodId = product.id;
        isFavorite = product.isFavorite;
      }
      isInit = true;
    }
  }

  @override
  void dispose() {
    super.dispose();

    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageFocus.removeListener(imageListner);
    _imageFocus.dispose();
    _imageController.dispose();
  }

  void imageListner() {
    if (!_imageFocus.hasFocus) {
      setState(() {});
    }
  }

  Future<void> confirm() async {
    setState(() {
      isLoading = true;
    });
    Product _product = Product(
      title: prod.title,
      price: prod.price,
      description: prod.description,
      imageUrl: prod.imageUrl,
      id: prodId != null ? prodId : DateTime.now().toString(),
      isFavorite: isFavorite,
    );
    if (prodId != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_product);
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_product);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Something went wrong...'),
            content: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Error massage: ',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                TextSpan(text: '\n'),
                TextSpan(
                    text: error.toString(),
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ]),
            ),
            actions: [
              FlatButton(
                child: Text('close'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  void _saveForm() {
    final isValidated = _form.currentState.validate();
    if (!isValidated) {
      return;
    }
    _form.currentState.save();
    FocusScope.of(context).requestFocus(FocusNode());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Confirm new product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('title: ${prod.title}'),
            Text('price: \$${prod.price}'),
            Text('description: ${prod.description}'),
            ImagePreview(imageURL: prod.imageUrl),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('cancel')),
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                confirm();
              },
              child: Text('confirm')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(prodId != null ? Icons.autorenew : Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: values['title'],
                      decoration: InputDecoration(
                        hintText: 'Title',
                        contentPadding: EdgeInsets.only(left: 5),
                        icon: Icon(Icons.title),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val.isEmpty || val.length < 3) {
                          return 'please enter valid data';
                        }
                        return null;
                      },
                      onFieldSubmitted: (val) =>
                          FocusScope.of(context).requestFocus(_priceFocus),
                      onSaved: (val) {
                        prod.title = val;
                      },
                    ),
                    TextFormField(
                      initialValue: values['price'],
                      decoration: InputDecoration(
                        hintText: 'Price',
                        contentPadding: EdgeInsets.only(left: 5),
                        icon: Icon(Icons.attach_money),
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'please enter price';
                        }
                        if (double.tryParse(val) == null) {
                          return 'please enter valid number';
                        }
                        if (double.parse(val) <= 0) {
                          return 'price must be greater than zero';
                        }
                        return null;
                      },
                      onFieldSubmitted: (val) => FocusScope.of(context)
                          .requestFocus(_descriptionFocus),
                      focusNode: _priceFocus,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onSaved: (val) {
                        prod.price = double.parse(val);
                      },
                    ),
                    TextFormField(
                      initialValue: values['description'],
                      decoration: InputDecoration(
                        hintText: 'Description',
                        contentPadding: EdgeInsets.only(left: 5),
                        icon: Icon(Icons.description),
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'please enter valid data';
                        }
                        return null;
                      },
                      focusNode: _descriptionFocus,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      minLines: 1,
                      onSaved: (val) {
                        prod.description = val;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Image URL',
                              contentPadding: EdgeInsets.only(left: 5),
                              icon: Icon(Icons.image),
                            ),
                            validator: (val) {
                              if (!val.endsWith('.jpg') &&
                                  !val.endsWith('.png') &&
                                  !val.endsWith('.jpeg')) {
                                return 'please enter valid image url';
                              }
                              return null;
                            },
                            focusNode: _imageFocus,
                            controller: _imageController,
                            keyboardType: TextInputType.url,
                            onFieldSubmitted: (val) {
                              _saveForm();
                            },
                            onSaved: (val) {
                              prod.imageUrl = val;
                            },
                          ),
                        ),
                        ImagePreview(imageURL: _imageController.text),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _Product {
  String title;
  String description;
  double price;
  String imageUrl;

  _Product({
    this.title,
    this.description,
    this.price,
    this.imageUrl,
  });
}
