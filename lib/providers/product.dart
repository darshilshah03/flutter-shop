import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite = false;
  

  Product({
    @required this.description,
    @required this.id,
    @required this.imageUrl,
    @required this.price,
    @required this.title,
    this.isFavourite = false
  });

  void toggleFavourite(String token,String userId) async{
    isFavourite = !isFavourite;
    
    final url = 'https://flutter-project-dbe14.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    await http.put(url,body: json.encode(
       isFavourite
    ));
    notifyListeners();
  }
}