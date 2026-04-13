// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:royalmart/grocery/General/Home.dart';
// import 'package:royalmart/service_app/Auth/signin.dart';
// import 'package:royalmart/service_app/dbhelper/database_helper.dart';
// import 'package:royalmart/service_app/model/CategaryModal.dart';

// import 'package:royalmart/service_app/model/productmodel.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'AppConstant.dart';
// import 'Home.dart';

// class AnimatedSplashScreen extends StatefulWidget {
//   @override
//   SplashScreenState createState() => new SplashScreenState();
// }

// class SplashScreenState extends State<AnimatedSplashScreen>
//     with SingleTickerProviderStateMixin {
//   static List<Products> filteredUsers =  [];
//   static List<Categary> listcat = <Categary>[];

//   var _visible = true;
//   String? logincheck;

//   void getLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     setState(() {
//       ServiceAppConstant.latitude = position.latitude;
//       ServiceAppConstant.longitude = position.longitude;
//     });
//     print(position);
//   }

//   void checkLogin() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();

//     String? pin = pref.getString("pin");
//     String? cityid = pref.getString("cityid");
//     bool ?val = pref.getBool("isLogin");

//     pref.setString("lat", ServiceAppConstant.latitude.toString());
//     pref.setString("lng", ServiceAppConstant.longitude.toString());

//     print("cityid.length");
//     print(val);

//     setState(() {
//       // cityid==null?Constant.cityid="": Constant.cityid=cityid;
//       ServiceAppConstant.pinid = pin!;
//       val == null
//           ? ServiceAppConstant.isLogin = false
//           : ServiceAppConstant.isLogin = val;
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ServiceApp()),
//       );
//       // Constant.isLogin==false? Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),):
//       // Constant.isLogin==false? Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()),):
//       // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),);
//     });

//     // print(cityname);
//   }

//   AnimationController? animationController;
//   Animation<double>? animation;
//   startTime() async {
//     var _duration = new Duration(seconds: 2);
//     return new Timer(_duration, navigationPage);
//   }

//   void navigationPage() {
//     checkLogin();
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => GroceryApp()),
//     );
//     // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),);
//     // Navigator.push(context, MaterialPageRoute(builder: (context) => SelectButton()),);

//     /* Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => LoginPage()),
//         );*/
//   }

//   @override
//   void initState() {
//     super.initState();

//     getLocation();

//     DatabaseHelper.getData("0").then((usersFromServe) {
//       if (this.mounted) {
//         setState(() {
//           listcat = usersFromServe!;
//         });
//       }
//     });

//     search("", "").then((usersFromServe) {
//       setState(() {
//         filteredUsers = usersFromServe!;
// //        print(filteredUsers.length.toString()+" jkjg");
//       });
//     });
//     animationController = new AnimationController(
//         vsync: this, duration: new Duration(seconds: 2));
//     animation =
//         new CurvedAnimation(parent: animationController!, curve: Curves.easeOut);

//     animation!.addListener(() => this.setState(() {}));
//     animationController!.forward();

//     setState(() {
//       _visible = !_visible;
//     });
//     startTime();
// //    checkLogin();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ServiceAppColors.white,
//       body: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           new Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
// //              Padding(padding: EdgeInsets.only(bottom: 30.0),child:new Image.asset('assets/images/powered_by.png',height: 25.0,fit: BoxFit.scaleDown,))
//             ],
//           ),
//           new Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               new Image.asset(
//                 "assets/images/ssplash.gif",
//                 width: animation!.value * 250,
//                 height: animation!.value * 250,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
