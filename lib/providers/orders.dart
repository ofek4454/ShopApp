import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import './Cart.dart';
import './products_provider.dart';

class Orders with ChangeNotifier {
  List<OrderItem> items = [];

  List<OrderItem> get orders {
    return [...items];
  }

  Future<void> loadOrders(BuildContext context) async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    print('load orders');
    const url = 'https://shopapp-4bde7.firebaseio.com/orders.json';
    try {
      final response = await http.get(url);
      print('done load orders');
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      final List<CartItem> cartItems = [];
      final List<Map<String, Object>> products =
          loadedData['products'] as List<Map<String, Object>>;
      products.forEach(
        (item) => cartItems.add(
          CartItem(
            quantity: item['quantity'],
            product: productsProvider.getProductById(
              item['prodId'],
            ),
          ),
        ),
      );
      final List<OrderItem> loadedOrders = [];
      loadedData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
              id: orderId,
              amount: orderData['amount'],
              date: DateTime.parse(orderData['date']),
              products: cartItems),
        );
      });
      items = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(double amount, List<CartItem> products) async {
    const url = 'https://shopapp-4bde7.firebaseio.com/orders.json';
    final date = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': amount,
            'date': date.toIso8601String(),
            'products': products
                .map((cp) => {
                      'pordId': cp.product.id,
                      'quantity': cp.quantity,
                    })
                .toList(),
          },
        ),
      );
      final OrderItem order = OrderItem(
          id: json.decode(response.body)['name'],
          amount: amount,
          products: products,
          date: date);
      items.insert(0, order);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products; //list of product + quantity
  final DateTime date;

  OrderItem({this.id, this.amount, this.products, this.date});
}
