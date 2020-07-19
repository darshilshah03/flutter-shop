import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {

  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id,this.productId,this.price,this.quantity,this.title);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context,listen: false);
    
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete,
          color: Colors.white,
          size: 35,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical : 4,
        ),
        
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context : context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure ? '),
            content: Text('Do you want to remove the item from the cart?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
            ],
          )
        ); 
      },
      onDismissed: (direction) {
         showDialog(
            context : context,
            builder: (ctx) => AlertDialog(
              title: Text('Do you want to remove all the items'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Remove all'),
                  onPressed: () {
                    cart.removeItem(productId);
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  child: Text('Remove single item'),
                  onPressed: () {
                    cart.removeSingleItem(productId);
                    String t = cart.items[productId].title;
                    double p = cart.items[productId].price;
                    int q = cart.items[productId].quantity;
                    cart.removeItem(productId);
                    cart.addItem(t, p, productId,quantity: q);
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            )
          );
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical : 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              radius: 35,
              child: Text('\$ $price'),
            ),
            title: Text(title),
            subtitle: Text('Total \$ ${price*quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}