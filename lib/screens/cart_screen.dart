import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../items/cart_item.dart' as ci;
import '../providers/order.dart';
import '../screens/orders_screen.dart';

class CartScreen extends StatelessWidget{

  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(children: <Widget>[
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              Text('Total',style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),),
              Spacer(),
              Chip(
                label: Text('\$ ${cart.totalAmount.toStringAsFixed(2)}',style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).accentColor,
                ),),
              ),
              PlaceOrder(cart: cart)
            ],),
          ),
        ),
        SizedBox(height: 20,),
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx,index) => ci.CartItem(
              cart.items.values.toList()[index].id,
              cart.items.keys.toList()[index],
              cart.items.values.toList()[index].price,
              cart.items.values.toList()[index].quantity,
              cart.items.values.toList()[index].title              
            ),
            itemCount: cart.itemCount,
          ),
        )
      ],),
    );
  }
}

class PlaceOrder extends StatefulWidget {
  const PlaceOrder({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: isLoading ? CircularProgressIndicator(backgroundColor: Colors.black,) :
       Text('Place Order',style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 18,
      )),
      onPressed:  (widget.cart.totalAmount<=0 || isLoading) ? null : () async {
        setState(() {
          isLoading = true;
        });
       await Provider.of<Order>(context,listen: false).addOrder(widget.cart.     items.values.toList(),widget.cart.totalAmount);
       setState(() {
         isLoading = false;
       });
        widget.cart.clearCart();
        Navigator.of(context).pushNamed(OrdersScreen.routeName );
      },
    );
  }
}