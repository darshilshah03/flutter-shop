import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './items/product_item.dart';
import './providers/products.dart';

class ProductGrid extends StatelessWidget {

  final bool showFavourites;

  ProductGrid(this.showFavourites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavourites ? productsData.favourite : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemBuilder: (context,index) => ChangeNotifierProvider.value (
        value: products[index],
        child: ProductItem(
          // products[index].id, 
          // products[index].title,
          // products[index].imageUrl
        ),
      ),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/4,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
    );
  }
}