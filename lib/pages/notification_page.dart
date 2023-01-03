
import 'package:ecom_firebase_07/models/notification_model.dart';
import 'package:ecom_firebase_07/pages/order_details.dart';
import 'package:ecom_firebase_07/pages/product_details.dart';
import 'package:ecom_firebase_07/pages/user_list_page.dart';
import 'package:ecom_firebase_07/providers/notification_provider.dart';
import 'package:ecom_firebase_07/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  static const String routeName='/notifications';
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const Text('Notification List'),
      ),
      body:Consumer<NotificationProvider>(
        builder: (context,provider,child){
          final notificationList=provider.notificationList;
          return ListView.builder(
            itemCount:notificationList.length,
            itemBuilder: (context,index){
              final notification=notificationList[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  onTap: (){
                    _navigate(context,provider,notification);
                  },
                  tileColor:notification.status?null:Colors.grey.withOpacity(.5),
                  title: Text(notification.type),
                  subtitle: Text(notification.message),
                ),
              );
            }
          );
        },
      ),
    );
  }

  void _navigate(BuildContext context, NotificationProvider provider, NotificationModel notification) {
    String id='';
    String routeName='';
    switch(notification.type){
      case NotificationType.user:
        routeName=UserListPage.routeName;
        id=notification.userModel!.userId!;
        break;
      case NotificationType.order:
        routeName=OrderDetails.routeName;
        id=notification.orderModel!.orderId;
        break;

      case NotificationType.comment:
        routeName=ProductDetails.routeName;
        id=notification.commentModel!.productId;
        break;
    }

    provider.updateNotificationStatus(notification.notificationId);
    Navigator.pushNamed(context, routeName,arguments: id);

  }
}
