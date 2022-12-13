
import 'dart:io';

import 'package:ecom_firebase_07/db/db_helper.dart';
import 'package:ecom_firebase_07/models/image_model.dart';
import 'package:ecom_firebase_07/models/product_model.dart';
import 'package:ecom_firebase_07/models/purchase_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../models/category_model.dart';
import '../utils/constant.dart';

class ProductProvider extends ChangeNotifier{
  List<CategoryModel> categorList=[];
  List<ProductModel> productList=[];
  List<PurchaseModel> purchaseList=[];

  Future<void> addCategory(String category){
      final categoryModel=CategoryModel(categoryName: category);
      return DbHelper.addCategory(categoryModel);
  }
  Future<void> addNewProduct(ProductModel productModel, PurchaseModel purchaseModel) async{
   return DbHelper.addNewProduct(productModel,purchaseModel);
  }


  getAllProducts(){
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) =>
          ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllCategoies(){
     DbHelper.getAllCategories().listen((snapshot) {
      categorList=List.generate(snapshot.docs.length, (index) =>CategoryModel.fromMap(snapshot.docs[index].data()));
      categorList.sort((model1,model2)=>model1.categoryName.compareTo(model2.categoryName));
      notifyListeners();
    });
  }
  getAllPurchases(){
    DbHelper.getAllPurchases().listen((snapshot) {
      purchaseList=List.generate(snapshot.docs.length, (index) =>
          PurchaseModel.fromMap(snapshot.docs[index].data())
      );
      notifyListeners();
    });
  }

  getAllProductsByCategory(String categoryName){
  DbHelper.getAllProductsByCategory(categoryName).listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) =>
          ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  // Future<List<PurchaseModel>> getAllPurchasesByProductId(String productId) async{
  //   final snapshot=await DbHelper.getAllPurchasesByProductId(productId);
  //   return List.generate(snapshot.docs.length, (index) => PurchaseModel.fromMap(snapshot.docs[index].data()));
  // }

  List<PurchaseModel> getAllPurchasesByProductId(String productId){
   return purchaseList.where((element) => element.productId==productId).toList();
  }


  Future<void> productRepurchses(PurchaseModel purchaseModel,ProductModel productModel) async{
    return DbHelper.productRepurchases(purchaseModel,productModel);
  }



  List<CategoryModel> filteringCategory(){
    return <CategoryModel>[
      CategoryModel(categoryName: 'All'),
      ...categorList
    ];
  }



  Future<ImageModel> uploadImage(String path ) async{
    final imageName = 'pro_${DateTime.now().millisecondsSinceEpoch}';
    final imageRef = FirebaseStorage
        .instance.ref()
        .child('$firebaseProductImageUpload/$imageName');
    final uploadTask = imageRef.putFile(File(path));
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return ImageModel(
      title: imageName,
      imageDownloadUrl: downloadUrl,
    );
  }

  double priceAfterDiscount(num salePrice, num productDiscount) {
    final discountPrice=(salePrice*productDiscount)/100;
    return salePrice-discountPrice;
  }

  Future<void> productFieldUpdate(String productId, String productField, dynamic value){
    return DbHelper.productFieldUpdate(productId,{productField:value});
  }

  Future<void> deleteImage(String url){
    return FirebaseStorage.instance.refFromURL(url).delete();
  }



}