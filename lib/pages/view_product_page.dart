

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_firebase_07/models/category_model.dart';
import 'package:ecom_firebase_07/pages/product_details.dart';
import 'package:ecom_firebase_07/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName='/view_product';
  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  CategoryModel? categoryModel;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        title:Text('View Products'),
      ),

      body: Consumer<ProductProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<CategoryModel>(
                isExpanded: true,
                hint: const Text('Select Category'),
                value: categoryModel,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
                items: provider.filteringCategory()
                    .map((catModel) => DropdownMenuItem(
                  value: catModel,
                  child: Text(catModel.categoryName),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    categoryModel = value;
                  });
                  if(categoryModel!.categoryName == 'All') {
                    provider.getAllProducts();
                  } else {
                    provider.getAllProductsByCategory(categoryModel!.categoryName);
                  }
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: provider.productList.length,
                itemBuilder: (context, index) {
                  final product = provider.productList[index];
                  return ListTile(
                  onTap: (){
                    Navigator.pushNamed(context, ProductDetails.routeName, arguments:product);
                  },
                    leading: CachedNetworkImage(
                      width: 50,
                      imageUrl: product.thumbnailImageModel.imageDownloadUrl,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    title: Text(product.productName),
                    subtitle: Text(product.category.categoryName),
                    trailing: Text('Stock: ${product.stock}'),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
