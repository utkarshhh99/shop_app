import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/order_drawer.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../provider/cart.dart';
import '../screens/cart_screen.dart';
import '../provider/products.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;
  var _isInit=true;
  var _isLoading=false;
   
  @override
  void didChangeDependencies() {



    if(_isInit){
      setState(() {
        _isLoading=true;
      });

    Provider.of<Products>(context).fetchAndGetProducts().then((value) {
      setState(() {
        _isLoading=false;
      });
    } );
    }
    _isInit=false;
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
              ),
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favourites) {
                    _showOnlyFavourites = true;
                  } else {
                    _showOnlyFavourites = false;
                  }
                });
              },
              itemBuilder: (_) {
                return [
                  PopupMenuItem(
                      child: Text('Show Favourites Only'),
                      value: FilterOptions.Favourites),
                  PopupMenuItem(
                      child: Text('Show All'), value: FilterOptions.All),
                ];
              }),
            Consumer<Cart>(builder: (_, cart, ch)=>Badge(
              child: ch,
              value: cart.itemCount.toString() ,
             ),
             child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
               Navigator.of(context).pushNamed(CartScreen.routeName);
             }),
            ),      
        ],
      ),
      drawer:AppDrawer(),
      body: _isLoading? Center(child:CircularProgressIndicator()) :ProductsGrid(_showOnlyFavourites),
    );
  }
}
