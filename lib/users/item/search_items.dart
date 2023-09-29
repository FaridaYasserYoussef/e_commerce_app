import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../cart/cart_list_screen.dart';
import '../model/clothes.dart';
import 'package:http/http.dart' as http;

import 'item_details_screen.dart';

class SearchItems extends StatefulWidget {
  final String typedKeyWord;

  const SearchItems({super.key, required this.typedKeyWord});

  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {

  Future<List<Clothes>> readSearchRecords() async{
    List<Clothes> clothingList = [];
    try{
      var res = await http.post(
        Uri.parse(API.searchItem),
        body: {
          'typedKeyWord' : searchController.text.toString()
        }
      );

      print(res.body);

      if(res.statusCode == 200){
        var decodedResBody = jsonDecode(res.body);
        if(decodedResBody["success"] == true){
          (decodedResBody["itemsData"] as List).forEach((eachItem) {
            clothingList.add(Clothes.fromJson(eachItem));
          });
        }else{
          Fluttertoast.showToast(msg: "your search was unsuccessful");
        }

      }else{
        Fluttertoast.showToast(msg: "unable to reach server");
      }

    }catch(e){
      print(e.toString());
    }
    return clothingList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.text = widget.typedKeyWord;
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: showSearchBarWidget(),
        titleSpacing: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.teal,
          ),
        ),
      ),
      body: allItemsWidget(context),
    );
  }


  Widget allItemsWidget(BuildContext context){
    return FutureBuilder(
      future: readSearchRecords(),
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


  Widget showSearchBarWidget(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
            prefixIcon: IconButton(
              onPressed: (){
               setState(() {

               });
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

}
