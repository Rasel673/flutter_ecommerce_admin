
import 'package:ecom_firebase_07/models/order_constant_model.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';

class OrderProvider extends ChangeNotifier{
OrderConstantModel orderConstantModel=OrderConstantModel();

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
}