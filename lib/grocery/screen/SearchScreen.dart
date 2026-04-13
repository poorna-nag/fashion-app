import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/grocery/General/AnimatedSplashScreen.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/grocery/dbhelper/database_helper.dart';
import 'package:royalmart/grocery/model/productmodel.dart';
import 'package:royalmart/grocery/screen/detailpage.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// Define your Products class and GroceryAppConstant appropriately.

class UserFilterDemo extends StatefulWidget {
  UserFilterDemo() : super();

  @override
  UserFilterDemoState createState() => UserFilterDemoState();
}

class Debouncer {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}

class UserFilterDemoState extends State<UserFilterDemo> {
  final _debouncer = Debouncer(milliseconds: 500);
  List<Products> users = [];
  List<Products> suggestionList = [];
  bool _progressBarActive = false;
  bool _loadMoreActive = false;
  int _currentOffset = 0;
  String _currentQuery = "";
  bool _hasMoreData = true;
  ScrollController _scrollController = ScrollController();
  int _currentRequestId = 0;

  @override
  void initState() {
    super.initState();

    // Add scroll listener for infinite scroll
    _scrollController.addListener(_scrollListener);

    // Load all products initially (empty query shows all products)
    _loadProducts("");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // User is near the bottom (200 pixels before the end)
      // Load more only if user is not actively searching (browsing all products)
      // Don't load more when user has typed something (search mode)
      if (_hasMoreData &&
          !_loadMoreActive &&
          suggestionList.isNotEmpty &&
          (_currentQuery.trim().isEmpty)) {
        _loadMoreProducts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.5, 1.0],
              colors: [
                Color.fromARGB(255, 201, 35, 104),
                Color.fromARGB(255, 205, 85, 127),
                Color(0xFFE91E63),
              ],
            ),
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: InkWell(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width - 90,
              child: Material(
                color: Colors.white,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: TextField(
                    onChanged: (string) {
                      // Use the debouncer to delay the API call until the user stops typing for 500 milliseconds
                      _debouncer.run(() {
                        _loadProducts(string);
                      });
                    },
                    style: TextStyle(color: Color(0xFFE91E63)),
                    decoration: InputDecoration(
                      hintText: 'Search Your Item',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _progressBarActive
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE91E63),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.5, 1.0],
                  colors: [
                    Color(0xFFF8F9FA),
                    Color(0xFFFFE8F0),
                    Color(0xFFF8F9FA),
                  ],
                ),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: suggestionList.length > 0
                        ? Stack(
                            children: [
                              GridView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                padding: EdgeInsets.all(8),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: suggestionList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                                    suggestionList[index]),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // Product Image
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                ),
                                                color: Color(0xFFFFE8F0),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                    GroceryAppConstant
                                                            .Product_Imageurl +
                                                        suggestionList[index]
                                                            .img!,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Product Details
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    suggestionList[index]
                                                            .productName ??
                                                        'name',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        '\u{20B9} ${calDiscount(suggestionList[index].buyPrice ?? "", suggestionList[index].discount ?? "")} ${suggestionList[index].unit_type ?? ""}',
                                                        style: TextStyle(
                                                          color:
                                                              GroceryAppColors
                                                                  .sellp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                      if (suggestionList[index]
                                                                  .discount !=
                                                              null &&
                                                          suggestionList[index]
                                                              .discount!
                                                              .isNotEmpty &&
                                                          suggestionList[index]
                                                                  .discount !=
                                                              "0")
                                                        Text(
                                                          '(\u{20B9} ${suggestionList[index].buyPrice})',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 10,
                                                            color:
                                                                GroceryAppColors
                                                                    .mrp,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Loading indicator at bottom when loading more (only in browse mode, not search mode)
                              if (_loadMoreActive &&
                                  _currentQuery.trim().isEmpty)
                                Positioned(
                                  bottom: 16,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircularProgressIndicator(
                                            color: Color(0xFFE91E63),
                                            strokeWidth: 2,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            'Loading more...',
                                            style: TextStyle(
                                              color: Color(0xFFE91E63),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : Center(
                            child: _progressBarActive
                                ? CircularProgressIndicator(
                                    color: Color(0xFFE91E63),
                                  )
                                : Text(
                                    suggestionList.isEmpty &&
                                            _currentQuery.isEmpty
                                        ? 'Loading products...'
                                        : _currentQuery.isEmpty
                                            ? 'No products available'
                                            : 'No products found for "$_currentQuery"',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  // Load products with pagination support
  void _loadProducts(String query) {
    // Increment request ID to track this specific search
    _currentRequestId++;
    int requestId = _currentRequestId;

    _currentQuery = query;
    _currentOffset = 0;
    _hasMoreData = true;

    // Cancel previous debounced calls if any
    _debouncer._timer?.cancel();

    // Reset scroll position when loading new search
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    searchval(query, 0, requestId).then((usersFromServe) {
      // Only update if this is still the latest request
      if (requestId == _currentRequestId) {
        setState(() {
          users = usersFromServe ?? [];
          suggestionList = users;

          // Check if we got less than 50 items, meaning no more data
          if (users.length < 50) {
            _hasMoreData = false;
          }
        });
      }
    });
  }

  // Load more products for pagination
  void _loadMoreProducts() {
    if (_loadMoreActive || !_hasMoreData) return;

    // Increment request ID for this load more request
    _currentRequestId++;
    int requestId = _currentRequestId;

    setState(() {
      _loadMoreActive = true;
    });

    _currentOffset += 50;

    searchval(_currentQuery, _currentOffset, requestId).then((usersFromServe) {
      // Only update if this is still the latest request
      if (requestId == _currentRequestId) {
        setState(() {
          _loadMoreActive = false;

          if (usersFromServe != null && usersFromServe.isNotEmpty) {
            // Add new products to existing list
            suggestionList.addAll(usersFromServe);

            // Check if we got less than 50 items, meaning no more data
            if (usersFromServe.length < 50) {
              _hasMoreData = false;
            }
          } else {
            _hasMoreData = false;
          }
        });
      }
    });
  }

  Future<List<Products>?> searchval(String query,
      [int offset = 0, int? requestId]) async {
    // Only show main loading indicator for initial load and if this is the latest request
    if (offset == 0 && (requestId == null || requestId == _currentRequestId)) {
      setState(() {
        _progressBarActive = true;
      });
    }

    String link = GroceryAppConstant.base_url +
        "manage/api/products/all/?X-Api-Key=" +
        GroceryAppConstant.API_KEY +
        "&start=$offset&limit=50&field=shop_id&filter=" +
        GroceryAppConstant.Shop_id +
        "&q=" +
        query +
        "&user_id=" +
        GroceryAppConstant.User_ID +
        "&id=";

    print("Search API: $link");

    final date2 = DateTime.now();
    String md5 =
        GroceryAppConstant.Shop_id + DateFormat("dd-MM-yyyy").format(date2);
    print(md5);
    // generateMd5(md5, query); // Ensure this function is defined or remove it if not necessary

    try {
      final response = await http.get(Uri.parse(link));

      // Check if this request is still valid
      if (requestId != null && requestId != _currentRequestId) {
        print("Request outdated, ignoring response");
        return null;
      }

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var galleryArray = responseData["data"]["products"];
        return Products.getListFromJson(galleryArray);
      } else {
        print("Failed to load products: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    } finally {
      if (offset == 0 &&
          (requestId == null || requestId == _currentRequestId)) {
        setState(() {
          _progressBarActive = false;
        });
      }
    }
  }
}

// class UserFilterDemo extends StatefulWidget {
//   UserFilterDemo() : super();

//   @override
//   UserFilterDemoState createState() => UserFilterDemoState();
// }

// class Debouncer {
//   final int? milliseconds;
//   VoidCallback? action;
//   Timer? _timer;

//   Debouncer({this.milliseconds});

//   run(VoidCallback action) {
//     if (null != _timer) {
//       _timer!.cancel();
//     }
//     _timer = Timer(Duration(milliseconds: milliseconds!), action);
//   }
// }

// class UserFilterDemoState extends State<UserFilterDemo> {
//   // https://jsonplaceholder.typicode.com/users

//   final _debouncer = Debouncer(milliseconds: 500);
//   List<Products> users = [];
//   List<Products> suggestionList = [];
//   bool _progressBarActive = false;
//   int _current = 0;
//   int total = 000;
//   int actualprice = 200;
//   double? mrp, totalmrp = 000;
//   int _count = 1;

//   double? sgst1, cgst1, dicountValue, admindiscountprice;

//   @override
//   void initState() {
//     super.initState();
//    // setState(() {
//       // users = SplashScreenState.filteredUsers;
//       // print(users.toString());
//       // suggestionList = users;
//    // });

//     // DatabaseHelper.getTopProduct("day", "0").then((usersFromServe) {
//     //   setState(() {
//     //     users = usersFromServe;
//     //     suggestionList = users;
//     //   });
//     // });
//     searchval("").then((usersFromServe) {
//       setState(() {
//         users = usersFromServe!;
//         suggestionList = users;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: GroceryAppColors.tela,
//         leading: Padding(
//             padding: EdgeInsets.only(left: 0.0),
//             child: InkWell(
//               onTap: () {
//                 if (Navigator.canPop(context)) {
//                   Navigator.pop(context);
//                 } else {
//                   SystemNavigator.pop();
//                 }
//               },
//               child: Icon(
//                 Icons.arrow_back,
//                 size: 30,
//                 color: Colors.white,
//               ),
//             )),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Container(
//               height: 40,
//               width: MediaQuery.of(context).size.width - 90,
//               padding: EdgeInsets.symmetric(
// //              vertical: 10,
// //                  horizontal: 10,
//                   ),
//               child: Container(
//                 height: 45,
//                 child: Material(
//                   color: Colors.white,
//                   elevation: 0.0,
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                       color: Colors.white,
//                     ),
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(20),
//                     ),
//                   ),
//                   clipBehavior: Clip.antiAlias,
//                   child: InkWell(
//                       child: Padding(
//                     padding: EdgeInsets.only(top: 5.0),
//                     child: TextField(
//                       onChanged: (string) {
//                          _debouncer.run(() {
//                           setState(() {
//                             suggestionList = users
//                                 .where((u) => (u.productName!
//                                     .toLowerCase()
//                                     .contains(string.toLowerCase())))
//                                 .toList();
//                           });
//                         });
//                         // if (string != null) {
//                         //   // DatabaseHelper.getTopProduct("day", "0")
//                         //   //     .then((usersFromServe) {
//                         //   //   setState(() {
//                         //   //     users = usersFromServe;
//                         //   //     if (users != null) {
//                         //   //       suggestionList = users;
//                         //   //     }
//                         //   //   });
//                         //   // });
//                         //   searchval("").then((usersFromServe) {
//                         //     setState(() {
//                         //       users = usersFromServe!;
//                         //       if (users != null) {
//                         //         suggestionList = users;
//                         //       }
//                         //     });
//                         //   });
//                         // }

//                         // _debouncer.run(() {
//                         //   setState(() {
//                         //     suggestionList = users
//                         //         .where((u) => (u.productName!
//                         //             .toLowerCase()
//                         //             .contains(string.toLowerCase())))
//                         //         .toList();
//                         //   });
//                         // });
//                       },
//                       style: TextStyle(color: Colors.green[900]),
//                       decoration: InputDecoration(
//                         hintText: 'Search Your Item',
//                         hintStyle: TextStyle(color: Colors.teal[200]),
//                         prefixIcon: Icon(
//                           Icons.search,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   )),
//                 ),
//               ),
//             ),

// //             Container(
// //               width: MediaQuery.of(context).size.width - 90,
// //               padding: EdgeInsets.symmetric(
// // //              vertical: 10,
// // //                  horizontal: 10,
// //                   ),
// //               child: Material(
// //                 color: Colors.white,
// //                 elevation: 0.0,
// //                 shape: RoundedRectangleBorder(
// //                   side: BorderSide(
// //                     color: Colors.white,
// //                   ),
// //                   borderRadius: BorderRadius.all(
// //                     Radius.circular(20),
// //                   ),
// //                 ),
// //                 clipBehavior: Clip.antiAlias,
// //                 child: InkWell(
// //                     child: Padding(
// //                   padding: EdgeInsets.only(top: 5.0),
// //                   child: TextField(
// //                     onChanged: (string) {
//             // if (string != null) {
//             //  DatabaseHelper.getTopProduct("day", "0").then((usersFromServe) {
//             //     setState(() {
//             //       users = usersFromServe;
//             //       if (users != null) {
//             //         suggestionList = users;
//             //       }
//             //     });
//             //   });
//             // }
//             // _debouncer.run(() {
//             //   setState(() {
//             //     suggestionList = users.where((u) => (u.productName.toLowerCase().contains(string.toLowerCase()))).toList();
//             //   });
//             // });
// //                     },
// //                     style: TextStyle(color: Colors.green[900]),
// //                     decoration: InputDecoration(
// //                       hintText: 'Search Your Product',
// //                       hintStyle: TextStyle(color: GroceryAppColors.black),
// //                       prefixIcon: Icon(
// //                         Icons.search,
// //                         color: Colors.black,
// //                       ),
// //                     ),
// //                   ),
// //                 )),
// //               ),
// //             ),
//           ],
//         ),
//       ),
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: suggestionList != null
//                   ? ListView.builder(
//                       shrinkWrap: true,
//                       primary: false,
//                       scrollDirection: Axis.vertical,
//                       itemCount: suggestionList.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Container(
//                           margin: EdgeInsets.only(
//                               left: 10, right: 10, top: 6, bottom: 6),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(16))),
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         ProductDetails(suggestionList[index])),
//                               );
//                             },
//                             child: Container(
//                               child: Row(
//                                 children: <Widget>[
//                                   Container(
//                                     margin: EdgeInsets.only(
//                                         right: 8, left: 8, top: 8, bottom: 8),
//                                     width: 110,
//                                     height: 110,
//                                     decoration: BoxDecoration(
//                                         border: Border.all(
//                                             color: GroceryAppColors.tela),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(14)),
//                                         color: Colors.blue.shade200,
//                                         image: DecorationImage(
//                                             fit: BoxFit.cover,
//                                             image: NetworkImage(
//                                               GroceryAppConstant
//                                                       .Product_Imageurl +
//                                                   suggestionList[index].img!,
//                                             ))),
//                                   ),
//                                   Expanded(
//                                     child: Container(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.max,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Container(
//                                             child: Text(
//                                               suggestionList[index]
//                                                           .productName ==
//                                                       null
//                                                   ? 'name'
//                                                   : suggestionList[index]
//                                                           .productName ??
//                                                       "",
//                                               overflow: TextOverflow.fade,
//                                               style: TextStyle(
//                                                       fontSize: 15,
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       color: Colors.black)
//                                                   .copyWith(fontSize: 14),
//                                             ),
//                                           ),
//                                           SizedBox(height: 6),
//                                           Row(
//                                             children: <Widget>[
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 2.0, bottom: 1),
//                                                 child: Text(
//                                                     '\u{20B9} ${calDiscount(suggestionList[index].buyPrice ?? "", suggestionList[index].discount ?? "")} ${suggestionList[index].unit_type != null ? suggestionList[index].unit_type : ""}',
//                                                     style: TextStyle(
//                                                       color: GroceryAppColors
//                                                           .sellp,
//                                                       fontWeight:
//                                                           FontWeight.w700,
//                                                     )),
//                                               ),
//                                               SizedBox(
//                                                 width: 20,
//                                               ),
//                                               Expanded(
//                                                 child: Text(
//                                                   '(\u{20B9} ${suggestionList[index].buyPrice})',
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   maxLines: 2,
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w700,
//                                                       fontStyle:
//                                                           FontStyle.italic,
//                                                       color:
//                                                           GroceryAppColors.mrp,
//                                                       decoration: TextDecoration
//                                                           .lineThrough),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                           Container(
//                                             margin: EdgeInsets.only(
//                                                 left: 0.0, right: 10),
//                                             child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.end,
//                                                 children: <Widget>[
//                                                   SizedBox(
//                                                     width: 0.0,
//                                                     height: 10.0,
//                                                   ),
// //                                                   Column(
// //                                                     children: <Widget>[
// //                                                       Row(
// //                                                         mainAxisAlignment: MainAxisAlignment.end,
// //                                                         children: <Widget>[
// //                                                           Container(
// //                                                               height: 25,
// //                                                               width: 35,
// //                                                               child: Material(
// //                                                                 color: GroceryAppColors.tela,
// //                                                                 elevation: 0.0,
// //                                                                 shape: RoundedRectangleBorder(
// //                                                                   borderRadius: BorderRadius.all(
// //                                                                     Radius.circular(15),
// //                                                                   ),
// //                                                                 ),
// //                                                                 clipBehavior: Clip.antiAlias,
// //                                                                 child: Padding(
// //                                                                   padding: EdgeInsets.only(bottom: 10),
// //                                                                   child: InkWell(
// //                                                                       onTap: () {
// //                                                                         print(suggestionList[index].count);
// //                                                                         if (suggestionList[index].count != "1") {
// //                                                                           setState(() {
// // //                                                                                _count++;
// //                                                                             String quantity = suggestionList[index].count;
// //                                                                             int totalquantity = int.parse(quantity) - 1;
// //                                                                             suggestionList[index].count = totalquantity.toString();
// //                                                                           });
// //                                                                         }
// // //
// //                                                                       },
// //                                                                       child: Padding(
// //                                                                         padding: EdgeInsets.only(
// //                                                                           top: 10.0,
// //                                                                         ),
// //                                                                         child: Icon(
// //                                                                           Icons.maximize,
// //                                                                           size: 20,
// //                                                                           color: Colors.white,
// //                                                                         ),
// //                                                                       )),
// //                                                                 ),
// //                                                               )),
// //                                                           Padding(
// //                                                             padding: EdgeInsets.only(top: 0.0, left: 15.0, right: 8.0),
// //                                                             child: Center(
// //                                                               child: Text(
// //                                                                   suggestionList[index].count != null ? '${suggestionList[index].count}' : '$_count',
// //                                                                   style: TextStyle(
// //                                                                       color: Colors.black,
// //                                                                       fontSize: 19,
// //                                                                       fontFamily: 'Roboto',
// //                                                                       fontWeight: FontWeight.bold)),
// //                                                             ),
// //                                                           ),
// //                                                           Container(
// //                                                               margin: EdgeInsets.only(left: 3.0),
// //                                                               height: 25,
// //                                                               width: 35,
// //                                                               child: Material(
// //                                                                 color: GroceryAppColors.tela,
// //                                                                 elevation: 0.0,
// //                                                                 shape: RoundedRectangleBorder(
// //                                                                   borderRadius: BorderRadius.all(
// //                                                                     Radius.circular(15),
// //                                                                   ),
// //                                                                 ),
// //                                                                 clipBehavior: Clip.antiAlias,
// //                                                                 child: InkWell(
// //                                                                   onTap: () {
// //                                                                     if (int.parse(suggestionList[index].count) <=
// //                                                                         int.parse(suggestionList[index].quantityInStock)) {
// //                                                                       setState(() {
// // //                                                                                _count++;
// //                                                                         String quantity = suggestionList[index].count;
// //                                                                         int totalquantity = int.parse(quantity) + 1;
// //                                                                         suggestionList[index].count = totalquantity.toString();
// //                                                                       });
// //                                                                     } else {
// //                                                                       showLongToast('Only  ${suggestionList[index].count}  products in stock ');
// //                                                                     }
// //                                                                   },
// //                                                                   child: Icon(
// //                                                                     Icons.add,
// //                                                                     size: 20,
// //                                                                     color: Colors.white,
// //                                                                   ),
// //                                                                 ),
// //                                                               )),
// //                                                         ],
// //                                                       )
// //                                                     ],
// //                                                   ),
//                                                   // SizedBox(width: 25,),
//                                                   Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.end,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment.end,
//                                                     children: <Widget>[
//                                                       Container(
//                                                           margin:
//                                                               EdgeInsets.only(
//                                                                   left: 3.0),
//                                                           height: 35,
//                                                           child: Material(
//                                                             color:
//                                                                 GroceryAppColors
//                                                                     .tela,
//                                                             elevation: 0.0,
//                                                             shape:
//                                                                 RoundedRectangleBorder(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .all(
//                                                                 Radius.circular(
//                                                                     20),
//                                                               ),
//                                                             ),
//                                                             clipBehavior:
//                                                                 Clip.antiAlias,
//                                                             child: InkWell(
//                                                               onTap: () {
//                                                                 String mrp_price = calDiscount(
//                                                                     suggestionList[index]
//                                                                             .buyPrice ??
//                                                                         "",
//                                                                     suggestionList[index]
//                                                                             .discount ??
//                                                                         "");
//                                                                 totalmrp =
//                                                                     double.parse(
//                                                                         mrp_price);
//                                                                 double
//                                                                     dicountValue =
//                                                                     double.parse(suggestionList[index].buyPrice ??
//                                                                             "") -
//                                                                         totalmrp!;
//                                                                 String gst_sgst = calGst(
//                                                                     mrp_price,
//                                                                     suggestionList[index]
//                                                                             .sgst ??
//                                                                         "");
//                                                                 String gst_cgst = calGst(
//                                                                     mrp_price,
//                                                                     suggestionList[index]
//                                                                             .cgst ??
//                                                                         "");
//                                                                 String adiscount = calDiscount(
//                                                                     suggestionList[index]
//                                                                             .buyPrice ??
//                                                                         "",
//                                                                     suggestionList[index].msrp !=
//                                                                             null
//                                                                         ? suggestionList[index].msrp ??
//                                                                             ""
//                                                                         : "0");
//                                                                 admindiscountprice = (double.parse(
//                                                                         suggestionList[index].buyPrice ??
//                                                                             "") -
//                                                                     double.parse(
//                                                                         adiscount));
//                                                                 String color =
//                                                                     "";
//                                                                 String size =
//                                                                     "";
//                                                                 _addToproducts(
//                                                                     suggestionList[index].productIs ??
//                                                                         "",
//                                                                     suggestionList[index].productName ??
//                                                                         "",
//                                                                     suggestionList[
//                                                                                 index]
//                                                                             .img ??
//                                                                         "",
//                                                                     int.parse(
//                                                                         mrp_price),
//                                                                     int.parse(
//                                                                         suggestionList[index].count ??
//                                                                             ""),
//                                                                     color,
//                                                                     size,
//                                                                     suggestionList[
//                                                                                 index]
//                                                                             .productDescription ??
//                                                                         "",
//                                                                     gst_sgst,
//                                                                     gst_cgst,
//                                                                     suggestionList[
//                                                                                 index]
//                                                                             .discount ??
//                                                                         "",
//                                                                     dicountValue
//                                                                         .toString(),
//                                                                     suggestionList[
//                                                                                 index]
//                                                                             .APMC ??
//                                                                         "",
//                                                                     admindiscountprice
//                                                                         .toString(),
//                                                                     suggestionList[
//                                                                                 index]
//                                                                             .buyPrice ??
//                                                                         "",
//                                                                     suggestionList[index]
//                                                                             .shipping ??
//                                                                         "",
//                                                                     suggestionList[index]
//                                                                             .quantityInStock ??
//                                                                         "");
//                                                                 setState(() {
// //                                                                              cartvalue++;
//                                                                   GroceryAppConstant
//                                                                       .groceryAppCartItemCount++;
//                                                                   groceryCartItemCount(
//                                                                       GroceryAppConstant
//                                                                           .groceryAppCartItemCount);
//                                                                 });

// //                                                                Navigator.push(context,
// //                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);
// //
//                                                               },
//                                                               child: Padding(
//                                                                   padding: EdgeInsets
//                                                                       .only(
//                                                                           left:
//                                                                               8,
//                                                                           top:
//                                                                               5,
//                                                                           bottom:
//                                                                               5,
//                                                                           right:
//                                                                               8),
//                                                                   child: Center(
//                                                                     child: Icon(
//                                                                       Icons
//                                                                           .add_shopping_cart,
//                                                                       color: Colors
//                                                                           .white,
//                                                                     ),
//                                                                   )),
//                                                             ),
//                                                           )),
//                                                     ],
//                                                   ),
//                                                 ]),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                         // double.parse(suggestionList[index].discount) > 0 ? showSticker(index, suggestionList) : Row()
//                       },
//                     )
//                   : Center(child: CircularProgressIndicator()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

String calDiscount(String byprice, String discount2) {
  String returnStr;
  double discount = 0.0;
  returnStr = discount.toString();
  double byprice1 = double.parse(byprice);
  double discount1 = double.parse(discount2);

  discount = (byprice1 - (byprice1 * discount1) / 100.0);

  returnStr = discount.toStringAsFixed(GroceryAppConstant.val);
  print(returnStr);
  return returnStr;
}

final DbProductManager dbmanager = new DbProductManager();

ProductsCart? products1;
//cost_price=buyprice

void _addToproducts(
    String pID,
    String p_name,
    String image,
    int price,
    int quantity,
    String c_val,
    String p_size,
    String p_disc,
    String sgst,
    String cgst,
    String discount,
    String dis_val,
    String adminper,
    String adminper_val,
    String cost_price,
    String shippingcharge,
    String totalQun) {
  //  if (suggestionList != null) {
//      print(pID+"......");
//      print(p_name);
//      print(image);
//      print(price);
//      print(quantity);
//      print(c_val);
//      print(p_size);
//      print(p_disc);
//      print(sgst);
//      print(cgst);
//      print(discount);
//      print(dis_val);
//      print(adminper);
//      print(adminper_val);
//      print(cost_price);
  ProductsCart st = new ProductsCart(
      pid: pID,
      pname: p_name,
      pimage: image,
      pprice: (price * quantity).toString(),
      pQuantity: quantity,
      pcolor: c_val,
      psize: p_size,
      pdiscription: p_disc,
      sgst: sgst,
      cgst: cgst,
      discount: discount,
      discountValue: dis_val,
      adminper: adminper,
      adminpricevalue: adminper_val,
      costPrice: cost_price,
      shipping: shippingcharge,
      totalQuantity: totalQun);
  dbmanager.insertStudent(st).then((id) => {
        showLongToast(" Products  is added to cart "),
        print(' Added to Db ${id}')
      });
  // }
}

String calGst(String byprice, String sgst) {
  String returnStr;
  double discount = 0.0;
  if (sgst.length > 1) {
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    print(sgst);

    double discount1 = double.parse(sgst);

    discount = ((byprice1 * discount1) / (100.0 + discount1));

    returnStr = discount.toStringAsFixed(2);
    print(returnStr);
    return returnStr;
  } else {
    return '0';
  }
}
