

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_firebase_07/models/comment_model.dart';
import 'package:ecom_firebase_07/models/product_model.dart';
import 'package:ecom_firebase_07/pages/product_repurchase_page.dart';
import 'package:ecom_firebase_07/providers/product_provider.dart';
import 'package:ecom_firebase_07/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../utils/constant.dart';
import '../widgets/photo_Frame_View.dart';

class ProductDetails extends StatefulWidget {
  static const String routeName='/product-details';
  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late ProductModel productModel;
  late ProductProvider productProvider;

    @override
  void didChangeDependencies() {
      productProvider=Provider.of<ProductProvider>(context);
      final object=ModalRoute.of(context)!.settings.arguments;
      if(object is String){
        productModel=productProvider.getSingleProductFromCache(object);
      }else{
        productModel=object as ProductModel;
      }



    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        title:Text(productModel.productName),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            height:180,
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: productModel.thumbnailImageModel.imageDownloadUrl,
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(
            height:80,
              width:double.infinity,
              child: Card(
                  child:Row(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      PhotoFrameView(
                        onImagePressed: (){
                          _showImageDialog(0);
                        },
                        url: productModel.additionalImageModels[0],
                        child:IconButton(onPressed: (){
                          _addImage(0);
                        }, icon: const Icon(Icons.add)),),
                      PhotoFrameView(
                        onImagePressed: (){
                          _showImageDialog(1);
                        },
                        url: productModel.additionalImageModels[1],
                        child:IconButton(onPressed: (){
                          _addImage(1);
                        }, icon: const Icon(Icons.add)),),
                      PhotoFrameView(
                        onImagePressed: (){
                          _showImageDialog(0);
                        },
                        url: productModel.additionalImageModels[2],
                        child:IconButton(onPressed: (){
                          _addImage(2);
                        }, icon: const Icon(Icons.add)),),


              ],
                  )
              )
          ),
          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: (){
                    _showPurchases(productModel);
              }, child:const Text('Purchase History')),
              const SizedBox(width:10,),
              OutlinedButton(onPressed: (){
                Navigator.pushNamed(context, ProductRepurchase.routeName, arguments:productModel);
              }, child:const Text('Repurchase')),
            ],
          ),
          ListTile(
            title:Text(productModel.productName),
            subtitle:Text(productModel.category.categoryName),
          ),
          ListTile(
            title:Text('$currencySymbol ${productModel.salePrice}'),
            subtitle:Text('Discount: ${productModel.productDiscount}%'),
            trailing:Text('$currencySymbol ${productProvider.priceAfterDiscount(productModel.salePrice,productModel.productDiscount)}'),
          ),
          SwitchListTile(value: productModel.available, onChanged:(value){
            setState(() {
              productModel.available=!productModel.available;
            });
            productProvider.productFieldUpdate(productModel.productId!, productFieldAvailable, productModel.available);
          },
           title:const  Text('Available'),
          ),
          SwitchListTile(value: productModel.featured, onChanged:(value){
            setState(() {
              productModel.featured=!productModel.featured;
            });
            productProvider.productFieldUpdate(productModel.productId!, productFieldFeatured, productModel.featured);
          },
            title:const Text('Featured'),
          ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child:Text('All Comments',style:Theme.of(context).textTheme.headline5,),
          ),
          FutureBuilder(
              future: productProvider.getAllCommentsByProductId(productModel.productId!),
              builder:(context,snapshot){
                if(snapshot.hasData){
                  final commentList=snapshot.data!;
                  if(commentList.isEmpty){
                    return const Center(child:Text('No Comments Yet'),);
                  }else{
                    return Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children:commentList.map((comment) =>ListTile(
                        leading: comment.userModel.userPhotoUrl==null? const Icon(Icons.person):CachedNetworkImage(
                          height:50,
                          width:50,
                          fit: BoxFit.cover,
                          imageUrl:comment.userModel.userPhotoUrl!,
                          placeholder: (context, url) =>const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>const  Icon(Icons.error),
                        ),
                        title: Text(comment.userModel.displayName?? comment.userModel.email),
                        subtitle: Text(comment.comment),
                        trailing:Column(
                          children: [
                            Text(comment.date),
                            Expanded(
                              child: OutlinedButton(onPressed: comment.approved?null:(){
                                EasyLoading.show(status: 'please Wait');
                                _approveComment(comment);
                                EasyLoading.dismiss();
                                showMsg(context, 'Updated');
                              }, child:const Text('Approved')),
                            )
                          ],
                        ) ,
                      )).toList(),
                    );
                  }
                }
                if(snapshot.hasError){
                }
                return const Center(child:Text('Loading...'),);
              })
        ],
      ),
    );
  }

  void _showPurchases(ProductModel productModel) {
    showModalBottomSheet(
        context: context,
        builder: (context){
          final purchaseList=productProvider.getAllPurchasesByProductId(productModel.productId!);
      return ListView.builder(
          itemCount: purchaseList.length,
          itemBuilder: (context, index)
          {
            final purchase = purchaseList[index];
            return ListTile(
              title: Text(getFormatedDate(purchase.dateModel.timestamp.toDate())),
              subtitle: Text('BDT: ${purchase.purchasePrice}'),
              trailing: Text('Quantity: ${purchase.purchaseQuantity}'),
            );
          });
    }
    );
  }



  void _approveComment(CommentModel commentModel) async {
    EasyLoading.show(status: 'Please wait');
    await productProvider.approveComment(productModel.productId!, commentModel);
    EasyLoading.dismiss();
    showMsg(context, 'Comment Approved');
    setState(() {

    });
  }

  void _addImage(int index) async{

        final selectImage= await ImagePicker().pickImage(source: ImageSource.gallery);
        if(selectImage!=null){
          EasyLoading.show(status: 'please Wait');
          try{
            final imageModel= await productProvider.uploadImage(selectImage.path);
            final previousImageList=productModel.additionalImageModels;
            previousImageList[index]=imageModel.imageDownloadUrl;
            await productProvider.productFieldUpdate(productModel.productId!, productFieldImages, productModel.additionalImageModels)
                .then((value){
                  setState(() {
                    productModel.additionalImageModels[index]=imageModel.imageDownloadUrl;
                  });
              EasyLoading.dismiss();

              showMsg(context, 'Image Uploaded Successfull');
            }).catchError((error){
              EasyLoading.dismiss();
              showMsg(context, 'Upload Failed');
            });
          }catch(error){
            EasyLoading.dismiss();
            showMsg(context, 'Select Image or Check Internet Connection');

          }


      }

  }

  void _showImageDialog(int index) {
    final url = productModel.additionalImageModels[index];
      showDialog(context: context, builder:(context)=>AlertDialog(
        content:CachedNetworkImage(
          height:MediaQuery.of(context).size.height/2,
          fit: BoxFit.cover,
          imageUrl:url,
          placeholder: (context, url) =>const  Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>const  Icon(Icons.error),
        ),
        actions: [
          TextButton(onPressed:() async{
            Navigator.pop(context);
            setState(() {
              productModel.additionalImageModels[index]='';
            });
            EasyLoading.show(status: 'Deleting...');
            try{
              await productProvider.deleteImage(url);
              await productProvider.productFieldUpdate(productModel.productId!, productFieldImages, productModel.additionalImageModels).then((value){
                EasyLoading.dismiss();
                if(mounted) showMsg(context, 'Deleted');
              });

            }catch(error){
              EasyLoading.dismiss();
              showMsg(context, 'Delte Failed');
            }
          }, child:const  Text('Delete')),

          TextButton(onPressed:() async{



          }, child:const  Text('Change')),
        ],
      ),
      );
  }
}
