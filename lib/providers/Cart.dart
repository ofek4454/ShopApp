import 'package:flutter/foundation.dart';

import './product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double sum = 0;
    _items.forEach((key, value) {
      sum += (value.product.price * value.quantity);
    });
    return sum;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (value) =>
            CartItem(product: value.product, quantity: value.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(product: product, quantity: 1),
      );
    }
    notifyListeners();
  }
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({this.product, this.quantity});
}
