import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  //var _showFavouritesOnly=false;
  final String authToken;
  final String userId;
  Products(this.authToken,this.userId,this._items);

  List<Product> get items {
    //if(_showFavouritesOnly==true)return _items.where((element) => element.isFavourite==true).toList();
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((element) => element.isFavourite == true).toList();
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://shopapp1-8b039.firebaseio.com/products.json?auth=$authToken';
    try {
      final value = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId':userId,
            
          }));

      print(json.decode(value.body));
      var newProduct = Product(
          description: product.description,
          id: json.decode(value.body)['name'],
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title);
      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndGetProducts([bool filterByUser =false]) async {
    var filterString=filterByUser?'orderBy="creatorId"&equalTo="$userId"':'';
    var url = 'https://shopapp1-8b039.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData==null)return;
      url='https://shopapp1-8b039.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final favouriteResponse=await http.get(url);
      final favouriteData=json.decode(favouriteResponse.body);
      print(json.decode(favouriteResponse.body));
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            description: prodData['description'],
            id: prodId,
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            title: prodData['title'],
            isFavourite: favouriteData==null?false:favouriteData[prodId]?? false,));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {print(error);}
  }

  Future<void> updateProduct(String productId, Product product) async {
    var prodIndex = _items.indexWhere((element) => element.id == productId);
    if (prodIndex >= 0) {
      final url =
          'https://shopapp1-8b039.firebaseio.com/products/$productId.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
    }
    _items[prodIndex] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://shopapp1-8b039.firebaseio.com/products/$id.json?auth=$authToken';
    final prodIndex = _items.indexWhere((element) => element.id == id);
    var existingProd = _items.elementAt(prodIndex);
    _items.removeAt(prodIndex);
    notifyListeners();
    final response= await http.delete(url);
    if(response.statusCode>=400){                   //400 is a  error code
        _items.insert(prodIndex, existingProd);
        notifyListeners();
        throw HttpException('Could not delete message');
      }
    existingProd = null;
  }

  Product findById(String id) {
    return _items.firstWhere((ind) => ind.id == id);
  }

  // void showFavouritesOnly(){
  //     _showFavouritesOnly=true;
  //     notifyListeners();
  // }
  // void showAll(){
  //   _showFavouritesOnly=false;
  //   notifyListeners();
  // }

}
