import 'package:flutter/material.dart';
import './screens/user_products_screen.dart';
import './providers/auth.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        AppBar(
          title: Text('Hello!'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop,
          color: Theme.of(context).accentColor,
          ),
          title: Text('Shop',style: TextStyle(
            color: Theme.of(context).accentColor
          ),),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Divider(
          color: Colors.white60,
        ),
        ListTile(
          leading: Icon(Icons.payment,color: Theme.of(context).accentColor,),
          title: Text('Orders',style: TextStyle(
            color: Theme.of(context).accentColor
          ),),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/orders');
          },
        ),
        Divider(
          color: Colors.white60,
        ),
        ListTile(
          leading: Icon(Icons.edit,color: Theme.of(context).accentColor,),
          title: Text('Your products',style: TextStyle(
            color: Theme.of(context).accentColor
          ),),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
          },
        ),
        Divider(
          color: Colors.white60,
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app,color: Theme.of(context).accentColor,),
          title: Text('Logout',style: TextStyle(
            color: Theme.of(context).accentColor
          ),),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context,listen: false).logout();
          },
        )
      ],),
    );
  }
}