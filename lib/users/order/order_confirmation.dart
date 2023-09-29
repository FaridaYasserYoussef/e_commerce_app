import 'dart:convert';
import 'dart:typed_data';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/fragments/dashboard_of_fragments.dart';
import 'package:clothes_app/users/model/order.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import '../fragments/home_fragment_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final List<int> selectedcartIDs;
  final List<Map<String, dynamic>> selectedCartListItems;
  final double totalAmount;
  final String deliverySystem;
  final String paymentSystem;
  final String phoneNumber;
  final String shipmentAddress;
  final String note;

   OrderConfirmationScreen({super.key, required this.selectedcartIDs, required this.selectedCartListItems, required this.totalAmount, required this.deliverySystem, required this.paymentSystem, required this.phoneNumber, required this.shipmentAddress, required this.note});
  RxList<int> _imageSelectedByte = <int>[].obs;
  Uint8List get imageSelectedByte => Uint8List.fromList(_imageSelectedByte);
  RxString _imageSelectedName = "".obs;
  String get imageSelectedName => _imageSelectedName.value;
  final ImagePicker _picker = ImagePicker();
  CurrentUser currentOnlineUser = Get.put(CurrentUser());

  setSelectedImage(Uint8List selectedImage){
   _imageSelectedByte.value =  selectedImage;
  }

  setSelectedImageName(String selectedImageName){
    _imageSelectedName.value =  selectedImageName;
  }
  chooseImageFromGallery() async{

    final pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedImageXFile != null){
     final bytesOfImage = await pickedImageXFile.readAsBytes();
     setSelectedImage(bytesOfImage);
     setSelectedImageName(path.basename(pickedImageXFile.path));
    }

  }

  saveNewOrderInfo() async{


  String selectedItemsString =  selectedCartListItems.map((eachSelectedItem) => jsonEncode(eachSelectedItem)).toList().join("||");
  Order order = Order(
    order_id: 1,
    user_id: currentOnlineUser.user.user_id,
    selectedItems: selectedItemsString,
    deliverySystem: deliverySystem,
    paymentSystem: paymentSystem,
    note: note,
    totalAmount: totalAmount,
    dateTime: DateTime.now(),
    image: DateTime.now().millisecondsSinceEpoch.toString() + "-" + imageSelectedName,
    status: "new",
    shipmentAddress: shipmentAddress,
    phoneNumber: phoneNumber,

  );

try{

  var res =  await http.post(
    Uri.parse(API.addOrder),
    body: order.toJson(base64Encode(imageSelectedByte), selectedcartIDs)
  );

  print(order.toJson(base64Encode(imageSelectedByte), selectedcartIDs));
  print(res.body);

  if(res.statusCode == 200){
    var decodedResBody = jsonDecode(res.body);
    if(decodedResBody["success"] == true){
      Fluttertoast.showToast(msg: "Your Order has been made successfully", backgroundColor: Color(0xFFDDA87E));
      Future.delayed(Duration(seconds: 2));
      Get.to(DashboardOfFragments());
    }else{
      Fluttertoast.showToast(msg: "Error while saving your order", backgroundColor: Color(0xFFDDA87E));
    }
  }else{
    Fluttertoast.showToast(msg: "Unable to reach server", backgroundColor: Color(0xFFDDA87E));
  }


} catch(e){

  print(e.toString());
}


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset("images/transaction2.png",
            width: 580,
            ),
              Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Please Attach a Transaction:\n Proof /  Receipt / Screenshot",
                  textAlign: TextAlign.center,
                    style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                  )
              ),

              const SizedBox(height: 30,),
              Material(
                elevation: 8,
                color: Colors.teal,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: (){

                    chooseImageFromGallery();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12
                    ),
                    child: Text(
                      "Select Image",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              // display selected image by user
              Obx(() => ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                  maxHeight: MediaQuery.of(context).size.width * 0.6,

                ),
                child: imageSelectedByte.length > 0 ? Image.memory(imageSelectedByte, fit: BoxFit.contain,) : const Placeholder(color: Colors.white60,),
              )),

             const SizedBox(height: 16,),

              // confirm and proceed Button
              Obx(() =>
                  Material(
                    elevation: 8,
                    color: imageSelectedByte.length > 0 ? Colors.teal : Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () async{
                        if(imageSelectedByte.length > 0){
                          saveNewOrderInfo();

                        }else{
                          Fluttertoast.showToast(msg: "Please attach a transaction proof", backgroundColor: Color(0xFFDDA87E));

                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12
                        ),
                        child: Text(
                          "Confirm And Proceed",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                          ),
                        ),
                      ),

                    ),
                  ))

            ],
          ),
        ),
      ),
    );
  }
}
