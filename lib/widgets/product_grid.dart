import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid(this.showFavs);


  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =   showFavs?productsData.favouriteItems:productsData.items;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        itemBuilder: (ctx, i) {
          return ChangeNotifierProvider.value(
            //create: (c)=>products[i],
            value: products[i],
            child: ProductItem(
            // id: products[i].id,
            // imageUrl: products[i].imageUrl,
            // title: products[i].title,
          ));
        });
  }
}
