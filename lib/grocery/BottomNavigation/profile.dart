import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/constent/app_constent.dart';
import 'package:royalmart/dbhelper/CarrtDbhelper.dart' as food;
import 'package:royalmart/grocery/General/AppConstant.dart';

import 'package:royalmart/grocery/dbhelper/CarrtDbhelper.dart' as grocery;
import 'package:royalmart/grocery/screen/MyReview.dart';
import 'package:royalmart/grocery/screen/ShowAddress.dart';
import 'package:royalmart/grocery/screen/active_membership.dart';
import 'package:royalmart/grocery/screen/add_bank_details.dart';
import 'package:royalmart/grocery/screen/changePassword.dart';
import 'package:royalmart/grocery/screen/editprofile.dart';

import 'package:royalmart/grocery/screen/myorder.dart';
import 'package:royalmart/grocery/screen/screen_memebership.dart';
import 'package:royalmart/service_app/dbhelper/CarrtDbhelper.dart' as service;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  final Function? changeView;

  const ProfileView({Key? key, this.changeView}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? name = "";
  String? image;
  String? email = "";
  String? user_id = "";
  String? mId = "";
  bool? isloginv = false;
  final food.DbProductManager dbmanager1 = new food.DbProductManager();
  final grocery.DbProductManager dbmanager2 = new grocery.DbProductManager();
  final service.DbProductManager dbmanager3 = new service.DbProductManager();

  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    isloginv = pref.get("isLogin") as bool?;
    Object? name = pref.get("name");
    Object? email = pref.get("email");
    Object? image = pref.get("pp");
    Object? userid = pref.get("user_id");
    mId = pref.getString("mID");
    log("mid pro" + pref.getString("mID").toString());
    if (isloginv == null) {
      isloginv = false;
    }

    setState(() {
      user_id = userid as String?;
      GroceryAppConstant.name = name.toString();
      GroceryAppConstant.email = email.toString();
      GroceryAppConstant.isLogin = isloginv!;
      GroceryAppConstant.User_ID = userid.toString();
      GroceryAppConstant.image = image.toString();

      // print(Constant.image.length);
      // print(Constant.name.length);
      // print("Constant.name");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GroceryAppConstant.isLogin = false;

    gatinfo();
  }

  @override
  Widget build(BuildContext context) {
    print("Constant.check");
    print(GroceryAppConstant.check);
    if (GroceryAppConstant.check) {
      gatinfo();
      setState(() {
        GroceryAppConstant.check = false;
      });
    }
    //
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FA), // Light elegant background like sign-in page
              Color(0xFFFFE8F0), // Soft pink tint
              Color(0xFFF8F9FA),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFE8F0), // Soft pink background
                        Color(0xFFE91E63), // Primary accent color
                      ],
                      stops: [0.0, 1.0],
                    ),
                  ),
                  child: Column(children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 45),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: GroceryAppColors.white,
                          child: ClipOval(
                            child: new SizedBox(
                              width: 120.0,
                              height: 120.0,
                              child: GroceryAppConstant.image == null
                                  ? Image.asset(
                                      'assets/images/logo.png',
                                      fit: BoxFit.fill,
                                    )
                                  : GroceryAppConstant.image.length == 1
                                      ? Image.asset('assets/images/logo.png',
                                          fit: BoxFit.cover)
                                      : GroceryAppConstant.image ==
                                              "https://www.bigwelt.com/manage/uploads/customers/nopp.png"
                                          ? Image.asset(
                                              'assets/images/logo.png',
                                            )
                                          : Image.network(
                                              GroceryAppConstant.image,
                                              fit: BoxFit.fill),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        GroceryAppConstant.name == null
                            ? "Hello Guest"
                            : GroceryAppConstant.name.length == 1
                                ? "Hello Guest"
                                : GroceryAppConstant.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GroceryAppConstant.isLogin
                        ? Text(
                            GroceryAppConstant.email == null
                                ? " "
                                : GroceryAppConstant.email,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()),
                              );
                            },
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: GroceryAppColors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                  ]),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  height: 100,
                  child: InkWell(
                    onTap: () {
                      if (GroceryAppConstant.isLogin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TrackOrder()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 20),
                              child: Icon(
                                Icons.shopping_bag_rounded,
                                color: Color(0xFFE91E63),
                                size: 30.0,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Text(
                                  "My Orders",
                                  style: TextStyle(
                                    color: GroceryAppColors.darkGray,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  height: 100,
                  child: InkWell(
                    onTap: () {
                      if (GroceryAppConstant.isLogin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowAddress("1")),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      }
                    },
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Icon(
                              Icons.location_on,
                              color: Color(0xFFE91E63),
                              size: 30.0,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Text(
                                "Shipping address",
                                style: TextStyle(
                                  color: GroceryAppColors.darkGray,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  height: 100,
                  child: InkWell(
                    onTap: () {
                      if (GroceryAppConstant.isLogin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddBankDetails(user_id ?? "")),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      }
                    },
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Icon(
                              Icons.edit,
                              color: Color(0xFFE91E63),
                              size: 30.0,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Text(
                                "Add Bank Details",
                                style: TextStyle(
                                  color: GroceryAppColors.darkGray,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  height: 100,
                  child: InkWell(
                    onTap: () {
                      if (GroceryAppConstant.isLogin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyReview()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      }
                    },
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Icon(
                              Icons.star,
                              color: Color(0xFFE91E63),
                              size: 30.0,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Text(
                                "My review",
                                style: TextStyle(
                                  color: GroceryAppColors.darkGray,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),

                ///--------------------update password--------------------------------------------
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  height: 100,
                  child: InkWell(
                    onTap: () {
                      if (FoodAppConstant.isLogin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      }
                    },
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Icon(
                              Icons.lock,
                              color: FoodAppColors.tela,
                              size: 30.0,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Update Password ",
                                style: TextStyle(
                                  color: FoodAppColors.darkGray,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  height: 100,
                  child: InkWell(
                    onTap: () {
                      if (GroceryAppConstant.isLogin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditProfilePage(user_id ?? "")),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      }
                    },
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Icon(
                              Icons.edit,
                              color: Color(0xFFE91E63),
                              size: 30.0,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Text(
                                "Update profile",
                                style: TextStyle(
                                  color: GroceryAppColors.darkGray,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  height: 70,
                  child: InkWell(
                    onTap: () {
                      // if (FoodAppConstant.isLogin) {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => MembershipList(true)),
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ActiveMembership(mId ?? "", true)),
                      );
                      // } else {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => SignInPage()),
                      //   );
                      // }
                    },
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Icon(
                              Icons.card_membership_rounded,
                              color: Color(0xFFff1717),
                              size: 30.0,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Package",
                                style: TextStyle(
                                  color: FoodAppColors.darkGray,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),

                GroceryAppConstant.isLogin
                    ? Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                        height: 100,
                        child: InkWell(
                          onTap: () {
                            _callLogoutData();
                          },
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 20),
                                  child: Icon(
                                    Icons.logout,
                                    color: Color(0xFFE91E63),
                                    size: 30.0,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(
                                        color: GroceryAppColors.darkGray,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                        height: 100,
                        child: InkWell(
                          onTap: () {
                            if (GroceryAppConstant.isLogin) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()),
                              );
                            }
                          },
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 20),
                                  child: Icon(
                                    Icons.lock,
                                    color: GroceryAppColors.tela,
                                    size: 30.0,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: GroceryAppColors.darkGray,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _callLogoutData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    GroceryAppConstant.isLogin = false;
    GroceryAppConstant.email = " ";
    GroceryAppConstant.name = " ";
    GroceryAppConstant.image = " ";
    AppConstent.cc = 0;
    pref.setInt("cc", 0);
    pref.setString("pp", " ");
    pref.setString("email", " ");
    pref.setString("name", " ");
    pref.setBool("isLogin", false);
    dbmanager1.deleteallProducts();
    dbmanager2.deleteallProducts();

    dbmanager3.deleteallProducts();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
        (route) => false);
    // Navigator.pushAndRemoveUntil(context, newRoute, (route) => false)(
    //     context, MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
