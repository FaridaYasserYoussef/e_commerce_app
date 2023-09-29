import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:clothes_app/users/userPreferences/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProfileFragmentScreen extends StatelessWidget {

  CurrentUser _currentUser = Get.put(CurrentUser());
  
  signOutUser() async{
  var resultResponse =   await Get.dialog(
      AlertDialog(
        backgroundColor: Color(0xFFDDA87E),
        title: Text(
            "Logout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        content: Text("Are you sure \n You want to logout"),
        actions: [
          TextButton(onPressed: (){
            Get.back();
          },
              child: Text(
                  "No",
                style: TextStyle(color: Colors.black),

              )),
          TextButton(
              onPressed: (){
              Get.back(result: "LoggedOut");
              },
              child: Text(
                "Yes",
               style: TextStyle(color: Colors.black)

              ))
        ],
      )
    );

  if(resultResponse == "LoggedOut"){
   await RememberUserPrefs.removeUserInfo().then((value) {
     Get.off(LoginScreen());
   });
  }

  }

  Widget userInfoItemProfile(IconData iconData, String userData){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color:  Color(0XFFA4DBD5)
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8
      ),
      child: Row(
        children: [
          Icon(iconData,size: 30, color: Colors.black,),
          SizedBox(width: 16,),
          Text(userData, style:  TextStyle(fontSize: 15),)
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(32),
      children: [
        Center(
          child: Image.asset("images/woman.png"),
        ),
        SizedBox(
          height: 20,
        ),
        userInfoItemProfile(Icons.person, _currentUser.user.user_name),
        SizedBox(height: 20,),
        userInfoItemProfile(Icons.email, _currentUser.user.user_email),
        SizedBox(height: 20,),

        Center(
          child: Material(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(5),
            child: InkWell(
              onTap: (){
                signOutUser();
              },
              borderRadius: BorderRadius.circular(32),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12
                ),
                child: Text("Sign Out", style: TextStyle(color: Colors.white, fontSize: 16),),
              ),
            ),
          ),
        )



      ],
    );
  }
}
