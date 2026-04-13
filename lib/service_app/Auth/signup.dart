// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:royalmart/service_app/Auth/Form5.dart';
// import 'package:royalmart/service_app/Auth/widgets/custom_shape.dart';
// import 'package:royalmart/service_app/Auth/widgets/customappbar.dart';
// import 'package:royalmart/service_app/Auth/widgets/responsive_ui.dart';
// import 'package:royalmart/service_app/Auth/widgets/textformfield.dart';
// import 'package:royalmart/service_app/General/AppConstant.dart';
// import 'package:royalmart/service_app/General/Home.dart';

// import 'package:geocoder/geocoder.dart';
// import 'package:geolocator/geolocator.dart';

// import 'package:royalmart/service_app/model/RegisterModel.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:http/http.dart' as http;

// import 'UploadImage.dart';

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   String name;
//   String mobile;
//   bool checkBoxValue = false, flag = false;
//   double _height;
//   double _width;
//   double _pixelRatio;
//   bool _large;
//   bool _medium;
//   TextEditingController namelController = TextEditingController();
//   TextEditingController ShopnamelController = TextEditingController();
//   TextEditingController SHOPADDRESSController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController cityController = TextEditingController();
//   String pinval = "";

//   Future<void> getLocation() async {
//     PermissionStatus permission = await PermissionHandler()
//         .checkPermissionStatus(PermissionGroup.location);

//     if (permission == PermissionStatus.denied) {
//       await PermissionHandler()
//           .requestPermissions([PermissionGroup.locationAlways]);
//     } else if (permission == PermissionStatus.granted) {
//       _getCurrentLocation();
//       // showToast('Access granted');
//     }

//     // var geolocator = Geolocator();

//     //
//     // GeolocationStatus geolocationStatus =
//     // await geolocator.checkGeolocationPermissionStatus();
//     //
//     // switch (geolocationStatus) {
//     //   case GeolocationStatus.denied:
//     //     showToast('denied');
//     //     break;
//     //   case GeolocationStatus.disabled:
//     //     showToast('disabled');
//     //     break;
//     //   case GeolocationStatus.restricted:
//     //     showToast('restricted');
//     //     break;
//     //   case GeolocationStatus.unknown:
//     //     showToast('unknown');
//     //     break;
//     //   case GeolocationStatus.granted:
//     //     showToast('Access granted');
//     //     _getCurrentLocation();
//     // }
//   }

//   Position position;
//   double lat, long;

//   void _getCurrentLocation() async {
//     Position res = await Geolocator.getCurrentPosition();
//     setState(() {
//       position = res;
//       lat = position.latitude;
//       long = position.longitude;
//       ServiceAppConstant.latitude = lat;
//       ServiceAppConstant.longitude = long;

//       getAddress();
//       print(lat);
//       print(long);
//     });
//   }

//   String valArea;
//   getAddress() async {
//     final coordinates = new Coordinates(lat, long);
//     var addresses =
//         await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     var first = addresses.first;
//     setState(() {
//       valArea = first.subLocality +
//           " " +
//           first.subAdminArea.toString() +
//           " " +
//           first.featureName.toString() +
//           " " +
//           first.thoroughfare.toString() +
//           "" +
//           first.postalCode.toString();
//     });
//     print(
//         ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
//     return first;
//   }

//   Future _getEmployee() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     print(ServiceAppConstant.Shop_id);
//     print(namelController.text);
//     print(mobileController.text);
//     print(emailController.text);
//     print(passwordController.text);
//     print(SHOPADDRESSController.text);
//     print(ServiceAppConstant.latitude.toString());
//     print(ServiceAppConstant.longitude.toString());
//     print(cityController.text);
//     print(pinval);

//     var map = new Map<String, dynamic>();
//     map['shop_id'] = ServiceAppConstant.Shop_id;
//     map['name'] = namelController.text;
//     map['mobile'] = mobileController.text;
//     map['email'] = emailController.text;
//     map['password'] = passwordController.text;
//     map['address'] = SHOPADDRESSController.text;
//     map['lat'] = ServiceAppConstant.latitude.toString();
//     map['lng'] = ServiceAppConstant.longitude.toString();
//     map['cities'] = cityController.text;
//     map['pin'] = pinval;
//     final response = await http
//         .post(ServiceAppConstant.base_url + 'api/step3.php', body: map);
//     if (response.statusCode == 200) {
//       final jsonBody = json.decode(response.body);
//       RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));
//       if (user.message.toString() == "User Registered Successfully") {
//         setState(() {
//           flag = false;
//           ServiceAppConstant.user_id = user.userId;
//         });
//         _showLongToast(user.message);
//         pref.setString("email", user.email);
//         pref.setString("name", user.name);
//         pref.setString("city", user.city);
//         pref.setString("address", SHOPADDRESSController.text);
//         print(user.address);
//         pref.setString("mobile", user.username);
//         pref.setString("user_id", user.userId);
//         pref.setString("pp", user.pp);
//         pref.setString("lat", ServiceAppConstant.latitude.toString());
//         pref.setString("lng", ServiceAppConstant.longitude.toString());

//         pref.setBool("isLogin", true);
//         ServiceAppConstant.email = user.email;
//         ServiceAppConstant.name = user.name;
//         ServiceAppConstant.isLogin = true;
//         ServiceAppConstant.image = user.pp;
//         if (user.pp == null) {
//           ServiceAppConstant.image = "";
//         } else {
//           ServiceAppConstant.image = user.pp;
//         }
//         ServiceAppConstant.image = user.pp;

// //        pref.setString("mobile",phoneController.text);

//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ServiceApp()),
//         );
//         // Navigator.push(context, MaterialPageRoute(builder: (context) => Uploadimage(user.userId,user.username)),);
//       } else {
//         _showLongToast(user.message);
//       }
//     } else
//       throw Exception("Unable to get Employee list");
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     gatinfo();
//     getLocation();
//   }

//   void gatinfo() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     name = pref.get("name");
//     mobile = pref.get("mobile");
//     String add = pref.get("address");
//     String lat = pref.get("lat");
//     String lng = pref.get("lng");
//     String pin = pref.get("pin");
//     String city = pref.get("city");
//     setState(() {
//       // namelController.text= name;
//       mobileController.text = mobile;

//       add != null
//           ? SHOPADDRESSController.text = add
//           : SHOPADDRESSController.text = valArea;
//       pinval = pin != null ? pin : "";
//       cityController.text = city != null ? city : "";
//       ServiceAppConstant.latitude = double.parse(lat);
//       ServiceAppConstant.longitude = double.parse(lng);
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       // _showPasswordDialog();
//       print("Hii RAhul");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _height = MediaQuery.of(context).size.height;
//     _width = MediaQuery.of(context).size.width;
//     _pixelRatio = MediaQuery.of(context).devicePixelRatio;
//     _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
//     _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

//     return Material(
//       child: Scaffold(
//         body: Container(
//           height: _height,
//           width: _width,
//           margin: EdgeInsets.only(bottom: 5),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Opacity(opacity: 0.88, child: CustomAppBar()),
//                 // clipShape(),
//                 /*      Container(
//                   margin: EdgeInsets.only(left: 20,right: 20,top: 20),

//                   child: new Text(
//                     'Name',
//                     style: TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 new Container(
//                   margin: EdgeInsets.only(left: 20,right: 20),
//                   child:  TextFormField(
//                     controller:ShopnamelController,
//                     validator: (String value){
//                       if(value.isEmpty){
//                         return " Please enter the name";
//                       }
//                     },
//                     decoration: const InputDecoration(
//                       hintText: "Enter Your Name",
//                     ),


//                   ),
//                 ),*/

//                 Container(
//                   margin: EdgeInsets.only(left: 20, right: 20, top: 20),
//                   child: new Text(
//                     'Enter Address',
//                     style:
//                         TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
//                   child: Container(
//                       child: new TextFormField(
//                           maxLines: 4,
//                           // keyboardType: TextInputType.text, // Use mobile input type for emails.
//                           controller: SHOPADDRESSController,
//                           validator: (String value) {
//                             print("Length${value.length}");
//                             if (value.isEmpty && value.length > 10) {
//                               return " Please enter the  address";
//                             }
//                           },
//                           decoration: new InputDecoration(
//                             hintText: 'Address',
//                             labelText: 'Enter the  address',
//                             focusedBorder: OutlineInputBorder(
//                               borderSide:
//                                   BorderSide(color: Colors.black54, width: 3.0),
//                             ),

// //                                      icon: new Icon(Icons.queue_play_next),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide:
//                                   BorderSide(color: Colors.black54, width: 3.0),
//                             ),
//                           ))),
//                 ),

//                 form(),
//                 // acceptTermsTextRow(),
//                 // SizedBox(height: _height/35,),
//                 button(),
//                 // infoTextRow(),
//                 // socialIconsRow(),
//                 signInTextRow(),
//               ],
//             ),
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

//   Widget form() {
//     return Container(
//       margin: EdgeInsets.only(
//           left: _width / 12.0, right: _width / 12.0, top: _height / 60.0),
//       child: Form(
//         child: Column(
//           children: <Widget>[
//             lastNameTextFormField(),
//             SizedBox(height: _height / 60.0),
//             firstNameTextFormField(),
//             SizedBox(height: _height / 60.0),
//             phoneTextFormField(),
//             SizedBox(height: _height / 60.0),
//             emailTextFormField(),
//             SizedBox(height: _height / 60.0),
//             passwordTextFormField(),
//             SizedBox(height: _height / 60.0),
//             flag ? circularIndi() : Row(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget firstNameTextFormField() {
//     return CustomTextField(
//       obscureText: false,
//       keyboardType: TextInputType.text,
//       textEditingController: namelController,
//       icon: Icons.person,
//       hint: "Name",
//     );
//   }

//   Widget lastNameTextFormField() {
//     return Container(
//       child: InkWell(
//         onTap: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => MyMap1()),
//           );
//         },
//         child: Card(
//           color: ServiceAppColors.tela1,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(5),
//                 child: Icon(Icons.location_on_outlined,
//                     size: 30, color: ServiceAppColors.boxColor1),
//               ),
//               Expanded(
//                   child: Container(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(
//                           top: 10, left: 3, right: 3, bottom: 5),
//                       child: Text(
//                         "Use Current Location",
//                         style: TextStyle(
//                             fontSize: 20,
//                             color: ServiceAppColors.black,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         bottom: 10,
//                         left: 3,
//                         right: 3,
//                       ),
//                       child: Text(
//                         "Add New Address  ",
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: ServiceAppColors.black,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//               Padding(
//                 padding: EdgeInsets.all(5),
//                 child: Icon(Icons.forward,
//                     size: 30, color: ServiceAppColors.boxColor1),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget emailTextFormField() {
//     return CustomTextField(
//       keyboardType: TextInputType.emailAddress,
//       textEditingController: emailController,
//       obscureText: false,
//       icon: Icons.email,
//       hint: "Email ID",
//     );
//   }

//   Widget phoneTextFormField() {
//     return CustomTextField(
//       keyboardType: TextInputType.number,
//       textEditingController: mobileController,
//       obscureText: false,
//       icon: Icons.phone,
//       hint: "Mobile Number",
//     );
//   }

//   Widget passwordTextFormField() {
//     return CustomTextField(
//       keyboardType: TextInputType.text,
//       textEditingController: passwordController,
//       obscureText: true,
//       icon: Icons.lock,
//       hint: "Password",
//     );
//   }

//   Widget acceptTermsTextRow() {
//     return Container(
//       margin: EdgeInsets.only(top: _height / 100.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Checkbox(
//               activeColor: Colors.orange[200],
//               value: checkBoxValue,
//               onChanged: (bool newValue) {
//                 setState(() {
//                   checkBoxValue = newValue;
//                 });
//               }),
//           Text(
//             "I accept all terms and conditions",
//             style: TextStyle(
//                 fontWeight: FontWeight.w400,
//                 fontSize: _large ? 12 : (_medium ? 11 : 10)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget button() {
//     return Container(
//       alignment: Alignment.center,
//       child: RaisedButton(
//         elevation: 0,
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//         onPressed: () {
//           if (namelController.text.length < 2) {
//             _showLongToast("Name is Empty !");
//           } else if (mobileController.text.length != 10) {
//             _showLongToast("Please enter ten desigt No ");
//           } else if (emailController.text.length < 2) {
//             _showLongToast("Enter the email");
//           } else if (passwordController.text.length < 5) {
//             _showLongToast("Password should be at list six desigt");
//           } else if (passwordController.text.length < 3) {
//             _showLongToast("Enter the city name ");
//           } else {
//             setState(() {
//               flag = true;
//             });
//             _getEmployee();
//           }
//         },
//         textColor: Colors.white,
//         padding: EdgeInsets.all(0.0),
//         child: Container(
//           alignment: Alignment.center,
// //        height: _height / 20,
//           width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(20.0)),
//             gradient: LinearGradient(
//               colors: <Color>[ServiceAppColors.tela, ServiceAppColors.tela],
//             ),
//           ),
//           padding: const EdgeInsets.all(12.0),
//           child: Text(
//             'SIGN UP',
//             style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget infoTextRow() {
//     return Container(
//       margin: EdgeInsets.only(top: _height / 40.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             "Or create using social media",
//             style: TextStyle(
//                 fontWeight: FontWeight.w400,
//                 fontSize: _large ? 12 : (_medium ? 11 : 10)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget socialIconsRow() {
//     return Container(
//       margin: EdgeInsets.only(top: _height / 80.0),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           CircleAvatar(
//             radius: 15,
//             backgroundImage: AssetImage("assets/images/googlelogo.png"),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           CircleAvatar(
//             radius: 15,
//             backgroundImage: AssetImage("assets/images/fblogo.jpg"),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           /* CircleAvatar(
//             radius: 15,
//             backgroundImage: AssetImage("assets/images/twitterlogo.jpg"),
//           ),*/
//         ],
//       ),
//     );
//   }

//   Widget signInTextRow() {
//     return Container(
//       margin: EdgeInsets.only(top: _height / 50.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             "Already have an account?",
//             style: TextStyle(fontWeight: FontWeight.w400),
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           GestureDetector(
//             onTap: () {},
//             child: Text(
//               "Sign in",
//               style: TextStyle(
//                   fontWeight: FontWeight.w800,
//                   color: Colors.orange[200],
//                   fontSize: 19),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   void _showLongToast(String s) {
//     Fluttertoast.showToast(
//       msg: s,
//       toastLength: Toast.LENGTH_LONG,
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
