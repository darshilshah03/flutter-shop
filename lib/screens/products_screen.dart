import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../product_grid.dart';
import '../providers/cart.dart';
import '../badge.dart';
import '../screens/cart_screen.dart';
import '../app_drawer.dart';
import '../providers/products.dart';

class ProductsScreen extends StatefulWidget {
  
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  var showFavourites = false;
  var isLoading = false;
  var isInit = true;

  // @override
  // void initState() {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   Future.delayed(Duration.zero).then((_) async{
  //     try{
  //         await Provider.of<Products>(context,listen: false).fetchProducts();
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //     catch(error)
  //     {
  //       print( error.toString());
  //     }
  //   });
  //   super.initState();
  // }

  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (int value) {
              setState(() {
                if(value == 0)
                  showFavourites = false;
                else
                  showFavourites = true;
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Show All '),value: 0,),
              PopupMenuItem(child: Text('Show Favourites'),value: 1),
            ],
          ),
          Consumer<Cart>(
            builder: (_,cart,_c) => Badge(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CartScreen.routeName,
                  );
                },
                icon: Icon(Icons.shopping_cart),
              ),
              value: cart.itemCount.toString(),

            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading ? 
      Center(
        child: CircularProgressIndicator(),
      ) :
      ProductGrid(showFavourites),
    );
  }
}

