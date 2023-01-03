import 'package:ecom_firebase_07/pages/order_details.dart';
import 'package:ecom_firebase_07/providers/order_provider.dart';
import 'package:ecom_firebase_07/utils/constant.dart';
import 'package:ecom_firebase_07/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class OrderPage extends StatelessWidget {
  static const String routeName='/orders';
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const  Text('Orders'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context,provider,child)=>ListView.builder(
          itemCount: provider.orderList.length,
          itemBuilder: (context,index){
            final order=provider.orderList[index];
            return ListTile(
              onTap: (){
                Navigator.pushNamed(context, OrderDetails.routeName, arguments: order.orderId);
              },
              title: Text(getFormatedDate(order.orderDate.timestamp.toDate(),pattern:'dd/MM/yyyy')),
              subtitle: Text(order.orderStatus),
              trailing: Text('$currencySymbol${order.grandTotal}'),
            );
          },
        ),
      ),
    );
  }
}
