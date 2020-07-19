import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  OrderItem({
    this.amount,
    this.date,
    this.id,
    this.products
  });

}

class Order with ChangeNotifier{
  List<OrderItem> _orders = [];

  final String authToken;
  final String userId;

  Order(this.authToken,this.userId,this._orders);

  List<OrderItem> get order{
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> products,double total) async
  {
    final url = 'https://flutter-project-dbe14.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final res = await http.post(url,body: json.encode(
      {
        'amount' : total,
        'date' : timeStamp.toIso8601String(),
        'products' : products.map((pro)=>{
          'id' : pro.id,
          'title' : pro.title,
          'quantity' : pro.quantity,
          'price' : pro.price
        }).toList(),
      } 
    ));
    _orders.insert(0,
      OrderItem(
        id: json.decode(res.body)['name'],
        amount: total,
        date: timeStamp,
        products: products
      )
    );

    notifyListeners();
  }

  Future<void> fetchOrders () async {
    final url = 'https://flutter-project-dbe14.firebaseio.com/orders/$userId.json?auth=$authToken';
    final res = await http.get(url);
    final List<OrderItem> loadedProducts = [];
    print(json.decode(res.body));
    final extractedData = json.decode(res.body) as Map<String, dynamic> ;
    if(extractedData==null)
        return;
    extractedData.forEach((key,value){
      loadedProducts.add(
        OrderItem(
          id : key,
          amount: value['amount'],
          date: DateTime.parse(value['date']),
          products: (value['products'] as List<dynamic>).map((pro) => 
            CartItem(
              id : pro['id'],
              price: pro['price'],
              quantity: pro['quantity'],
              title: pro['title'],
            ),
          ).toList(),
        )
      );
      
    });

    _orders = loadedProducts.reversed.toList();
    notifyListeners();
  }
}

