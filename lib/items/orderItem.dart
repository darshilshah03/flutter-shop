import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import '../providers/order.dart' as ord;

class OrderItem extends StatefulWidget {
  
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: expanded ? min(widget.order.products.length*20.0 + 110, 200) : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(children: <Widget>[
          ListTile(
            title: Text('\$ ${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
            trailing: IconButton(
              icon: Icon(expanded ?  Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.all(15),
            height: expanded ? min(widget.order.products.length*20.0 + 10,100) : 0,
            child: ListView(children: widget.order.products.map((pro) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
              Text('${pro.title}',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                //color: Theme.of(context).accentColor
              ),),
              Text('${pro.quantity} x \$ ${pro.price}',style: TextStyle(
               // color: Theme.of(context).accentColor,
                fontSize: 15
              ),),
              SizedBox(height: 10,)
            ],)).toList(),),
          
          ),
        ],),
      ),
    );
  }
}