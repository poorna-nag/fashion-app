// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:royalmart/screen/wallecttransation.dart';
// import 'package:royalmart/service_app/Auth/forgetPassword.dart';
// import 'package:royalmart/Auth/signin.dart';
// import 'package:royalmart/service_app/General/AppConstant.dart';
// import 'package:royalmart/service_app/General/Home.dart';
// import 'package:royalmart/service_app/Web/WebviewTermandCondition.dart';
// import 'package:royalmart/service_app/dbhelper/database_helper.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:share/share.dart';

// import '../../General/AppConstant.dart';

// class AppDrawer extends StatefulWidget {
//   @override
//   _AppDrawerState createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer> {
//   bool islogin = false;
//   String ?name, email, image, cityname, mobile;
//   int ?wcount;
//   SharedPreferences? pref;
//   void gatinfo() async {
//     pref = await SharedPreferences.getInstance();
//       islogin = pref!.getBool("isLogin")!;
//     Object? wcount1 = pref!.get("wcount");
//     name = pref!.get("name") as String?;
//     email = pref!.get("email") as String?;
//     image = pref!.get("pp") as String?;
//     cityname = pref!.get("city") as String?;
//     mobile = pref!.get("mobile") as String?;
//     if (islogin == null) {
//       islogin = false;
//     }

//     // print(islogin);
//     setState(() {
//       ServiceAppConstant.name = name??"";
//       ServiceAppConstant.email = email??"";
//       islogin == null ? ServiceAppConstant.isLogin = false : ServiceAppConstant.isLogin = islogin;
//       ServiceAppConstant.image = image!;
//       print(ServiceAppConstant.image);

//       ServiceAppConstant.citname = cityname!;

//       // print( Constant.image.length);
//       wcount = wcount!;
//     });
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
//                               margin: EdgeInsets.only(right: 10),
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
//                                           padding: EdgeInsets.only(left: 10, right: 10),
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

//   @override
//   void initState() {
//     gatinfo();

//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       physics: ScrollPhysics(),
//       child: Column(
//         children: <Widget>[
//           Container(
//             color: ServiceAppColors.tela1,
//             child: Column(
//               children: [
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(top: 40, left: 20),
//                   color: ServiceAppColors.tela1,
//                   height: 140,
//                   width: MediaQuery.of(context).size.width,
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundColor: ServiceAppColors.white,
//                     child: ClipOval(
//                       child: new SizedBox(
//                         width: 100.0,
//                         height: 100.0,
//                         child: ServiceAppConstant.image == null
//                             ? Image.asset(
//                                 'assets/images/logo.png',
//                               )
//                             : ServiceAppConstant.image.length == 1
//                                 ? Image.asset(
//                                     'assets/images/logo.png',
//                                   )
//                                 : ServiceAppConstant.image == "https://www.bigwelt.com/manage/uploads/customers/nopp.png"
//                                     ? Image.asset(
//                                         'assets/images/logo.png',
//                                       )
//                                     : Image.network(
//                                         ServiceAppConstant.image,
//                                         fit: BoxFit.fill,
//                                       ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 20),
//                   child: Text(
//                     islogin ? ServiceAppConstant.name : " ",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 20, bottom: 20),
//                   child: Text(
//                     islogin ? ServiceAppConstant.email : " ",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 /*    InkWell(
//                   onTap: (){
//                     _displayDialog(context);
//                   },
//                   child: Container(
//                     alignment: Alignment.centerLeft,
//                     padding: EdgeInsets.only(left: 20,bottom: 20),
//                     child:Text(Constant.citname!=null?Constant.citname:" ",
//                       overflow:TextOverflow.ellipsis,
//                       maxLines: 1,
//                       style: TextStyle(color: Colors.black),),
//                   ),
//                 ),*/
//               ],
//             ),
//           ),

//           /* UserAccountsDrawerHeader(
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: AssetImage('assets/images/drawer-header.jpg'),
//                 )),
//             currentAccountPicture:  CircleAvatar(
//               radius:30,
//               backgroundColor: Colors.black,
//               backgroundImage:Constant.image==null? AssetImage('assets/images/logo.jpg',):Constant.image.length==1?AssetImage('assets/images/logo.jpg',):Constant.image=="https://www.bigwelt.com/manage/uploads/customers/nopp.png"? AssetImage('assets/images/logo.jpg',):NetworkImage(
//                   Constant.image),
//             ),
//             accountName: Text(islogin?Constant.name:" ",style: TextStyle(color: Colors.black),),
//             accountEmail: Text(islogin?Constant.email:" ",style: TextStyle(color: Colors.black),),
//           ),*/
//           Container(
//             child: ListView(
//               physics: ScrollPhysics(),
//               shrinkWrap: true,
//               children: <Widget>[
//                 ListTile(
//                   leading: Icon(Icons.home, color: ServiceAppColors.tela),
//                   title: Text('Home'),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ServiceApp()),
//                     );
//                   },
//                 ),
//                 Divider(),

//                 /*   ListTile(
//                   leading: Icon(Icons.list_alt,
//                       color: AppColors.tela),
//                   title: Text('Shop By Categories'),
//                   trailing: Text('',
//                       style: TextStyle(color: Theme.of(context).primaryColor)),
//                   onTap: () {
//                     Navigator.of(context).pop();

//                     Navigator.push(context, MaterialPageRoute(builder: (context) => Cgategorywise("0")),);
//                   },
//                 ), */

//                 /* ListTile(
//                   leading: Icon(Icons.offline_bolt_rounded,
//                       color: AppColors.tela),
//                   title: Text('Deals of the Day'),
//                   trailing: Text('New',
//                       style: TextStyle(color: Colors.red)),
//                   onTap: () {
//                     Navigator.of(context).pop();

//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ProductList("day","DEALS OF THE DAY")),
//                     );
//                   },
//                 ),*/

//                 /* ListTile(
//                   leading: Icon(Icons.stacked_line_chart,
//                       color: AppColors.tela),
//                   title: Text('Top Products'),
//                   trailing: Text('',
//                       style: TextStyle(color: Theme.of(context).primaryColor)),
//                   onTap: () {
//                     Navigator.of(context).pop();

//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ProductList("top","TOP PRODUCTS")),
//                     );
//                   },
//                 ),*/

//                 /* ListTile(
//                   leading: Icon(Icons.traffic,
//                       color: AppColors.tela),
//                   title: Text('New Arrival'),
//                   trailing: Text('',
//                       style: TextStyle(color: Theme.of(context).primaryColor)),
//                   onTap: () {
//                     Navigator.of(context).pop();

//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) =>
//                           ProductList("day",
//                               Constant.AProduct_type_Name2)),);
//                   },
//                 ),*/
//                 /* ListTile(
//                   leading:
//                   Icon(Icons.favorite, color: AppColors.tela),
//                   title: Text('My Wishlist'),
//                   /* trailing: Container(
//                     padding: const EdgeInsets.all(10.0),
//                     decoration: new BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     child: Text(wcount!=null?wcount.toString():'0',
//                         style: TextStyle(color: Colors.white, fontSize: 15.0)),
//                   ),*/
//                   onTap: () {
//                     Navigator.of(context).pop();

//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => NewWishList())
// //                        NewWishList()),
// //                      Cat_Product
//                     );
//                   },
//                 ), */

//                 /*  ListTile(
//                   leading: Icon(Icons.star_border,
//                       color: AppColors.tela),
//                   title: Text('Rate US',),
//                   onTap: () {
//                     Navigator.of(context).pop();

//                     String os = Platform.operatingSystem; //in your code
//                     if (os == 'android') {
//                       LaunchReview.launch(
//                         androidAppId: "com.freshatdoorstep",);

//                     }
//                   },
//                 ),*/
//                 // ListTile(
//                 //   leading: Icon(Icons.analytics_rounded,
//                 //       color: AppColors.tela),
//                 //   title: Text('Blog'),
//                 //   trailing: Text('',
//                 //       style: TextStyle(color: Theme.of(context).primaryColor)),
//                 //   onTap: () {
//                 //     Navigator.of(context).pop();
//                 //
//                 //     Navigator.push(context, MaterialPageRoute(
//                 //         builder: (context) => BlogScreen()),
//                 //     );
//                 //   },
//                 // ),
//                 ListTile(
//                   leading: Icon(
//                     Icons.account_balance_wallet_rounded,
//                     color: ServiceAppColors.tela,
//                   ),
//                   title: Text('My Wallet'),
//                   onTap: () {
//                     Navigator.of(context).pop();
//                     if (ServiceAppConstant.isLogin) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => WalltReport(),
//                         ),
//                       );
//                     } else {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SignInPage(),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//                 Divider(),
//                 ListTile(
//                   leading: Icon(
//                     Icons.money_sharp,
//                     color: ServiceAppColors.tela,
//                   ),
//                   title: Text('My Earnings'),
//                   onTap: () {
//                     Navigator.of(context).pop();
//                     if (ServiceAppConstant.isLogin) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => WebViewClass(
//                             "My Earnings",
//                             "${ServiceAppConstant.base_url}Api_earnings.php?username=$mobile&shop_id=${ServiceAppConstant.Shop_id}",
//                           ),
//                         ),
//                       );
//                     } else {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SignInPage(),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//                 Divider(),
//                 ListTile(
//                   leading: Icon(Icons.phone, color: ServiceAppColors.tela),
//                   title: Text('Contact Us'),
//                   onTap: () {
//                     Navigator.of(context).pop();

//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => WebViewClass(
//                                 "Contact Us",
//                                 ""
//                                     "${ServiceAppConstant.base_url}contact"))
//                         // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
// //                        NewWishList()),
// //                      Cat_Product
//                         );
//                   },
//                 ),
//                 Divider(),
//                 ListTile(
//                   leading: Icon(Icons.privacy_tip, color: ServiceAppColors.tela),
//                   title: Text('Privacy Policy'),
//                   onTap: () {
//                     Navigator.of(context).pop();

//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => WebViewClass(
//                                 "Privacy Policy",
//                                 ""
//                                     "${ServiceAppConstant.base_url}pp"))
//                         // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
// //                        NewWishList()),
// //                      Cat_Product
//                         );
//                   },
//                 ),
//                 Divider(),
//                 ListTile(
//                   leading: Icon(Icons.info, color: ServiceAppColors.tela),
//                   title: Text('About Us'),
//                   onTap: () {
//                     Navigator.of(context).pop();

//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => WebViewClass(
//                                 "About Us",
//                                 ""
//                                     "${ServiceAppConstant.base_url}about"))
//                         // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
// //                        NewWishList()),
// //                      Cat_Product
//                         );
//                   },
//                 ),
//                 Divider(),
//                 ListTile(
//                   leading: Icon(Icons.file_copy, color: ServiceAppColors.tela),
//                   title: Text('Terms & Conditions'),
//                   onTap: () {
//                     Navigator.of(context).pop();

//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => WebViewClass(
//                                 "Terms & Conditions",
//                                 ""
//                                     "${ServiceAppConstant.base_url}tc"))
//                         // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
// //                        NewWishList()),
// //                      Cat_Product
//                         );
//                   },
//                 ),
//                 Divider(),
//                 /* ListTile(
//                   leading:
//                   Icon(Icons.file_copy, color: AppColors.tela),
//                   title: Text('Terms & Conditions'),
//                   onTap: () {
//                     Navigator.of(context).pop();

//                     Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewClass("Terms & Conditions","https://www.freshatdoorstep.com/tc"))
//                     // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
// //                        NewWishList()),
// //                      Cat_Product
//                     );
//                   },
//                 ),*/
//                 /* ListTile(
//                   leading:
//                   Icon(Icons.question_answer, color: AppColors.tela),
//                   title: Text('FAQ'),
//                   onTap: () {
//                     Navigator.of(context).pop();

//                     Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewClass("FAQ","https://www.freshatdoorstep.com/faq"))
//                     // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
// //                        NewWishList()),
// //                      Cat_Product
//                     );
//                   },
//                 ),*/
//                 ListTile(
//                     leading: Icon(Icons.share, color: ServiceAppColors.tela),
//                     title: Text('Refer & Earn'),
//                     onTap: () {
//                       if (Platform.isAndroid) {
//                         _shareAndroidApp();
//                       } else {
//                         _shareIosApp();
//                       }
//                     }),
//                 Divider(),

//                 ServiceAppConstant.isLogin
//                     ? new Container()
//                     : ListTile(
//                         leading: Icon(Icons.lock, color: ServiceAppColors.tela),
//                         title: Text('Login'),
//                         onTap: () {
//                           Navigator.of(context).pop();

//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => SignInPage()),
//                           );
//                         },
//                       ),
//                 // Divider(),
// //              ListTile(
// //                leading:
// //                    Icon(Icons.settings, color: AppColors.tela),
// //                title: Text('Settings'),
// //                onTap: () {
// //
// //                },
// //              ),
//                 /* Constant.isLogin? ListTile(
//                   leading: Icon(Icons.exit_to_app,
//                       color: AppColors.tela),
//                   title: Text('Logout'),
//                   onTap: () async {
//                     _callLogoutData();
//                   },
//                 ):new Container()*/
//               ],
//             ),
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
//     Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
//   }

//   _shareAndroidApp() {
//     ServiceAppConstant.isLogin
//         ? Share.share("Hi, Looking for referral bonuses? Download " +
//             ServiceAppConstant.appName +
//             " app from this link: https://play.google.com/store/apps/details?id=${ServiceAppConstant.packageName}.\n Don't forget to use my referral code: ${mobile}")
//         : Share.share("Hi, Looking for referral bonuses? Download " +
//             ServiceAppConstant.appName +
//             " app from this link: https://play.google.com/store/apps/details?id=${ServiceAppConstant.packageName}");
//   }

//   _shareIosApp() {
//     ServiceAppConstant.isLogin
//         ? Share.share("Hi, Looking for referral bonuses? Download " +
//             ServiceAppConstant.appName +
//             " app from this link: ${ServiceAppConstant.iosAppLink}.\n Don't forget to use my referral code: ${mobile}")
//         : Share.share(
//             "Hi, Looking for referral bonuses? Download " + ServiceAppConstant.appName + " app from this link:${ServiceAppConstant.iosAppLink}");
//   }
// }
