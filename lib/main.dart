
import 'package:ecom_firebase_07/pages/add_product_page.dart';
import 'package:ecom_firebase_07/pages/category_page.dart';
import 'package:ecom_firebase_07/pages/dashboard.dart';
import 'package:ecom_firebase_07/pages/launcher.dart';
import 'package:ecom_firebase_07/pages/login.dart';
import 'package:ecom_firebase_07/pages/notification_page.dart';
import 'package:ecom_firebase_07/pages/order_details.dart';
import 'package:ecom_firebase_07/pages/order_page.dart';
import 'package:ecom_firebase_07/pages/product_details.dart';
import 'package:ecom_firebase_07/pages/product_repurchase_page.dart';
import 'package:ecom_firebase_07/pages/report_page.dart';
import 'package:ecom_firebase_07/pages/settings_page.dart';
import 'package:ecom_firebase_07/pages/user_list_page.dart';
import 'package:ecom_firebase_07/pages/view_product_page.dart';
import 'package:ecom_firebase_07/providers/notification_provider.dart';
import 'package:ecom_firebase_07/providers/order_provider.dart';
import 'package:ecom_firebase_07/providers/product_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers:[
      ChangeNotifierProvider(create: (_)=>ProductProvider()),
      ChangeNotifierProvider(create: (_)=>OrderProvider()),
      ChangeNotifierProvider(create: (_)=>NotificationProvider()),
    ],

      child:const MyApp(),
    )
     
  
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.s
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner:false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
     builder:EasyLoading.init(),
     initialRoute:Dashboard.routeName,
     routes: {
        Dashboard.routeName:(_)=>Dashboard(),
       Launcher.routeName:(_)=>Launcher(),
       AddProductPage.routeName:(_)=>AddProductPage(),
       CategoryPage.routeName:(_)=>CategoryPage(),
       OrderPage.routeName:(_)=>OrderPage(),
       OrderDetails.routeName:(_)=>OrderDetails(),
       ReportPage.routeName:(_)=>ReportPage(),
       SettingsPage.routeName:(_)=>SettingsPage(),
       UserListPage.routeName:(_)=>UserListPage(),
       ViewProductPage.routeName:(_)=>ViewProductPage(),
       LoginPage.routeName:(_)=>LoginPage(),
       ProductDetails.routeName:(_)=>ProductDetails(),
       ProductRepurchase.routeName:(_)=>ProductRepurchase(),
       NotificationPage.routeName:(_)=>NotificationPage(),
     },
    );
  }
}


