
import 'package:ecom_firebase_07/models/order_model.dart';
import 'package:ecom_firebase_07/providers/order_provider.dart';
import 'package:ecom_firebase_07/utils/constant.dart';
import 'package:ecom_firebase_07/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatelessWidget {
  static const String routeName='/order_details';
  const OrderDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderProvider=Provider.of<OrderProvider>(context);
    final orderId=ModalRoute.of(context)!.settings.arguments as String;
    final orderModel=orderProvider.getSingleOrder(orderId);

    return Scaffold(
      appBar:AppBar(
        title:Text(orderId),
      ),

      body: ListView(
        padding: const EdgeInsets.all(9),
        children: [
          buildHeader('Product Info'),
          buildProduct(orderModel),
          buildHeader('Order Summary'),
          buildOrder(orderModel),
          buildHeader('Update Status'),
          buildStatus(orderModel,orderProvider)
        ],
      ),
    );
  }

  Padding buildHeader(String header) {
    return Padding(padding: const EdgeInsets.all(8.0),
      child: Text(
        header,
        style: const TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget buildProduct(OrderModel orderModel) {
    return Card(
      child:Padding(
        padding: EdgeInsets.all(8),
        child: Column(
            children: orderModel.productDetails.map((cartProduct) =>ListTile(
              title: Text(cartProduct.productName),
              trailing: Text('${cartProduct.quantity}x$currencySymbol${cartProduct.salePrice}'),
            ) ).toList()
        ),
      ),
    );
  }

  Widget buildOrder(OrderModel orderModel) {
    return Card(
      child: Padding(padding: EdgeInsets.all(8),
        child:Column(
          children: [
            ListTile(
              title:const Text('Discount'),
              trailing: Text('$currencySymbol${orderModel.discount}'),
            ),
            ListTile(
              title: const Text('Vat'),
              trailing: Text('$currencySymbol${orderModel.VAT}'),
            ),
            ListTile(
              title: const Text('Delivery Charge)'),
              trailing: Text('$currencySymbol${orderModel.deliveryCharge}'),
            ),
            const Divider(height:4,color:Colors.black,),
            ListTile(
              title:const  Text('Grand Total',style:TextStyle(fontWeight: FontWeight.bold),),
              trailing: Text('$currencySymbol${orderModel.grandTotal}',style:const TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatus(OrderModel orderModel, OrderProvider orderProvider) {
    ValueNotifier<String> orderGroupStatus=ValueNotifier(orderModel.orderStatus);
    ValueNotifier<bool> updateStatus=ValueNotifier(true);
    return Card(
      child: Padding(padding:const EdgeInsets.all(8),
        child: Column(
          children: [
            buildValueListenableBuilder(orderGroupStatus, updateStatus, orderModel,orderStatus.pending),
            buildValueListenableBuilder(orderGroupStatus, updateStatus, orderModel,orderStatus.processing),
            buildValueListenableBuilder(orderGroupStatus, updateStatus, orderModel,orderStatus.delivered),
            buildValueListenableBuilder(orderGroupStatus, updateStatus, orderModel,orderStatus.cencelled),
            buildValueListenableBuilder(orderGroupStatus, updateStatus, orderModel,orderStatus.returned),
           ValueListenableBuilder<bool>(
             valueListenable:updateStatus,
             builder:(context,value,child)=> ElevatedButton(
          onPressed:value ? null:(){
            EasyLoading.show(status: 'Updating');
            try{
              orderProvider.updateOrderStatus(orderModel.orderId, orderGroupStatus.value);
              EasyLoading.dismiss();
              showMsg(context, 'Updated');
            }catch(error){
              EasyLoading.dismiss();
              showMsg(context, 'Failed to Update');
            }

          },
          child: const Text('Update'),
        ),
           )
          ],
        ),
      ),
    );
  }

  ValueListenableBuilder<String> buildValueListenableBuilder(ValueNotifier<String> orderGroupStatus, ValueNotifier<bool> updateStatus, OrderModel orderModel,String radioValue) {
    return ValueListenableBuilder<String>(
            valueListenable:orderGroupStatus,
            builder:(context,value,child)=> Row(
              children: [
                Radio<String>(value: radioValue, groupValue:value, onChanged:(value){
                  orderGroupStatus.value=value!;
                  updateStatus.value=isEnabled(orderModel,orderGroupStatus.value);
                },),
                Text(radioValue),
              ],
            ),
          );
  }

  bool isEnabled(OrderModel orderModel, String groupValue){
    return orderModel.orderStatus==groupValue;
  }



}

