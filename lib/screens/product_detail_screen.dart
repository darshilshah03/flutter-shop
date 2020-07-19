import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {

  // final String id;
  // final String title;

  // ProductDetailScreen(this.id,this.title);

  static const routeName = '/product-details-screen';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context,listen: false).findById(id);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            height: 400,
            width: double.infinity,
            child: Hero(
              tag: product.id,
              child: Image.network(product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20,),
          Text('\$ ${product.price}',style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 20,
          ),),
          SizedBox(height: 20,),
          Text('${product.description}',style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 17,
          ),)
        ],),
      ),
    );
  }
}