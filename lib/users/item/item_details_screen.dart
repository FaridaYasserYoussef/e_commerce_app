import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/cart/cart_list_screen.dart';
import 'package:clothes_app/users/controllers/item_details_controller.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/clothes.dart';
import '../model/user.dart';
import '../userPreferences/user_preferences.dart';

class ItemDetailsScreen extends StatefulWidget {

  final Clothes? itemInfo;
  ItemDetailsScreen({this.itemInfo});
  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
   final itemDetailsController = Get.put(ItemDetailsController());
   final currentOnlineUser = Get.put(CurrentUser());




   getItemFromFavorite() async{

     try{

       var res = await http.post(
           Uri.parse(API.getItemFromFavorite),
           body: {
             "user_id" : currentOnlineUser.user.user_id.toString(),
             "item_id" : widget.itemInfo!.item_id.toString(),
           }
       );

       print(res.body);

       if(res.statusCode == 200){
        var decodedResBody = jsonDecode(res.body);

        if(decodedResBody["success"] == true){
          itemDetailsController.setIsFavoriteItem(true);
        }else if(decodedResBody["success"] == false){
          itemDetailsController.setIsFavoriteItem(false);


        }

       }


     } catch(e){
       print(e.toString());
     }


   }





   addItemToFavorite() async{
     try{

       var res = await http.post(
           Uri.parse(API.addItemToFavorite),
           body: {
       "user_id" : currentOnlineUser.user.user_id.toString(),
       "item_id" : widget.itemInfo!.item_id.toString(),
       }
       );

       print(res.body);

       if(res.statusCode == 200){

         var decodedResBody = jsonDecode(res.body);

         if(decodedResBody["success"]) {
           Fluttertoast.showToast(
               msg: "Item has been successfully added to favorites list",
               backgroundColor: Color(0xFFDDA87E));
           itemDetailsController.setIsFavoriteItem(true);
         }else{
           Fluttertoast.showToast(msg: "error while adding item to favorites list", backgroundColor: Color(0xFFDDA87E));
         }

       }


     } catch(e){
       print(e.toString());
     }

   }

   deleteItemFromFavorite() async{

     try{

       var res = await http.post(
           Uri.parse(API.deleteItemFromFavorite),
           body: {
       "user_id" : currentOnlineUser.user.user_id.toString(),
       "item_id" : widget.itemInfo!.item_id.toString(),
       }
       );

       print(res.body);

       if(res.statusCode == 200){
         var decodedResBody = jsonDecode(res.body);

         if(decodedResBody["success"] == true) {
           Fluttertoast.showToast(
               msg: "Item has been successfully removed from favorites list",
               backgroundColor: Color(0xFFDDA87E));
           itemDetailsController.setIsFavoriteItem(false);
         }else{
           Fluttertoast.showToast(msg: "error while deleting item from favorites list", backgroundColor: Color(0xFFDDA87E));

       }

       }


     } catch(e){
       print(e.toString());
     }


   }


   addItemToCart() async{
     try{
       var res = await http.post(
         Uri.parse(API.addToCart),
         body: {
           'user_id' : currentOnlineUser.user.user_id.toString(),
           'item_id' : widget.itemInfo!.item_id.toString(),
           'quantity': itemDetailsController.quantity.toString(),
           'color': widget.itemInfo!.colors![itemDetailsController.color],
           'size': widget.itemInfo!.sizes![itemDetailsController.size]
         }

       );

       print(res.body);

       if(res.statusCode == 200){

         var decodedBody = jsonDecode(res.body);
         if(decodedBody["success"] == true){
           Fluttertoast.showToast(msg: "Item was Successfully added to cart", backgroundColor: Color(0xFFDDA87E));
         } else{
           Fluttertoast.showToast(msg: "Error while adding item to cart", backgroundColor: Color(0xFFDDA87E));
         }

       }else{
         print("Status code is not 200");
       }


     }catch(e){
       print("Error " + e.toString());
       e.printInfo();
     }

   }

   @override
  void initState() {
     super.initState();

     getItemFromFavorite();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: FadeInImage(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              image: NetworkImage(widget.itemInfo!.image!),
              fit: BoxFit.cover,
              placeholder: AssetImage('images/place_holder.png'),
              imageErrorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                      Icons.broken_image_outlined
                  ),
                );
              },

            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: ItemInfoWidget(),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent ,
              child: Row(
                children: [
                  //back
                  IconButton(
                    onPressed: (){
                      Get.back();
                    },
                    icon: const Icon(
                        Icons.arrow_back,
                      color: Colors.teal,
                    ),
                  ),

                  const Spacer(),

                  // favorite
                  Obx(() => IconButton(
                      onPressed: (){
                        if(itemDetailsController.isFavorite){
                          deleteItemFromFavorite();
                        }else{
                          addItemToFavorite();


                        }
                      },
                      icon: Icon(
                        itemDetailsController.isFavorite ? Icons.bookmark : Icons.bookmark_border_outlined,
                        color: Colors.teal,
                      ))),

                  // shopping cart icon buttons
                  IconButton(
                    onPressed: (){
                      Get.to(CartListScreen());
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.teal,
                    ),
                  )
                ],
              ),
            ),
          )


        ],
      ),
    );
  }

  Widget ItemInfoWidget(){
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      width:  MediaQuery.of(Get.context!).size.width ,
      decoration: const BoxDecoration(
        color:  Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30)
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -3),
            blurRadius: 6,
            color: Colors.teal
          )
        ]
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
               height: 18,
             ),
            Center(
              child: Container(
                height: 8,
                width: 140,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(30)
                  ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            Text(widget.itemInfo!.name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFFDDA87E),
                  fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // price

                Expanded(child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: widget.itemInfo!.rating!,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemBuilder: (context, index){
                            return Icon(Icons.star, color: Colors.amber,);
                          }
                          ,
                          onRatingUpdate:(value) {

                          },
                          ignoreGestures: true,
                          unratedColor: Colors.grey,
                          itemSize: 20,

                        ),

                        SizedBox(width: 10,),

                        Text("( " + widget.itemInfo!.rating.toString() + " )",
                          style: TextStyle(
                              color: Colors.teal
                          ),

                        )

                      ],
                    ),

                    //tags
                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      widget.itemInfo!.tags.toString().replaceAll("[", "").replaceAll("]", ""),
                      maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.teal
                      ),
                    ),

                    SizedBox(
                      height: 16,
                    ),

                    Text(widget.itemInfo!.price!.toString() + " EGP",
                      style: TextStyle(
                          fontSize: 24,
                          color:Color(0xFFDDA87E),
                          fontWeight: FontWeight.bold
                      ),
                    ),


                  ],
                )
                ),
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: (){
                          itemDetailsController.setQuantityItem(itemDetailsController.quantity +1);
                        },
                        icon: Icon(Icons.add_circle_outline, color: Colors.teal,)),
                    Text(
                      itemDetailsController.quantity.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFDDA87E),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    IconButton(
                        onPressed: (){
                          if(itemDetailsController.quantity == 1){
                            itemDetailsController.setQuantityItem(itemDetailsController.quantity);
                            Fluttertoast.showToast(msg: "You Can't Order less than one item", backgroundColor: Color(0xFFDDA87E));
                          }
                          else{
                            itemDetailsController.setQuantityItem(itemDetailsController.quantity - 1);
                          }
                        },
                        icon: Icon(Icons.remove_circle_outline, color: Colors.teal,)),
                  ],
                ))

              ],
            ),

            Text("Size:",
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFFDDA87E),
              fontWeight: FontWeight.bold
            ),),


            const SizedBox(height:  8,),
            
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children:
                List.generate(widget.itemInfo!.sizes!.length, (index) {
                  return Obx(() => GestureDetector(
                    onTap: (){
                      itemDetailsController.setSizeItem(index);
                    },
                    child: Container(
                      child: Center(
                          child: Text(
                              widget.itemInfo!.sizes![index],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,


                          )
                      ),
                      height: 40,
                        width: 95,

                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: itemDetailsController.size == index ? Colors.teal : Colors.transparent
                        ),
                      ),
                      alignment: Alignment.center,
                    ),

                  ));
                })
              ,
            ),
            const SizedBox(height:  20,),

            Text("Color:",
              style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFDDA87E),
                  fontWeight: FontWeight.bold
              ),),


            const SizedBox(height:  8,),

            Wrap(
              runSpacing: 8,
              spacing: 8,
              children:
              List.generate(widget.itemInfo!.colors!.length, (index) {
                return Obx(() => GestureDetector(
                  onTap: (){
                    itemDetailsController.setColorItem(index);
                  },
                  child: Container(
                    child: Center(
                        child: Text(
                          widget.itemInfo!.colors![index],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,


                        )
                    ),
                    height: 40,
                    width: 95,

                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: itemDetailsController.color == index ? Colors.teal : Colors.transparent
                      ),
                    ),
                    alignment: Alignment.center,
                  ),

                ));
              })
              ,
            ),

            const SizedBox(height:  20,),


            Text("Description:",
              style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFDDA87E),
                  fontWeight: FontWeight.bold
              ),),


            const SizedBox(height:  8,),


            Text(widget.itemInfo!.description!,
              textAlign: TextAlign.justify,

            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Material(
                elevation: 4,
                color: Colors.teal,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: (){
                    addItemToCart();
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: Text(
                        "Add to cart",
                      style: TextStyle(
                          color: Colors.black,
                      fontSize: 20),

                    ),

                  ),
                ),
              ),
            )








            // Item Counter
            
          ],
        ),
      ),
    );
  }

}
