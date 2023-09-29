import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/users/model/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class OrderDetailsScreen extends StatefulWidget {
  final Order clickdOrderInfo;

  const OrderDetailsScreen({super.key, required this.clickdOrderInfo});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  RxString _status = "new".obs;
  String get status => _status.value;


  @override
  void initState(){
    super.initState();
    updateParcelStatus(widget.clickdOrderInfo.status!);
  }

  updateParcelStatus(String parcelRecived){
    _status.value = parcelRecived;


  }

  showDialogForParcelConfirmation() async{

    if(widget.clickdOrderInfo.status == "new"){
      var response = await Get.dialog(
        AlertDialog(
          backgroundColor: Color(0xFFDDA87E),
          title: Text(
            "Confirmation",
            style: TextStyle(
              color: Colors.teal
            ),
          ),
          content: Text(
              "Have You received your parcel?",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Get.back();
              },
              child: Text("No",

              ),
            ),
            TextButton(
              onPressed: (){
                Get.back(result: "yesConfirmed");
              },
              child: Text("Yes",

              ),
            )
          ],
        )
      );

      if(response == "yesConfirmed"){
        updateStatusValueInDatabase();
      }

    }

  }


  updateStatusValueInDatabase() async{
    try{

      var res = await http.post(
        Uri.parse(API.updateOrderStatus),
            body: {
          "order_id": widget.clickdOrderInfo.order_id.toString()
      }
      );

      print((res.body));

      if(res.statusCode == 200){

        var decodedResBody = jsonDecode(res.body);

        if(decodedResBody["success"] == true){
          Fluttertoast.showToast(msg: "You've successfully confirmed receiving your order.");
          updateParcelStatus("received");
        }else{
          Fluttertoast.showToast(msg: "Error while updating your parcel's status, please try again.", backgroundColor: Color(0xFFDDA87E));

        }

      }else{
        Fluttertoast.showToast(msg: "Unable to reach Server", backgroundColor: Color(0xFFDDA87E));
      }


    }catch(e){
      print(e.toString());

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: Material(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: (){

                if(status == "new"){
                  showDialogForParcelConfirmation();
                }

              },
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Text("Received",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                    ),
                    ),
                 const   SizedBox(width: 8,),
                    Obx(() =>
                    status == "new" ?
                  const  Icon(Icons.help_outline, color: Colors.redAccent,) :
                   const Icon(Icons.check_circle_outline, color: Colors.greenAccent,)
                    )
                  ],
                ),
              ),
            ),
          ),
          )
        ],
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          DateFormat("dd/MM/yyyy - hh:mm a").format(widget.clickdOrderInfo.dateTime!),
          style: TextStyle(
            fontSize: 14,
                color: Colors.black
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // items that belong to the order
              displayClickedOrderItems(),

              const SizedBox(height: 16,),

              showTitle("Phone Number: "),
              const SizedBox(height: 8,),

              showContentText(widget.clickdOrderInfo.phoneNumber!),

              const SizedBox(height:26),


              showTitle("Shipment Address: "),
              const SizedBox(height: 8,),

              showContentText(widget.clickdOrderInfo.shipmentAddress!),

              const SizedBox(height:26),


              showTitle("Delivery System: "),
              const SizedBox(height: 8,),

              showContentText(widget.clickdOrderInfo.deliverySystem!),

              const SizedBox(height:26),


              showTitle("Payment System: "),
              const SizedBox(height: 8,),

              showContentText(widget.clickdOrderInfo.paymentSystem!),

              checkForNote(),

              const SizedBox(height:26),


              showTitle("Total Amount: "),
              const SizedBox(height: 8,),

              showContentText(widget.clickdOrderInfo.totalAmount!.toString()),

              const SizedBox(height:26),


              showTitle("Proof of Payment / Transaction: "),
              const SizedBox(height: 8,),

              FadeInImage(
                width:MediaQuery.of(context).size.width *0.8,
                image: NetworkImage(API.hostImages+widget.clickdOrderInfo.image.toString()),
                fit: BoxFit.fitWidth,
                placeholder: AssetImage('images/place_holder.png'),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                        Icons.broken_image_outlined
                    ),
                  );
                },

              ),


            ],
          ),
        ),
      ),
    );
  }

 Widget showTitle(String titleText){
    return Text(
     titleText,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.teal

      ),
    );
  }

  Widget showContentText(String contentText){
    return Text(
      contentText,
      style: TextStyle(
        fontSize: 14,


      ),
    );
  }
  Widget checkForNote(){
    if(widget.clickdOrderInfo.note != ""){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
        const SizedBox(height:26),


        showTitle("Note to Seller: "),
        const SizedBox(height: 8,),

        showContentText(widget.clickdOrderInfo.note!),
      ],);
  }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const SizedBox(height:26),


        showTitle("Note to Seller: "),
        const SizedBox(height: 8,),

        showContentText("No note to seller"),
      ],);
    }
  }


  displayClickedOrderItems(){
   List<dynamic> clickedOrderListItems =  widget.clickdOrderInfo.selectedItems!.split("||").map((e) => jsonDecode(e)).toList();
    return Column(
      children: List.generate(clickedOrderListItems.length, (index) {
        Map<String, dynamic> eachSelectedItem = clickedOrderListItems[index];
        return Container(

          margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16, index == clickedOrderListItems.length - 1 ? 16 : 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0,0),
                    blurRadius: 6,
                    color: Color(0xFFDDA87E)
                )
              ]
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)
                ),
                child: FadeInImage(
                  height: 150,
                  width:130,
                  image: NetworkImage(eachSelectedItem["image"]),
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

              //name
              //size
              //total amount

              Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // name

                        Text(
                          eachSelectedItem["name"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFDDA87E),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 16,),

                        Text(
                          eachSelectedItem["size"] + "\n" +  eachSelectedItem["color"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 16,),

                        Text(
                          "E£" +   eachSelectedItem["price"].toString() ,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.teal,
                          ),
                        ),

                        Text(
                          eachSelectedItem["price"].toString() + " x " + eachSelectedItem["quantity"].toString() + " = " + eachSelectedItem["totalAmount"].toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.teal,
                          ),
                        ),


                      ],
                    ),
                  )
              ),

              // quantity
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Q: " + eachSelectedItem["quantity"].toString(),
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.teal
                  ) ,
                ),
              )


            ],
          ),
        );
      }),
    );

  }

}
