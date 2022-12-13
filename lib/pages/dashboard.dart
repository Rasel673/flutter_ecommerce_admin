
import 'package:ecom_firebase_07/auth/auth_service.dart';
import 'package:ecom_firebase_07/models/dashboard_model.dart';
import 'package:ecom_firebase_07/pages/launcher.dart';
import 'package:ecom_firebase_07/providers/product_provider.dart';
import 'package:ecom_firebase_07/widgets/dashboard_item_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  static const String routeName='/dashboard';
   Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context).getAllCategoies();
    Provider.of<ProductProvider>(context).getAllProducts();
    Provider.of<ProductProvider>(context).getAllPurchases();

    return Scaffold(
      appBar:AppBar(
        title:Text('Dashboard'),
        actions: [
          IconButton(onPressed:(){
            AuthService.logout().then((value){
              Navigator.pushReplacementNamed(context, Launcher.routeName);
            });
          }, icon: Icon(Icons.logout))
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal:10,vertical:10),
        child: GridView.builder(gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: MediaQuery.of(context).size.width>600? 3:2,
        ),

            itemCount:dashboardModelList.length,
            itemBuilder:(context,index)=> DashboardItemView(dashboardModel: dashboardModelList[index])
        ),
      ) ,
    );
  }
}
