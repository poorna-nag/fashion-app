import 'dart:io';

import 'package:flutter/material.dart';
import 'package:royalmart/BottomNavigation/profile.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/General/drawer.dart';
import 'package:royalmart/screen/myorder.dart';
import 'package:royalmart/screen/vendor_categories.dart';
import 'package:royalmart/screen/wallecttransation.dart';
import 'package:royalmart/service_app/General/AppConstant.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Widget> pages = [
    VendorCategories(),
    TrackOrder(),
    WalltReport(),
    ProfileView(),
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // drawer is open then first close it
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        } else {
          showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                    title: Text('Warning'),
                    content: Text('Do you really want to exit?'),
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
        // we can now close the app.
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: FoodAppColors.tela,
        appBar: AppBar(
          backgroundColor: FoodAppColors.tela,
          elevation: 0,
          title: Text(
            FoodAppConstant.appname,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () {
                    // Navigate to cart
                  },
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: AppDrawer(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: FoodAppColors.tela,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                //  color: ServiceAppColors.tela,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 1
                      ? Icons.shopping_bag
                      : Icons.shopping_bag_outlined,
                  //color: ServiceAppColors.tela,
                ),
                label: 'Orders'),
            BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 2
                      ? Icons.account_balance_wallet
                      : Icons.account_balance_wallet_outlined,
                  // color: ServiceAppColors.tela,
                ),
                label: 'Wallet'),
            BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 3 ? Icons.menu_open : Icons.menu,
                  //color: ServiceAppColors.tela,
                ),
                label: 'More'),
          ],
          selectedItemColor: ServiceAppColors.tela,
          unselectedItemColor: ServiceAppColors.black,
          selectedLabelStyle: TextStyle(color: Colors.red),
          unselectedLabelStyle: TextStyle(color: Colors.green),
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          onTap: changeIndex,
        ),
        body: pages[_selectedIndex],
      ),
    );
  }

  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
