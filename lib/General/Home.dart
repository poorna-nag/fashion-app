import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:royalmart/BottomNavigation/categories.dart';
import 'package:royalmart/BottomNavigation/profile.dart';
import 'package:royalmart/BottomNavigation/food_app_home_screen.dart';
import 'package:royalmart/BottomNavigation/wishlist.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/Utils.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/screen/CustomeOrder.dart';
import 'package:royalmart/screen/SearchScreen.dart';
import 'package:royalmart/screen/feedback.dart';
import 'package:royalmart/utils/dimensions.dart';
import 'package:royalmart/widgets/bottom_nav_item.dart';
import 'package:royalmart/widgets/cart_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'my_app_bar.dart';

class MyApp1 extends StatefulWidget {
  @override
  MyApp1State createState() => MyApp1State();
}

class MyApp1State extends State<MyApp1> {
  static int? countval = 0;
  SharedPreferences ?pref;

  void gatinfoCount() async {
    pref = await SharedPreferences.getInstance();
    double latitud = double.parse(
        pref!.getString("lat") != null ? pref!.getString("lat")??"" : "00");
    double longitud = double.parse(
        pref!.getString("lng") != null ? pref!.getString("lng")??"" : "00");
    int ?Count = pref!.getInt("itemCount");
    bool ?ligin = pref!.getBool("isLogin");
    String ?userid = pref!.getString("user_id");
    String ?image = pref!.getString("pp");
    setState(() {
      FoodAppConstant.latitude = latitud;
      FoodAppConstant.longitude = longitud;

      FoodAppConstant.image = image!;
      FoodAppConstant.user_id = userid!;
      if (ligin != null) {
        FoodAppConstant.isLogin = ligin;
      } else {
        FoodAppConstant.isLogin = false;
      }
      if (Count == null) {
        FoodAppConstant.foodAppCartItemCount = 0;
      } else {
        FoodAppConstant.foodAppCartItemCount = Count;
        countval = Count;
      }
    });
  }

  int count = 0;
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
  void initState() {
//    getData();
    super.initState();
    gatinfoCount();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FoodAppHomeScreen? _screen = FoodAppHomeScreen();
  final Cgategorywise? _categories = Cgategorywise();

  final WishList _cartitem = WishList();
  final ProfileView _profilePage = ProfileView();
  final FeedBack _feedback = FeedBack();

  int _current = 0;
  int _selectedIndex = 0;
  Widget _showPage = new FoodAppHomeScreen();

  Widget _PageChooser(int page) {
    switch (page) {
      case 0:
        _onItemTapped(0);
        return _screen!;
        break;
      case 1:
        _onItemTapped(1);
        return _categories!;
        break;
      case 2:
        _onItemTapped(2);
        return _cartitem;
        break;
      case 3:
        _onItemTapped(3);
        return _feedback;
        break;
      case 4:
        _onItemTapped(4);
        return _profilePage;
        break;

      default:
        return Container(
          child: Center(
            child: Text('Page does not exist!!'),
          ),
        );
    }
  }

  bool check = false;
  _shairApp() {
   
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
        return exitApp();
      
      },
            //}
            // we can now close the app.

            child: AlertDialog(
              scrollable: true,
              title: Text('Please Select City'),
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
                                width:
                                    snapshot.data![index] != 0 ? 130.0 : 230.0,
                                color: Colors.white,
//                                margin: EdgeInsets.only(right: 10),

                                child: InkWell(
                                  onTap: () {
                                    Utils.firstTimeOpen = false;
                                    print("Clickkk-->   ");
                                    print(
                                        "Clickkk-->2  ${snapshot.data![index].places} ");
                                    setState(() {
                                      check = true;
                                      pref!.setString(
                                          'city', snapshot.data![index].places??"");
                                      pref!.setString('cityid',
                                          snapshot.data![index].loc_id??"");
                                      FoodAppConstant.cityid =
                                          snapshot.data![index].loc_id??"";
                                      FoodAppConstant.citname =
                                          snapshot.data![index].places??"";
                                      Navigator.pop(context);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyApp1()),
                                      );
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              snapshot.data![index].places??"",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: FoodAppColors.black,
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
                        : showLongToast(" Select city");
                  },
                )
              ],
            ),
          );
        });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    gatinfoCount();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Utils.firstTimeOpen == true) {
        //_displayDialog(context);
        Utils.firstTimeOpen = false;
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: AppDrawer(),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 5,
          backgroundColor: _selectedIndex == 2
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          child: CartWidget(
            color: _selectedIndex == 2
                ? Theme.of(context).cardColor
                : Theme.of(context).disabledColor,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              _selectedIndex = 2;
              _showPage = _PageChooser(2);
            });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        notchMargin: 5,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: Row(children: [
            BottomNavItem(
              iconData: Icons.home,
              isSelected: _selectedIndex == 0,
              onTap: () => _showPage = _showPage = _PageChooser(0),
            ),
            BottomNavItem(
              iconData: Icons.category_sharp,
              isSelected: _selectedIndex == 1,
              onTap: () => _showPage = _showPage = _PageChooser(1),
            ),
            Expanded(child: SizedBox()),
            BottomNavItem(
              iconData: Icons.feedback,
              isSelected: _selectedIndex == 3,
              onTap: () => _showPage = _showPage = _PageChooser(3),
            ),
            BottomNavItem(
              iconData: Icons.menu,
              isSelected: _selectedIndex == 4,
              onTap: () => _showPage = _showPage = _PageChooser(4),
            ),
          ]),
        ),
      ),

      /* bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              color: _selectedIndex == 0 ? AppColors.tela.withOpacity(.6) : AppColors.tela,
              size: 25,
            ),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category,
              color: _selectedIndex == 1 ? AppColors.tela.withOpacity(.6) : AppColors.tela,
              size: 25,
            ),
            title: Text('categories'),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                color: _selectedIndex == 2 ? AppColors.tela.withOpacity(.6) : AppColors.tela,
                size: 25,
              ),
              title: Text(
                'My cart',
              )),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.rate_review,
              color: _selectedIndex == 2 ? AppColors.tela.withOpacity(.6) : AppColors.tela,
              size: 25,
            ),
            title: Text('Feedback'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _selectedIndex == 4 ? AppColors.tela.withOpacity(.6) : AppColors.tela,
              size: 25,
            ),
            title: Text('Account'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.tela.withOpacity(.6),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _showPage = _PageChooser(index);
          });
        },
      ),*/
      body: Container(child: _showPage),
    );
  }
}
