import 'dart:io';

import 'package:flutter/material.dart';
import 'package:royalmart/grocery/BottomNavigation/grocery_app_home_screen.dart';
import 'package:royalmart/grocery/General/Home.dart';
import 'package:royalmart/screen/home_page.dart';

class ShowInVoiceId extends StatefulWidget {
  final String invoice;
  const ShowInVoiceId(this.invoice) : super();

  @override
  _ShowInVoiceIdState createState() => _ShowInVoiceIdState();
}

class _ShowInVoiceIdState extends State<ShowInVoiceId> {
  _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are You Sure !'),
            content: new Text('Do you want to continue Shopping?'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => exit(0),
                child: Text("No", style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => GroceryApp()),
                    (route) => false),
                child: Text("YES", style: TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:()=> _onBackPressed(),
      child: Container(
        child: AspectRatio(
          aspectRatio: 100 / 100,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.5, 1.0],
                colors: [
                  Color(0xFFF8F9FA),
                  Color(0xFFFFE8F0),
                  Color(0xFFE91E63).withOpacity(0.1),
                ],
              ),
            ),
            child: Center(
              child: Container(
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 150),
                          child: SizedBox(
                            height: 300,
                            width: double.infinity,
                            child: Image.asset('assets/images/orderdone1.png'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: ListTile(
                          title: Center(
                            child: Text(
                              "Order Placed",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, bottom: 1),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      height: 40,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0xFFE91E63).withOpacity(0.5),
                                        ),
//                                    borderRadius: BorderRadius.(10.0),
                                      ),
                                      child: Center(
                                        child: Text('Order ID',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: Color(0xFFE91E63),
                                              fontWeight: FontWeight.w700,
                                            )),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 10.0, bottom: 11.0),
                                    height: 40,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFFE91E63).withOpacity(0.5),
                                      ),
//                                    borderRadius: BorderRadius.(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.invoice,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GroceryApp()),
                                          (route) => false);
                                    },
                                    child: Center(
                                      child: Text(
                                        "Continue Shopping ?",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFE91E63),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
