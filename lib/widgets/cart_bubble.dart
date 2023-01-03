

import 'package:flutter/material.dart';
class CartBubble extends StatelessWidget {

  final int  count;
  const CartBubble({Key? key,required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        alignment:Alignment.center,
        height: 30,
        width: 30,
        decoration:const BoxDecoration(
            color:Colors.red,
            shape:BoxShape.circle
        ),
        child: FittedBox(child:
        Text('$count')
        ),
      ),
    );

  }
}
