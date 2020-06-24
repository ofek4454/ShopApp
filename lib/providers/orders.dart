import 'package:flutter/foundation.dart';

import './Cart.dart';

class Orders with ChangeNotifier{
  List<OrderItem> items =[];

  List<OrderItem> get orders{
    return [...items];
  }

  void addOrder(double amount , List<CartItem> products){
    items.insert(0, OrderItem(amount: amount , products: products , date: DateTime.now()));
    notifyListeners();
  }
}

class OrderItem{
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  OrderItem({this.amount , this.products , this.date});
}
