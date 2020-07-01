import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favorites {
    return _products.where((product) => product.isFavorite).toList();
  }

  Product getProductById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  int getProductIndex(String id) {
    return _products.indexWhere((product) => product.id == id);
  }

  Future<void> insertProduct(Product product, int index) async {
    const url = 'https://shopapp-4bde7.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'price': product.price.toString(),
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          },
        ),
      );
      final newProd = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          isFavorite: product.isFavorite);
      _products.insert(index, newProd);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://shopapp-4bde7.firebaseio.com/products/$id.json';
    final extProdIndex = _products.indexWhere((product) => product.id == id);
    var extProd = _products.firstWhere((product) => product.id == id);
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
    try {
      await http.delete(url).then((response) {
        if (response.statusCode >= 400) {
          throw Error();
        } else {
          extProd = null;
        }
      });
    } catch (error) {
      _products.insert(extProdIndex, extProd);
      notifyListeners();
      throw error;
    }
  }

  Future<void> loadProducts() async {
    print('loadProducts');
    const url = 'https://shopapp-4bde7.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      print('done');
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      // print(json.decode(response.body));
      final List<Product> loadedProducts = [];
      loadedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: double.parse(prodData['price']),
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://shopapp-4bde7.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'price': product.price.toString(),
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          },
        ),
      );
      final newProd = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          isFavorite: product.isFavorite);
      _products.add(newProd);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((prod) => prod.id == product.id);
    final url =
        'https://shopapp-4bde7.firebaseio.com/products/${product.id}.json';
    if (index >= 0) {
      try {
        await http.patch(
          url,
          body: json.encode(
            {
              'title': product.title,
              'price': product.price.toString(),
              'description': product.description,
              'imageUrl': product.imageUrl,
            },
          ),
        );
      } catch (error) {
        print(error);
        throw error;
      }
      _products[index] = product;
    }
    notifyListeners();
  }
}
