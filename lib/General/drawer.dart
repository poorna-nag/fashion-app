import 'dart:io';

import 'package:flutter/material.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/General/Home.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/map/mainScreen.dart';
import 'package:royalmart/screen/CustomeOrder.dart';
import 'package:royalmart/screen/choosevendertype.dart';
import 'package:royalmart/screen/coupon_codes.dart';
import 'package:royalmart/screen/myorder.dart';
import 'package:royalmart/screen/newWishlist.dart';
import 'package:royalmart/screen/productlist.dart';
import 'package:royalmart/screen/wallecttransation.dart';
import 'package:royalmart/webview/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:share_plus/share_plus.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool islogin = false;
  String? name, email, image, cityname, mobile;
  int? wcount;
  SharedPreferences? pref;
  void gatinfo() async {
    pref = await SharedPreferences.getInstance();
    islogin = pref!.getBool("isLogin")!;
    int? wcount1 = pref!.get("wcount") as int?;
    name = pref!.get("name") as String?;
    email = pref!.get("email") as String?;
    image = pref!.get("pp") as String?;
    cityname = pref!.get("city") as String?;
    mobile = pref!.getString('mobile');
    if (islogin == null) {
      islogin = false;
    }

    // print(islogin);
    setState(() {
      FoodAppConstant.name = name ?? "";
      FoodAppConstant.email = email ?? "";
      islogin == null
          ? FoodAppConstant.isLogin = false
          : FoodAppConstant.isLogin = islogin;
      FoodAppConstant.image = image ?? "";
      print(FoodAppConstant.image);
      FoodAppConstant.citname = cityname ?? "";
      // print( Constant.image.length);
      wcount = wcount1;
    });
  }

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
                              margin: EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    check = true;
                                    pref!.setString('city',
                                        snapshot.data![index].places ?? "");
                                    pref!.setString('cityid',
                                        snapshot.data![index].loc_id ?? "");
                                    FoodAppConstant.cityid =
                                        snapshot.data![index].loc_id ?? "";
                                    FoodAppConstant.citname =
                                        snapshot.data![index].places ?? "";
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyApp1()),
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
                                              left: 10, right: 10),
                                          child: Text(
                                            snapshot.data![index].places ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: FoodAppColors.white,
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
              new ElevatedButton(
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

  @override
  void initState() {
    gatinfo();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8F9FA), // Light elegant background
            Color(0xFFFFE8F0), // Soft pink tint
            Color(0xFFF8F9FA),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            // Enhanced header with sign-in page theme
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Color(0xFFFFF0F5), // Light pink background
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFE91E63).withOpacity(0.15),
                    blurRadius: 25,
                    spreadRadius: 5,
                    offset: Offset(0, 8),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    children: [
                      // Enhanced profile section
                      Row(
                        children: [
                          // Enhanced profile avatar
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFE91E63).withOpacity(0.2),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFE91E63).withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: SizedBox(
                                  width: 70.0,
                                  height: 70.0,
                                  child: FoodAppConstant.image == null ||
                                          FoodAppConstant.image.isEmpty ||
                                          FoodAppConstant.image.length == 1 ||
                                          FoodAppConstant.image ==
                                              "https://www.bigwelt.com/manage/uploads/customers/nopp.png"
                                      ? Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFE91E63)
                                                    .withOpacity(0.1),
                                                Colors.white,
                                              ],
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.person_rounded,
                                            color: Color(0xFFE91E63),
                                            size: 35,
                                          ),
                                        )
                                      : Image.network(
                                          FoodAppConstant.image,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFFE91E63)
                                                      .withOpacity(0.1),
                                                  Colors.white,
                                                ],
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.person_rounded,
                                              color: Color(0xFFE91E63),
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          // User info with sign-in page typography
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  islogin && FoodAppConstant.name.isNotEmpty
                                      ? "👋 Hello, ${FoodAppConstant.name}"
                                      : "👋 Welcome, Guest!",
                                  style: TextStyle(
                                    color: Color(0xFF2D3748),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  islogin && FoodAppConstant.email.isNotEmpty
                                      ? FoodAppConstant.email
                                      : "Sign in to access your account",
                                  style: TextStyle(
                                    color: Color(0xFF718096),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (!islogin) ...[
                                  SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignInPage()),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 6),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFE91E63).withOpacity(0.1),
                                            Color(0xFFE91E63).withOpacity(0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Color(0xFFE91E63)
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        "Sign In",
                                        style: TextStyle(
                                          color: Color(0xFFE91E63),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Elegant menu items section with sign-in page theme
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFE91E63).withOpacity(0.08),
                    spreadRadius: 3,
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: Color(0xFFE91E63).withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Home item
                  _buildModernMenuItem(
                    context,
                    icon: Icons.home_rounded,
                    title: '🏠 Home',
                    subtitle: 'Go to main screen',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp1()),
                      );
                    },
                  ),
                  _buildDivider(),

                  // My Orders item
                  _buildModernMenuItem(
                    context,
                    icon: Icons.shopping_bag_rounded,
                    title: '📦 My Orders',
                    subtitle: 'Track your purchases',
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
                  ),
                  _buildDivider(),

                  // Coupon Codes item
                  _buildModernMenuItem(
                    context,
                    icon: Icons.local_offer_rounded,
                    title: '🎫 Coupon Codes',
                    subtitle: 'Save more with offers',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CouponCodes()),
                      );
                    },
                  ),
                  _buildDivider(),

                  // My Wallet item
                  _buildModernMenuItem(
                    context,
                    icon: Icons.account_balance_wallet_rounded,
                    title: '💰 My Wallet',
                    subtitle: 'Check your balance',
                    onTap: () {
                      Navigator.of(context).pop();
                      if (FoodAppConstant.isLogin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WalltReport(
                              ShowAppBar: true,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInPage(),
                          ),
                        );
                      }
                    },
                  ),
                  _buildDivider(),

                  // My Earnings item
                  _buildModernMenuItem(
                    context,
                    icon: Icons.trending_up_rounded,
                    title: '💵 My Earnings',
                    subtitle: 'Track your referrals',
                    onTap: () {
                      Navigator.of(context).pop();
                      if (FoodAppConstant.isLogin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewClass(
                              "My Earnings",
                              "${FoodAppConstant.base_url}Api_earnings.php?username=$mobile&shop_id=${FoodAppConstant.Shop_id}",
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInPage(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Support & Information section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFE91E63).withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Section header
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFE91E63).withOpacity(0.1),
                                Color(0xFFE91E63).withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.support_agent_rounded,
                            color: Color(0xFFE91E63),
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Support & Information",
                          style: TextStyle(
                            color: Color(0xFF2D3748),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Contact Us item
                  _buildModernMenuItem(
                    context,
                    icon: Icons.phone_rounded,
                    title: '📞 Contact Us',
                    subtitle: 'Get help and support',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CustomeOrder()),
                      );
                    },
                  ),
                  _buildDivider(),

                  // Privacy Policy item
                  _buildModernMenuItem(
                    context,
                    icon: Icons.privacy_tip_rounded,
                    title: '🔒 Privacy Policy',
                    subtitle: 'How we protect your data',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewClass(
                            "Privacy Policy",
                            FoodAppConstant.base_url + "pp",
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),

                  // Terms & Conditions item
                  _buildModernMenuItem(
                    context,
                    icon: Icons.description_rounded,
                    title: '📋 Terms & Conditions',
                    subtitle: 'App usage guidelines',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewClass(
                            "Terms & Conditions",
                            FoodAppConstant.base_url + "tc",
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),

                  // FAQ item
                  _buildModernMenuItem(
                    context,
                    icon: Icons.help_rounded,
                    title: '❓ FAQ',
                    subtitle: 'Frequently asked questions',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewClass(
                            "FAQ",
                            FoodAppConstant.base_url + "faq",
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),

                  // Refer & Earn item
                  _buildModernMenuItem(
                    context,
                    icon: Icons.share_rounded,
                    title: '🎁 Refer & Earn',
                    subtitle: 'Share app and earn rewards',
                    onTap: () {
                      if (Platform.isAndroid) {
                        _shareAndroidApp();
                      } else {
                        _shareIosApp();
                      }
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Authentication section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFE91E63).withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (!FoodAppConstant.isLogin)
                    _buildModernMenuItem(
                      context,
                      icon: Icons.login_rounded,
                      title: '🔑 Login',
                      subtitle: 'Access your account',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                    ),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method to build elegant menu items with sign-in page theme
  Widget _buildModernMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8F9FA),
                    Color(0xFFFFE8F0),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFE91E63).withOpacity(0.12),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Color(0xFFE91E63).withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: Color(0xFFE91E63),
                size: 24,
              ),
            ),
            SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFF2D3748),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Color(0xFF718096),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFFE91E63).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFFE91E63),
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build elegant dividers for sign-in page theme
  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Color(0xFFE91E63).withOpacity(0.08),
            Color(0xFFF8F9FA),
            Color(0xFFE91E63).withOpacity(0.08),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Future<void> _callLogoutData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    FoodAppConstant.isLogin = false;
    FoodAppConstant.email = " ";
    FoodAppConstant.name = " ";
    FoodAppConstant.image = " ";
    pref.setString("pp", " ");
    pref.setString("email", " ");
    pref.setString("name", " ");
    pref.setBool("isLogin", false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  _shareAndroidApp() {
    FoodAppConstant.isLogin
        ? Share.share("Hi, Looking for referral bonuses? Download " +
            FoodAppConstant.appname +
            " app from this link: https://play.google.com/store/apps/details?id=${FoodAppConstant.packageName}.\n Don't forget to use my referral code: ${this.mobile}")
        : Share.share("Hi, Looking for referral bonuses? Download " +
            FoodAppConstant.appname +
            " app from this link: https://play.google.com/store/apps/details?id=${FoodAppConstant.packageName}");
  }

  _shareIosApp() {
    FoodAppConstant.isLogin
        ? Share.share("Hi, Looking for referral bonuses? Download " +
            FoodAppConstant.appname +
            " app from this link: ${FoodAppConstant.iosAppLink}.\n Don't forget to use my referral code: ${this.mobile}")
        : Share.share("Hi, Looking for referral bonuses? Download " +
            FoodAppConstant.appname +
            " app from this link:${FoodAppConstant.iosAppLink}");
  }
}
