import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/order_drawer.dart';

import '../provider/orders.dart';
import '../widgets/order_item.dart';
 class OrdersScreen extends StatefulWidget {
   static const routeName='/orders';
   // this widget does not need to be stateful now

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading=false;
  // var _isInit=true;
   @override
  // void didChangeDependencies() {
  //   if(_isInit){
  //     setState(() {
  //       _isLoading=true;
  //     });
  //     Provider.of<Orders>(context,listen:false).getAndSetOrders().then((value){
  //     setState(() {
  //       _isLoading=false;
  //     });
  //   });
  //   }
  //   _isInit=false;
  //   super.didChangeDependencies();
  // }

   @override
   Widget build(BuildContext context) {
     //final orderData=Provider.of<Orders>(context);
     return Scaffold(
       appBar: AppBar(title:Text('Your Orders!'),),
       drawer:AppDrawer(),
       body:FutureBuilder(future: Provider.of<Orders>(context,listen:false).getAndSetOrders(),
       builder: (ctx,dataSnapshot){
         if(dataSnapshot.connectionState==ConnectionState.waiting){
           return Center(child: CircularProgressIndicator());
         }
         if(dataSnapshot.error!=null){
           return Center(child: Text('An error occured'));
         }
         else{
           return Consumer<Orders>(
                        builder:(ctx,orderData,_)=> ListView.builder(
         itemCount: orderData.orders.length,
         
         itemBuilder:(ctx,i)=>OrderItemD(orderData.orders[i]),
        ),
           );
         }
       },),
       
       

        
       
     );
   }
}