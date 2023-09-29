import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/users/model/favorites.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../item/item_details_screen.dart';


class FavoriteFragmentScreen extends StatelessWidget {

  var currentOnlineUser = Get.put(CurrentUser());

 Future<List<Favorites>> getFavoritesList() async{
    List<Favorites> itemsList = [];
    try{
      var res = await http.post(
        Uri.parse(API.getAllFavoriteItems),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString()
        }

      );

      print(res.body);

      if(res.statusCode == 200){
        var decodedResBody = jsonDecode(res.body);
        if(decodedResBody["success"] == true){
          (decodedResBody["favoritesItemData"] as List).forEach((element) {
            itemsList.add(Favorites.fromJson(element));
          });

        }else{
          Fluttertoast.showToast(msg: "error while getting items");
        }

      }
      
      
    } catch(e){
      print(e.toString());
    }
    return itemsList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const Padding(padding: EdgeInsets.fromLTRB(16, 24, 0, 0),
            child: Text("My Favorites",style: TextStyle(color: Colors.teal, fontSize: 30, fontWeight: FontWeight.bold),),
          ),
          Padding(padding: EdgeInsets.fromLTRB(16, 24, 0, 0),
            child: Text("Choose from your favorites list",style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300),),
          ),

          const SizedBox(height: 24,),

          allItemsWidget(context)

        ],
      ),
    );
  }


  Widget allItemsWidget(BuildContext context){
    return FutureBuilder(
      future: getFavoritesList(),
      builder: (context, snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        if(snapshot.data!.length == 0){
          return Center(child: Text("No Favorite Items Found"));
        }

        if(snapshot.data!.length > 0){
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {

              Favorites favoritesInstance = snapshot.data![index];

              return GestureDetector(
                onTap: (){

                  Get.to(ItemDetailsScreen(itemInfo: Clothes.fromFavorite(favoritesInstance),));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(index == 0 ? 16 : 8, 10, index == snapshot.data!.length - 1 ? 16 : 8 , 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 6,
                            color: Color(0xFFDDA87E)
                        )
                      ]

                  ),
                  child: Row(
                    children: [
                      Expanded(child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                          children: [

                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    favoritesInstance.name!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFFDDA87E),
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),

                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "E£" + favoritesInstance.price!.toString() ,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 16,
                            ),

                            Text(
                              favoritesInstance.tags!.toString().replaceAll("[", "").replaceAll("]", "") ,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFDDA87E),
                              ),
                            ),

                          ],
                        ),

                      )),

                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20)
                        ),
                        child: FadeInImage(
                          height: 130,
                          width:130,
                          image: NetworkImage(favoritesInstance.image!),
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



                    ],
                  ),
                ),
              );

            },
          );
        } else{
          return Center(
            child: Text("No Data Found"),
          );
        }

      },

    );

  }
}
