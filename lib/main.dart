import 'package:flutter/material.dart';
import 'package:royalmart/General/AnimatedSplashScreen.dart';
import 'package:royalmart/Utils.dart';
import 'General/AppConstant.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(
    new MaterialApp(
      title: FoodAppConstant.appname,
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: AnimatedSplashScreen(),
      // home: GroceryApp(),
    ),
  );
  Utils.firstTimeOpen = true;
}
