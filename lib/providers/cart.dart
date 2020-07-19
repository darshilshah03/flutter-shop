import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    this.id,
    this.price,
    this.quantity,
    this.title
  });

}

class Cart with ChangeNotifier{
  Map <String ,CartItem> _items = {};
  
  Map<String,CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key,item) {
      total += item.quantity*item.price; 
    });
    return total;
  }

  void addItem(String title,double price,String productId, {int quantity = 1})
  {
    if(_items.containsKey(productId))
    {
      _items.update(productId, (previous) => CartItem(
        id: previous.id,
        price: previous.price,
        quantity: previous.quantity+1,
        title: previous.title
      ));
    }
    else{
      _items.putIfAbsent(productId, () => CartItem(
        id : DateTime.now().toString(),
        price: price,
        quantity: quantity,
        title: title
      ));
    }

    notifyListeners();
  }

  void removeItem(String id)
  {
    _items.remove(id);
    notifyListeners();
  }

  void clearCart()
  {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String id)
  {
    if(!_items.containsKey(id))
      return;
    if(_items[id].quantity>1)
    {
      _items.update(id, (previous) => CartItem(
        id: previous.id,
        price: previous.price,
        quantity: previous.quantity-1,
        title: previous.title
      ));
    }
    else{
      _items.remove(id);
    }
    notifyListeners();
  }
}