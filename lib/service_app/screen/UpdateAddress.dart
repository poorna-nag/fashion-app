// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:http/http.dart' as http;
// import 'package:royalmart/service_app/Auth/signin.dart';
// import 'package:royalmart/service_app/General/AppConstant.dart';
// import 'package:royalmart/service_app/model/AddressModel.dart';
// import 'package:royalmart/service_app/model/RegisterModel.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// import 'ShowAddress.dart';

// class UpDateAddress extends StatefulWidget {
//   final UserAddress address;
//   final String valu;
//   const UpDateAddress(this.address, this.valu) : super();
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<UpDateAddress> {
//   bool _status = false;
//   final FocusNode myFocusNode = FocusNode();
//   Future<File> file;
//   String status = '';
//   String base64Image, imagevalue;
//   File _image, imageshow1;
//   String errMessage = 'Error Uploading Image';
//   String user_id;
//   String url = "http://chuteirafc.cartacapital.com.br/wp-content/uploads/2018/12/15347041965884.jpg";

//   var _formKeyad = GlobalKey<FormState>();

//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final stateController = TextEditingController();
//   final passwordController = TextEditingController();
//   final pincodeController = TextEditingController();
//   final mobileController = TextEditingController();
//   final cityController = TextEditingController();
//   final profilescaffoldkey = new GlobalKey<ScaffoldState>();
//   final address1 = TextEditingController();
//   final address2 = TextEditingController();
//   final labelController = TextEditingController();

//   String _dropDownValue1;
//   Future<File> profileImg;

//   int selectedRadio = 1;

//   Widget _child;
//   Position position;
//   double lat, long;
//   GoogleMapController _controller;

//   void _getCurrentLocation() async {
//     Position res = await Geolocator.getCurrentPosition();
//     setState(() {
//       position = res;
//       lat = position.latitude;
//       long = position.longitude;
//       ServiceAppConstant.latitude = lat;
//       ServiceAppConstant.longitude = long;
//       ;
//       print(ServiceAppConstant.latitude.toString());
//       print(ServiceAppConstant.longitude.toString());
//       _child = _mapWidget();
//     });
//   }

//   Widget _mapWidget() {
//     return GoogleMap(
//       mapType: MapType.normal,
//       markers: _createMarker(),
//       zoomGesturesEnabled: true,

//       // tiltGesturesEnabled: false,
// //      onCameraMove: ((position) => _updatePosition(position)),
//       initialCameraPosition: CameraPosition(
//         target: LatLng(position.latitude, position.longitude),
//         zoom: 16.0,
//       ),
//       onMapCreated: (GoogleMapController controller) {
//         _controller = controller;
//         // _controller.setMapStyle('[{"featureType": "all","stylers": [{ "color": "#C0C0C0" }]},{"featureType": "road.arterial","elementType": "geometry","stylers": [{ "color": "#CCFFFF" }]},{"featureType": "landscape","elementType": "labels","stylers": [{ "visibility": "off" }]}]');

//         // _setStyle(controller);
//       },
//     );
//   }

//   Set<Marker> _createMarker() {
//     return <Marker>[
//       Marker(
//           draggable: true,
//           onDragEnd: ((position) {
//             setState(() {
//               lat = position.latitude;
//               long = position.longitude;
//               ServiceAppConstant.latitude = lat;
//               ServiceAppConstant.longitude = long;
//               ;
//               print(ServiceAppConstant.latitude.toString());
//               print(ServiceAppConstant.longitude.toString());
//             });

//             print(lat);
//             print(long);
//           }),
//           markerId: MarkerId('home'),
//           position: LatLng(position.latitude, position.longitude),
//           icon: BitmapDescriptor.defaultMarker,
//           infoWindow: InfoWindow(title: '${lat}  ${long}'))
//     ].toSet();
//   }

//   void _setStyle(GoogleMapController controller) async {
//     String value = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
//     controller.setMapStyle(value);
//   }

//   setSelectRadio(int val) {
//     setState(() {
//       selectedRadio = val;
//       if (3 == selectedRadio) {
//         setState(() {
//           _status = true;
//         });
//       } else if (2 == selectedRadio) {
//         setState(() {
//           _status = false;
//           labelController.text = "Office";
//         });
//       } else {
//         setState(() {
//           _status = false;
//           labelController.text = "Home";
//         });
//       }
//     });
//   }

//   Future<void> getLocation() async {
//     PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);

//     if (permission == PermissionStatus.denied) {
//       await PermissionHandler().requestPermissions([PermissionGroup.locationAlways]);
//     }

//     // var geolocator = Geolocator();

//     _getCurrentLocation();
//   }

//   @override
//   void initState() {
//     getLocation();
//     super.initState();
//     setState(() {
//       nameController.text = widget.address.fullName;
//       emailController.text = widget.address.email;
//       stateController.text = widget.address.state;
//       pincodeController.text = widget.address.pincode;
//       mobileController.text = widget.address.mobile;
//       cityController.text = widget.address.city;
//       address1.text = widget.address.address1;
//       address2.text = widget.address.address2;
//       if (widget.address.label == "Home") {
//         selectedRadio = 1;
//         labelController.text = widget.address.label;
//       } else if (widget.address.label == "Office") {
//         selectedRadio = 2;
//         labelController.text = widget.address.label;
//       } else {
//         _status = true;

//         selectedRadio = 3;
//         labelController.text = widget.address.label;
//       }
//     });
//   }

//   Widget getLabel() {
//     return Padding(
//       padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
//       child: TextFormField(
//         controller: labelController,
//         validator: (String value) {
//           if (value.isEmpty) {
//             return " Please enter the label";
//           }
//         },
//         decoration: const InputDecoration(hintText: "Enter Label"),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           elevation: 0.0,
//           backgroundColor: ServiceAppColors.tela,
//           title: Text(
//             "Update Address",
//             style: TextStyle(color: Colors.white),
//           )),
//       key: profilescaffoldkey,
//       body: Container(
//         color: Colors.white,
//         child: new ListView(
//           children: <Widget>[
//             Column(
//               children: <Widget>[
//                 new Container(
//                   color: Color(0xffFFFFFF),
//                   child: Form(
//                     key: _formKeyad,
//                     child: Padding(
//                       padding: EdgeInsets.only(bottom: 25.0),
//                       child: new Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           RadioListTile(
//                             value: 1,
//                             groupValue: selectedRadio,
//                             title: Text("Home"),
//                             onChanged: (val) {
//                               print("Radio $val");
//                               setSelectRadio(val);
//                             },
//                             activeColor: Colors.red,
//                           ),
//                           RadioListTile(
//                             value: 2,
//                             groupValue: selectedRadio,
//                             title: Text("Office "),
//                             onChanged: (val) {
//                               print("Radio $val");
//                               setSelectRadio(val);
//                             },
//                             activeColor: Colors.red,
//                           ),
//                           RadioListTile(
//                             value: 3,
//                             groupValue: selectedRadio,
//                             title: Text("Others "),
//                             onChanged: (val) {
//                               print("Radio $val");
//                               setSelectRadio(val);
//                             },
//                             activeColor: Colors.red,
//                           ),
//                           _status ? getLabel() : Row(),
//                           Padding(
//                               padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 0.0),
//                               child: new Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: <Widget>[],
//                               )),
//                           Padding(
//                               padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
//                               child: new Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: <Widget>[
//                                   new Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: <Widget>[
//                                       new Text(
//                                         'Name',
//                                         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               )),
//                           Padding(
//                               padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
//                               child: new Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: <Widget>[
//                                   new Flexible(
//                                     child: TextFormField(
//                                       controller: nameController,
//                                       validator: (String value) {
//                                         if (value.isEmpty) {
//                                           return " Please enter the name";
//                                         }
//                                       },
//                                       decoration: const InputDecoration(
//                                         hintText: "Enter Your Name",
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               )),
//                           Padding(
//                               padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
//                               child: new Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: <Widget>[
//                                   new Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: <Widget>[
//                                       new Text(
//                                         'Address1',
//                                         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               )),
//                           Padding(
//                             padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0),
//                             child: Container(
//                                 child: new TextFormField(
//                                     maxLines: 2,
//                                     keyboardType: TextInputType.text, // Use mobile input type for emails.
//                                     controller: address1,
//                                     validator: (String value) {
//                                       print("Length${value.length}");
//                                       if (value.isEmpty && value.length > 10) {
//                                         return " Please enter the  address";
//                                       }
//                                     },
//                                     decoration: new InputDecoration(
//                                       hintText: 'Address',
//                                       labelText: 'Enter the address1',
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(color: Colors.black54, width: 3.0),
//                                       ),

// //                                      icon: new Icon(Icons.queue_play_next),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(color: Colors.black54, width: 3.0),
//                                       ),
//                                     ))),
//                           ),
//                           Padding(
//                               padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
//                               child: new Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: <Widget>[
//                                   new Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: <Widget>[
//                                       new Text(
//                                         'Address2',
//                                         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               )),
//                           Padding(
//                             padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0),
//                             child: Container(
//                                 child: new TextFormField(
//                                     maxLines: 2,
//                                     keyboardType: TextInputType.text, // Use mobile input type for emails.
//                                     controller: address2,
//                                     validator: (String value) {
//                                       print("Length${value.length}");
//                                       if (value.isEmpty && value.length > 10) {
//                                         return " Please enter the  address";
//                                       }
//                                     },
//                                     decoration: new InputDecoration(
//                                       hintText: 'Address',
//                                       labelText: 'Enter the address2',
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(color: Colors.black54, width: 3.0),
//                                       ),

// //                                      icon: new Icon(Icons.queue_play_next),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(color: Colors.black54, width: 3.0),
//                                       ),
//                                     ))),
//                           ),
//                           Padding(
//                               padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
//                               child: new Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: <Widget>[
//                                   new Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: <Widget>[
//                                       new Text(
//                                         'Email ID',
//                                         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               )),
//                           Padding(
//                               padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
//                               child: new Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: <Widget>[
//                                   new Flexible(
//                                     child: TextFormField(
//                                       controller: emailController,
//                                       validator: (String value) {
//                                         if (value.isEmpty) {
//                                           return " Please enter the email id";
//                                         }
//                                       },
//                                       decoration: const InputDecoration(hintText: "Enter Email ID"),
//                                       enabled: !_status,
//                                     ),
//                                   ),
//                                 ],
//                               )),
//                           /*Padding(
//                               padding: EdgeInsets.only(
//                                   left: 25.0, right: 25.0, top: 25.0),
//                               child: new Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: <Widget>[
//                                   new Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: <Widget>[
//                                       new Text(
//                                         'Mobile',
//                                         style: TextStyle(
//                                             fontSize: 16.0,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               )),
//                           Padding(
//                               padding: EdgeInsets.only(
//                                   left: 25.0, right: 25.0, top: 2.0),
//                               child: new Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: <Widget>[
//                                   new Flexible(
//                                     child: new TextFormField(
//                                       controller:mobileController,
//                                       keyboardType: TextInputType.number,
//                                       validator: (String value){
//                                         if(value.isEmpty){
//                                           return " Please enter the mobile No";
//                                         }
//                                       },
//                                       decoration: const InputDecoration(
//                                           hintText: "Enter Mobile Number"),
//                                       enabled: false,
//                                     ),
//                                   ),
//                                 ],
//                               )),*/
//                           Padding(
//                               padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
//                               child: new Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: <Widget>[
//                                   Expanded(
//                                     child: Container(
//                                       child: new Text(
//                                         'Mobile',
//                                         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     flex: 2,
//                                   ),
//                                   Expanded(
//                                     child: Container(
//                                       child: new Text(
//                                         'State',
//                                         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     flex: 2,
//                                   ),
//                                 ],
//                               )),
//                           Padding(
//                               padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
//                               child: new Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: <Widget>[
//                                   Flexible(
//                                     child: Padding(
//                                       padding: EdgeInsets.only(right: 10.0),
//                                       child: TextFormField(
//                                         controller: mobileController,
//                                         keyboardType: TextInputType.number,
//                                         inputFormatters: [
//                                           WhitelistingTextInputFormatter.digitsOnly,
//                                           new LengthLimitingTextInputFormatter(10),
//                                         ],
//                                         validator: (String value) {
//                                           if (value.isEmpty) {
//                                             return " Please enter the mobile No";
//                                           }
//                                         },
//                                         decoration: const InputDecoration(hintText: "Enter Mobile No"),
//                                         enabled: !_status,
//                                       ),
//                                     ),
//                                     flex: 2,
//                                   ),
//                                   Flexible(
//                                     child: TextFormField(
//                                       controller: stateController,
//                                       validator: (String value) {
//                                         if (value.isEmpty) {
//                                           return " Please enter the state";
//                                         }
//                                       },
//                                       decoration: const InputDecoration(hintText: "Enter State"),
//                                     ),
//                                     flex: 2,
//                                   ),
//                                 ],
//                               )),
//                           Padding(
//                               padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
//                               child: new Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: <Widget>[
//                                   Expanded(
//                                     child: Container(
//                                       child: new Text(
//                                         'City',
//                                         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     flex: 2,
//                                   ),
//                                   Expanded(
//                                     child: Container(
//                                       child: new Text(
//                                         'Pin Code',
//                                         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     flex: 2,
//                                   ),
//                                 ],
//                               )),
//                           Container(
//                             height: 70,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             margin: EdgeInsets.only(left: 20, right: 20),
//                             padding: EdgeInsets.all(0.0),
//                             child: Row(children: <Widget>[
//                               Expanded(
//                                 child: Padding(
//                                   padding: EdgeInsets.all(5),
//                                   child: Padding(
//                                     padding: EdgeInsets.only(right: 10.0),
//                                     child: TextFormField(
//                                       controller: cityController,
//                                       validator: (String value) {
//                                         if (value.isEmpty) {
//                                           return " Please enter the city";
//                                         }
//                                       },
//                                       decoration: const InputDecoration(hintText: "Enter City"),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 30,
//                               ),
//                               Expanded(
//                                 child: Padding(
//                                   padding: EdgeInsets.all(5),
//                                   child: Padding(
//                                     padding: EdgeInsets.only(right: 10.0),
//                                     child: TextFormField(
//                                       controller: pincodeController,
//                                       keyboardType: TextInputType.number,
//                                       inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
//                                       validator: (String value) {
//                                         if (value.isEmpty) {
//                                           return " Please enter the pin code";
//                                         }
//                                       },
//                                       decoration: const InputDecoration(hintText: "Enter Pin Code"),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ]),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Container(
//                             height: 400,
//                             child: _child,
//                           ),
//                           _getActionButtons(),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     // Clean up the controller when the Widget is disposed
//     myFocusNode.dispose();
//     super.dispose();
//   }

//   Widget _getActionButtons() {
//     return Padding(
//       padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
//       child: new Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(right: 10.0),
//               child: Container(
//                   child: Center(
//                 child: RaisedButton(
//                   child: new Text("Save"),
//                   textColor: Colors.white,
//                   color: Colors.green,
//                   onPressed: () {
//                     setState(() {
//                       if (_formKeyad.currentState.validate()) {
// //                              setInfo();
//                         _updateEmployee(widget.address.addId);
//                       }

// //                        _status = true;
//                       FocusScope.of(context).requestFocus(new FocusNode());
//                     });
//                   },
//                   shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
//                 ),
//               )),
//             ),
//             flex: 2,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _getEditIcon() {
//     return new GestureDetector(
//       child: new CircleAvatar(
//         backgroundColor: ServiceAppColors.pink,
//         radius: 14.0,
//         child: new Icon(
//           Icons.edit,
//           color: Colors.white,
//           size: 16.0,
//         ),
//       ),
//       onTap: () {
//         setState(() {
//           _status = false;
//         });
//       },
//     );
//   }

// //

//   Future setInfo() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     pref.setString("email", emailController.text);
//     pref.setString("name", nameController.text);
//     pref.setString("city", cityController.text);
//     pref.setString("address", address1.text);
//     pref.setString("sex", _dropDownValue1);
//     pref.setString("mobile", mobileController.text);
//     pref.setString("pin", pincodeController.text);
//     pref.setString("state", stateController.text);
//     pref.setBool("isLogin", true);
// //        print(user.name);
//     ServiceAppConstant.email = emailController.text;
//     ServiceAppConstant.name = nameController.text;

//     if (ServiceAppConstant.isLogin) {
// //      Navigator.push(context,
// //          new MaterialPageRoute(builder: (context) => CheckOutPage()));

//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => SignInPage()),
//       );
//     }
//   }

//   Future _updateEmployee(String id) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();

//     var map = new Map<String, dynamic>();
//     map['add_id'] = id;
//     map['shop_id'] = ServiceAppConstant.Shop_id;
//     map['X-Api-Key'] = ServiceAppConstant.API_KEY;
//     map['user_id'] = ServiceAppConstant.user_id;
//     map['full_name'] = nameController.text;
//     map['mobile'] = mobileController.text;
//     map['email'] = emailController.text;
//     map['label'] = labelController.text;
//     map['address1'] = address1.text;
//     map['address2'] = address2.text;
//     map['city'] = cityController.text;
//     map['state'] = stateController.text;
//     map['pincode'] = pincodeController.text;
//     map['lat'] = "";
//     map['lng'] = "";
//     String link = ServiceAppConstant.base_url + "manage/api/user_address/update";
//     print(link);
//     final response = await http.post(link, body: map);

//     if (response.statusCode == 200) {
//       final jsonBody = json.decode(response.body);
//       print(jsonBody);

//       OtpModal user = OtpModal.fromJson(jsonDecode(response.body));

//       showLongToast(user.message);

//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ShowAddress(widget.valu)),
//       );
// //      RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));

//     } else
//       throw Exception("Unable to get Employee list");
//   }
// }
