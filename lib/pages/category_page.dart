import 'package:ecom_firebase_07/widgets/widget_function.dart';
import 'package:flutter/material.dart';
import'package:provider/provider.dart';

import '../providers/product_provider.dart';
class CategoryPage extends StatelessWidget {
  static const String routeName='/category';
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 Provider.of<ProductProvider>(context,listen:false).getAllCategoies();
    return Scaffold(
      appBar:AppBar(
        title: Text('Categories'),
      ),
      floatingActionButton:FloatingActionButton(
        onPressed: () {
          showSingleInputDailog(title: 'Add New Category', onSubmit: (categoy){
            Provider.of<ProductProvider>(context,listen: false).addCategory(categoy);
          }, context: context);
        },
        child: Icon(Icons.add),
      ),
      body: Consumer<ProductProvider>(
        builder: (context,provider,child)=>ListView.builder(
          itemCount:provider.categorList.length,
          itemBuilder: (context,index){
            final catModel=provider.categorList[index];
            return ListTile(
              title:Text(catModel.categoryName),
              trailing:Text('Total:${catModel.productCount}'),
            );
          },

        ),
      ),
    );
  }
}