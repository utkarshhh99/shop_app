import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier{
  final String id;
  final String imageUrl;
  bool isFavourite;
  final String description;
  final double price;
  final String title;

  Product({
    @required this.description,
     @required this.id,
    @required this.imageUrl,
    this.isFavourite=false,
    @required this.price,
     @required this.title,
  });
 Future<void> toggleFavouriteStatus(String token,String userId) async{
   var _oldStatus=isFavourite;
   isFavourite = !isFavourite;
   notifyListeners();
    final url ='https://shopapp1-8b039.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    
    try{
      final response= await http.put(url,body:json.encode(
      isFavourite,
      
      ));
      if(response.statusCode>=400){
        isFavourite=_oldStatus;
        notifyListeners();
      }
    }catch(error){
      isFavourite=_oldStatus;
      notifyListeners();
    }
   




 }


}