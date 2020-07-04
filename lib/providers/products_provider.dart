import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [];
  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this._products);

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favorites {
    return _products.where((product) => product.isFavorite).toList();
  }

  Product getProductById(String id) {
    if (!_products.any((product) => product.id == id)) {
      return null;
    }
    return _products.firstWhere((product) => product.id == id);
  }

  int getProductIndex(String id) {
    return _products.indexWhere((product) => product.id == id);
  }

  Future<void> insertProduct(Product product, int index) async {
    final url =
        'https://shopapp-4bde7.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'price': product.price.toString(),
            'description': product.description,
            'imageUrl': product.imageUrl,
            'creatorId': userId
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
    final url =
        'https://shopapp-4bde7.firebaseio.com/products/$id.json?auth=$authToken';
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

  Future<void> loadProducts([bool filter = false]) async {
    print('loadProducts');
    var filterString = filter ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shopapp-4bde7.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      print('done load products');
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      if (loadedData == null) {
        return;
      }
      url =
          'https://shopapp-4bde7.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      loadedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: double.parse(prodData['price']),
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shopapp-4bde7.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'price': product.price.toString(),
            'description': product.description,
            'imageUrl': product.imageUrl,
            'creatorId': userId
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
        'https://shopapp-4bde7.firebaseio.com/products/${product.id}.json?auth=$authToken';
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
