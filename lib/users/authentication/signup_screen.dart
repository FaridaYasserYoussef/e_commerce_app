
import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var isObscure = true.obs;

  registerAndSaveUserRecord() async{

    print("in register");

    User userModel = User(
        1,
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim()
    );

    try{
      var res = await http.post(
       Uri.parse(API.signup),
       body: userModel.toJson()
      );

      if(res.statusCode == 200){
        print("in status code if");
       var resBodyOfSignup = jsonDecode(res.body);
       print(resBodyOfSignup);
       if(resBodyOfSignup["success"] == true){
         Fluttertoast.showToast(msg: "Registered Successfully", backgroundColor: Color(0xFFDDA87E));
         setState(() {
           nameController.clear();
           emailController.clear();
           passwordController.clear();
         });
       }
       else{
         Fluttertoast.showToast(msg: "An error occurred while signing you up, please try again.", backgroundColor: Color(0xFFDDA87E));

       }


      }
      
    }

    catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Color(0xFFDDA87E));
    }


  }

  validateUserEmail() async{

    try{
     var res =  await http.post(
        Uri.parse(API.validateEmail),
        body: {
          'user_email': emailController.text.trim(),
        }
      );


      if(res.statusCode == 200){
        var resBodyOfValidateEmail = jsonDecode(res.body);
        print("response body is ");
        print(resBodyOfValidateEmail);
        if(resBodyOfValidateEmail["emailFound"] == true){ // success is equal to true
          Fluttertoast.showToast(msg: "Email is already in use. Try another email.", backgroundColor: Color(0xFFDDA87E));

        }
        else{
           registerAndSaveUserRecord();
        }

      }

    }
    catch(e){
      print("in validate catch");
    print(e.toString());
    Fluttertoast.showToast(msg: e.toString(), backgroundColor: Color(0xFFDDA87E));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF9F0),
      appBar: AppBar(
        backgroundColor: Color(0XFFA4DBD5),
        title: Text('Signup Screen'),
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
                    child:    Image(width: MediaQuery.of(context).size.width, fit: BoxFit.cover ,image: AssetImage('images/signup.jpg'),),
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
                                      validator: (val) => val == "" ? "Please write your name" : null ,
                                      decoration: InputDecoration(
                                          hintText: 'Full Name',
                                          prefixIcon: Icon(
                                            Icons.person,
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
                                    color: Color(0XFFA4DBD5),
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: (){
                                        if(formKey.currentState!.validate()){
                                          validateUserEmail();
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
                                          child: Text('Signup',
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
                                Text('Already have an account?', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                                TextButton(onPressed: (){
                                  Get.to(LoginScreen());
                                },
                                    child: Text('Login Here', style: TextStyle(color: Colors.teal[500], fontSize: 16), ))
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
