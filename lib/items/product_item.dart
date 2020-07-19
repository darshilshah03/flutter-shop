import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id,this.title,this.imageUrl);
  
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    final auth = Provider.of<Auth>(context);
    print(product.id);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            return Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: Image.network(product.imageUrl,
            fit: BoxFit.cover,  
      ),
          ),
        ),
      footer: GridTileBar(
        backgroundColor: Colors.redAccent ,
        leading: IconButton(
          color: Theme.of(context).primaryColor,
          icon: Icon(product.isFavourite? Icons.favorite : Icons.favorite_border),
          onPressed: () {
            product.toggleFavourite(auth.token,auth.userId);
          },
        ),
        title : Text(product.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color : Colors.black
          ),
        ),
        trailing: IconButton(
          color: Theme.of(context).primaryColor,
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            cart.addItem(
              product.title,
              product.price,
              product.id
            );
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Item added to cart!'),
              duration: Duration(seconds: 2),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  cart.removeSingleItem(product.id);
                },
              ),
            ));
          },
        ),
      ),
      ),
    );
  }
}