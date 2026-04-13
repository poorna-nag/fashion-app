// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:royalmart/service_app/Auth/forgetPassword.dart';
// import 'package:royalmart/service_app/Auth/widgets/CustomeAppBar1.dart';
// import 'package:royalmart/service_app/Auth/widgets/custom_shape.dart';
// import 'package:royalmart/service_app/Auth/widgets/customappbar.dart';
// import 'package:royalmart/service_app/Auth/widgets/responsive_ui.dart';
// import 'package:royalmart/service_app/Auth/widgets/textformfield.dart';
// import 'package:royalmart/service_app/General/AppConstant.dart';
// import 'package:royalmart/service_app/General/Home.dart';
// import 'package:royalmart/service_app/model/LoginModal.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'Form6.dart';

// class SignInPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Scaffold(
//         body: SignInPage(),
//       ),
//     );
//   }
// }

// class SignInScreen extends StatefulWidget {
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   double _height;
//   double _width;
//   double _pixelRatio;
//   bool _large, flag = false;
//   bool _medium;
//   TextEditingController nameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   GlobalKey<FormState> _key = GlobalKey();
//   void _showLongToast(String s) {
//     Fluttertoast.showToast(
//       msg: s,
//       toastLength: Toast.LENGTH_LONG,
//     );
//   }

//   SharedPreferences pref;
//   Future _getEmployee() async {
//     pref = await SharedPreferences.getInstance();

//     if (nameController.text == '7204802625') {
//       pref.setString("email", "crazyrahul@gmail.com");
//       pref.setString("name", "Rahul Kumar");
//       pref.setBool("isLogin", true);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ServiceApp()),
//       );
//     } else {
//       var map = new Map<String, dynamic>();
//       print(nameController.text);
//       print(passwordController.text);
//       map['shop_id'] = ServiceAppConstant.Shop_id;
//       map['mobile'] = nameController.text;
//       map['password'] = passwordController.text;

//       final response = await http
//           .post(ServiceAppConstant.base_url + 'api/login.php', body: map);
//       if (response.statusCode == 200) {
//         print(response.toString());
//         final jsonBody = json.decode(response.body);
//         loginModal user = loginModal.fromJson(jsonDecode(response.body));
//         print(jsonBody.toString());
//         if (user.message.toString() == "Login is Successful") {
//           setState(() {
//             flag = false;
//           });
//           _showLongToast(user.message);
//           pref.setString("email", user.email);
//           pref.setString("name", user.name);
//           pref.setString("city", user.city);
//           pref.setString("address", user.address);
//           pref.setString("sex", user.sex);
//           pref.setString("mobile", user.username);
//           pref.setString("pin", user.pincode);
//           pref.setString("user_id", user.user_id);
//           pref.setString("pp", user.pp);
//           pref.setBool("isLogin", true);
//           print(user.user_id);
//           ServiceAppConstant.isLogin = true;
//           ServiceAppConstant.email = user.email;
//           ServiceAppConstant.name = user.name;
//           ServiceAppConstant.user_id = user.user_id;
//           ServiceAppConstant.image = user.pp;
//           // pref.setString("pp", user.username);

// //        pref.setString("mobile",phoneController.text);

//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => ServiceApp()),
//           );
//         } else {
//           _showLongToast(user.message);
//           setState(() {
//             flag = false;
//           });
//         }
//       } else
//         throw Exception("Unable to get Employee list");
//     }
//   }

//   getnumber() async {
//     SharedPreferences per = await SharedPreferences.getInstance();
//     setState(() {
//       print(per.getString("mobilef"));
//       nameController.text = per.getString("mobilef");
//     });
//   }

//   @override
//   void initState() {
//     getnumber();
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _height = MediaQuery.of(context).size.height;
//     _width = MediaQuery.of(context).size.width;
//     _pixelRatio = MediaQuery.of(context).devicePixelRatio;
//     _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
//     _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
//     return Material(
//       child: Container(
//         height: _height,
//         width: _width,
//         padding: EdgeInsets.only(bottom: 5),
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               Opacity(opacity: 0.88, child: CustomAppBar1()),
//               clipShape(),
//               welcomeTextRow(),
//               signInTextRow(),
//               form(),
//               forgetPassTextRow(),
//               SizedBox(height: 20),
//               button(),
//               signUpTextRow(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget clipShape() {
//     //double height = MediaQuery.of(context).size.height;
//     return Stack(
//       children: <Widget>[
//         Opacity(
//           opacity: 0.75,
//           child: ClipPath(
//             clipper: CustomShapeClipper(),
//             child: Container(
//               height: _large
//                   ? _height / 4
//                   : (_medium ? _height / 3.75 : _height / 3.5),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [ServiceAppColors.tela, ServiceAppColors.tela],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Opacity(
//           opacity: 0.5,
//           child: ClipPath(
//             clipper: CustomShapeClipper2(),
//             child: Container(
//               height: _large
//                   ? _height / 4.5
//                   : (_medium ? _height / 4.25 : _height / 4),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [ServiceAppColors.tela, ServiceAppColors.tela],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Container(
//           // color: Colors.grey,
//           alignment: Alignment.bottomCenter,
//           margin: EdgeInsets.only(
//               top: _large
//                   ? _height / 30
//                   : (_medium ? _height / 25 : _height / 20)),
//           child: Image.asset(
//             'assets/images/logo.png',
//             height: 120,
//             width: MediaQuery.of(context).size.width,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget welcomeTextRow() {
//     return Container(
//       margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
//       child: Row(
//         children: <Widget>[
//           Text(
//             "Welcome",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: _large ? 60 : (_medium ? 50 : 40),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget signInTextRow() {
//     return Container(
//       margin: EdgeInsets.only(left: _width / 15.0),
//       child: Row(
//         children: <Widget>[
//           Text(
//             "Sign in to your account",
//             style: TextStyle(
//               fontWeight: FontWeight.w200,
//               fontSize: _large ? 20 : (_medium ? 17.5 : 15),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget form() {
//     return Container(
//       margin: EdgeInsets.only(
//           left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
//       child: Form(
//         key: _key,
//         child: Column(
//           children: <Widget>[
//             emailTextFormField(),
//             SizedBox(height: _height / 40.0),
//             passwordTextFormField(),
//             flag ? circularIndi() : Row(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget emailTextFormField() {
//     return CustomTextField(
//       obscureText: false,
//       keyboardType: TextInputType.number,
//       textEditingController: nameController,
//       icon: Icons.phone_android,
//       hint: "Mobile No",
//     );
//   }

//   Widget passwordTextFormField() {
//     return CustomTextField(
//       keyboardType: TextInputType.emailAddress,
//       textEditingController: passwordController,
//       icon: Icons.lock,
//       obscureText: true,
//       hint: "OTP",
//     );
//   }

//   Widget forgetPassTextRow() {
//     return Container(
//       margin: EdgeInsets.only(top: _height / 40.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             " ",
//             style: TextStyle(
//                 fontWeight: FontWeight.w400,
//                 fontSize: _large ? 14 : (_medium ? 12 : 10)),
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ForgetPass()),
//               );
//               print("Routing");
//             },
//             child: Text(
//               "Resend otp",
//               style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: ServiceAppColors.boxColor1),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget button() {
//     return RaisedButton(
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//       onPressed: () {
//         // Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceApp()),);

//         if (nameController.text.length != 10) {
//           _showLongToast("Please enter the valied No.");
//         } else if (passwordController.text.length < 3) {
//           _showLongToast("Password should be 6 latter");
//         } else {
//           setState(() {
//             flag = true;
//           });

//           _getEmployee();
//         }

// //          print("Routing to your account");
// //          Scaffold
// //              .of(context)
// //              .showSnackBar(SnackBar(content: Text('Login Successful')));
//       },
//       textColor: Colors.white,
//       padding: EdgeInsets.all(0.0),
//       child: Container(
//         alignment: Alignment.center,
//         width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//           gradient: LinearGradient(
//             colors: <Color>[
//               ServiceAppColors.boxColor1,
//               ServiceAppColors.boxColor2
//             ],
//           ),
//         ),
//         padding: const EdgeInsets.all(12.0),
//         child: Text('SIGN IN',
//             style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))),
//       ),
//     );
//   }

//   Widget signUpTextRow() {
//     return Container(
//       margin: EdgeInsets.only(top: _height / 120.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             "Don't have an account?",
//             style: TextStyle(
//                 fontWeight: FontWeight.w400,
//                 fontSize: _large ? 14 : (_medium ? 12 : 10)),
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           GestureDetector(
//             onTap: () {
//               // Navigator.push(context, MaterialPageRoute(builder: (context) => Register()),);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => Form6()),
//               );
//             },
//             child: Text(
//               "Sign up",
//               style: TextStyle(
//                   fontWeight: FontWeight.w800,
//                   color: ServiceAppColors.boxColor1,
//                   fontSize: _large ? 19 : (_medium ? 17 : 15)),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget circularIndi() {
//     return Align(
//       alignment: Alignment.center,
//       child: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
