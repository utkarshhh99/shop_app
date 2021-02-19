import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';

class CartItemD extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  CartItemD({this.price,this.productId,this.quantity,this.id,this.title});
  @override
  Widget build(BuildContext context) {
    //print('run');
    return Dismissible(
        key: ValueKey(id),
        background: Container(
          color:Theme.of(context).errorColor,
          child: Icon(Icons.delete,size:40,color:Colors.white),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right:20),
          margin: EdgeInsets.symmetric(horizontal: 15,vertical:4),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction){
          return showDialog(context: context,
          builder:(ctx)=>AlertDialog(
            title:Text('Are you sure?'),
            content: Text('Do you want to remove this item from cart?'),
            actions: [
              FlatButton(onPressed: (){Navigator.of(ctx).pop(true);}, child: Text('Yes')),
              FlatButton(onPressed: (){Navigator.of(ctx).pop(false);}, child: Text('No')),
            ],
          ),
          
          
          );
        },


        onDismissed: (direction){
            Provider.of<Cart>(context,listen:false).removeItem(productId);
        },
        child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical:4),
        child: Padding(
          padding:EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child:Padding(padding:EdgeInsets.all(5),child: FittedBox(child: Text('\$$price'))),
              ),
            title:Text(title),
            subtitle: Text('\$${(quantity*price)}'),
            trailing: Text('$quantity x'),
            
          ),
        ),
      ),
    );
  }
}