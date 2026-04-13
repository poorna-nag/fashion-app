import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:royalmart/constent/app_constent.dart';
import 'package:royalmart/grocery/BottomNavigation/categories.dart';
import 'package:royalmart/grocery/BottomNavigation/profile.dart';
import 'package:royalmart/grocery/BottomNavigation/grocery_app_home_screen.dart';
import 'package:royalmart/grocery/BottomNavigation/wishlist.dart';
import 'package:royalmart/grocery/BottomNavigation/new_cat.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/dbhelper/database_helper.dart';
import 'package:royalmart/grocery/model/CategaryModal.dart';
import 'package:http/http.dart' as http;
import 'package:royalmart/grocery/screen/SearchScreen.dart';
import 'package:royalmart/grocery/screen/active_membership.dart';
import 'package:royalmart/grocery/screen/custom_order.dart';
import 'package:royalmart/grocery/screen/screen_memebership.dart';
import 'package:royalmart/screen/wallecttransation.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'drawer.dart';
import 'my_app_bar.dart';

class GroceryApp extends StatefulWidget {
  @override
  GroceryAppState createState() => GroceryAppState();
}

String mId = "";

class GroceryAppState extends State<GroceryApp> {
  static int countval = 0;
  int cc = 0;
  SharedPreferences? pref;

  void getcartCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? cCount = pref.getInt("cc");
    setState(() {
      // log("cart get count------------------->>$cCount");
      if (cCount != null) {
        if (cCount == 0 || cCount < 0) {
          cc = 0;
          AppConstent.cc = 0;
          // log(" AppConstent.cc------------------->>${AppConstent.cc}");
        } else {
          setState(() {
            cc = cCount;
            AppConstent.cc = cCount;
          });
        }
      }
      // log("cart count------------------->>$cc");
    });
  }

  // final translator =GoogleTranslator();
  void gatinfoCount() async {
    log("mid home");
    pref = await SharedPreferences.getInstance();
    mId = pref!.getString("mID").toString();
    log("mid home" + pref!.getString("mID").toString());

    int? Count = pref!.getInt("itemCount");
    bool? ligin = pref!.getBool("isLogin");
    String? userid = pref!.getString("user_id");
    String? image = pref!.getString("pp");
    String? lval = pref!.getString("language");
    //  int cCount = pref!.getInt("cc");
    setState(() {
      lngval = lval != null ? lval : "en";
      // GroceryAppConstant.image = image;
      print(image);
      print("Constant.image=image");
      GroceryAppConstant.user_id = userid ?? "";
      setState(() {
        // if (cc == 0 || cc < 0) {
        //   cc = 0;
        // } else {
        //   cc = cCount;
        //   log("cart count------------------->>$cc");
        // }
      });
      if (ligin != null) {
        GroceryAppConstant.isLogin = ligin;
      } else {
        GroceryAppConstant.isLogin = false;
      }
      if (Count == null) {
        GroceryAppConstant.groceryAppCartItemCount = 0;
      } else {
        GroceryAppConstant.groceryAppCartItemCount = Count;
        countval = Count;
      }
//      print(Constant.carditemCount.toString()+"itemCount");
    });
  }

  Position? position;
  getAddress(double lat, double long) async {
    var addresses = await placemarkFromCoordinates(lat, long);

    var first = addresses.first;
    setState(() {
      // valArea=first.subLocality+ " "+first.subAdminArea.toString()+" "+first.featureName.toString()+" "+first.thoroughfare.toString()+""+first.postalCode.toString();
      var address = first.subLocality.toString() +
          " " +
          first.subLocality.toString() +
          " " +
          first.thoroughfare.toString() +
          " ";

      print('Rahul ${address}');
      pref!.setString("lat", lat.toString());
      pref!.setString("lat", lat.toString());
      pref!.setString("add", address.toString().replaceAll("null", ""));
    });
  }

  void _getCurrentLocation() async {
    await Geolocator.requestPermission();
    Position res = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        position = res;
        GroceryAppConstant.latitude = position!.latitude;
        GroceryAppConstant.longitude = position!.longitude;
        print(
            ' lat ${GroceryAppConstant.latitude},${GroceryAppConstant.longitude}');
        getAddress(GroceryAppConstant.latitude, GroceryAppConstant.longitude);
      });
    }
  }

  int count = 0;
  @override
  void initState() {
    // mId = pref.getString("mID");
    log(mId.toString());
    getcartCount();
    _getCurrentLocation();
    super.initState();
    gatinfoCount();
  }

  String? lngval;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GroceryAppHomeScreen _screen = GroceryAppHomeScreen();
  // final Cgategorywise _categories = Cgategorywise("");
  final ActiveMembership _slmplan =
      ActiveMembership(GroceryAppConstant.mid, false);
  final WishList _cartitem = WishList();
  final ProfileView _profilePage = ProfileView();
  final WalltReport _WalltReport = WalltReport(
    ShowAppBar: false,
  );
  final CustomOrder _customOrder = CustomOrder();
  int _current = 0;
  int _selectedIndex = 0;
  Widget _showPage = new GroceryAppHomeScreen();
  List<Widget> screems = [
    GroceryAppHomeScreen(),
    ActiveMembership(GroceryAppConstant.mid, false),
    WalltReport(
      ShowAppBar: false,
    ),
    WishList(),
    ProfileView(),
  ];

  Widget _PageChooser(int page) {
    switch (page) {
      case 0:
        _onItemTapped(0);
        return _screen;
        break;
      case 1:
        _onItemTapped(1);
        return _slmplan;
        break;
      case 2:
        _onItemTapped(2);
        return _WalltReport;
        break;
      case 3:
        _onItemTapped(3);
        return _cartitem;
        break;
      case 4:
        _onItemTapped(4);
        return _profilePage;
        break;
      default:
        return Container(
          child: Center(
            child: Text('No Page is found'),
          ),
        );
    }
  }

  String? appname;
  String? hm, cat, cart, hlp;
  static String? cathome;
  bool check = false;
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Select City'),
            content: Container(
              width: double.maxFinite,
              height: 400,
              child: FutureBuilder(
                  future: getPcity(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length == null
                              ? 0
                              : snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: snapshot.data![index] != 0 ? 130.0 : 230.0,
                              color: Colors.white,
//                                margin: EdgeInsets.only(right: 10),

                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    check = true;
                                    pref!.setString('city',
                                        snapshot.data![index].places ?? "");
                                    pref!.setString('cityid',
                                        snapshot.data![index].loc_id ?? "");
                                    GroceryAppConstant.cityid =
                                        snapshot.data![index].loc_id ?? "";
                                    GroceryAppConstant.citname =
                                        snapshot.data![index].places ?? "";
                                    Navigator.pop(context);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GroceryApp()),
                                    );
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Card(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.all(10),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0),
                                          child: Text(
                                            snapshot.data![index].places ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: GroceryAppColors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Divider(
                                    //
                                    //   color: AppColors.black,
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),
            actions: <Widget>[
              new TextButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: check ? Colors.green : Colors.grey),
                ),
                onPressed: () {
                  check
                      ? Navigator.of(context).pop()
                      : showLongToast("Please Select city");
                },
              )
            ],
          );
        });
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    log("mid home");
    pref = await SharedPreferences.getInstance();
    mId = pref!.getString("mID") ?? "";
    log("mid home const" + GroceryAppConstant.mid);
  }

  exitApp() async {
    await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
              title: Text('Warning'),
              content: Text('Do you really want to exit'),
              actions: [
                TextButton(
                  child: Text('Yes'),
                  onPressed: () => {
                    exit(0),
                  },
                ),
                TextButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(c, false),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    getcartCount();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //getcartCount();
    });
    return WillPopScope(
      onWillPop: () async {
        return exitApp();
        //}
        // we can now close the app.
        //return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        backgroundColor: Colors.transparent,
        drawer: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Color(0xFFFFF5F8),
                Color(0xFFFCE4EC),
              ],
            ),
          ),
          child: Drawer(
            backgroundColor: Colors.transparent,
            child: AppDrawer(
              onTabTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE91E63),
                  Color(0xFFD81B60),
                  Color(0xFFAD1457),
                ],
              ),
            ),
          ),
          centerTitle: true,
          title: Container(
            height: 45,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.menu_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          actions: <Widget>[
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WishList()),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                if (cc > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cc',
                        style: TextStyle(
                          color: Color(0xFFE91E63),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 8),
          ],
        ),
//              MyAppBar(
//                scaffoldKey: _scaffoldKey,
//              ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xFFFFF5F8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFE91E63).withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: _selectedIndex == 0
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFE91E63).withOpacity(0.2),
                              Color(0xFFE91E63).withOpacity(0.1),
                            ],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.home_outlined,
                    color: _selectedIndex == 0
                        ? Color(0xFFE91E63)
                        : Color(0xFF9E9E9E),
                    size: 24,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: _selectedIndex == 1
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFE91E63).withOpacity(0.2),
                              Color(0xFFE91E63).withOpacity(0.1),
                            ],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.card_membership_rounded,
                    color: _selectedIndex == 1
                        ? Color(0xFFE91E63)
                        : Color(0xFF9E9E9E),
                    size: 24,
                  ),
                ),
                label: 'Package',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: _selectedIndex == 2
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFE91E63).withOpacity(0.2),
                              Color(0xFFE91E63).withOpacity(0.1),
                            ],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: _selectedIndex == 2
                        ? Color(0xFFE91E63)
                        : Color(0xFF9E9E9E),
                    size: 24,
                  ),
                ),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: _selectedIndex == 3
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFE91E63).withOpacity(0.2),
                              Color(0xFFE91E63).withOpacity(0.1),
                            ],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: _selectedIndex == 3
                        ? Color(0xFFE91E63)
                        : Color(0xFF9E9E9E),
                    size: 24,
                  ),
                ),
                label: 'My cart',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: _selectedIndex == 4
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFE91E63).withOpacity(0.2),
                              Color(0xFFE91E63).withOpacity(0.1),
                            ],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: _selectedIndex == 4
                        ? Color(0xFFE91E63)
                        : Color(0xFF9E9E9E),
                    size: 24,
                  ),
                ),
                label: 'Account',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xFFE91E63),
            unselectedItemColor: Color(0xFF9E9E9E),
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.3,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 11,
              letterSpacing: 0.2,
            ),
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF5F8),
                Colors.white,
                Color(0xFFFFF5F8).withOpacity(0.3),
              ],
            ),
          ),
          child: screems[_selectedIndex],
        ),

//         body: Container(
//             color: GroceryAppColors.tela,
// //    margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
//             child: _showPage),
      ),
    );
  }
}
