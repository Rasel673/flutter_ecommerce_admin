

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_firebase_07/models/category_model.dart';
import 'package:ecom_firebase_07/models/comment_model.dart';
import 'package:ecom_firebase_07/models/notification_model.dart';
import 'package:ecom_firebase_07/models/order_constant_model.dart';
import 'package:ecom_firebase_07/models/order_model.dart';
import 'package:ecom_firebase_07/models/product_model.dart';
import 'package:ecom_firebase_07/models/purchase_model.dart';

class DbHelper {
  static const String collectionAdmin = 'Admins';
  static final _db = FirebaseFirestore.instance;

  static Future<bool> isAdmin(String uid) async {
    final snapshot = await _db.collection(collectionAdmin).doc(uid).get();
    return snapshot.exists;
  }


  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();
  static Future<void> addCategory(CategoryModel categoryModel) {
    final catDoc = _db.collection(collectionCategory).doc();
    categoryModel.categoryId = catDoc.id;
    return catDoc.set(categoryModel.toMap());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsByCategory(String categoryName) =>
      _db.collection(collectionProduct)
          .where('$productFieldCategory.$categoryFieldName', isEqualTo: categoryName)
          .snapshots();

  static Future<void> addNewProduct(ProductModel productModel, PurchaseModel purchaseModel){
    final productDoc=_db.collection(collectionProduct).doc();
    final purchaseDoc=_db.collection(collectionPurchase).doc();
    final catDoc = _db.collection(collectionCategory).doc(productModel.category.categoryId);
    productModel.productId=productDoc.id;
    purchaseModel.purchaseId=purchaseDoc.id;
    purchaseModel.productId=productDoc.id;
    final updateCount=purchaseModel.purchaseQuantity+productModel.category.productCount;
    final wb=_db.batch();
     wb.set(productDoc, productModel.toMap());
    wb.set(purchaseDoc, purchaseModel.toMap());
    wb.update(catDoc, {categoryFieldProductCount:updateCount});
    return wb.commit();

  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProduct).snapshots();


  // static Future<QuerySnapshot<Map<String, dynamic>>> getAllPurchasesByProductId(String productId) =>
  //     _db.collection(collectionPurchase)
  //         .where('$purchaseFieldProductId', isEqualTo: productId)
  //         .get();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPurchases() =>
      _db.collection(collectionPurchase)
          .snapshots();


  static Future<void> productRepurchases(PurchaseModel purchaseModel, ProductModel productModel) async{
      final wb=_db.batch();
      final purchaseDoc=_db.collection(collectionPurchase).doc();
      purchaseModel.purchaseId=purchaseDoc.id;
      wb.set(purchaseDoc, purchaseModel.toMap());
      final productDoc=_db.collection(collectionProduct).doc(productModel.productId);
      wb.update(productDoc,{productFieldStock:(productModel.stock+purchaseModel.purchaseQuantity)});
      final snapshot=await _db.collection(collectionCategory).doc(productModel.category.categoryId).get();
      final previousCount=snapshot.data()![categoryFieldProductCount];
      final catDoc=_db.collection(collectionCategory).doc(productModel.category.categoryId);
      wb.update(catDoc, {categoryFieldProductCount:(purchaseModel.purchaseQuantity+previousCount)});
      wb.commit();
  }

  static Future<void> productFieldUpdate(String productId,Map<String,dynamic> map){
        return _db.collection(collectionProduct).doc(productId).update(map);
      }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db.collection(collectionUtils).doc(documentOrderConstants).snapshots();


  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrders() =>
      _db.collection(collectionOrder).snapshots();

  static Future<void> updateOrderConstants(OrderConstantModel model) {
    return _db.collection(collectionUtils)
        .doc(documentOrderConstants)
        .update(model.toMap());
  }

  static Future<void> updateOrderStatus(String orderId,String status) {
    return _db.collection(collectionOrder)
        .doc(orderId)
        .update({orderFieldOrderStatus:status});
  }


  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllNotifications()=>
      _db.collection(collectionNotification).snapshots();

  static Future<void> updateNotificationStatus(String notificationId) {
   return _db.collection(collectionNotification).doc(notificationId).update({notificationFieldStatus:true});
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getCommentsByProduct(
      String proId) =>
      _db
          .collection(collectionProduct)
          .doc(proId)
          .collection(collectionComment)
          .get();



  static Future<void> updateCommentStatus(String productId,CommentModel comment) {
    return _db.collection(collectionProduct)
        .doc(productId)
        .collection(collectionComment)
        .doc(comment.commentId)
        .update({commentFieldApproved : true});
  }

}