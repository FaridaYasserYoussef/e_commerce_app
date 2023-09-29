import 'dart:convert';
import 'dart:io';

import 'package:clothes_app/admin/admin_get_all_orders.dart';
import 'package:clothes_app/admin/admin_login.dart';
import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AdminUploadItemsScreen extends StatefulWidget {
  const AdminUploadItemsScreen({Key? key}) : super(key: key);


  @override
  State<AdminUploadItemsScreen> createState() => _AdminUploadItemsScreenState();
}

class _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen> {


  ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ratingController = TextEditingController();
  var tagsController = TextEditingController();
  var priceController = TextEditingController();
  var sizesController = TextEditingController();
  var colorsController = TextEditingController();
  var descriptionController = TextEditingController();
  var imageLink = "";


  clearEverything(){
    nameController.clear();
    ratingController.clear();
    tagsController.clear();
    priceController.clear();
    sizesController.clear();
    colorsController.clear();
    descriptionController.clear();
  }

  // defaultScreen methods
  captureImageWithPhoneCamera() async{
     pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);
     Get.back();
     setState(() {
       pickedImageXFile;
     });
  }

  pickImageFromPhoneGallery() async{
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();
    setState(() {
      pickedImageXFile;
    });
  }

  showDialogBoxForImagePickingAndCapturing(){
    return showDialog(
      context: context,
      builder: (context){
        return SimpleDialog(
          backgroundColor: Colors.black ,
          title: Text(
            "Item Image",
            style: TextStyle(
              color: Color(0xFFDDA87E),
              fontWeight: FontWeight.bold
            ),

          ),
          children: [
            SimpleDialogOption(
              onPressed: (){
                captureImageWithPhoneCamera();
              },
              child:  Text("Capture with Phone Camera",
                style: TextStyle(color: Colors.white) ,
              ),
            ),
            SimpleDialogOption(
              onPressed: (){
                pickImageFromPhoneGallery();
              },
              child:  Text("Pick Image From Phone Gallery",
                style: TextStyle(color: Colors.white) ,
              ),
            ),
            SimpleDialogOption(
              onPressed: (){
                Get.back();
              },
              child:  Text("Cancel",
                style: TextStyle(color: Colors.red) ,
              ),
            )
          ],
        );
      }
    );
  }

  // defaultScreen methods


  Widget defaultScreen(){
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Get.to(LoginScreen());
          },
              icon: Icon(Icons.logout))
        ],
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: (){
            Get.to(AdminGetAllOrdersScreen());
          },
          child: Text(
            "New Orders",
            style: TextStyle(
              fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: false,
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [ Color(0xFFDDA87E), Color(0XFFA4DBD5)])
            )
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0XFFA4DBD5), Color(0xFFDDA87E)])
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SafeArea(child: Center(child: const Icon(Icons.add_photo_alternate, color: Colors.black, size: 200,))),


            Material(

              color: Color(0xFFDDA87E),
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: (){
                  showDialogBoxForImagePickingAndCapturing();
                },
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical:  10,
                      horizontal: 28
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('Add New Item',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
              ),
            )


          ],
        ),
      ),
    );
  }


  uploadItemToDatabase() async{
 List<String> tagsList = tagsController.text.split(',');
 List<String> sizesList = sizesController.text.split(',');
 List<String> colorsList = colorsController.text.split(',');


 try{
   var res = await   http.post(
       Uri.parse(API.addItems),
       body: {
         'name': nameController.text.trim().toString(),
         'rating': ratingController.text.trim().toString(),
         'tags' : tagsList.toString(),
         'price' : priceController.text.trim().toString(),
         'sizes' : sizesList.toString(),
         'colors' : colorsList.toString(),
         'description' : descriptionController.text.trim().toString(),
         'image' : imageLink
       }

   );

   print(res.body);

   if (res.statusCode == 200){
     var resbody = jsonDecode(res.body);
     if(resbody["success"] == true){
       Fluttertoast.showToast(msg: "Item added successfully" , backgroundColor: Color(0xFFDDA87E));
       setState(() {
         pickedImageXFile = null;
       });
       clearEverything();
       Get.to(AdminUploadItemsScreen());

     }
     else{
       Fluttertoast.showToast(msg: "Failed to add Item" , backgroundColor: Color(0xFFDDA87E));
     }
   }

 } catch(e){
   print(e.toString());
 }



  }


  //upload Item Form Screen mehods
  uploadItemImage() async{
 var requestImgurApi = http.MultipartRequest(
    "POST",
    Uri.parse("https://api.imgur.com/3/image")
  );


 String imageName = DateTime.now().microsecondsSinceEpoch.toString();
 requestImgurApi.fields['title'] = imageName;
 requestImgurApi.headers['Authorization'] = "Client-ID " + "713840aae8f33eb";
 var imageFile = await http.MultipartFile.fromPath('image', pickedImageXFile!.path, filename:  imageName);
 requestImgurApi.files.add(imageFile);
 var responseFromImgurApi = await requestImgurApi.send();
var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
var resultFromImurApi = String.fromCharCodes(responseDataFromImgurApi);
print("Result:: ");
print(resultFromImurApi);

Map<String, dynamic> jsonResponse  = json.decode(resultFromImurApi);
 imageLink = (jsonResponse["data"]["link"]).toString();
 String deleteHash = (jsonResponse["data"]["deletehash"]).toString();

 uploadItemToDatabase();


  }

  Widget uploadItemFormScreen(){
    return Scaffold(
      appBar:  AppBar(
        actions: [
          TextButton(onPressed: (){
            Fluttertoast.showToast(msg: 'Uploading Now...',  backgroundColor: Color(0xFFDDA87E));
            uploadItemImage();
          },
              child: Text("Done",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
              ))
        ],
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: (){
            setState(() {
              pickedImageXFile = null;
            });
            Get.to(AdminUploadItemsScreen());
          },
        ),

        title: Text(
          "Upload A New Item",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [ Color(0xFFDDA87E), Color(0XFFA4DBD5)])
            )
        ),
      ),
    backgroundColor:  Color(0xFFDDA87E),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height *0.4,
            width: MediaQuery.of(context).size.width *0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(pickedImageXFile!.path),
                ),
                fit: BoxFit.cover
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(
                      Radius.circular(60)
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, -3)
                    )
                  ]
              ),

              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: TextFormField(
                              controller: nameController,
                              validator: (val) => val == "" ? "Please write an Item name" : null ,
                              decoration: InputDecoration(
                                  hintText: 'Item Name',
                                  prefixIcon: Icon(
                                    Icons.title,
                                    color: Colors.black,

                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: TextFormField(
                              controller: ratingController,
                              validator: (val) => val == "" ? "Please give the item a rating" : null ,
                              decoration: InputDecoration(
                                  hintText: 'Item Rating',
                                  prefixIcon: Icon(
                                    Icons.rate_review,
                                    color: Colors.black,

                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: TextFormField(
                              controller: tagsController,
                              validator: (val) => val == "" ? "Please give the item tags" : null ,
                              decoration: InputDecoration(
                                  hintText: 'Item Tags',
                                  prefixIcon: Icon(
                                    Icons.tag,
                                    color: Colors.black,

                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: TextFormField(
                              controller: priceController,
                              validator: (val) => val == "" ? "Please give the item a price" : null ,
                              decoration: InputDecoration(
                                  hintText: 'Item Price',
                                  prefixIcon: Icon(
                                    Icons.price_change_outlined,
                                    color: Colors.black,

                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: TextFormField(
                              controller: sizesController,
                              validator: (val) => val == "" ? "Please provide the available sizes" : null ,
                              decoration: InputDecoration(
                                  hintText: 'Item Sizes',
                                  prefixIcon: Icon(
                                    Icons.picture_in_picture,
                                    color: Colors.black,

                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: TextFormField(
                              controller: colorsController,
                              validator: (val) => val == "" ? "Please provide the available colors" : null ,
                              decoration: InputDecoration(
                                  hintText: 'Item Colors',
                                  prefixIcon: Icon(
                                    Icons.color_lens,
                                    color: Colors.black,

                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: TextFormField(
                              controller: descriptionController,
                              validator: (val) => val == "" ? "Please provide a description for the Item" : null ,
                              decoration: InputDecoration(
                                  hintText: 'Item Description',
                                  prefixIcon: Icon(
                                    Icons.description,
                                    color: Colors.black,

                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: Colors.white60)
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                            ),
                          ),


                          SizedBox(height: 25,),


                          Material(
                            color: Color(0XFFA4DBD5),
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: () {

                                if(formKey.currentState!.validate())
                                {
                                  Fluttertoast.showToast(msg: 'Uploading Now...',  backgroundColor: Color(0xFFDDA87E));
                                   uploadItemImage();




                                }

                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:  10,
                                    horizontal: 28
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: Text('Upload Now',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )


                        ],

                      ),
                    ),

                    SizedBox(height: 16,),



                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );

  }


  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null ?  defaultScreen() : uploadItemFormScreen();
  }
}
