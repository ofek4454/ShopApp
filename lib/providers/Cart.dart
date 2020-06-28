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

  void removeItem(Product product) {
    _items.update(
      product.id,
      (value) {
        if (value.quantity > 1) {
          return CartItem(product: value.product, quantity: value.quantity - 1);
        }
        return value;
      },
    );
    notifyListeners();
  }

  void deleteItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if(!_items.containsKey(id)){
      return;
    }
    if(_items[id].quantity > 1){
      _items.update(id, (value) => CartItem(product: value.product , quantity: value.quantity-1));
    } else {
      this.deleteItem(id);
    }
    notifyListeners();
  }
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({this.product, this.quantity});
}
