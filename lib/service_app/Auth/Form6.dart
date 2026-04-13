// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geocoder/model.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;

// // import 'package:country_code_picker/country_code.dart';
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:royalmart/service_app/Auth/widgets/custom_shape.dart';
// import 'package:royalmart/service_app/Auth/widgets/customappbar.dart';
// import 'package:royalmart/service_app/Auth/widgets/responsive_ui.dart';
// import 'package:royalmart/service_app/General/AppConstant.dart';
// import 'package:royalmart/service_app/General/Home.dart';
// import 'package:royalmart/service_app/model/RegisterModel.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'package:pin_entry_text_field/pin_entry_text_field.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../grocery/General/AppConstant.dart';

// class Form6 extends StatefulWidget {
//   @override
//   _Form6State createState() => _Form6State();
// }

// class _Form6State extends State<Form6> {
//   final updatephoneControler = TextEditingController();
//   final nameController = TextEditingController();

//   String result = " ";
//   void _onCountryChange(CountryCode countryCode) {
// //    this.phoneNumber =  countryCode.toString();
//     print("New Country selected: " + countryCode.toString());
//   }

//   String photo = "", currentText = "";
//   bool flag = true;
//   bool flag1 = false;

//   @override
//   void initState() {
//     getLocation();
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   void dispose() {
//     updatephoneControler.dispose();
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _height = MediaQuery.of(context).size.height;
//     _width = MediaQuery.of(context).size.width;
//     _pixelRatio = MediaQuery.of(context).devicePixelRatio;
//     _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
//     _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
//     return Material(
//       child: flag
//           ? Container(
//               height: _height,
//               width: _width,
//               padding: EdgeInsets.only(bottom: 5),
//               color: Colors.white,
//               child: new SingleChildScrollView(
//                 child: Container(
//                   // margin:EdgeInsets.only(left: 20,right: 20,top: 40) ,

//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Opacity(opacity: 0.88, child: CustomAppBar()),
//                       clipShape(),
//                       getTitle("Enter your  Name"),
//                       Container(
//                           margin: EdgeInsets.only(left: 20, right: 20),
//                           child: Padding(
//                             padding: EdgeInsets.only(right: 20, left: 0),
//                             child: TextField(
//                               // onChanged:(String str){
//                               //   setState((){
//                               //     print(str);
//                               //     result = str;
//                               //   });
//                               // } ,
//                               // onSubmitted: (String str){
//                               //   setState((){
//                               //     print(str);
//                               //     result = str;
//                               //   });
//                               // },
//                               controller: nameController,
//                               // maxLength: 10,
//                               // minLines: 1,
//                               keyboardType: TextInputType.text,
//                               cursorColor: Theme.of(context).primaryColor,
//                               decoration:
//                                   new InputDecoration(helperText: 'Enter Name'),
//                             ),
//                           )),
//                       getTitle("Enter your Phone number"),
//                       new Row(
//                         children: <Widget>[
//                           new Expanded(
//                             flex: 3,
//                             child: Padding(
//                               padding: EdgeInsets.only(left: 10),
//                               child: CountryCodePicker(
//                                 onChanged: _onCountryChange,
//                                 // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
//                                 initialSelection: 'IN',
//                                 favorite: ['+91', 'IN'],
//                                 // optional. Shows only country name and flag
//                                 showCountryOnly: false,
//                                 // optional. Shows only country name and flag when popup is closed.
//                                 showOnlyCountryWhenClosed: false,
//                                 // optional. aligns the flag and the Text left
//                                 alignLeft: false,
//                               ),
//                             ),
//                           ),
// //                        new SizedBox(
// //                          width: ScreenUtil().setWidth(20.0),
// //                        ),
//                           new Expanded(
//                               flex: 7,
//                               child: Padding(
//                                 padding: EdgeInsets.only(right: 20, left: 20),
//                                 child: TextField(
//                                   onChanged: (String str) {
//                                     setState(() {
//                                       print(str);
//                                       result = str;
//                                     });
//                                   },
//                                   onSubmitted: (String str) {
//                                     setState(() {
//                                       print(str);
//                                       result = str;
//                                     });
//                                   },
//                                   controller: updatephoneControler,
//                                   maxLength: 10,
//                                   minLines: 1,
//                                   keyboardType: TextInputType.number,
//                                   cursorColor: Theme.of(context).primaryColor,
//                                   decoration: new InputDecoration(
//                                       helperText: 'Phone number'),
//                                 ),
//                               )),
//                         ],
//                       ),
//                       result.length == 10
//                           ? InkWell(
//                               onTap: () async {
//                                 if (this.mounted) {
//                                   setState(() async {
// //
//                                     SharedPreferences sharedPreferences =
//                                         await SharedPreferences.getInstance();
//                                     sharedPreferences.setString(
//                                         "mobile", updatephoneControler.text);
//                                     // _checkuserName();
//                                     nameController.text.length > 2
//                                         ? _getEmployee()
//                                         : showLongToast(
//                                             "Please enter the name");
// //                          Navigator.push(context,
// //                              new MaterialPageRoute(builder: (context) => Form1()));
//                                   });
//                                 }
//                               },
//                               child: Center(
//                                 child: Container(
//                                   margin: EdgeInsets.only(bottom: 10, top: 10),
//                                   padding:
//                                       EdgeInsets.only(bottom: 10, right: 10),
//                                   decoration: new BoxDecoration(
//                                     color: ServiceAppColors.tela,
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: getTitle1("Continue"),
//                                 ),
//                               ),
//                             )
//                           : Center(
//                               child: Container(
//                                 margin: EdgeInsets.only(bottom: 10, top: 10),
//                                 padding: EdgeInsets.only(bottom: 10, right: 10),
//                                 decoration: new BoxDecoration(
//                                   color: Colors.grey[300],
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: getTitle1("Continue"),
//                               ),
//                             ),
//                     ],
//                   ),
//                 ),
//               ))
//           : Material(
//               child: Container(
//                 height: _height,
//                 width: _width,
//                 padding: EdgeInsets.only(bottom: 5),
//                 // margin: EdgeInsets.only(top: 100),
//                 child: SingleChildScrollView(
//                   child: Container(
//                     // padding: EdgeInsets.all(6),
//                     // margin: EdgeInsets.all(8),
//                     child: Column(
//                       children: [
//                         Opacity(opacity: 0.88, child: CustomAppBar()),
//                         clipShape(),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(top: 18.0),
//                               child: Text(
//                                 "Enter the code send to",
//                                 style: TextStyle(fontSize: 18.0),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                   left: 3.0, top: 18.0, right: 0.0, bottom: 0),
//                               child: Text(
//                                 updatephoneControler.text != null
//                                     ? updatephoneControler.text
//                                     : " ",
//                                 style: TextStyle(
//                                     fontSize: 18.0,
//                                     fontWeight: FontWeight.normal,
//                                     color: ServiceAppColors.tela),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Container(
// //                        color: Colors.white,
//                           alignment: Alignment.center,
//                           width: 260,
//                           padding:
//                               EdgeInsets.only(left: 10, bottom: 10, top: 20),
//                           child: PinEntryTextField(
// //                isTextObscure: true,
//                             showFieldAsBox: true,
//                             fields: 5,

//                             onSubmit: (String pin) {
//                               setState(() {
//                                 currentText = pin;
//                                 print(currentText);
//                               });
//                             }, // end onSubmit
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(top: 18.0),
//                               child: Text(
//                                 "Didn't receive the code? ",
//                                 style: TextStyle(fontSize: 13.0),
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   flag = true;
//                                   result = "1234567890";
//                                 });
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 5.0,
//                                     top: 18.0,
//                                     right: 0.0,
//                                     bottom: 0),
//                                 child: Text(
//                                   "RESEND",
//                                   style: TextStyle(
//                                       fontSize: 13.0,
//                                       fontWeight: FontWeight.normal,
//                                       color: Colors.green),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         flag1 ? circularIndi() : Row(),
//                         Center(
//                           child: Container(
//                             width: 120,
//                             height: 40,
//                             margin: EdgeInsets.only(top: 15, bottom: 15),
//                             padding: EdgeInsets.only(
//                                 left: 10, right: 10, top: 5, bottom: 5),
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(25),
//                               color: ServiceAppColors.tela,
//                             ),
//                             child: InkWell(
//                                 onTap: () {
//                                   // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()),);

//                                   if (currentText.length == 5) {
//                                     _getEmployeeotp();
//                                     setState(() {
//                                       flag1 = true;
//                                     });
//                                   } else {
//                                     showLongToast("Please Enter  the otp!");
//                                     setState(() {
//                                       flag1 = false;
//                                     });
//                                   }

// //                           Navigator.of(context).push(new SecondPageRoute());
// //                               Navigator.push(context, MaterialPageRoute(builder: (context) => Form1()));
//                                 },
//                                 child: Text(
//                                   "VERIFY",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       letterSpacing: 1.2,
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 20),
//                                 )),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   Future _getEmployee() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     print(updatephoneControler.text);
//     var map = new Map<String, dynamic>();
//     map['shop_id'] = ServiceAppConstant.Shop_id;
//     map['name'] = nameController.text;
//     map['mobile'] = updatephoneControler.text;
//     final response = await http
//         .post(ServiceAppConstant.base_url + 'api/step1.php', body: map);
//     if (response.statusCode == 200) {
//       final jsonBody = json.decode(response.body);
//       print(jsonBody.toString());
//       User user = User.fromJson(jsonDecode(response.body));
//       if (user.message.toString() == "OTP Sent Successfully") {
//         showLongToast(user.message);
//         setState(() {
//           flag = false;
//         });
//       } else {
//         showLongToast(user.message);
//         print(user.message);
//       }
//     } else
//       throw Exception("Unable to get Employee list");
//   }

//   Future<List<OtpModal>> _getEmployeeotp() async {
//     print(currentText);
//     var map = new Map<String, dynamic>();
//     map['shop_id'] = ServiceAppConstant.Shop_id;
//     map['otp'] = currentText;
//     map['mobile'] = updatephoneControler.text;
//     final response = await http
//         .post(ServiceAppConstant.base_url + 'api/step2.php', body: map);
//     if (response.statusCode == 200) {
//       final jsonBody = json.decode(response.body);
//       print(jsonBody);
//       OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
//       if (user.message.toString() == "OTP Verified Successfully.") {
//         // showLongToast(user.message);
//         _getEmploye();
//         // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()),);
//       } else {
//         showLongToast(user.message);
//       }
//     } else
//       throw Exception("Unable to get Employee list");
//   }

//   Future _getEmploye() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     print(ServiceAppConstant.Shop_id);
//     // print(namelController.text);
//     // print(mobileController.text);
//     // print(emailController.text);
//     // print(passwordController.text);
//     // print(SHOPADDRESSController.text);
//     // print(Constant.latitude.toString());
//     // print(Constant.longitude.toString());
//     // print(cityController.text);
//     // print(pinval);

//     var map = new Map<String, dynamic>();
//     map['shop_id'] = ServiceAppConstant.Shop_id;
//     map['name'] = nameController.text;
//     map['mobile'] = updatephoneControler.text;
//     map['email'] = "";
//     map['password'] = "";
//     map['address'] = valArea != null ? valArea : "";
//     map['lat'] = lat != null ? lat.toString() : 00;
//     map['lng'] = long != null ? long.toString() : 00;
//     map['cities'] = city != null ? city : "";
//     map['pin'] = pincode != null ? pincode : "";
//     final response = await http
//         .post(ServiceAppConstant.base_url + 'api/step3.php', body: map);
//     if (response.statusCode == 200) {
//       final jsonBody = json.decode(response.body);
//       RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));
//       if (user.message.toString() == "User Registered Successfully") {
//         setState(() {
//           flag = false;
//           flag1 = false;
//           ServiceAppConstant.user_id = user.userId;
//         });
//         showLongToast(user.message);
//         pref.setString("email", user.email);
//         pref.setString("name", user.name);
//         pref.setString("city", user.city);
//         // pref.setString("address", SHOPADDRESSController.text);
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
//         showLongToast(user.message);

//         setState(() {
//           flag = false;
//           flag1 = false;
//         });
//       }
//     } else
//       throw Exception("Unable to get Employee list");
//   }

// /*
//   Future<List<OtpModal>> _getEmployeeotp() async {
// setState(() {
//   flag1= true;
// });
//     var map = new Map<String, dynamic>();
//     // map['shop_id']=Constant.Shop_id;
//     map['otp']=currentText   ;
//     map['mobile']= updatephoneControler.text;
//     final response = await http.post(Constant.base_url+'api/cpsms.php',body:map);
//     if (response.statusCode == 200) {

//       final jsonBody = json.decode(response.body);
//       print(jsonBody.toString());
//       OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
//       if(user.message.toString()== "OTP Verified Successfully." )
//       {
//         setState(() {
//           flag1= false;
//         });
//         showLongToast(user.message);
//         Navigator.push(context, MaterialPageRoute(builder: (context) => Form1()));


//       }
//       else {
//         setState(() {
//           flag1= false;
//         });
//         showLongToast(user.message);

//       }

//     } else
//       throw Exception("Unable to get Employee list");
//   }
// */

//   Widget getTitle(String title) {
//     return Padding(
//       padding: EdgeInsets.only(left: 20, top: 10),
//       child: Text(
//         title,
//         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget getTitle1(String title) {
//     return Padding(
//       padding: EdgeInsets.only(left: 20, top: 10),
//       child: Text(
//         title,
//         style: TextStyle(
//             fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
//       ),
//     );
//   }

//   double _height;
//   double _width;
//   double _pixelRatio;
//   bool _large;
//   bool _medium;

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
//                   colors: [
//                     ServiceAppColors.boxColor1,
//                     ServiceAppColors.boxColor2
//                   ],
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
//                   colors: [
//                     ServiceAppColors.boxColor1,
//                     ServiceAppColors.boxColor2
//                   ],
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
//   }

//   Position position;
//   Widget _child;
//   double lat, long;
//   // bool flag = false;
//   String pincode;
//   String city;
//   void _getCurrentLocation() async {
//     Position res = await Geolocator.getCurrentPosition();
//     setState(() {
//       position = res;
//       lat = position.latitude;
//       long = position.longitude;
//       ServiceAppConstant.latitude = lat;
//       ServiceAppConstant.longitude = long;
//       getAddress();
//     });
//   }

//   SharedPreferences pref;

//   String valArea;
//   getAddress() async {
//     pref = await SharedPreferences.getInstance();

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
//           first.thoroughfare.toString();
//       pincode = first.postalCode.toString();
//       city = first.subLocality.toString();
//       pref.setString("address", valArea);
//       pref.setString("lat", lat.toString());
//       pref.setString("lng", long.toString());
//       pref.setString("pin", first.postalCode.toString());
//       pref.setString("city", first.subLocality.toString());
//     });
//     print(
//         ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
//     return first;
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
