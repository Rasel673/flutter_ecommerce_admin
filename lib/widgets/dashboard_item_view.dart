

import 'package:ecom_firebase_07/models/dashboard_model.dart';
import 'package:flutter/material.dart';

class DashboardItemView extends StatelessWidget {
  final DashboardModel dashboardModel;
  Widget? bubble;
DashboardItemView({Key? key, required this.dashboardModel,this.bubble}) : super(key: key);

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
              Stack(
                children: [
                  Icon(dashboardModel.iconData,size:50,color:Theme.of(context).primaryColor,),
                  if(bubble!=null) Positioned(
                    bottom: 10,
                      right: 5,
                      child: bubble!)
                ],
              ),
              const SizedBox(height:10 ,),
              Text(dashboardModel.title,style:Theme.of(context).textTheme.headline6,),
            ],
          ),
        ),
      ),
    );;
  }
}
