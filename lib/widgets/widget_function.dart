import 'package:flutter/material.dart';
showSingleInputDailog({
  required String title,
  String positive='ok',
  String negative='close',
required Function(String) onSubmit,
required  BuildContext context
}){
final txtController=TextEditingController();

showDialog(context: context, builder: (context)=>AlertDialog(
  title:Text(title),
  content:Padding(
    padding:EdgeInsets.all(20),
    child:TextField(
      controller: txtController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText:'Enter $title',
      ),
    ),
  ),
  actions: [
    TextButton(onPressed: ()=>Navigator.pop(context), child:Text(negative)),
    TextButton(onPressed: (){
      if(txtController.text.isEmpty) return;
      onSubmit(txtController.text);
      Navigator.pop(context);
    }, child:Text(positive)),
  ],
));


}