import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../provider/orders.dart';

class OrderItemD extends StatefulWidget {
  final OrderItem order;
  OrderItemD(this.order);

  @override
  _OrderItemDState createState() => _OrderItemDState();
}

class _OrderItemDState extends State<OrderItemD> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: _expanded?min(widget.order.products.length * 20.0 + 110, 200):95,
          child: Card(
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('\$${widget.order.amount}'),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy  hh:mm').format(widget.order.dateTime),
                ),
                trailing: IconButton(
                    icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    }),
              ),
              //if (_expanded)
                AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical:4,horizontal:15),
                    height:  _expanded?min(widget.order.products.length * 20.0 + 10, 100):0,
                    child: ListView(
                        children: widget.order.products
                            .map((e) => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(e.title,style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                    Text('${e.quantity}x  \$${e.price}',style:TextStyle(color:Colors.grey,fontSize: 18),),
                                  ],
                                ))
                            .toList()))
            ],
          )),
    );
  }
}
