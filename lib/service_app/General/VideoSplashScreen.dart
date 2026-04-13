// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:video_player/video_player.dart';

// import 'AppConstant.dart';
// import 'Home.dart';

// class VideoSplashScreen extends StatefulWidget {
//   @override
//   VideoState createState() => VideoState();
// }

// class VideoState extends State<VideoSplashScreen> {
//   VideoPlayerController ?playerController;
//   VoidCallback? listener;

//   @override
//   @override
//   void initState() {
//     getLocation();
//     super.initState();
//     initializeVideo();

//     ///video splash display only 5 second you can change the duration according to your need
//     startTime();
//   }

//   startTime() async {
//     var _duration = new Duration(seconds: 4);
//     return new Timer(_duration, navigationPage);
//   }

//   void navigationPage() {
//     playerController!.setVolume(0.0);
//     //playerController.removeListener(listener);
//     // Navigator.of(context).pop(VIDEO_SPALSH);
//     // Navigator.of(context).pushReplacementNamed(HOME_SCREEN);
//     // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),);
//     checkLogin();
//   }

//   void getLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

//     setState(() {
//       ServiceAppConstant.latitude = position.latitude;
//       ServiceAppConstant.longitude = position.longitude;
//     });
//     print(position);
//   }

//   void checkLogin() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();

//     String ?pin = pref.getString("pin");
//     String ?cityid = pref.getString("cityid");
//     bool? val = pref.getBool("isLogin");

//     pref.setString("lat", ServiceAppConstant.latitude.toString());
//     pref.setString("lng", ServiceAppConstant.longitude.toString());

//     print("cityid.length");
//     print(val);

//     setState(() {
//       cityid == null ? ServiceAppConstant.cityid = "" : ServiceAppConstant.cityid = cityid;
//       ServiceAppConstant.pinid = pin!;
//       val == null ? ServiceAppConstant.isLogin = false : ServiceAppConstant.isLogin = val;
//       // Constant.isLogin==false? Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),):
//       // Constant.isLogin==false? Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()),):
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ServiceApp()),
//       );
//     });

//     // print(cityname);
//   }

//   void initializeVideo() {
//     playerController = VideoPlayerController.asset('assets/videos/welcome.mp4')
//       ..addListener(listener!)
//       ..setVolume(1.0)
//       ..setLooping(false)
//       ..initialize()
//       ..play();
//   }

//   @override
//   void deactivate() {
//     if (playerController != null) {
//       playerController!.setVolume(0.0);
//       playerController!.removeListener(listener!);
//     }
//     super.deactivate();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose

//     playerController!.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: Stack(children: <Widget>[
//           new Column(
//             mainAxisAlignment: MainAxisAlignment.center,

//             // mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
// //              Padding(padding: EdgeInsets.only(bottom: 30.0),child:new Image.asset('assets/images/powered_by.png',height: 25.0,fit: BoxFit.scaleDown,))
//             ],
//           ),
//           // new Column(
//           //   mainAxisAlignment: MainAxisAlignment.center,
//           //   children: <Widget>[
//           //     new Image.asset(
//           //       'assets/images/logo.png',
//           //       width: animation.value * 250,
//           //       height: animation.value * 250,
//           //     ),
//           //   ],
//           // ),
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: (playerController != null
//                 ? VideoPlayer(
//                     playerController!,
//                   )
//                 : Container()),
//           ),
//         ]));
//   }
// }
