import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../items/user_product_item.dart';
import '../app_drawer.dart';
import './edit_products_screen.dart';

class UserProductsScreen extends StatelessWidget {

  static const routeName = '/user-products'; 

  Future<void> refresh(BuildContext context) async {
    await Provider.of<Products>(context,listen: false).fetchProducts(true);
  }
  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
            future: refresh(context),
            builder: (ctx,snapshot) => snapshot.connectionState == ConnectionState.waiting ? 
            Center(child: CircularProgressIndicator(),)
            : RefreshIndicator(
            onRefresh: () => refresh(context),
            child: Consumer<Products>(

              builder: (ctx,productsData,_) => Padding(
              padding: EdgeInsets.all(15),
              child: ListView.builder(
                itemBuilder: (context,index) {
                  return Column(
                    children: <Widget>[
                      UserProductItem(
                        productsData.items[index].id,
                        productsData.items[index].title,
                        productsData.items[index].imageUrl,
                        productsData.deleteProduct,
                      ),
                      Divider(
                        color: Colors.white60,
                      )
                    ],
                  );
                },
                itemCount: productsData.items.length,
              ),
          ),
            ),
        ),
      ),
    );
  }
}