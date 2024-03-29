
import 'package:ecom_firebase_07/models/order_constant_model.dart';
import 'package:ecom_firebase_07/models/order_model.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';

class OrderProvider extends ChangeNotifier{
OrderConstantModel orderConstantModel=OrderConstantModel();

List<OrderModel> orderList=[];

OrderModel getSingleOrder(String orderId){
  return orderList.firstWhere((element) => element.orderId==orderId);
}

getOrder(){
  DbHelper.getAllOrders().listen((snapshot) {
    orderList=List.generate(snapshot.docs.length, (index) => OrderModel.fromMap(snapshot.docs[index].data()));
    notifyListeners();
  });

}
getOrderConstants() {
  DbHelper.getOrderConstants().listen((snapshot) {
    if(snapshot.exists) {
      orderConstantModel = OrderConstantModel.fromMap(snapshot.data()!);
      notifyListeners();
    }
  });
}

Future<void> updateOrderConstants(OrderConstantModel model) {
  return DbHelper.updateOrderConstants(model);
}

Future<void> updateOrderStatus(String orderId,String status) {
  return DbHelper.updateOrderStatus(orderId,status);
}

}