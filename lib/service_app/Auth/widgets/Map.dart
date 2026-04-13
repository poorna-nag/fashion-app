// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:royalmart/service_app/Auth/signup.dart';
// import 'package:royalmart/service_app/Auth/widgets/customappbar.dart';
// import 'package:royalmart/service_app/General/AppConstant.dart';
// import 'package:royalmart/service_app/model/RegisterModel.dart';
// import 'package:royalmart/service_app/screen/AddAddress.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
// import 'package:royalmart/service_app/Auth/widgets/CustomeAppbar2.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class MapActivity extends StatefulWidget {
//   final String valu;
//   const MapActivity(this.valu) : super();
//   @override
//   _MyMapState createState() => _MyMapState();
// }

// class _MyMapState extends State<MapActivity> {
//   String shopname,
//       shopcat,
//       username,
//       email,
//       mobile,
//       shopadd,
//       locality,
//       city,
//       state,
//       pincode,
//       permanentadd,
//       password,
//       cont_persionname,
//       franchise,
//       user_id,
//       documenttype,
//       documentnumber,
//       docimage,
//       pan_number,
//       panImage,
//       firmnumber,
//       firmImage,
//       gstnumber,
//       gstImage;

//   GoogleMapController _controller;

//   SharedPreferences pref;

//   Position position;
//   Widget _child;
//   double lat, long;
//   bool flag = false;
//   String shop_id;

//   Future<void> getvalue12() async {
//     pref = await SharedPreferences.getInstance();
//     String shopname1 = pref.getString("shopid12");
//     setState(() {
//       shop_id = shopname1;
//     });
//   }

//   void _setStyle(GoogleMapController controller) async {
//     String value = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
//     controller.setMapStyle(value);
//   }

//   Set<Marker> _createMarker() {
//     return <Marker>[
//       Marker(
//           draggable: true,
//           onDragEnd: ((position) {
//             setState(() {
//               lat = position.latitude;
//               long = position.longitude;
//               print(lat);
//               print(long);
//               getAddress();
//             });
//           }),
//           markerId: MarkerId('home1234'),
//           position: LatLng(position.latitude, position.longitude),
//           icon: BitmapDescriptor.defaultMarker,
//           infoWindow: InfoWindow(title: '${lat}  ${long}'))
//     ].toSet();
//   }

//   void showToast(message) {
//     Fluttertoast.showToast(
//         msg: message,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
// //        timeInSecForIos: 1,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0);
//   }

//   @override
//   void initState() {
//     getLocation();
//     getvalue12();
//     // getvalue();
//     // _getCurrentLocation();
//     super.initState();
//   }

//   Future<void> getLocation() async {
//     PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);

//     if (permission == PermissionStatus.denied) {
//       await PermissionHandler().requestPermissions([PermissionGroup.locationAlways]);
//     } else if (permission == PermissionStatus.granted) {
//       _getCurrentLocation();
//       showToast('Access granted');
//     }

//     var geolocator = Geolocator();
//   }

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
//       _child = _mapWidget();
//     });
//   }

//   String valArea;
//   getAddress() async {
//     final coordinates = new Coordinates(lat, long);
//     var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     var first = addresses.first;
//     setState(() {
//       valArea = first.subLocality + " " + first.subAdminArea.toString() + " " + first.featureName.toString() + " " + first.thoroughfare.toString();
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

//   // void _updatePosition(CameraPosition _position) {
//   //   Position newMarkerPosition = Position(
//   //       latitude: _position.target.latitude,
//   //       longitude: _position.target.longitude);
//   //   Marker marker = markers["home"];
//   //
//   //   setState(() {
//   //     markers["home"] = marker.copyWith(
//   //         positionParam: LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude));
//   //   });
//   // }
//   Widget _mapWidget() {
//     return GoogleMap(
//       mapType: MapType.normal,
//       markers: _createMarker(),
//       // onCameraMove: ((position) => _updatePosition(position)),
//       initialCameraPosition: CameraPosition(
//         target: LatLng(position.latitude, position.longitude),
//         zoom: 16.0,
//       ),
//       onMapCreated: (GoogleMapController controller) {
//         _controller = controller;
//         // _setStyle(controller);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// //         appBar: AppBar(
// // //          backgroundColor: AppColors.tela,
// // //        backgroundColor: Colors.blue,
// //           title: Text('Update Location',textAlign: TextAlign.center,style: TextStyle(color: CupertinoColors.white),),
// //         ),
//         body: SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           Opacity(opacity: 0.88, child: CustomAppBar3()),
//           Container(
//             height: 400,
//             child: _child,
//           ),
//           Container(
//             margin: EdgeInsets.all(10),
//             // height: 400,
//             child: Text(valArea != null ? valArea : ""),
//           ),
//           flag ? circularIndi() : Row(),
//           SizedBox(
//             height: 20,
//           ),
//           _getActionButtons(),
//         ],
//       ),
//     ));
//   }

//   Widget _getActionButtons() {
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//       child: Center(
//         child: RaisedButton(
//           onPressed: () {
//             print(lat);
//             print(long);
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AddAddress(widget.valu)),
//             );

//             // updatelocation( lat, long );
//             // _registerData();
//           },
//           color: ServiceAppColors.tela,
//           padding: EdgeInsets.only(top: 12, left: 10, right: 10, bottom: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
//           child: Text(
//             "OK",
//             style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }

//   Future updatelocation(double latitude, double longitide) async {
//     setState(() {
//       flag = true;
//     });
//     print(latitude);
//     print(longitide);
//     String link = ServiceAppConstant.base_url + "api/cp.php?shop_id=" + shop_id + "&lat=" + latitude.toString() + "&lng=" + longitide.toString();
//     final response = await http.get(link);
//     if (response.statusCode == 200) {
//       var responseData = json.decode(response.body);
//       OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
//       print(jsonDecode(response.body));
//       showLongToast(user.message);
//       // Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()),);

//     }
// //    print("List Size: ${list.length}");
//   }

// /*  Future _registerData() async {
//     SharedPreferences pref= await SharedPreferences.getInstance();
//     print(shopname);
//     print(Constant.API_KEY);
//     print(username);
//     print(password);
//     print(shopcat);
//     print(cont_persionname);
//     print(city);
//     print(pincode);
//     print(mobile);
//     // print(_dropDownValue1);
//     print(locality);
//     print(email);
//     print(user_id);
//     print(franchise);
//     print(shop_id);
//     var map = new Map<String, dynamic>();
//     map['shop']=shopname;
//     map['address']=shopadd;
// //    map['X-Api-Key']=Constant.API_KEY;
//     map['user']=username;
//     map['pass']=password;
//     map['cat']=shopcat;
//     map['name']=cont_persionname;
//     map['loc']=locality;
//     map['city']=city;
//     map['pin']=pincode;
//     map['email']=email;
//     map['mobile']=mobile;
//     map['permanent_address']=permanentadd;
//     map['franchise']=franchise;
//     map['added_by']=user_id;
//     map['shop_id']==shop_id;
//     final response = await http.post(Constant.base_url+'api/save-cpreg.php',body:map);
//     if (response.statusCode == 200) {
//       final jsonBody = json.decode(response.body);
//       print(jsonBody);
//       CpRegistration user = CpRegistration.fromJson(jsonDecode(response.body));
//       if(user.message.toString()=="Registration is Successful")
//       {
//         showLongToast(user.message);
//         pref.setString("shopid12", user.shop_id);


//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => Homepage()),);



//       }
//       else {
//         showLongToast(user.message);
// //        Navigator.push(context,
// //            new MaterialPageRoute(builder: (context) => Form3()));


//       }

//     } else
//       throw Exception("Unable to get Employee list");
// //    _showLongToast("You have no changes");
//   }*/

//   Widget circularIndi() {
//     return Align(
//       alignment: Alignment.center,
//       child: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
