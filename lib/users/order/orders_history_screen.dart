import 'dart:convert';

import 'package:clothes_app/users/model/order.dart';
import 'package:clothes_app/users/order/order_details.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../../api_connection/api_connection.dart';
import 'package:intl/intl.dart';

class OrdersHistoryScreen extends StatelessWidget {

  CurrentUser currentOnlineUser =  Get.put(CurrentUser());

  Future<List<Order>> getOrdersList() async{
    List<Order> ordersList = [];
    try{
      var res = await http.post(
          Uri.parse(API.getOrdersHistory),
          body: {
            "user_id": currentOnlineUser.user.user_id.toString()
          }

      );

      print(res.body);

      if(res.statusCode == 200){
        var decodedResBody = jsonDecode(res.body);
        if(decodedResBody["success"] == true){
          (decodedResBody["OrdersData"] as List).forEach((element) {
            ordersList.add(Order.fromJson(element));
          });

        }else{
          Fluttertoast.showToast(msg: "error while getting orders");
        }

      }


    } catch(e){
      print(e.toString());
    }
    return ordersList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:EdgeInsets.fromLTRB(16, 24, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/orders_icon.png",
                        width: 140,
                      ),
                      const Text(
                        "My Past Orders",
                        style: TextStyle(
                            color: Colors.teal,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),

                ],
              ),

            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Below are your past orders.",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                ),

              ),
            ),

            // displaying the user order List
            Expanded(child: displayOrdersList(context)),
          ],
        ),
      ),
    );
  }
  Widget displayOrdersList(BuildContext context){
    return FutureBuilder(
      future: getOrdersList(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text("Connection waiting..."),

              ),

              Center(
                child: CircularProgressIndicator(),

              )
            ],
          );
        }
        if(snapshot.data == null){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text("No Orders Found Yet"),

              ),

              Center(
                child: CircularProgressIndicator(),

              )
            ],
          );
        }
        if(snapshot.data!.length > 0){

          List<Order> orderList = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index){
              return Divider(
                height: 1,
                thickness: 1,
              );
            },
            itemCount: orderList.length,
            itemBuilder: (context, index){
              Order eachOrderData = orderList[index];
              return Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: ListTile(
                    onTap: (){
                      Get.to(OrderDetailsScreen(
                          clickdOrderInfo: eachOrderData
                      ));
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order ID #: " + eachOrderData.order_id.toString(),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          )
                          ,),
                        Text("Amount #: E£" + eachOrderData.totalAmount.toString(),
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          )
                          ,)
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //date
                        //time

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(DateFormat(
                                "dd MMMM, yyyy"
                            ).format(eachOrderData.dateTime!),

                            ),

                            const SizedBox(height: 4,),

                            Text(DateFormat(
                                "hh:mm a"
                            ).format(eachOrderData.dateTime!),

                            )
                          ],
                        ),
                        const SizedBox(width: 10,),

                        Icon(
                          Icons.navigate_next,
                          color: Colors.teal,
                        )

                      ],
                    ),
                  ),
                ),
              );

            },

          );

        }else{

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text("Nothing to show...."),

              ),

              Center(
                child: CircularProgressIndicator(),

              )
            ],
          );

        }

      },
    );
  }

}
