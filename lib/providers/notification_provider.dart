
import 'package:ecom_firebase_07/db/db_helper.dart';
import 'package:ecom_firebase_07/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier{
  List<NotificationModel> notificationList=[];

  getAllNotification(){
    DbHelper.getAllNotifications().listen((snapshot) {
      notificationList=List.generate(snapshot.docs.length, (index) => NotificationModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });

  }

 Future <void> updateNotificationStatus(String notificationId) {
    return DbHelper.updateNotificationStatus(notificationId);

  }

   int get totalUnreadMessage{
    int total=0;
    for(var notification in notificationList){
      if(!notification.status){
        total+=1;
      }
    }
    return total;

  }

}