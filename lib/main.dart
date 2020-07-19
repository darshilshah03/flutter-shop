import 'package:flutter/material.dart';
import './screens/auth_screen.dart';
import 'package:provider/provider.dart';
import './screens/products_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/order.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_products_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers : [
      ChangeNotifierProvider.value(
        value: Auth(),
      ),
      ChangeNotifierProxyProvider<Auth,Products>(
        update: (ctx,auth,previousProducts) => Products(auth.token,auth.userId, previousProducts== null ? [] : previousProducts.items),
      ),
      ChangeNotifierProvider.value(
        value : Cart()
      ),
      ChangeNotifierProxyProvider<Auth,Order>(
        update: (ctx,auth,previousOrder) => Order(auth.token,auth.userId,previousOrder == null ? [] : previousOrder.order),
      ),
      ],
      child: Consumer<Auth> (
        builder: (ctx,auth,_) =>  MaterialApp(
      
        title: 'Shop App',
        theme: ThemeData(
          canvasColor: Colors.black,
          primarySwatch: Colors.cyan,
          accentColor: Colors.white,
          hintColor: Colors.white
        ),
        
        routes: {
          ProductDetailScreen.routeName : (ctx) =>  ProductDetailScreen(),
          CartScreen.routeName : (ctx) => CartScreen(),
          OrdersScreen.routeName : (ctx) => OrdersScreen(),
          UserProductsScreen.routeName : (ctx) => UserProductsScreen(),
          EditProductsScreen.routeName : (ctx) => EditProductsScreen(),
        },
        home:auth.isAuthenticated ? ProductsScreen() : FutureBuilder(
          future: auth.autoLogin(),
          builder: (ctx,snapshot) => snapshot.connectionState == ConnectionState.waiting? 
          SplashScreen()
          : AuthScreen(),
        ),
      ),
      )
    );
  }
}
