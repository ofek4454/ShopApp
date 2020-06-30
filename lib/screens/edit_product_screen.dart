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

  _Product prod = _Product();

  @override
  void initState() {
    super.initState();
    _imageFocus.addListener(imageListner);
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

  void confirm() {
    Product _product = Product(
      title: prod.title,
      price: prod.price,
      description: prod.description,
      imageUrl: prod.imageUrl,
      id: DateTime.now().toString(),
    );
    Provider.of<ProductsProvider>(context, listen: false).addProduct(_product);
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
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              TextFormField(
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
                onFieldSubmitted: (val) =>
                    FocusScope.of(context).requestFocus(_descriptionFocus),
                focusNode: _priceFocus,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onSaved: (val) {
                  prod.price = double.parse(val);
                },
              ),
              TextFormField(
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
                            !val.endsWith('.gpeg')) {
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

  _Product({this.title, this.description, this.price, this.imageUrl});
}
