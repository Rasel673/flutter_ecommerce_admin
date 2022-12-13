
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecom_firebase_07/models/category_model.dart';
import 'package:ecom_firebase_07/models/date_model.dart';
import 'package:ecom_firebase_07/models/product_model.dart';
import 'package:ecom_firebase_07/models/purchase_model.dart';
import 'package:ecom_firebase_07/providers/product_provider.dart';
import 'package:ecom_firebase_07/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  static const String routeName='/add_product';
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}
class _AddProductPageState extends State<AddProductPage> {
  CategoryModel? category;
  final _formkey=GlobalKey<FormState>();
  final _nameController=TextEditingController();
  final _shortdiscriptionController=TextEditingController();
  final _longdiscriptionController=TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _salePriceController=TextEditingController();
  final _stock=TextEditingController();
  final _discountController=TextEditingController();
  DateTime? purchaseDate;
  String? thumbnail;
  ImageSource _imageSource=ImageSource.gallery;
  late ProductProvider _productProvider;
  bool _isConnected=true;
  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {

    isConnectedToInternet().then((value){
      setState(() {
        _isConnected=value;
      });
    });

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.wifi || result==ConnectivityResult.mobile){
        setState(() {
          _isConnected=true;
        });
      }
    });
    super.initState();
  }
  @override
  void didChangeDependencies() {
    _productProvider=Provider.of<ProductProvider>(context,listen:false);
    super.didChangeDependencies();
  }
  @override
  void dispose() {
   _nameController.dispose();
   _shortdiscriptionController.dispose();
   _longdiscriptionController.dispose();
   _salePriceController.dispose();
   _purchasePriceController.dispose();
   _stock.dispose();
   _discountController.dispose();

   subscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('Add New Product'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(onPressed:_onSave,icon:Icon(Icons.save,size:40),),
          )
        ],
      ),
      body: Form(
        key: _formkey,
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical:10.0),
          child: ListView(
            children: [
              if(!_isConnected)
                ListTile(
                  title:Text('No internet !! ',style:TextStyle(color:Colors.white),),
                  tileColor:Colors.black,),

              Consumer<ProductProvider>(builder:(context,provider,child)=>

            DropdownButtonFormField<CategoryModel>(
              isExpanded:true,
              decoration:InputDecoration(
                border:OutlineInputBorder(),
                labelText:'Category'
              ),
              hint:Text('Select Categoy'),
                validator:(value){
                if(value==null){
                  return 'Please select category';
                }
                return null;
                },
                items:provider.categorList.map((categoryModel) =>DropdownMenuItem(
                  value:categoryModel,
                    child: Text(categoryModel.categoryName) )).toList() ,
                value:category,
                onChanged: (value){
              setState(() {
                category=value;
              });
      })
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration:InputDecoration(
                    border:OutlineInputBorder(),
                    hintText: 'Enter Product Name',
                    labelText:'Product Name'
                  ),
                  keyboardType:TextInputType.text,
                  validator:(value){
                    if(value==null || value.isEmpty){
                      return 'This field can not be empty';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0),
                child: TextFormField(
                  controller: _shortdiscriptionController,
                  maxLines: 2,
                  decoration:InputDecoration(
                    border:OutlineInputBorder(),
                    hintText: 'Enter Short discription',
                    labelText:'Short discription'
                  ),
                  keyboardType:TextInputType.text,
                  validator:(value){
                    if(value==null || value.isEmpty){
                      return null;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0),
                child: TextFormField(
                  controller: _longdiscriptionController,
                  maxLines:3,
                  decoration:InputDecoration(
                    border:OutlineInputBorder(),
                    hintText: 'Enter long discription',
                    labelText:'Long discription',
                  ),
                  keyboardType:TextInputType.text,
                  validator:(value){
                    if(value==null || value.isEmpty){
                      return null;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0),
                child: TextFormField(
                  controller: _salePriceController,
                  decoration:InputDecoration(
                    filled:true,
                      border:OutlineInputBorder(),
                      hintText: 'Enter Product Sale Price',
                      labelText:'Sale Price'

                  ),
                  keyboardType:TextInputType.number,
                  validator:(value){
                    if(value==null || value.isEmpty){
                      return 'This field can not be empty';
                    }
                    if (num.parse(value!) <= 0) {
                      return 'Price should be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0),
                child: TextFormField(
                  controller: _purchasePriceController,
                  decoration:InputDecoration(
                    filled:true,
                      border:OutlineInputBorder(),
                      hintText: 'Enter Product Purchase Price',
                      labelText:'Sale Price'

                  ),
                  keyboardType:TextInputType.number,
                  validator:(value){
                    if(value==null || value.isEmpty){
                      return 'This field can not be empty';
                    }
                    if (num.parse(value!) <= 0) {
                      return 'Price should be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0),
                child: TextFormField(
                  controller: _stock,
                  decoration:InputDecoration(
                    filled:true,
                      border:OutlineInputBorder(),
                      hintText: 'Enter Product Quantity',
                      labelText:'Stock'

                  ),
                  keyboardType:TextInputType.number,
                  validator:(value){
                    if(value==null || value.isEmpty){
                      return 'This field can not be empty';
                    }
                    if (num.parse(value!) <= 0) {
                      return 'Price should be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0),
                child: TextFormField(
                  controller: _discountController,
                  decoration:InputDecoration(
                    filled:true,
                      border:OutlineInputBorder(),
                      hintText: 'Enter discount ',
                      labelText:'Discount(%)'

                  ),
                  keyboardType:TextInputType.number,
                  validator:(value){
                    if(value==null || value.isEmpty){
                      return 'This field can not be empty';
                    }
                    if (num.parse(value!) <= 0) {
                      return 'Price should be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    TextButton.icon(onPressed:_selectDate, label:Text('Select Purchase Date') , icon:Icon(Icons.calendar_month),),
                    Text(purchaseDate!=null?getFormatedDate(purchaseDate!):'No Date chosen')
                  ],
                ),
              ),
            Card(
              child:Column(
                children: [
                  Card(child:thumbnail==null?
                  Icon(Icons.image,size:100,):Image.file(File(thumbnail!),width:100,height:100,fit:BoxFit.cover,)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        TextButton.icon(onPressed: (){
                          _imageSource=ImageSource.camera;
                          _getImage();
                        },label: Text('Camera'),icon: Icon(Icons.camera), ),
                        TextButton.icon(onPressed: (){
                          _imageSource=ImageSource.gallery;
                          _getImage();
                        },label: Text('Gallery'),icon: Icon(Icons.photo_album), ),

                    ],
                  )
                ],
              ),
            )
              
            ],
          ),
        ),
      ),
    );
  }

  _selectDate() async{
    final date=await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year-1),
        lastDate:DateTime.now());
    if(date!=null){
      setState(() {
        purchaseDate=date;
      });
    }
  }

  void _getImage() async{
    final pickedImage=await ImagePicker().pickImage(source: _imageSource,imageQuality:70);
    if(pickedImage!=null){
      setState(() {
        thumbnail=pickedImage.path;
      });
    }
  }

  void _reset(){
    setState(() {
      _nameController.clear();
      _shortdiscriptionController.clear();
      _longdiscriptionController.clear();
      _salePriceController.clear();
      _purchasePriceController.clear();
      _stock.clear();
      _discountController.clear();
      purchaseDate=null;
      thumbnail=null;
      category=null;
    });

  }

  void _onSave() async{
    if(thumbnail==null){
      return showMsg(context, 'Image Should Be Upload');
    }
    if(purchaseDate==null){
      return showMsg(context, 'Date Should Be Select');
    }

    if(_formkey.currentState!.validate()){

      EasyLoading.show(status: 'please wait');
      try{
        final imagModel= await _productProvider.uploadImage(thumbnail!);
        final productModel=ProductModel(
            productName:_nameController.text ,
            category: category!,
            shortDescription:_shortdiscriptionController.text.isEmpty?null:_shortdiscriptionController.text,
            longDescription:_longdiscriptionController.text.isEmpty?null:_longdiscriptionController.text,
            salePrice: num.parse(_salePriceController.text),
            stock:  num.parse(_stock.text),
            productDiscount:_discountController.text.isEmpty?0:num.parse(_discountController.text),
            thumbnailImageModel:imagModel,
            additionalImageModels: ['','','']);
        final purchaseModel=PurchaseModel(
          purchaseQuantity: num.parse(_stock.text),
          purchasePrice: num.parse(_purchasePriceController.text),
          dateModel:DateModel(
              timestamp:Timestamp.fromDate(purchaseDate!),
              day: purchaseDate!.day,
              month: purchaseDate!.month,
              year: purchaseDate!.year),
        );
        await _productProvider.addNewProduct(productModel,purchaseModel);
        EasyLoading.dismiss();
        if(mounted){
          showMsg(context, 'Saved');
        }
      }catch(error){
        EasyLoading.dismiss();
        showMsg(context, 'Please Check your internet Connection');
        print(error);
        throw error;
      }
      _reset();
    }

  }
}
