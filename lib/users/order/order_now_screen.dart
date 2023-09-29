import 'package:clothes_app/users/controllers/order_now_controller.dart';
import 'package:clothes_app/users/order/order_confirmation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../model/cart.dart';

class OrderNowScreen extends StatelessWidget {

  final List<Map<String, dynamic>> selectedCartListItems;
  final double totalAmount;
  final List<int> selectedcartIDs;

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController shipmentAddressController = TextEditingController();
  TextEditingController noteToSellerController = TextEditingController();


  OrderNowController orderNowController = Get.put(OrderNowController());
  List<String> deliverySystemNamesList = ["FedEx", "DHL", "United Parcel Service"];
  List<String> paymentSystemNamesList = ["Apple Pay", "Wire Transfer", "Google Pay"];


  OrderNowScreen({super.key, required this.selectedCartListItems, required this.totalAmount, required this.selectedcartIDs});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Order Now",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        titleSpacing: 0,
        centerTitle: false,

      ),
      body: ListView(
        children: [

          // selected items from cartlist

          displaySelectedItemsFromUserCart(),

         const SizedBox(height: 30,),

          const Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16),
             child: Text(
              "Delivery System",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold

              ),

          ),
           ),
          Padding(padding: EdgeInsets.all(18),
          child: Column(
            children:
            deliverySystemNamesList.map((deliverySystemName) {
              return Obx(() =>
                  RadioListTile<String>(
                    tileColor: Color(0xFFDDA87E),
                    dense: true,
                    activeColor: Colors.teal,
                    title: Text(deliverySystemName,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    value: deliverySystemName,
                    groupValue: orderNowController.deliverySystem,
                    onChanged: (newDeliverySystemValue){
                      orderNowController.setDeliverySystem(newDeliverySystemValue!);
                    },
                  )
              );
            }).toList()
          ),
          ),
          const SizedBox(height: 16,),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Text(
                  "Payment System",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold

                  ),

                ),
                const SizedBox(height: 2,),

                Text(
                  "Account Number / ID: \nY87Y-HJF9-cvn-4321",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold

                  ),

                ),

              ],
            ),
          ),

          Padding(padding: EdgeInsets.all(18),
            child: Column(
                children:
                paymentSystemNamesList.map((paymentSystemName) {
                  return Obx(() =>
                      RadioListTile<String>(
                        tileColor: Color(0xFFDDA87E),
                        dense: true,
                        activeColor: Colors.teal,
                        title: Text(paymentSystemName,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        value: paymentSystemName,
                        groupValue: orderNowController.paymentSystem,
                        onChanged: (newPaymentSystemValue){
                          orderNowController.setPaymentSystem(newPaymentSystemValue!);
                        },
                      )
                  );
                }).toList()
            ),
          ),

          const SizedBox(height: 16,),

          // phone number

          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Phone Number",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold

              ),

            ),
          ),

          Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: TextStyle(color: Colors.black),
               controller: phoneNumberController,
              decoration: InputDecoration(
                hintText: "Contact Number",
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.teal,
                    width: 2
                  )
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 2
                    )
                ),
              ),
            ),
          ),

          const SizedBox(height: 16,),


          // shipment address
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Shipment Address",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold

              ),

            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: TextStyle(color: Colors.black),
              controller: shipmentAddressController,
              decoration: InputDecoration(
                hintText: "Your Shipment Address",
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Colors.teal,
                        width: 2
                    )
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 2
                    )
                ),
              ),
            ),
          ),

          const SizedBox(height: 16,),


          // note to seller
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Note to Seller",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold

              ),

            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: TextStyle(color: Colors.black),
              controller: noteToSellerController,
              decoration: InputDecoration(
                hintText: "Your note to the seller",
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Colors.teal,
                        width: 2
                    )
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 2
                    )
                ),
              ),
            ),
          ),

          const SizedBox(height: 30,),
          Padding(padding: EdgeInsets.all(16),
          child: Material(
            color: Colors.teal ,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: (){
                if(phoneNumberController.text.isNotEmpty && shipmentAddressController.text.isNotEmpty){
                  Get.to(OrderConfirmationScreen(
                      selectedcartIDs: selectedcartIDs,
                      selectedCartListItems: selectedCartListItems,
                      totalAmount: totalAmount,
                      deliverySystem: orderNowController.deliverySystem,
                      paymentSystem: orderNowController.paymentSystem,
                      phoneNumber: phoneNumberController.text,
                      shipmentAddress: shipmentAddressController.text,
                      note: noteToSellerController.text
                  ));
                }else{
                  Fluttertoast.showToast(msg: "Please fill the phone number and shipment address", backgroundColor: Color(0xFFDDA87E));
                }
              },
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12
                ),
                child: Row(
                  children: [
                    Text("E£" + totalAmount.toStringAsFixed(2),style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.25,),
                    Text("Pay Amount Now",style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
          )

            )
        ],
      ),
    );
  }

   displaySelectedItemsFromUserCart(){
   return Column(
     children: List.generate(selectedCartListItems.length, (index) {
       Map<String, dynamic> eachSelectedItem = selectedCartListItems[index];
       return Container(

         margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16, index == selectedCartListItems.length - 1 ? 16 : 8),
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
