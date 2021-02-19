import 'package:flutter/foundation.dart';

class CartItem{
  final String id;
  final int quantity;
  final String title;
  final double price;
  CartItem({
    @required this.id,
    @required this.price,
    @required this.title,
    @required this.quantity,
  });
}


class Cart with ChangeNotifier{
  Map<String,CartItem> _items={};
  Map<String,CartItem> get items{
    return {..._items};
  }
  void addItem(String productId,String title,double amount){
    if(_items.containsKey(productId)){
      _items.update(productId, (value) => CartItem(id: value.id,price: value.price,title: value.title,quantity: value.quantity+1),);
    }
    else{
      _items.putIfAbsent(productId, () => CartItem(id: DateTime.now().toString(), price: amount, title: title, quantity: 1),);
    }
    notifyListeners();
  }
  int get itemCount{
    return   _items.length;
  }
  double get totalAmount{
    var total=0.0;
    _items.forEach((key, value){total+=value.quantity*value.price;});
    return total;
  }
  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }
  void clear(){
    _items={};
    notifyListeners();
  }
  void removeSingleItem(String productId){
    if(!_items.containsKey(productId))
      return;
      if(_items[productId].quantity>1){
        _items.update(productId, (value) => 
        CartItem(id: value.id, price: value.price, title: value.title, quantity: value.quantity-1)
        );
      }
      else{
        _items.remove(productId);
      }
      notifyListeners();

  }
}