// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:royalmart/service_app/BottomNavigation/categories.dart';
// import 'package:royalmart/service_app/BottomNavigation/profile.dart';
// import 'package:royalmart/service_app/BottomNavigation/service_app_home_screen.dart';
// import 'package:royalmart/service_app/BottomNavigation/wishlist.dart';
// import 'package:royalmart/service_app/General/AppConstant.dart';
// import 'package:royalmart/service_app/dbhelper/database_helper.dart';
// import 'package:royalmart/service_app/screen/CustomeOrder.dart';
// import 'package:royalmart/service_app/screen/SearchScreen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../General/AppConstant.dart';
// import 'drawer.dart';
// import 'my_app_bar.dart';

// class ServiceApp extends StatefulWidget {
//   @override
//   ServiceAppState createState() => ServiceAppState();
// }

// class ServiceAppState extends State<ServiceApp> {
//   static int countval = 0;
//   SharedPreferences? pref;
//   void gatinfoCount() async {
//     pref = await SharedPreferences.getInstance();
//     double latitud = double.parse(pref!.getString("lat") != null ? pref!.getString("lat")??"" : "00");
//     double longitud = double.parse(pref!.getString("lng") != null ? pref!.getString("lng")??"" : "00");
//     int ?Count = pref!.getInt("itemCount");
//     bool ?ligin = pref!.getBool("isLogin");
//     String? userid = pref!.getString("user_id");
//     String? image = pref!.getString("pp");
//     setState(() {
//       ServiceAppConstant.latitude = latitud;
//       ServiceAppConstant.longitude = longitud;

//       ServiceAppConstant.image = image!;
//       print(image);
//       print("Constant.image=image");
//       ServiceAppConstant.user_id = userid??"";
//       if (ligin != null) {
//         ServiceAppConstant.isLogin = ligin;
//       } else {
//         ServiceAppConstant.isLogin = false;
//       }
//       if (Count == null) {
//         ServiceAppConstant.serviceAppCartItemCount = 0;
//       } else {
//         ServiceAppConstant.serviceAppCartItemCount = Count;
//         countval = Count;
//       }
// //      print(Constant.carditemCount.toString()+"itemCount");
//     });
//   }

//   int count = 0;
//   @override
//   void initState() {
// //    getData();
//     // TODO: implement initState
//     super.initState();
//     gatinfoCount();
//   }

//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//   final ServiceAppHomeScreen _screen = ServiceAppHomeScreen();
//   final Cgategorywise _categories = Cgategorywise();
// //  final Categories _categories = Categories();
//   final WishList _cartitem = WishList();
//   final ProfileView _profilePage = ProfileView();
//   final CustomeOrder _customeOrder = CustomeOrder();

//   int _current = 0;
//   int _selectedIndex = 0;
//   Widget _showPage = new ServiceAppHomeScreen();
//   Widget _PageChooser(int page) {
//     switch (page) {
//       case 0:
//         _onItemTapped(0);
//         return _screen;
//         break;
//       case 1:
//         _onItemTapped(1);
//         return _categories;
//         break;
//       // case 2:
//       //   _onItemTapped(2);
//       //   return _cartitem;
//       //   break;
//       case 2:
//         _onItemTapped(2);
//         return _customeOrder;
//         break;

//       case 3:
//         _onItemTapped(3);
//         return _profilePage;
//         break;

//       default:
//         return Container(
//           child: Center(
//             child: Text('No Page is found'),
//           ),
//         );
//     }
//   }

//   bool check = false;
//   _displayDialog(BuildContext context) async {
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDialog(
//             scrollable: true,
//             title: Text('Select City'),
//             content: Container(
//               width: double.maxFinite,
//               height: 400,
//               child: FutureBuilder(
//                   future: getPcity(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return ListView.builder(
//                           scrollDirection: Axis.vertical,
//                           itemCount: snapshot.data!.length == null ? 0 : snapshot.data!.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Container(
//                               width: snapshot.data![index] != 0 ? 130.0 : 230.0,
//                               color: Colors.white,
// //                                margin: EdgeInsets.only(right: 10),

//                               child: InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     check = true;
//                                     pref!.setString('city', snapshot.data![index].places??"");
//                                     pref!.setString('cityid', snapshot.data![index].loc_id??"");
//                                     ServiceAppConstant.cityid = snapshot.data![index].loc_id??"";
//                                     ServiceAppConstant.citname = snapshot.data![index].places??"";
//                                     Navigator.pop(context);

//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(builder: (context) => ServiceApp()),
//                                     );
//                                   });
//                                 },
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     Card(
//                                       child: Container(
//                                         width: MediaQuery.of(context).size.width,
//                                         padding: EdgeInsets.all(10),
//                                         child: Padding(
//                                           padding: EdgeInsets.only(left: 0, right: 0),
//                                           child: Text(
//                                             snapshot.data![index].places??"",
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 2,
//                                             style: TextStyle(
//                                               fontSize: 15,
//                                               color: ServiceAppColors.black,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     // Divider(
//                                     //
//                                     //   color: AppColors.black,
//                                     // ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           });
//                     }
//                     return Center(child: CircularProgressIndicator());
//                   }),
//             ),
//             actions: <Widget>[
//               new TextButton(
//                 child: Text(
//                   'CANCEL',
//                   style: TextStyle(color: check ? Colors.green : Colors.grey),
//                 ),
//                 onPressed: () {
//                   check ? Navigator.of(context).pop() : showLongToast("Please Select city");
//                 },
//               )
//             ],
//           );
//         });
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: Drawer(
//         child: AppDrawer(),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.home,
//               color: _selectedIndex == 0 ? ServiceAppColors.black : ServiceAppColors.tela,
//               size: 25,
//             ),
//             label:"Home" ,
//           ),

//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.category_sharp,
//               color: _selectedIndex == 1 ? ServiceAppColors.black : ServiceAppColors.tela,
//               size: 25,
//             ),
//             label: "Categories",
//           ),
//           // BottomNavigationBarItem(
//           //   icon: Icon(Icons.shopping_cart,color: _selectedIndex == 2 ? AppColors.onselectedBottomicon : AppColors.carticon,size: 25,),
//           //   label: Text('My cart'),
//           // ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.dynamic_feed,
//               color: _selectedIndex == 2 ? ServiceAppColors.black : ServiceAppColors.tela,
//               size: 25,
//             ),
//             label: 'Feedback',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.person,
//               color: _selectedIndex == 3 ? ServiceAppColors.black : ServiceAppColors.tela,
//               size: 25,
//             ),
//             label:"Account",
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: ServiceAppColors.black,
//         backgroundColor: Colors.white,
//         type: BottomNavigationBarType.fixed,
//         onTap: (int index) {
// //          debugPrint("Current Index is $index");
//           setState(() {
//             _showPage = _PageChooser(index);
//           });
//         },
//       ),
//       body: Container(
//           color: ServiceAppColors.tela,
// //    margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
//           child: _showPage),
//     );
//   }
// }
