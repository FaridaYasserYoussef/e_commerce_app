
import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/controllers/cart_list_controller.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/users/order/order_now_screen.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../model/cart.dart';

class CartListScreen extends StatefulWidget {
  const CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {


  final CurrentUser currentOnlineUser = Get.put(CurrentUser());
  final CartListController cartListController = Get.put(CartListController());


  updateQuantityInCart(int newQuantity, int cartid) async{
    try{
      var res = await http.post(
        Uri.parse(API.updateQuantity),
        body: {
          "new_quantity": newQuantity.toString(),
          "cart_id": cartid.toString()
        }
      );

      print(res.body);

      if(res.statusCode == 200){
        var decodedBody = jsonDecode(res.body);

        if(decodedBody["success"] == true){
          cartListController.setCartItemQuantity(cartid, newQuantity);
          calculateTotalAmount();

        }else{
          Fluttertoast.showToast(msg: "error updating quantity");

        }

      }


    }catch(e){
      print(e.toString());
    }

  }
  deleteFromCart() async{

    try{
      var res = await http.post(
        Uri.parse(API.deleteFromCart),
        body:{
          "items_to_delete": cartListController.selectedItemsList.toString().replaceAll("[", "").replaceAll("]", "")

        }
      );

      print("delete body is");
      print(res.body);

      if(res.statusCode == 200){

        var decodedResBody = jsonDecode(res.body);

        if(decodedResBody["success"] == true){
          Fluttertoast.showToast(msg: "Successfully deleted selected items from cart", backgroundColor:  Color(0xFFDDA87E));
          cartListController.deleteSelectedItemsFromCart();
          calculateTotalAmount();
        }else{
          Fluttertoast.showToast(msg: "error while deleting selected items from cart", backgroundColor:  Color(0xFFDDA87E));

        }
        
      }


    }catch(e){
      print(e.toString());
    }

  }

  getCurrentUserCartList() async{
   List<Cart> cartList = [];

   try{
     var res = await http.post(
         Uri.parse(API.getFromCart),
         body: {
           "user_id": currentOnlineUser.user.user_id.toString()
         }
     );

     print(res.body);

     if(res.statusCode == 200){
       var decodedResponseBody = jsonDecode(res.body);

       if(decodedResponseBody["success"] == true){

         for(Map<String, dynamic> eachCartItem in decodedResponseBody["CartData"]){
           cartList.add(Cart.fromJson(eachCartItem));
         }

       }else{
        Fluttertoast.showToast(msg: "No Cart Items were found for this user", backgroundColor: Color(0xFFDDA87E));
       }
       cartListController.setList(cartList);

     }

   }catch(e){
     Fluttertoast.showToast(msg: e.toString(), backgroundColor: Color(0xFFDDA87E));

   }
   calculateTotalAmount();
  }

  calculateTotalAmount(){

    double total = 0;
    cartListController.setTotal(total);

    if(cartListController.selectedItemsList.length > 0 ){

      for(Cart cartItem in cartListController.cartList){
        if(cartListController.selectedItemsList.contains(cartItem.cart_id)){
          total = (cartItem.price! * double.parse(cartItem.quantity!.toString()));
          cartListController.setTotal(cartListController.total + total);

        }

      }

    }else{
      cartListController.setTotal(total);
    }
  }

  List<Map<String, dynamic>> selectedCartListItemsInformation(){
    List<Map<String, dynamic>> itemInformationList = [];

   if(cartListController.selectedItemsList.length > 0){
  cartListController.cartList.forEach((cartListItem) {
  if(cartListController.selectedItemsList.contains(cartListItem.cart_id)){
  Map<String, dynamic> itemInformation = {
  "item_id" : cartListItem.item_id,
  "name" : cartListItem.name,
  "image": cartListItem.image,
  "color": cartListItem.color,
  "size": cartListItem.size,
  "quantity": cartListItem.quantity,
  "totalAmount": cartListItem.price! * cartListItem.quantity!,
    "price": cartListItem.price!
  };
  itemInformationList.add(itemInformation);

  }
  });
  }
return itemInformationList;
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xFFDDA87E),
        title: Text("My Cart",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        actions: [
          Obx(()=> IconButton(
              onPressed: (){


                if(cartListController.isSelectedAll){
                  cartListController.setIsSelectedAll();
                  cartListController.clearAllSelectedItems();
                  calculateTotalAmount();
                }else{
                  cartListController.setIsSelectedAll();
                  cartListController.selectAllItems();
                  calculateTotalAmount();

                }
              },
              icon:  Icon(cartListController.isSelectedAll? Icons.check_box : Icons.check_box_outline_blank)
          )
          ),
          GetBuilder(
            init: CartListController(),
            builder: (controller) {
              if(cartListController.selectedItemsList.length > 0){
               return IconButton(
                    onPressed: () async{
                      var responseFromDialogBox = await Get.dialog(
                        AlertDialog(
                          backgroundColor:  Color(0xFFDDA87E),
                          title: Text("Delete"),
                          content: Text("Are you sure you want to delete the selected items from your cart"),
                          actions: [
                            TextButton(
                                onPressed: (){
                                  Get.back();
                                },
                                child: Text("No",
                                  style: TextStyle(color: Colors.black),
                                )),
                            TextButton(
                                onPressed: (){
                                  Get.back(result: "yesDelete");
                                },
                                child: Text("Yes",
                                  style: TextStyle(color: Colors.black),
                                ))
                          ],
                        )
                      );
                      if(responseFromDialogBox == "yesDelete"){
                        deleteFromCart();
                      }
                    },

                    icon:Icon(Icons.delete, color: Colors.redAccent,));
              }
              else{
                return Container();
              }

          },)


        ],
      ),
      body: Obx(
          () =>
          cartListController.cartList.length > 0 ?
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: cartListController.cartList.length,
            itemBuilder: (context, index) {

              Cart cartModel =  cartListController.cartList[index];
              Clothes clothesModel = Clothes(
                item_id: cartModel.item_id,
                name: cartModel.name,
                rating: cartModel.rating,
                tags: cartModel.tags,
                price: cartModel.price,
                sizes: cartModel.sizes,
                colors: cartModel.colors,
                description: cartModel.description,
                image: cartModel.image
              );

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    //Check Box
                    GetBuilder(
                      init: CartListController(),
                      builder: (controller) {
                        return IconButton(
                            onPressed: (){

                              if(cartListController.selectedItemsList.contains(cartModel.cart_id!)){
                                if(cartListController.selectedItemsList.length == cartListController.cartList.length){
                                  cartListController.setIsSelectedAll();

                                }


                                  cartListController.deleteSelectedItem(cartModel.cart_id!);
                                  calculateTotalAmount();





                              }else{
                                cartListController.addSelectedItem(cartModel.cart_id!);
                                if(cartListController.selectedItemsList.length == cartListController.cartList.length){
                                  cartListController.setIsSelectedAll();

                                }

                                calculateTotalAmount();
                              }

                            },
                            icon: Icon(
                              cartListController.selectedItemsList.contains(cartModel.cart_id) ? Icons.check_box : Icons.check_box_outline_blank,
                              color: cartListController.isSelectedAll ? Colors.black : Colors.grey,
                            ));
                      },
                    ),
                    Expanded
                      (child: GestureDetector(
                      onTap: (){},
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            0,
                            index == 0 ? 16 : 8,
                            16,
                            index == cartListController.cartList.length - 1 ? 16 : 8
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0,0),
                              blurRadius: 6,
                              color:  Color(0xFFDDA87E)
                            )
                          ]
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                       clothesModel.name!.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color:  Color(0xFFDDA87E),
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(height:  20,),
                                      Row(
                                        children: [
                                          Expanded(child:
                                          Text(
                                            "Color: ${cartModel.color!.replaceAll("[", "").replaceAll("]", "")}" + "\n" + "Size: ${cartModel.size!.replaceAll("[", "").replaceAll("]", "")}",
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                          )
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(left: 12, right: 12),
                                              child: Text(
                                                  "E£" + clothesModel.price!.toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.teal,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),

                                          )

                                        ],
                                      ),
                                      SizedBox(height:  20,),
                                      // + -
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: (){

                                                  if(cartModel.quantity! - 1 >= 1){
                                                    updateQuantityInCart(cartModel.quantity! - 1, cartModel.cart_id!);
                                                  }




                                              },
                                              icon: Icon(
                                                  Icons.remove_circle_outline,
                                                   color: Colors.black,
                                              )

                                          ),
                                          GetBuilder(
                                            init: CartListController(),
                                            builder: (controller) {
                                              return Text(cartListController.cartList.where((element) => element.cart_id == cartModel.cart_id).elementAt(0).quantity.toString(),
                                                style: TextStyle(
                                                    color: Colors.teal,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              );
                                            },
                                          ),

                                          IconButton(
                                              onPressed: (){
                                                updateQuantityInCart(cartModel.quantity! + 1, cartModel.cart_id!);

                                              },
                                              icon: Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.black,
                                              )

                                          ),
                                          


                                        ],
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
                                height: 235,
                                width:150,
                                image: NetworkImage(clothesModel.image!),
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
                    )
                    )
                  ],
                ),
              );

            },
          )
              :
              Center(
                child: Text("Cart is Empty"),

              )
      ),
      bottomNavigationBar: GetBuilder(
        init: CartListController(),
        builder: (controller) {
          return Container(
            decoration: const BoxDecoration(
              color:  Color(0xFFDDA87E),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -3),
                  color: Colors.white,
                  blurRadius: 6
                )
              ]
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8
            ),
            child: Row(
              children: [
                //total
              const  Text(
                  "Total Amount: ",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(width: 4,),
                Obx(() =>
                    Text("E£ " + cartListController.total.toStringAsFixed(2),
                    maxLines: 1,
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    )
                ),
                const Spacer(),
                Material(
                  color: cartListController.selectedItemsList.length > 0 ? Colors.teal :Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: (){



                      cartListController.selectedItemsList.length > 0 ? Get.to(OrderNowScreen(
                        selectedCartListItems:  selectedCartListItemsInformation(),
                        totalAmount: cartListController.total,
                          selectedcartIDs: cartListController.selectedItemsList
                      )) : null;
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text("Order Now",
                        style: TextStyle(
                          color: Colors.white,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
