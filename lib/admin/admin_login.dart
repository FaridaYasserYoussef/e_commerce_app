
import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/authentication/signup_screen.dart';
import 'package:clothes_app/users/model/user.dart';
import 'package:clothes_app/users/userPreferences/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../users/fragments/dashboard_of_fragments.dart';
import 'admin_upload_items.dart';


class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObscure = true.obs;


  loginAdminNow() async{

    try{
      var res = await http.post(
          Uri.parse(API.adminLogin),
          body: {
            'admin_email': emailController.text.trim(),
            'admin_password' : passwordController.text.trim()
          }
      );


      if(res.statusCode == 200){
        var responseBodyOfLogin = jsonDecode(res.body);
        if(responseBodyOfLogin["success"] == true){
          Fluttertoast.showToast(msg: "Logged in Successfully", backgroundColor: Color(0xFFDDA87E));
          emailController.clear();
          passwordController.clear();


          Future.delayed(Duration(milliseconds: 2000), (){
            Get.to(AdminUploadItemsScreen());

          });

        }
        else if(responseBodyOfLogin["success"] == false){
          Fluttertoast.showToast(msg: "Invalid Email or Password", backgroundColor: Color(0xFFDDA87E));
        }

      }



    }
    catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF92C4C5),
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body:
      LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: constraints.maxHeight
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 285,
                    child:    Image(width: MediaQuery.of(context).size.width, fit: BoxFit.cover ,image: AssetImage('images/admin.jpg'),),
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
                                      controller: emailController,
                                      validator: (val) => val == "" ? "Please write an email" : null ,
                                      decoration: InputDecoration(
                                          hintText: 'Email',
                                          prefixIcon: Icon(
                                            Icons.email,
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
                                    child: Obx(
                                            ()=> TextFormField(
                                          obscureText: isObscure.value,
                                          controller: passwordController,
                                          validator: (val) => val == "" ? "Please write a password" : null ,
                                          decoration: InputDecoration(
                                              hintText: 'Password',
                                              prefixIcon: Icon(
                                                Icons.vpn_key_sharp,
                                                color: Colors.black,

                                              ),
                                              suffixIcon: Obx(
                                                    ()=> GestureDetector(
                                                  onTap: (){
                                                    isObscure.value = !isObscure.value;
                                                  },
                                                  child: Icon(
                                                    isObscure.value ? Icons.visibility_off : Icons.visibility,
                                                    color: Colors.black ,
                                                  ),
                                                ),

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
                                        )
                                    ),
                                  ),

                                  SizedBox(height: 25,),


                                  Material(
                                    color: Color(0xFFDDA87E),
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: (){

                                        if(formKey.currentState!.validate()){
                                          loginAdminNow();

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
                                          child: Text('Login',
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

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('I am not an admin', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                                TextButton(onPressed: (){
                                  Get.to(LoginScreen());

                                },
                                    child: Text('Click Here', style: TextStyle(color: Colors.teal[500], fontSize: 16), ))
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),

            ),
          );
        },
      ),
    );
  }
}
