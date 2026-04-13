import 'package:flutter/material.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/screen/MyReview.dart';
import 'package:royalmart/screen/ShowAddress.dart';
import 'package:royalmart/screen/editprofile.dart';
import 'package:royalmart/screen/myorder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:royalmart/service_app/dbhelper/CarrtDbhelper.dart' as service;
import 'package:royalmart/grocery/dbhelper/CarrtDbhelper.dart' as grocery;
import 'package:royalmart/dbhelper/CarrtDbhelper.dart' as food;

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
  bool? isloginv = false;
  final food.DbProductManager dbmanager1 = new food.DbProductManager();
  final grocery.DbProductManager dbmanager2 = new grocery.DbProductManager();
  final service.DbProductManager dbmanager3 = new service.DbProductManager();

  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    isloginv = pref.get("isLogin") as bool?;
    name = pref.get("name") as String?;
    email = pref.get("email") as String?;
    Object? image = pref.get("pp");
    String? userid = pref.get("user_id") as String?;
    if (isloginv == null) {
      isloginv = false;
    }

    setState(() {
      user_id = userid;
      FoodAppConstant.name = name ?? "";
      FoodAppConstant.email = email ?? "";
      FoodAppConstant.isLogin = isloginv!;
      FoodAppConstant.User_ID = userid ?? "";
      FoodAppConstant.image = image.toString();
      // print( "image " +Constant.image);

      // print(Constant.image.length);
      // print(Constant.name.length);
      // print("Constant.name");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FoodAppConstant.isLogin = false;

    gatinfo();
  }

  @override
  Widget build(BuildContext context) {
    print("Constant.check");
    print(FoodAppConstant.check);
    if (FoodAppConstant.check) {
      gatinfo();
      setState(() {
        FoodAppConstant.check = false;
      });
    }
    //
    return Scaffold(
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
      child: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Enhanced Header Section with Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE91E63),
                    Color(0xFFD81B60),
                    Color(0xFFAD1457),
                    Color(0xFF880E4F),
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFE91E63).withOpacity(0.4),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  // Enhanced Profile Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: SizedBox(
                          width: 120.0,
                          height: 120.0,
                          child: FoodAppConstant.image == null ||
                                  FoodAppConstant.image ==
                                      'https://www.bigwelt.com/manage/uploads/customers/nopp.png'
                              ? Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFE91E63).withOpacity(0.1),
                                        Color(0xFFE91E63).withOpacity(0.05),
                                      ],
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: Color(0xFFE91E63),
                                    size: 60,
                                  ),
                                )
                              : Image.network(
                                  FoodAppConstant.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFE91E63).withOpacity(0.1),
                                          Color(0xFFE91E63).withOpacity(0.05),
                                        ],
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: Color(0xFFE91E63),
                                      size: 60,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Enhanced Name and Email Section
                  Text(
                    FoodAppConstant.name == null ||
                            FoodAppConstant.name.length <= 1
                        ? "👋 Hello Guest!"
                        : "👋 Hello, ${FoodAppConstant.name}!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  FoodAppConstant.isLogin
                      ? Text(
                          FoodAppConstant.email ?? "",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              "🔑 Tap to Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 5),
              height: 70,
              child: InkWell(
                onTap: () {
                  if (FoodAppConstant.isLogin) {
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
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 20),
                        child: Icon(
                          Icons.delivery_dining,
                          color: FoodAppColors.boxColor1,
                          size: 30.0,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "My Orders",
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
              margin: EdgeInsets.only(left: 20, right: 20, top: 5),
              height: 70,
              child: InkWell(
                onTap: () {
                  if (FoodAppConstant.isLogin) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShowAddress("1")),
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
                          Icons.home_outlined,
                          color: FoodAppColors.boxColor1,
                          size: 30.0,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Shipping address",
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
              margin: EdgeInsets.only(left: 20, right: 20, top: 5),
              height: 70,
              child: InkWell(
                onTap: () {
                  if (FoodAppConstant.isLogin) {
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
                          Icons.streetview,
                          color: FoodAppColors.boxColor1,
                          size: 30.0,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "My review ",
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
              height: 75,
              child: InkWell(
                onTap: () {
                  if (FoodAppConstant.isLogin) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage(user_id ?? "")),
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
                          Icons.update,
                          color: FoodAppColors.boxColor1,
                          size: 30.0,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Update profile ",
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
            FoodAppConstant.isLogin
                ? Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    height: 70,
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
                                Icons.exit_to_app,
                                color: FoodAppColors.boxColor1,
                                size: 30.0,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Logout ",
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
                  )
                : Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    height: 70,
                    child: InkWell(
                      onTap: () {
                        if (FoodAppConstant.isLogin) {
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
                                Icons.power_settings_new,
                                color: FoodAppColors.boxColor1,
                                size: 30.0,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Login ",
                                  style: TextStyle(
                                    color: FoodAppColors.darkGray,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        )),
      ),
    ));
  }

  Future<void> _callLogoutData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    FoodAppConstant.isLogin = false;
    FoodAppConstant.email = " ";
    FoodAppConstant.name = " ";
    FoodAppConstant.image = " ";

    pref.setString("pp", " ");
    pref.setString("email", " ");
    pref.setString("name", " ");
    pref.setBool("isLogin", false);
    dbmanager1.deleteallProducts();
    dbmanager2.deleteallProducts();

    dbmanager3.deleteallProducts();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
