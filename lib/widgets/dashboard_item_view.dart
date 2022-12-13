

import 'package:ecom_firebase_07/models/dashboard_model.dart';
import 'package:flutter/material.dart';

class DashboardItemView extends StatelessWidget {
  final DashboardModel dashboardModel;
const DashboardItemView({Key? key, required this.dashboardModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context,dashboardModel.routeName );
      },
      child: Card(
        child:Center(
          child:Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(dashboardModel.iconData,size:40,color:Theme.of(context).primaryColor,),
              const SizedBox(height:10 ,),
              Text(dashboardModel.title,style:Theme.of(context).textTheme.headline6,)
            ],
          ),
        ),
      ),
    );;
  }
}
