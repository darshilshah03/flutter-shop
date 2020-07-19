import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart';
import '../items/orderItem.dart' as ord ;
import '../app_drawer.dart';

class OrdersScreen extends StatefulWidget {

  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var isLoading = false;
  @override
  void initState() {
    
    Future.delayed(Duration.zero).then((_) async{
      setState(() {
      isLoading =true;
    });
      await Provider.of<Order>(context,listen: false).fetchOrders();
      setState(() {
      isLoading =false;
    });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : ListView.builder(
        itemBuilder : (ctx,index) => ord.OrderItem(orderData.order[index]),
        itemCount: orderData.order.length,
      ),
    );
  }
}