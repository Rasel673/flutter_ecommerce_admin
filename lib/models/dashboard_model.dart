

import 'package:ecom_firebase_07/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:ecom_firebase_07/pages/add_product_page.dart';
import 'package:ecom_firebase_07/pages/category_page.dart';
import 'package:ecom_firebase_07/pages/order_page.dart';
import 'package:ecom_firebase_07/pages/report_page.dart';
import 'package:ecom_firebase_07/pages/settings_page.dart';
import 'package:ecom_firebase_07/pages/user_list_page.dart';

import '../pages/view_product_page.dart';
class DashboardModel {
  final String title;
  final IconData iconData;
  final String routeName;

  const DashboardModel({
    required this.title,
    required this.iconData,
    required this.routeName,
  });
}

const List<DashboardModel>dashboardModelList = [
  DashboardModel(title: 'Add Product', iconData: Icons.add, routeName: AddProductPage.routeName),
  DashboardModel(title: 'View Product', iconData: Icons.card_giftcard, routeName: ViewProductPage.routeName),
  DashboardModel(title: 'Categories', iconData: Icons.category, routeName: CategoryPage.routeName),
  DashboardModel(title: 'Orders', iconData: Icons.monetization_on, routeName: OrderPage.routeName),
  DashboardModel(title: 'Users', iconData: Icons.person, routeName: UserListPage.routeName),
  DashboardModel(title: 'Settings', iconData: Icons.settings, routeName: SettingsPage.routeName),
  DashboardModel(title: 'Report', iconData: Icons.pie_chart, routeName: ReportPage.routeName),
  DashboardModel(title: 'Notification', iconData: Icons.notifications_active, routeName: NotificationPage.routeName),
];