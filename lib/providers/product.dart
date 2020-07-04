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

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    this.isFavorite = !this.isFavorite;
    notifyListeners();
    final url =
        'https://shopapp-4bde7.firebaseio.com/userFavorites/$userId/${this.id}.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(this.isFavorite),
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
