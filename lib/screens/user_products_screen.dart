import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_products_screen.dart';
import '../widgets/order_drawer.dart';
import '../provider/products.dart';
import '../widgets/user_product_items.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName='/user-products';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context,listen:false).fetchAndGetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productData=Provider.of<Products>(context);   to avoid infinite loop use consumer below
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            )
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
                  future: _refreshProducts(context),
                  builder:(ctx,snapshot)=> snapshot.connectionState==ConnectionState.waiting?Center(child:CircularProgressIndicator())
                   :RefreshIndicator(
                    onRefresh: (){
                      return _refreshProducts(context);
                    },
                    child: Consumer<Products>(
                builder:(ctx,productData,_)=> Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount:productData.items.length,
                  
                  itemBuilder: (_,i)=>Column(
                      children: [
                        UserProductItem( id: productData.items[i].id ,title: productData.items[i].title,imageUrl: productData.items[i].imageUrl,),
                        Divider(),
                      ],
                  ),
                )),
                    ),
          ),
        ));
  }
}
