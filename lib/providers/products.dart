
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier{
  bool done = false;
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final String authToken;
  final String userId;

  Products(this.authToken,this.userId,this._items);

  List<Product> get items {
    return [..._items];
  } 

  List<Product> get favourite {
    return _items.where((pro) => pro.isFavourite).toList();
  }

  Future<void> fetchProducts([bool filter = false]) async {
    var filterString = filter? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://flutter-project-dbe14.firebaseio.com/products.json?auth=$authToken&$filterString';
    try{
      final res = await http.get(url);
      final List<Product> loadedProducts = [];
      final extractedProducts = json.decode(res.body) as Map<String,dynamic> ;
      if(extractedProducts==null)
        return;
      url = 'https://flutter-project-dbe14.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final res2 = await http.get(url);
      final extractedFav = json.decode(res2.body);
      extractedProducts.forEach((key,value) {
        loadedProducts.add(Product(
          id:key,
          description: value['description'],
          imageUrl: value['imageUrl'],
          price: value['price'],
          title: value['title'],
          isFavourite:  extractedFav == null ? false : extractedFav[key] ?? false,
        )
        );
      });
      _items = loadedProducts;
      notifyListeners();
    }
    catch(error) {
      throw error;
    }
  }

  Future<void> addProducrs(Product product) async {
    final url = 'https://flutter-project-dbe14.firebaseio.com/products.json?auth=$authToken';
    try {
      final res = await http.post(url,body : json.encode({
      'title' : product.title,
      'description' : product.description,
      'imageUrl' : product.imageUrl,
      'price' : product.price,
      'isFavourite' : product.isFavourite,
      'creatorId' : userId
    }),);
        final newProduct = Product( 
          description: product.description,
          id: json.decode(res.body)['name'],
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title,
          
        );
        _items.add(newProduct);
        print(json.decode(res.body)['name']);
        notifyListeners();
    }
    catch (error) {
      throw error;
    }    
  }

  Product findById(String id)
  {
    return items.firstWhere((pro) => pro.id == id );
  }

  Future<void> updateProduct(String id,Product newProduct) async
  {
    final index = _items.indexWhere((prod) => prod.id == id);
    final url = 'https://flutter-project-dbe14.firebaseio.com/products/$id.json?auth=$authToken';
    final res = await http.patch(url,body:json.encode({
      'title' : newProduct.title,
      'description' : newProduct.description,
      'imageUrl' : newProduct.imageUrl,
      'price' : newProduct.price,
    }
    ));
      _items[index] = newProduct;
      notifyListeners();
    
      print('.....');
 
  }

  Future<void> deleteProduct(String id) async
  {
    final url = 'https://flutter-project-dbe14.firebaseio.com/products/$id.json';
    final res = await http.delete(url);
    var index = _items.indexWhere((prod) => prod.id == id);
    var pro = _items[index];
    _items.removeWhere((prod) => prod.id==id);
    notifyListeners();
    if(res.statusCode>=400)
    {
      _items.insert(index, pro);
      notifyListeners();
      throw HttpException('There was an error in delete');
    }
    pro = null;

  }

}