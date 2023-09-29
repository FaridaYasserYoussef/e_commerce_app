import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/cart/cart_list_screen.dart';
import 'package:clothes_app/users/item/item_details_screen.dart';
import 'package:clothes_app/users/item/search_items.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeFragmentScreen extends StatelessWidget {

  TextEditingController searchController = TextEditingController();

 Future<List<Clothes>> getTrendingItems() async{
   List<Clothes> trendingClothes = [];

   try{

     var res =  await http.post(
        Uri.parse(API.getTrending)
      );
     print(res.body);
     if(res.statusCode == 200){
      var resBodyDecoded = jsonDecode(res.body);
      if(resBodyDecoded["success"] == true){
        print("The trending items are ");
        print(resBodyDecoded['clothesItemData'][0].runtimeType);

        for(Map<String, dynamic> json in resBodyDecoded['clothesItemData']){
          trendingClothes.add(Clothes.fromJson(json));
        }



      }
       
     }else{
       print(res.statusCode);
     }
     
    } catch (e){
      print(e.toString());
    }

    return trendingClothes;

 }

  Future<List<Clothes>> getAllItems() async{
    List<Clothes> allClothes = [];

    try{

      var res =  await http.post(
          Uri.parse(API.getAll)
      );
      print(res.body);
      if(res.statusCode == 200){
        var resBodyDecoded = jsonDecode(res.body);
        if(resBodyDecoded["success"] == true){
          print("The trending items are ");
          print(resBodyDecoded['clothesItemData'][0].runtimeType);

          for(Map<String, dynamic> json in resBodyDecoded['clothesItemData']){
            allClothes.add(Clothes.fromJson(json));
          }



        }

      }else{
        print(res.statusCode);
      }

    } catch (e){
      print(e.toString());
    }

    return allClothes;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(

        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showSearchBarWidget(),


              Padding(

                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text("Trending",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                    fontSize: 26
                )
                  ),
              ),

              trendingItemWidget(context),

              Padding(

                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text("New Collection",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                        fontSize: 26
                    )
                ),
              ),
              
              allItemsWidget(context)

            ],
          ),
        ),
      ),
    );
  }

  Widget showSearchBarWidget(){
   return Padding(
       padding: EdgeInsets.symmetric(horizontal: 10),
       child: TextField(
         controller: searchController,
         decoration: InputDecoration(
           prefixIcon: IconButton(
             onPressed: (){
               Get.to(SearchItems(typedKeyWord: searchController.text));
             },
             icon: Icon(Icons.search, color: Colors.teal[300],),
           ),
           hintText: "Search For Items Here",
           suffixIcon: IconButton(
             onPressed: (){
               Get.to(CartListScreen());
             },
             icon: Icon(Icons.shopping_cart, color: Colors.teal[300],),

           ),
           border: OutlineInputBorder(
             borderSide: BorderSide(
               width: 2,
               color: Colors.teal
             ),
           ),
           enabledBorder: OutlineInputBorder(
             borderSide: BorderSide(
                 width: 2,
                 color: Colors.teal
             ),
           ),
           focusedBorder: OutlineInputBorder(
             borderSide: BorderSide(
                 width: 2,
                 color: Colors.teal[100]!
             ),

           ),
           contentPadding: EdgeInsets.symmetric(
             horizontal: 16,
             vertical: 10
           )
         ),
       ),

   );
  }

  Widget trendingItemWidget(BuildContext context){
   return FutureBuilder(
     future: getTrendingItems(),
     builder: (context, snapshot){
       if(snapshot.connectionState == ConnectionState.waiting){
         return CircularProgressIndicator();
       }
       if(snapshot.data!.length == 0){
         return Center(child: Text("No Trending Items"));
       }
       if(snapshot.data!.length > 0){
         return Container(
           height: 260,
           child: ListView.builder(
            itemCount: snapshot.data!.length,
             scrollDirection: Axis.horizontal,
             itemBuilder: (context, index) {
              Clothes clothesInstance = snapshot.data![index];
              return GestureDetector(
                onTap: (){

                  Get.to(ItemDetailsScreen(itemInfo: clothesInstance,));
                },
                child: Container(
                  width: 200,
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
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)
                        ),
                        child: FadeInImage(
                          height: 150,
                          width:200,
                          image: NetworkImage(clothesInstance.image!),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Padding(

                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(clothesInstance.name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFDDA87E),
                                    fontWeight: FontWeight.bold
                                  ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(clothesInstance.price!.toString() + " EGP",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: RatingBar.builder(
                                  initialRating: clothesInstance.rating!,
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
                              ),
                              SizedBox(width: 10,),
                              
                              Text("( " + clothesInstance.rating.toString() + " )",
                              style: TextStyle(
                                color: Colors.teal
                              ),

                              )
                              

                            ],
                          )
                        ],
                      )

                    ],
                  ),
                ),
              );

             },

           )
         );
       }else{
         return Center();
       }
     },
   );
  }
  
  Widget allItemsWidget(BuildContext context){
   return FutureBuilder(
     future: getAllItems(),
     builder: (context, snapshot) {

       if(snapshot.connectionState == ConnectionState.waiting){
         return CircularProgressIndicator();
       }
       if(snapshot.data!.length == 0){
         return Center(child: Text("No Items Found"));
       }

       if(snapshot.data!.length > 0){
         return ListView.builder(
           shrinkWrap: true,
           physics: NeverScrollableScrollPhysics(),
           itemCount: snapshot.data!.length,
           scrollDirection: Axis.vertical,
           itemBuilder: (context, index) {

             Clothes clothesInstance = snapshot.data![index];

             return GestureDetector(
               onTap: (){

                 Get.to(ItemDetailsScreen(itemInfo: clothesInstance,));
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
                                 clothesInstance.name!,
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
                                   "E£" + clothesInstance.price!.toString() ,
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
                             clothesInstance.tags!.toString().replaceAll("[", "").replaceAll("]", "") ,
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
                         image: NetworkImage(clothesInstance.image!),
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
