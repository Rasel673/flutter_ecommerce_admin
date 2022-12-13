
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../models/date_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../providers/product_provider.dart';
import '../utils/helper_functions.dart';

class ProductRepurchase extends StatefulWidget {
  static const String routeName='/product-repurchase';
  const ProductRepurchase({Key? key}) : super(key: key);

  @override
  State<ProductRepurchase> createState() => _ProductRepurchaseState();
}

class _ProductRepurchaseState extends State<ProductRepurchase> {
  final _formkey=GlobalKey<FormState>();
  final _purchasePriceController = TextEditingController();
  final _stock=TextEditingController();
  DateTime? purchaseDate;
  late ProductModel productModel;
  late ProductProvider productProvider;

  @override
  void didChangeDependencies() {
    productModel=ModalRoute.of(context)!.settings.arguments as ProductModel;
    productProvider=Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _purchasePriceController.dispose();
    _stock.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('Repurchase'),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Text(productModel.productName,style:Theme.of(context).textTheme.headline6,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0),
                child: TextFormField(
                  controller: _purchasePriceController,
                  decoration:InputDecoration(
                      filled:true,
                      border:OutlineInputBorder(),
                      hintText: 'Enter Product Purchase Price',
                      labelText:'Purchase Price'

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
                      labelText:'Quantity'

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
              OutlinedButton(onPressed:_repurchase, child:Text('Save'))
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
  void _reset(){
    setState(() {
      _purchasePriceController.clear();
      _stock.clear();
      purchaseDate=null;

    });

  }

  void _repurchase() async{
    if(purchaseDate==null){
      return showMsg(context, 'Date Should Be Select');
    }
    if(_formkey.currentState!.validate()){
      EasyLoading.show(status: 'please wait');
      try{
        final purchaseModel=PurchaseModel(
          purchaseQuantity: num.parse(_stock.text),
          purchasePrice: num.parse(_purchasePriceController.text),
          dateModel:DateModel(
              timestamp:Timestamp.fromDate(purchaseDate!),
              day: purchaseDate!.day,
              month: purchaseDate!.month,
              year: purchaseDate!.year),
        );
        await productProvider.productRepurchses(purchaseModel,productModel).then((value){
          EasyLoading.dismiss();
          Navigator.pop(context);
          showMsg(context, 'Saved');
        }).catchError((error){
          EasyLoading.dismiss();
          showMsg(context, 'Failed to Save');
        });
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
