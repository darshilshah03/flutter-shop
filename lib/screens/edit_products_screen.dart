import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductsScreen extends StatefulWidget {

  static const routeName = '/edit-products';
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {

  final focusNode = FocusNode();
  final descFocusNode = FocusNode();
  final imageController = TextEditingController();
  final imageFocus = FocusNode();
  final form = GlobalKey<FormState>();
  var editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: ''
  );
  var initValues = {
    'title' : '',
    'description' : '',
    'price' : '',
    'imageUrl' : ''
  };
  bool isDep = true;
  var isLoading = false;

  @override
  void initState() {
    imageFocus.addListener(updateListner);
    super.initState();
  } 

  @override
  void didChangeDependencies() {
    if(isDep){
      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId != null)
      {
        editedProduct = Provider.of<Products>(context,listen:false).findById(productId);
        initValues = {
          'title' : editedProduct.title,
          'description' : editedProduct.description,
          'price' : editedProduct.price.toString(),
          'imageUrl' : '',
        };
        imageController.text = editedProduct.imageUrl;
      }
    }
    isDep = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    imageFocus.removeListener(updateListner);
    focusNode.dispose();
    descFocusNode.dispose();
    imageController.dispose();
    super.dispose();
  }

  void updateListner()
  {
    if(!imageFocus.hasFocus)
    {
      setState(() {
        
      });
    }
  }

  Future<void> saveForm() async {
    
    final isValid = form.currentState.validate();
    if(!isValid)
      return;
    form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if(editedProduct.id == null){
      try{
         await Provider.of<Products>(context,listen: false).addProducrs(editedProduct);
      }
      catch(error) {
        showDialog(
          context : context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured'),
            content: Text('Something went wrong'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          )
        );
      }
      finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
        print('after pop');
      }  
    }
    else{
       await Provider.of<Products>(context,listen: false).updateProduct(editedProduct.id,editedProduct);
       setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveForm,
          )
        ],
      ),
      body: isLoading ? 
      Center(
        child: CircularProgressIndicator(),
      ) :
       Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          margin: EdgeInsets.only(left:30,right:30,top:30 ),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0,
            child: Container(
              
              height: 400,
              alignment: Alignment.topCenter,
              child: Form(
              key: form,
              child: ListView(
                children: <Widget>[ 
                TextFormField(
                  initialValue: initValues['title'],
                  style: TextStyle(
                    color: Theme.of(context).primaryColor
                  ),
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Title', 
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor
                    ),
                    
                  ),
                  textInputAction : TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(focusNode);
                  },
                  validator: (value) {
                    if(value.isEmpty)
                      return 'Must be filled';
                    return null;
                  },
                  onSaved: (value) {
                    editedProduct = Product(
                      description: editedProduct.description,
                      id: editedProduct.id,
                      isFavourite : editedProduct.isFavourite,
                      imageUrl: editedProduct.imageUrl,
                      price: editedProduct.price,
                      title: value
                    );
                  },
                ),
                TextFormField(
                  initialValue: initValues['price'],
                  style: TextStyle(
                    color: Theme.of(context).primaryColor
                  ),
                  decoration: InputDecoration(
                    labelText: 'Price', 
                    fillColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  focusNode: focusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(descFocusNode);
                  },
                  textInputAction : TextInputAction.next,
                  validator: (value) {
                    if(value.isEmpty)
                      return 'enter a number.';
                    if(double.tryParse(value)== null)
                      return 'Enter a valid number';
                    if(double.parse(value)<0)
                      return 'Enter A value > 0';
                    return null;
                  },
                  onSaved: (value) {
                    editedProduct = Product(
                      description: editedProduct.description,
                      id: editedProduct.id,
                      isFavourite : editedProduct.isFavourite,
                      imageUrl: editedProduct.imageUrl,
                      price: double.parse(value),
                      title: editedProduct.title
                    );
                  },
                ),
                TextFormField(
                  initialValue: initValues['description'],
                  style: TextStyle(
                    color: Theme.of(context).primaryColor
                  ),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description', 
                    fillColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  focusNode: descFocusNode,
                  validator: (value) {
                    if(value.isEmpty) {
                      return 'Please enter a description';
                    
                    }
                    if(value.length < 10)
                      return 'LEngth should be atleat 10';
                    return null;
                  },
                  onSaved: (value) {
                    editedProduct = Product(
                      description: value,
                      id: editedProduct.id,
                      isFavourite : editedProduct.isFavourite,
                      imageUrl: editedProduct.imageUrl,
                      price: editedProduct.price,
                      title: editedProduct.title
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width :2,
                        color: Colors.black54
                      ),
                    ),
                    child: imageController.text.isEmpty ? 
                      Text('Enter a URL',style: TextStyle(
                        
                        color: Theme.of(context).primaryColor
                      ),) : 
                      FittedBox(
                        child: Image.network(imageController.text),
                        fit: BoxFit.cover,
                      )
                    
                  ),
                  Expanded(
                      child: TextFormField(
                      
                      style: TextStyle(
                        color: Theme.of(context).primaryColor
                      ),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor
                        ),
                        labelText: 'Image URL', 
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: imageController,
                      focusNode: imageFocus,
                      onFieldSubmitted: (_) {
                        saveForm();
                      },
                      validator: (value) {
                        if(value.isEmpty)
                          return 'Enter a URL';
                        if(!value.startsWith('http') && !value.startsWith('https'))
                        {
                          return 'Enter a valid url';
                
                        }
                        return null;
                      },
                      onSaved: (value) {
                    editedProduct = Product(
                      description: editedProduct.description,
                     id: editedProduct.id,
                      isFavourite : editedProduct.isFavourite,
                      imageUrl: value,
                      price: editedProduct.price,
                      title: editedProduct.title
                    );
                  },
                    ),
                  )
                ],)
              ],),
          ),
            ),
        ),
      ),
    );
  }
}