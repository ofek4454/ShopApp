import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import './Cart.dart';
import './products_provider.dart';
import './product.dart';

class Orders with ChangeNotifier {
  List<OrderItem> items = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this.items);

  List<OrderItem> get orders {
    return [...items];
  }

  Future<void> loadOrders(BuildContext context) async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    print('load orders');
    final url =
        'https://shopapp-4bde7.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      print('done load orders');
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      if (loadedData == null) {
        return;
      }
      loadedData.forEach((key, value) {
        final List<CartItem> cartItems = [];
        final List<dynamic> products = loadedData[key]['products'];
        for (int i = 0; i < products.length; i++) {
          print(productsProvider.getProductById(products[i]['prodId']));
          if (productsProvider.getProductById(products[i]['prodId']) != null) {
            cartItems.add(
              CartItem(
                quantity: products[i]['quantity'],
                product: productsProvider.getProductById(
                  products[i]['prodId'],
                ),
              ),
            );
          } else {
            cartItems.add(
              CartItem(
                quantity: products[i]['quantity'],
                product: Product(
                  id: products[i]['prodId'],
                  title: 'unKnown',
                  description: 'unKnown',
                  imageUrl:
                      'https://cdn3.iconfinder.com/data/icons/ui-ux-essentials-solid/24/help-solid-512.png',
                  price: 0,
                ),
              ),
            );
          }
        }
        loadedOrders.insert(
            0,
            OrderItem(
              id: key,
              amount: value['amount'],
              date: DateTime.parse(value['date']),
              products: cartItems,
            ));
      });
      items = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(double amount, List<CartItem> products) async {
    final url =
        'https://shopapp-4bde7.firebaseio.com/orders/$userId.json?auth=$authToken';
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
                      'prodId': cp.product.id,
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
