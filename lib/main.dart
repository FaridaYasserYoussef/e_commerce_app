import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/authentication/signup_screen.dart';
import 'package:clothes_app/users/fragments/dashboard_of_fragments.dart';
import 'package:clothes_app/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Clothes app',
      debugShowCheckedModeBanner: false,
      theme:  ThemeData(
         appBarTheme: AppBarTheme(
           centerTitle: true,
           color: Color(0xFFDDA87E),
           titleTextStyle: TextStyle(color: Colors.white, fontSize: 25,  ),

         ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: RememberUserPrefs.readUserInfo(),
        builder: (context, snapshot){
          if(snapshot.data == null){
            return LoginScreen();
          }
          else{
            return DashboardOfFragments();
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Clothes App"),
      ),
    );
  }
}
