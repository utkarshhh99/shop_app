import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';
import '../provider/products.dart';
class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      description: null, id: null, imageUrl: null, price: null, title: null);
  var _initValues={
    'title':'',
    'description':'',
    'price':'',
    'imageurl':''
  };



  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
  var _isInit=true;
  var _isLoading=false;
  @override
  void didChangeDependencies() {
    if(_isInit){
      final productId=ModalRoute.of(context).settings.arguments as String;
      
      if(productId!=null){
        _editedProduct=Provider.of<Products>(context).findById(productId);
        _initValues={
          'title':_editedProduct.title,
          'description':_editedProduct.description,
          'price':_editedProduct.price.toString(),
          //'imageurl':_editedProduct.imageUrl,
          'imageurl':'',
        };
        _imageUrlController.text=_editedProduct.imageUrl;
      }
    
    }
    _isInit=false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if(_imageUrlController.text.isEmpty)setState(() {
        //empty
      });
      if( !_imageUrlController.text.startsWith('http')
      ||(!_imageUrlController.text.endsWith('.png')&&!_imageUrlController.text.endsWith('.jpg')))
        return;

                       
      setState(() {
        //empty
      });
    }
  }

  Future<void> _saveForm() async {
    final isValid=_form.currentState.validate();
    if(!isValid)
      return;
    _form.currentState.save();

    setState(() {
      _isLoading=true;
    });


      if(_editedProduct.id==null){
        try{
           await  Provider.of<Products>(context,listen:false).addProduct(_editedProduct);


        }catch(error){
           await showDialog(context: context,builder:(ctx)=>AlertDialog(
               title: Text('An error occured'),
               content: Text('Something went wrong'),
               actions: [
                 FlatButton(onPressed:(){Navigator.of(ctx).pop();}, child: Text('Okay'),)
               ],
             ));
          }
          // finally{
          //   setState(() {
          //    _isLoading=false;
          //  });
          //  Navigator.of(context).pop();
          // }
       }
      else{
        await Provider.of<Products>(context,listen:false).updateProduct(_editedProduct.id,_editedProduct);
       }
      setState(() {
             _isLoading=false;
        });
      Navigator.of(context).pop();


    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              })
        ],
      ),
      body:_isLoading?Center(
        child: CircularProgressIndicator(),
      ): Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          //autovalidate: true,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      description: _editedProduct.description,
                      id: _editedProduct.id,
                      isFavourite: _editedProduct.isFavourite,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      title: value
                      );
                },
                validator: (value){
                  if(value.isEmpty)
                    return 'Enter a title!';
                  else
                    return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      description: _editedProduct.description,
                      id: _editedProduct.id,
                      isFavourite: _editedProduct.isFavourite,
                      imageUrl: _editedProduct.imageUrl,
                      price: double.parse(value),
                      title: _editedProduct.title);
                },
                validator: (value){
                  if(value.isEmpty)
                    return 'Enter a amount!';
                  else if(double.tryParse(value)==null)
                    return 'Enter a valid price';
                  else if(double.parse(value)<1)
                    return 'Enter a price greater than 0';
                  else
                    return null;
                },

              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                //textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                      description: value,
                      id: _editedProduct.id,
                      isFavourite: _editedProduct.isFavourite,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      title: _editedProduct.title);
                },
                validator: (value){
                  if(value.isEmpty)
                    return 'Enter a description!';
                  else if(value.length<10)
                    return 'Should be atleast 10 characters long';
                  else
                    return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a Url')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      //initialValue: _initValues['imageurl'], we are using controller
                      decoration: InputDecoration(labelText: 'Image Url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                      _editedProduct = Product(
                      description: _editedProduct.description,
                      id: _editedProduct.id,
                      isFavourite: _editedProduct.isFavourite,
                      imageUrl: value,
                      price: _editedProduct.price,
                      title: _editedProduct.title);
                      },
                      validator: (value){
                        if(value.isEmpty)
                          return 'Enter a Image Url!';
                        if(!value.startsWith('http')||(!value.endsWith('.png')&&!value.endsWith('.jpg')))
                          return 'Enter a valid Image Url';

                        return null;
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
