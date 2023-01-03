
import 'package:ecom_firebase_07/auth/auth_service.dart';
import 'package:ecom_firebase_07/models/dashboard_model.dart';
import 'package:ecom_firebase_07/pages/launcher.dart';
import 'package:ecom_firebase_07/providers/notification_provider.dart';
import 'package:ecom_firebase_07/widgets/cart_bubble.dart';
import 'package:ecom_firebase_07/widgets/dashboard_item_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecom_firebase_07/providers/order_provider.dart';
import 'package:ecom_firebase_07/providers/product_provider.dart';

class Dashboard extends StatelessWidget {
  static const String routeName='/dashboard';
 const   Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context,listen:false).getAllCategoies();
    Provider.of<ProductProvider>(context,listen:false).getAllProducts();
    Provider.of<ProductProvider>(context,listen:false).getAllPurchases();
    Provider.of<OrderProvider>(context,listen:false).getOrder();
    Provider.of<OrderProvider>(context,listen:false).getOrderConstants();
    Provider.of<NotificationProvider>(context).getAllNotification();

    return Scaffold(
      appBar:AppBar(
        title:const Text('Dashboard'),
        actions: [
          IconButton(onPressed:(){
            AuthService.logout().then((value){
              Navigator.pushReplacementNamed(context, Launcher.routeName);
            });
          }, icon:const  Icon(Icons.logout))
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal:10,vertical:10),
        child: GridView.builder(gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: MediaQuery.of(context).size.width>600? 3:2,
        ),

            itemCount:dashboardModelList.length,
            itemBuilder:(context,index){
              final dashModel=dashboardModelList[index];
              if(dashModel.title=='Notification'){
                final count = Provider.of<NotificationProvider>(context).totalUnreadMessage;
                if(count>0) {
                 return DashboardItemView(dashboardModel: dashModel,bubble:CartBubble(count:count),);
                }
              }
              return DashboardItemView(dashboardModel: dashModel);
            }
        ),
      ) ,
    );
  }
}
