// import 'package:flutter/material.dart';
// import 'package:royalmart/General/AppConstant.dart';
// import 'package:royalmart/service_app/Auth/forgetPassword.dart';
// import 'package:royalmart/Auth/signin.dart';
// import 'package:royalmart/service_app/General/AppConstant.dart';
// import 'package:royalmart/service_app/screen/MyReview.dart';
// import 'package:royalmart/service_app/screen/ShowAddress.dart';
// import 'package:royalmart/service_app/screen/changePassword.dart';
// import 'package:royalmart/service_app/screen/editprofile.dart';
// import 'package:royalmart/service_app/screen/myorder.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfileView extends StatefulWidget {
//   final Function changeView;

//   const ProfileView({Key key, this.changeView}) : super(key: key);

//   @override
//   _ProfileViewState createState() => _ProfileViewState();
// }

// class _ProfileViewState extends State<ProfileView> {
//   String name = "";
//   String image;
//   String email = "";
//   String user_id = "";
//   bool isloginv = false;
//   void gatinfo() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();

//     isloginv = pref.get("isLogin");
//     name = pref.get("name");
//     email = pref.get("email");
//     String image = pref.get("pp");
//     String userid = pref.get("user_id");
//     if (isloginv == null) {
//       isloginv = false;
//     }

//     setState(() {
//       user_id = userid;
//       ServiceAppConstant.name = name;
//       ServiceAppConstant.email = email;
//       ServiceAppConstant.isLogin = isloginv;
//       ServiceAppConstant.User_ID = userid;
//       ServiceAppConstant.image = image;
//       // print( "image " +Constant.image);

//       // print(Constant.image.length);
//       // print(Constant.name.length);
//       // print("Constant.name");
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     ServiceAppConstant.isLogin = false;

//     gatinfo();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("Constant.check");
//     print(ServiceAppConstant.check);
//     if (ServiceAppConstant.check) {
//       gatinfo();
//       setState(() {
//         ServiceAppConstant.check = false;
//       });
//     }
//     //
//     return Scaffold(
//       // backgroundColor: Colors.grey[300],
//       body: ListView(
//         children: <Widget>[
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 height: 230,
//                 color: ServiceAppColors.tela1,
//                 child: Column(children: <Widget>[
//                   Align(
//                     alignment: Alignment.center,
//                     child: Container(
//                       margin: EdgeInsets.only(top: 50),
//                       child: CircleAvatar(
//                         radius: 50,
//                         backgroundColor: ServiceAppColors.white,
//                         child: ClipOval(
//                           child: new SizedBox(
//                             width: 120.0,
//                             height: 120.0,
//                             child: ServiceAppConstant.image == null
//                                 ? Image.asset(
//                                     'assets/images/logo.png',
//                                   )
//                                 : ServiceAppConstant.image ==
//                                         'https://www.bigwelt.com/manage/uploads/customers/nopp.png'
//                                     ? Image.asset(
//                                         'assets/images/logo.png',
//                                       )
//                                     : Image.network(ServiceAppConstant.image,
//                                         fit: BoxFit.fill),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(top: 5),
//                     child: Text(
//                       ServiceAppConstant.name == null
//                           ? "Hello Guest"
//                           : ServiceAppConstant.name.length == 1
//                               ? "Hello Guest"
//                               : ServiceAppConstant.name,
//                       style: TextStyle(
//                         color: ServiceAppColors.tela,
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   ServiceAppConstant.isLogin
//                       ? Text(
//                           ServiceAppConstant.email == null
//                               ? " "
//                               : ServiceAppConstant.email,
//                           style: TextStyle(
//                               color: ServiceAppColors.black,
//                               fontWeight: FontWeight.bold),
//                         )
//                       : InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => ForgetPass()),
//                             );
//                           },
//                           child: Padding(
//                               padding: EdgeInsets.only(left: 20),
//                               child: Text(
//                                 "Login",
//                                 style: TextStyle(
//                                     color: ServiceAppColors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20),
//                               )),
//                         ),
//                 ]),
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 20, right: 20, top: 5),
//                 height: 70,
//                 child: InkWell(
//                   onTap: () {
//                     if (ServiceAppConstant.isLogin) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => TrackOrder()),
//                       );
//                     } else {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ForgetPass()),
//                       );
//                     }
//                   },
//                   child: Card(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(left: 10, right: 20),
//                           child: Icon(
//                             Icons.ac_unit,
//                             color: ServiceAppColors.tela,
//                             size: 30.0,
//                           ),
//                         ),
//                         Padding(
//                             padding: EdgeInsets.only(left: 10),
//                             child: Text(
//                               "My Service",
//                               style: TextStyle(
//                                 color: ServiceAppColors.darkGray,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 20, right: 20, top: 5),
//                 height: 70,
//                 child: InkWell(
//                   onTap: () {
//                     if (ServiceAppConstant.isLogin) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ShowAddress("1")),
//                       );
//                     } else {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ForgetPass()),
//                       );
//                     }
//                   },
//                   child: Card(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(left: 10, right: 20),
//                           child: Icon(
//                             Icons.home,
//                             color: ServiceAppColors.tela,
//                             size: 30.0,
//                           ),
//                         ),
//                         Padding(
//                             padding: EdgeInsets.only(left: 10),
//                             child: Text(
//                               "Shipping address ",
//                               style: TextStyle(
//                                 color: ServiceAppColors.darkGray,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 20, right: 20, top: 5),
//                 height: 70,
//                 child: InkWell(
//                   onTap: () {
//                     if (ServiceAppConstant.isLogin) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => MyReview()),
//                       );
//                     } else {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ForgetPass()),
//                       );
//                     }
//                   },
//                   child: Card(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(left: 10, right: 20),
//                           child: Icon(
//                             Icons.streetview,
//                             color: ServiceAppColors.tela,
//                             size: 30.0,
//                           ),
//                         ),
//                         Padding(
//                             padding: EdgeInsets.only(left: 10),
//                             child: Text(
//                               "My review ",
//                               style: TextStyle(
//                                 color: ServiceAppColors.darkGray,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               ///----------------------------------------Login/logout------------------------------------------
//               Container(
//                 margin: EdgeInsets.only(left: 20, right: 20, top: 10),
//                 height: 70,
//                 child: InkWell(
//                   onTap: () {
//                     if (ServiceAppConstant.isLogin) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => EditProfilePage(user_id)),
//                       );
//                     } else {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ForgetPass()),
//                       );
//                     }
//                   },
//                   child: Card(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(left: 10, right: 20),
//                           child: Icon(
//                             Icons.edit,
//                             color: ServiceAppColors.tela,
//                             size: 30.0,
//                           ),
//                         ),
//                         Padding(
//                             padding: EdgeInsets.only(left: 10),
//                             child: Text(
//                               "Update profile ",
//                               style: TextStyle(
//                                 color: ServiceAppColors.darkGray,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               ServiceAppConstant.isLogin
//                   ? Container(
//                       margin: EdgeInsets.only(left: 20, right: 20, top: 5),
//                       height: 70,
//                       child: InkWell(
//                         onTap: () {
//                           _callLogoutData();
//                         },
//                         child: Card(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(left: 10, right: 20),
//                                 child: Icon(
//                                   Icons.exit_to_app,
//                                   color: ServiceAppColors.tela,
//                                   size: 30.0,
//                                 ),
//                               ),
//                               Padding(
//                                   padding: EdgeInsets.only(left: 10),
//                                   child: Text(
//                                     "Logout ",
//                                     style: TextStyle(
//                                       color: ServiceAppColors.darkGray,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                   : Container(
//                       margin: EdgeInsets.only(left: 20, right: 20, top: 5),
//                       height: 70,
//                       child: InkWell(
//                         onTap: () {
//                           if (ServiceAppConstant.isLogin) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => ForgetPass()),
//                             );
//                             // Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()),);

//                           } else {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => ForgetPass()),
//                             );
//                             // Navigator.push(context, MaterialPageRoute(builder: (context) => LocationGenertor()),);
//                           }
//                         },
//                         child: Card(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(left: 10, right: 20),
//                                 child: Icon(
//                                   Icons.power_settings_new,
//                                   color: ServiceAppColors.tela,
//                                   size: 30.0,
//                                 ),
//                               ),
//                               Padding(
//                                   padding: EdgeInsets.only(left: 10),
//                                   child: Text(
//                                     "Login ",
//                                     style: TextStyle(
//                                       color: ServiceAppColors.darkGray,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Future<void> _callLogoutData() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     ServiceAppConstant.isLogin = false;
//     ServiceAppConstant.email = " ";
//     ServiceAppConstant.name = " ";
//     ServiceAppConstant.image = " ";

//     pref.setString("pp", " ");
//     pref.setString("email", " ");
//     pref.setString("name", " ");
//     pref.setBool("isLogin", false);
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => SignInPage()));
//   }
// }
