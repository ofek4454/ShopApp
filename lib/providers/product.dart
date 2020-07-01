import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    this.isFavorite = !this.isFavorite;
    notifyListeners();
    final url = 'https://shopapp-4bde7.firebaseio.com/products/${this.id}.json';
    try {
      final response = await http.patch(
        url,
        body: json.encode({'isFavorite': this.isFavorite}),
      );
      if (response.statusCode >= 400) {
        throw Error();
      }
    } catch (error) {
      print('error');
      print(error);
      this.isFavorite = !this.isFavorite;
      notifyListeners();
      throw error;
    }
  }
}
