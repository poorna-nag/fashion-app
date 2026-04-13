import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:launch_review/launch_review.dart';  // Temporarily disabled - package discontinued
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/grocery/BottomNavigation/profile.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/General/Home.dart';
import 'package:royalmart/grocery/Web/WebviewTermandCondition.dart';
import 'package:royalmart/grocery/Web/webview_team_and_prospect.dart';
import 'package:royalmart/grocery/dbhelper/database_helper.dart';
import 'package:royalmart/grocery/screen/ShowAddress.dart';
import 'package:royalmart/grocery/screen/myorder.dart';
import 'package:royalmart/grocery/screen/transaction_pin.dart';
import 'package:royalmart/screen/wallecttransation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:share_plus/share_plus.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool? islogin = false;
  String? name, email, image, cityname, mobile;
  int? wcount;
  SharedPreferences? pref;
  void gatinfo() async {
    pref = await SharedPreferences.getInstance();
    islogin = pref!.get("isLogin") as bool?;
    Object? wcount1 = pref!.get("wcount");
    name = pref!.get("name") as String?;
    email = pref!.get("email") as String?;
    image = pref!.get("pp") as String?;
    cityname = pref!.get("city") as String?;
    mobile = pref!.get("mobile") as String?;
    if (islogin == null) {
      islogin = false;
    }

    // print(islogin);
    setState(() {
      GroceryAppConstant.name = name ?? "";
      GroceryAppConstant.email = email ?? "";
      islogin == null
          ? GroceryAppConstant.isLogin = false
          : GroceryAppConstant.isLogin = islogin!;
      GroceryAppConstant.image = image!;
      print(GroceryAppConstant.image);
      GroceryAppConstant.citname = cityname ?? "";

      // print( Constant.image.length);
      wcount = wcount1 as int?;
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
                          itemCount: snapshot.data?.length ?? 0,
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
                                              left: 10, right: 10),
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
            Color(0xFFF8F9FA), // Light elegant background like sign-in page
            Color(0xFFFFE8F0), // Soft pink tint
            Color(0xFFF8F9FA),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE91E63), // Sign-in page pink color
                  Color(0xFFF8F9FA), // Light background
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Container(
                height: 68,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFE91E63), // Sign-in page pink color
                      Color(0xFFF8F9FA), // Light background
                    ],
                  ),
                ),
                child: Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 11, right: 12),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroceryApp()),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Menu",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            if (GroceryAppConstant.isLogin) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TrackOrder()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.shopping_bag,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /* USER PROFILE DRAWER Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 40,left: 20),
                  color: AppColors.tela1,
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  child:CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.white,
                    child: ClipOval(
                      child: new SizedBox(
                        width: 100.0,
                        height: 100.0,
                        child:Constant.image==null? Image.asset('assets/images/logo.png',):Constant.image.length==1?Image.asset('assets/images/logo.png',):Constant.image=="https://www.bigwelt.com/manage/uploads/customers/nopp.png"? Image.asset('assets/images/logo.png',):Image.network(
                          Constant.image,
                          fit: BoxFit.fill,),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child:Text(islogin?Constant.name:" ",style: TextStyle(color: Colors.black),) ,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20,bottom: 20),
                  child:Text(islogin?Constant.email:" ",style: TextStyle(color: Colors.black),),
                ),
            /*    InkWell(
                  onTap: (){
                    _displayDialog(context);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20,bottom: 20),
                    child:Text(Constant.citname!=null?Constant.citname:" ",
                      overflow:TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: Colors.black),),
                  ),
                ),*/
              ],
            ),*/
          ),

          /* UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/drawer-header.jpg'),
                )),
            currentAccountPicture:  CircleAvatar(
              radius:30,
              backgroundColor: Colors.black,
              backgroundImage:Constant.image==null? AssetImage('assets/images/logo.jpg',):Constant.image.length==1?AssetImage('assets/images/logo.jpg',):Constant.image=="https://www.bigwelt.com/manage/uploads/customers/nopp.png"? AssetImage('assets/images/logo.jpg',):NetworkImage(
                  Constant.image),
            ),
            accountName: Text(islogin?Constant.name:" ",style: TextStyle(color: Colors.black),),
            accountEmail: Text(islogin?Constant.email:" ",style: TextStyle(color: Colors.black),),
          ),*/
          // Elegant menu items section with sign-in page theme
          Container(
            child: ListView(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.home, color: Color(0xFFE91E63)),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GroceryApp()),
                    );
                  },
                ),
                Divider(),
                ExpansionTile(
                  title: Text('My Account'),
                  leading: Icon(Icons.person, color: Color(0xFFE91E63)),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Color(0xFFE91E63),
                          ),
                          title: Text("My Profile"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileView(
                                        changeView: null,
                                      )),
                            );
                          }),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: ListTile(
                        leading: Icon(
                          Icons.shopping_bag,
                          color: Color(0xFFE91E63),
                        ),
                        title: Text("My Orders"),
                        onTap: () {
                          if (GroceryAppConstant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrackOrder()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()),
                            );
                          }
                        },
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: ListTile(
                        leading: Icon(
                          Icons.add_road,
                          color: Color(0xFFE91E63),
                        ),
                        title: Text("My Addresses"),
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
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Divider(),
                /*   ListTile(
                  leading: Icon(Icons.list_alt,
                      color: AppColors.tela),
                  title: Text('Shop By Categories'),
                  trailing: Text('',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(context, MaterialPageRoute(builder: (context) => Cgategorywise("0")),);
                  },
                ), */

                /* ListTile(
                  leading: Icon(Icons.offline_bolt_rounded,
                      color: AppColors.tela),
                  title: Text('Deals of the Day'),
                  trailing: Text('New',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductList("day","DEALS OF THE DAY")),
                    );
                  },
                ),*/

                /* ListTile(
                  leading: Icon(Icons.stacked_line_chart,
                      color: AppColors.tela),
                  title: Text('Top Products'),
                  trailing: Text('',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductList("top","TOP PRODUCTS")),
                    );
                  },
                ),*/

                /* ListTile(
                  leading: Icon(Icons.traffic,
                      color: AppColors.tela),
                  title: Text('New Arrival'),
                  trailing: Text('',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          ProductList("day",
                              Constant.AProduct_type_Name2)),);
                  },
                ),*/
                /* ListTile(
                  leading:
                  Icon(Icons.favorite, color: AppColors.tela),
                  title: Text('My Wishlist'),
                  /* trailing: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Text(wcount!=null?wcount.toString():'0',
                        style: TextStyle(color: Colors.white, fontSize: 15.0)),
                  ),*/
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewWishList())
//                        NewWishList()),
//                      Cat_Product
                    );
                  },
                ), */

                /*  ListTile(
                  leading: Icon(Icons.star_border,
                      color: AppColors.tela),
                  title: Text('Rate US',),
                  onTap: () {
                    Navigator.of(context).pop();

                    String os = Platform.operatingSystem; //in your code
                    if (os == 'android') {
                      // LaunchReview.launch(  // Temporarily disabled - package discontinued
                      //   androidAppId: "com.freshatdoorstep",);

                    }
                  },
                ),*/
                // ListTile(
                //   leading: Icon(Icons.analytics_rounded,
                //       color: AppColors.tela),
                //   title: Text('Blog'),
                //   trailing: Text('',
                //       style: TextStyle(color: Theme.of(context).primaryColor)),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //
                //     Navigator.push(context, MaterialPageRoute(
                //         builder: (context) => BlogScreen()),
                //     );
                //   },
                // ),
                ListTile(
                  leading: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Color(0xFFE91E63),
                  ),
                  title: Text('My Wallet'),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (GroceryAppConstant.isLogin) {
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
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.pin,
                    color: Color(0xFFE91E63),
                  ),
                  title: Text('Transaction Password'),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (GroceryAppConstant.isLogin) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionPin(),
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
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.money_sharp,
                    color: Color(0xFFE91E63),
                  ),
                  title: Text('My Earnings'),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (GroceryAppConstant.isLogin) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewClass(
                            "My Earnings",
                            "${GroceryAppConstant.base_url}Api_earnings.php?username=$mobile&shop_id=${GroceryAppConstant.Shop_id}",
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
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.send_to_mobile_sharp,
                    color: Color(0xFFE91E63),
                  ),
                  title: Text('My Team'),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (GroceryAppConstant.isLogin) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewClassTeam(
                            "My Team",
                            "${GroceryAppConstant.base_url}Api_earnings.php?username=$mobile&shop_id=${GroceryAppConstant.Shop_id}",
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
                Divider(),
                ListTile(
                  leading: Icon(Icons.phone, color: Color(0xFFE91E63)),
                  title: Text('Contact Us'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "Contact Us",
                                ""
                                    "${GroceryAppConstant.base_url}contact"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                Divider(),
                ListTile(
                  leading:
                      Icon(Icons.privacy_tip, color: Color(0xFFE91E63)),
                  title: Text('Privacy Policy'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "Privacy Policy",
                                ""
                                    "${GroceryAppConstant.base_url}pp"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.info, color: Color(0xFFE91E63)),
                  title: Text('About Us'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "About Us",
                                ""
                                    "${GroceryAppConstant.base_url}about"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.file_copy, color: Color(0xFFE91E63)),
                  title: Text('Terms & Conditions'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "Terms & Conditions",
                                ""
                                    "${GroceryAppConstant.base_url}tc"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                Divider(),
                /* ListTile(
                  leading:
                  Icon(Icons.file_copy, color: AppColors.tela),
                  title: Text('Terms & Conditions'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewClass("Terms & Conditions","https://www.freshatdoorstep.com/tc"))
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                    );
                  },
                ),*/
                /* ListTile(
                  leading:
                  Icon(Icons.question_answer, color: AppColors.tela),
                  title: Text('FAQ'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewClass("FAQ","https://www.freshatdoorstep.com/faq"))
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                    );
                  },
                ),*/
                ListTile(
                    leading: Icon(Icons.share, color: Color(0xFFE91E63)),
                    title: Text('Refer & Earn'),
                    onTap: () {
                      if (Platform.isAndroid) {
                        _shareAndroidApp();
                      } else {
                        _shareIosApp();
                      }
                    }),
                Divider(),

                GroceryAppConstant.isLogin
                    ? new Container()
                    : ListTile(
                        leading: Icon(Icons.lock, color: Color(0xFFE91E63)),
                        title: Text('Login'),
                        onTap: () {
                          Navigator.of(context).pop();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()),
                          );
                        },
                      ),
                // Divider(),
//              ListTile(
//                leading:
//                    Icon(Icons.settings, color: AppColors.tela),
//                title: Text('Settings'),
//                onTap: () {
//
//                },
//              ),
                /* Constant.isLogin? ListTile(
                  leading: Icon(Icons.exit_to_app,
                      color: AppColors.tela),
                  title: Text('Logout'),
                  onTap: () async {
                    _callLogoutData();
                  },
                ):new Container()*/
              ],
            ),
          )
        ],
      ),
    ),);
  }

  Widget rateUs() {
    return InkWell(
        onTap: () {
          String os = Platform.operatingSystem; //in your code
          if (os == 'android') {
            // LaunchReview.launch(  // Temporarily disabled - package discontinued
            //   androidAppId:
            //       "https://play.google.com/store/apps/details?id=com.chickenista",
            // );
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "Rate Us",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

  Future<void> _callLogoutData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    GroceryAppConstant.isLogin = false;
    GroceryAppConstant.email = " ";
    GroceryAppConstant.name = " ";
    GroceryAppConstant.image = " ";
    pref.setString("pp", " ");
    pref.setString("email", " ");
    pref.setString("name", " ");
    pref.setBool("isLogin", false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  // Helper method to build elegant menu items with sign-in page theme
  Widget _buildElegantMenuItem(
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
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFFE91E63).withOpacity(0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build elegant expansion tiles
  Widget _buildElegantExpansionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Container(
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
        title: Column(
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
            SizedBox(height: 2),
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
        children: children,
      ),
    );
  }

  // Helper method to build elegant sub menu items
  Widget _buildElegantSubMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFFE91E63).withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Color(0xFFE91E63),
                size: 20,
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFFE91E63).withOpacity(0.6),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build elegant dividers for sign-in page theme
  Widget _buildElegantDivider() {
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

  _shareAndroidApp() {
    GroceryAppConstant.isLogin
        ? Share.share("Hi, Looking for referral bonuses? Download " +
            GroceryAppConstant.appname +
            " app from this link: https://play.google.com/store/apps/details?id=${GroceryAppConstant.packageName}.\n Don't forget to use my referral code: ${mobile}")
        : Share.share("Hi, Looking for referral bonuses? Download " +
            GroceryAppConstant.appname +
            " app from this link: https://play.google.com/store/apps/details?id=${GroceryAppConstant.packageName}");
  }

  _shareIosApp() {
    GroceryAppConstant.isLogin
        ? Share.share("Hi, Looking for referral bonuses? Download " +
            GroceryAppConstant.appname +
            " app from this link: ${GroceryAppConstant.iosAppLink}.\n Don't forget to use my referral code: ${mobile}")
        : Share.share("Hi, Looking for referral bonuses? Download " +
            GroceryAppConstant.appname +
            " app from this link:${GroceryAppConstant.iosAppLink}");
  }
}
