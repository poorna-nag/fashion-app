// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:royalmart/service_app/Auth/forgetPassword.dart';
// import 'package:royalmart/service_app/Auth/signin.dart';
// import 'package:royalmart/service_app/BottomNavigation/wishlist.dart';
// import 'package:royalmart/service_app/General/AppConstant.dart';
// import 'package:royalmart/service_app/dbhelper/CarrtDbhelper.dart';
// import 'package:royalmart/service_app/dbhelper/database_helper.dart';
// import 'package:royalmart/service_app/model/ListModel.dart';
// import 'package:royalmart/service_app/model/productmodel.dart';
// import 'package:royalmart/service_app/screen/AddAddress.dart';
// import 'package:royalmart/service_app/screen/SearchScreen.dart';
// import 'package:royalmart/service_app/screen/detailpage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'SearchScreen1.dart';

// class ProductList extends StatefulWidget {
//   final String cat, title;
//   const ProductList(this.cat, this.title) : super();

//   @override
//   _ProductListState createState() => _ProductListState();
// }

// class _ProductListState extends State<ProductList>
//     with SingleTickerProviderStateMixin {
//   bool flag = false;

//   TabController _tabController;
//   bool showFab = true;
//   int _current = 0;
//   List<ListModel> shoplist = List<ListModel>();

//   int total = 000;
//   int actualprice = 00;
//   double mrp, totalmrp = 00;
//   int _count = 1;
//   SharedPreferences pref;
//   double sgst1, cgst1, dicountValue, admindiscountprice;
//   List<Products> products1 = List();
//   void gatinfoCount() async {
//     pref = await SharedPreferences.getInstance();

//     int Count = pref.getInt("itemCount");
//     setState(() {
//       if (Count == null) {
//         ServiceAppConstant.serviceAppCartItemCount = 0;
//       } else {
//         ServiceAppConstant.serviceAppCartItemCount = Count;
//       }
//       print(
//           ServiceAppConstant.serviceAppCartItemCount.toString() + "itemCount");
//     });
//   }

//   ScrollController _scrollController = new ScrollController();

//   getdata(int count) {
//     catby_productData(widget.cat, "0", "").then((usersFromServe1) {
//       if (this.mounted) {
//         setState(() {
//           products1.addAll(usersFromServe1);
//           products1.length > 0 ? flag = false : flag = true;
//           // print("sliderlist1.length");
//           // print(shoplist.length);
//         });
//       }
//     });
//   }

//   int countval = 0;
//   @override
//   void initState() {
//     super.initState();
//     gatinfoCount();

//     getdata(countval);

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         setState(() {
//           countval = countval + 10;
//           getdata(countval);
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//         length: 4,
//         child: Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               backgroundColor: ServiceAppColors.tela,
//               leading: Padding(
//                   padding: EdgeInsets.only(left: 0.0),
//                   child: InkWell(
//                     onTap: () {
//                       if (Navigator.canPop(context)) {
//                         Navigator.pop(context);
//                       } else {
//                         SystemNavigator.pop();
//                       }
//                     },
//                     child: Icon(
//                       Icons.arrow_back,
//                       size: 30,
//                       color: Colors.white,
//                     ),
//                   )),
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Center(
//                     child: Padding(
//                       padding: EdgeInsets.only(right: 10),
//                       child: Text(
//                         widget.title.isEmpty ? "Products" : widget.title,
//                         maxLines: 2,
//                         style: TextStyle(
//                             color: ServiceAppColors.white, fontSize: 15),
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => UserFilterDemo()));
//                         },
//                         child: Stack(
//                           children: <Widget>[
//                             Padding(
//                               padding: EdgeInsets.only(top: 3),
//                               child: Icon(
//                                 Icons.search,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ),


                          
// //                    showCircle(),
//                           ],
//                         ),
//                       ),
//                       /*  SizedBox(width: 12,),
//                       InkWell(
//                         onTap: (){
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => WishList()),
//                           );
//                         },
//                         child: Stack(
//                           children: <Widget>[
//                             Padding(
//                               padding: EdgeInsets.only(top: 13),
//                               child: Icon(Icons.add_shopping_cart,color: Colors.white,),
//                             ),
//                             showCircle(),
//                           ],
//                         ),
//                       )*/
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             body: Stack(
//               children: [
//                 Column(
//                   children: <Widget>[
//                     !flag
//                         ? products1.length > 0
//                             ? Expanded(
//                                 child: ListView.builder(
//                                   shrinkWrap: true,
//                                   primary: false,
//                                   scrollDirection: Axis.vertical,
//                                   itemCount: products1.length,
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     return Container(
//                                       margin: EdgeInsets.only(
//                                           left: 5, right: 5, top: 6, bottom: 6),
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(16))),
//                                       child: InkWell(
//                                         onTap: () {
//                                           // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailofSafe(shoplist[index].mvId,shoplist[index].pp )),);

//                                           // Navigator.push(context, MaterialPageRoute(builder: (context) => Sbcategory(shoplist[index].company,shoplist[index].mvId,shoplist[index].cat)),);
//                                         },
//                                         child: Card(
//                                           shadowColor: Colors.grey,
//                                           elevation: 3.0,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(15.0),
//                                           ),
//                                           child: Container(
//                                             child: Column(
//                                               children: [
//                                                 Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: <Widget>[
//                                                     Container(
//                                                       margin: EdgeInsets.only(
//                                                           right: 8,
//                                                           left: 8,
//                                                           top: 8,
//                                                           bottom: 8),
//                                                       width: 80,
//                                                       height: 80,
//                                                       decoration: BoxDecoration(
//                                                           borderRadius:
//                                                               BorderRadius.all(
//                                                                   Radius.circular(
//                                                                       14)),
//                                                           color: Colors
//                                                               .blue.shade200,
//                                                           image: DecorationImage(
//                                                               fit: BoxFit.fill,
//                                                               image: products1[index]
//                                                                           .img !=
//                                                                       null
//                                                                   ? NetworkImage(ServiceAppConstant
//                                                                           .Product_Imageurl1 +
//                                                                       products1[index]
//                                                                           .img)
//                                                                   : AssetImage(
//                                                                       "assets/images/logo.png"))),
//                                                     ),
//                                                     Expanded(
//                                                       child: Container(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                     .only(
//                                                                 left: 3.0,
//                                                                 top: 5,
//                                                                 right: 4,
//                                                                 bottom: 5),
//                                                         child: Column(
//                                                           mainAxisSize:
//                                                               MainAxisSize.max,
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                           children: <Widget>[
//                                                             Container(
//                                                               child:
//                                                                   // Text(products1[index].productName==null? 'name':'${  gettranstation("mother")}   ',
//                                                                   // Text(products1[index].productName==null? 'name':'${  translator.translateAndPrint(products1[index].productName.substring(products1[index].productName.indexOf("/")+1),to: 'kn')}   }',
//                                                                   Text(
//                                                                 products1[index]
//                                                                             .productName ==
//                                                                         null
//                                                                     ? 'name'
//                                                                     : '${products1[index].productName}',
//                                                                 overflow:
//                                                                     TextOverflow
//                                                                         .fade,
//                                                                 style: TextStyle(
//                                                                         fontSize:
//                                                                             15,
//                                                                         fontWeight:
//                                                                             FontWeight
//                                                                                 .w400,
//                                                                         color: Colors
//                                                                             .black)
//                                                                     .copyWith(
//                                                                         fontSize:
//                                                                             14),
//                                                               ),
//                                                             ),
//                                                             SizedBox(width: 10),
//                                                             Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .spaceBetween,
//                                                               children: [
//                                                                 Padding(
//                                                                   padding: const EdgeInsets
//                                                                           .only(
//                                                                       top: 2.0,
//                                                                       bottom:
//                                                                           1),
//                                                                   child: Text(
//                                                                       '\u{20B9} ${calDiscount(products1[index].buyPrice, products1[index].discount)}',
//                                                                       style:
//                                                                           TextStyle(
//                                                                         color: ServiceAppColors
//                                                                             .sellp,
//                                                                         // fontWeight: FontWeight.w700,
//                                                                       )),
//                                                                 ),
//                                                                 SizedBox(
//                                                                   width: 20,
//                                                                 ),
//                                                                 double.parse(products1[index]
//                                                                             .discount) >
//                                                                         0
//                                                                     ? Expanded(
//                                                                         // child: Text(' /kg',
//                                                                         child:
//                                                                             Text(
//                                                                           '(\u{20B9} ${products1[index].buyPrice})',
//                                                                           overflow:
//                                                                               TextOverflow.ellipsis,
//                                                                           maxLines:
//                                                                               2,
//                                                                           style: TextStyle(
//                                                                               fontWeight: FontWeight.w700,
//                                                                               fontStyle: FontStyle.italic,
//                                                                               color: ServiceAppColors.darkGray,
//                                                                               decoration: TextDecoration.lineThrough),
//                                                                         ),
//                                                                       )
//                                                                     : Container(),
//                                                               ],
//                                                             ),
//                                                             Container(
//                                                               margin: EdgeInsets
//                                                                   .only(
//                                                                       left: 0.0,
//                                                                       right:
//                                                                           10),
//                                                               child: Row(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .end,
//                                                                   children: <
//                                                                       Widget>[
//                                                                     SizedBox(
//                                                                       width:
//                                                                           0.0,
//                                                                       height:
//                                                                           10.0,
//                                                                     ),

//                                                                     Column(
//                                                                       children: <
//                                                                           Widget>[
//                                                                         Row(
//                                                                           mainAxisAlignment:
//                                                                               MainAxisAlignment.start,
//                                                                           children: <
//                                                                               Widget>[
//                                                                             GestureDetector(
//                                                                               onTap: () {
//                                                                                 print(products1[index].counts);
//                                                                                 if (products1[index].counts != "0" && int.parse(products1[index].counts) > 0) {
//                                                                                   setState(() {
//                                                                                     print("products1[index].counts");
//                                                                                     print(products1[index].counts);
//                                                                                     print(products1[index].counts != "0");
// //                                                                                _count++;

//                                                                                     String quantity = products1[index].counts;
//                                                                                     // print(int.parse(products1[index].moq));
//                                                                                     int totalquantity = int.parse(quantity) - 1;
//                                                                                     products1[index].counts = totalquantity.toString();
//                                                                                   });
//                                                                                 }

// //
//                                                                               },
//                                                                               child: Container(
//                                                                                   height: 35,
//                                                                                   width: 35,
//                                                                                   child: Material(
//                                                                                     color: ServiceAppColors.teladep,
//                                                                                     elevation: 0.0,
//                                                                                     shape: RoundedRectangleBorder(
//                                                                                       side: BorderSide(
//                                                                                         color: Colors.white,
//                                                                                       ),
//                                                                                       borderRadius: BorderRadius.all(
//                                                                                         Radius.circular(17),
//                                                                                       ),
//                                                                                     ),
//                                                                                     clipBehavior: Clip.antiAlias,
//                                                                                     child: Padding(
//                                                                                       padding: EdgeInsets.only(bottom: 10),
//                                                                                       child: InkWell(
//                                                                                           child: Padding(
//                                                                                         padding: EdgeInsets.only(
//                                                                                           top: 15.0,
//                                                                                         ),
//                                                                                         child: Icon(
//                                                                                           Icons.maximize,
//                                                                                           size: 20,
//                                                                                           color: Colors.white,
//                                                                                         ),
//                                                                                       )),
//                                                                                     ),
//                                                                                   )),
//                                                                             ),
//                                                                             Padding(
//                                                                               padding: EdgeInsets.only(top: 0.0, left: 15.0, right: 8.0),
//                                                                               child: Center(
//                                                                                 child: Text(products1[index].counts != null ? '${products1[index].counts}' : '0', style: TextStyle(color: Colors.black, fontSize: 19, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
//                                                                               ),
//                                                                             ),
//                                                                             GestureDetector(
//                                                                               onTap: () {
//                                                                                 if (int.parse(products1[index].counts) <= int.parse(products1[index].quantityInStock)) {
//                                                                                   setState(() {
// //                                                                                _count++;

//                                                                                     String quantity = products1[index].counts;
//                                                                                     // String moq=products1[index].moq;
//                                                                                     if (products1[index].moq == "1") {
//                                                                                       int totalquantity = int.parse(quantity) + int.parse(products1[index].moq);
//                                                                                       products1[index].counts = totalquantity.toString();
//                                                                                     } else {
//                                                                                       int totalquantity = int.parse(quantity == "1" ? "0" : quantity) + int.parse(products1[index].moq);
//                                                                                       products1[index].counts = totalquantity.toString();
//                                                                                     }
//                                                                                   });
//                                                                                 } else {
//                                                                                   showLongToast('Only  ${products1[index].counts}  products in stock ');
//                                                                                 }
//                                                                               },
//                                                                               child: Container(
//                                                                                   margin: EdgeInsets.only(left: 3.0),
//                                                                                   height: 35,
//                                                                                   width: 35,
//                                                                                   child: Material(
//                                                                                     color: ServiceAppColors.teladep,
//                                                                                     elevation: 0.0,
//                                                                                     shape: RoundedRectangleBorder(
//                                                                                       side: BorderSide(
//                                                                                         color: Colors.white,
//                                                                                       ),
//                                                                                       borderRadius: BorderRadius.all(
//                                                                                         Radius.circular(17),
//                                                                                       ),
//                                                                                     ),
//                                                                                     clipBehavior: Clip.antiAlias,
//                                                                                     child: InkWell(
//                                                                                       child: Icon(
//                                                                                         Icons.add,
//                                                                                         size: 20,
//                                                                                         color: Colors.white,
//                                                                                       ),
//                                                                                     ),
//                                                                                   )),
//                                                                             ),
//                                                                           ],
//                                                                         )
//                                                                       ],
//                                                                     ),
//                                                                     // SizedBox(width: 25,),
//                                                                   ]),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                                 products1[index].counts == "0"
//                                                     ? Container()
//                                                     : Container(
//                                                         // height: 30,
//                                                         color: Colors.black12,
//                                                         padding:
//                                                             EdgeInsets.only(
//                                                                 left: 20,
//                                                                 right: 20,
//                                                                 bottom: 5,
//                                                                 top: 5),
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           children: <Widget>[
//                                                             Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                           .only(
//                                                                       top: 2.0,
//                                                                       bottom:
//                                                                           1),
//                                                               child: Text(
//                                                                   '\u{20B9} ${int.parse(calDiscount(products1[index].buyPrice, products1[index].discount)) * int.parse((products1[index].counts))}',
//                                                                   style:
//                                                                       TextStyle(
//                                                                     color: ServiceAppColors
//                                                                         .sellp,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w700,
//                                                                   )),
//                                                             ),
//                                                             SizedBox(
//                                                               width: 20,
//                                                             ),
//                                                             Column(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .end,
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .end,
//                                                               children: <
//                                                                   Widget>[
//                                                                 Container(
//                                                                     margin: EdgeInsets
//                                                                         .only(
//                                                                             left:
//                                                                                 10.0),
//                                                                     padding: EdgeInsets
//                                                                         .only(
//                                                                             left:
//                                                                                 10.0),
//                                                                     height: 30,
//                                                                     width: 70,
//                                                                     child:
//                                                                         Material(
//                                                                       color: ServiceAppColors
//                                                                           .sellp,
//                                                                       elevation:
//                                                                           0.0,
//                                                                       shape:
//                                                                           RoundedRectangleBorder(
//                                                                         side:
//                                                                             BorderSide(
//                                                                           color:
//                                                                               Colors.white,
//                                                                         ),
//                                                                         borderRadius:
//                                                                             BorderRadius.all(
//                                                                           Radius.circular(
//                                                                               10),
//                                                                         ),
//                                                                       ),
//                                                                       clipBehavior:
//                                                                           Clip.antiAlias,
//                                                                       child:
//                                                                           InkWell(
//                                                                         onTap:
//                                                                             () {
//                                                                           print(
//                                                                               pref.getString("catid"));
//                                                                           // print(pref.getString("catid").isEmpty);

//                                                                           if (widget.cat == pref.getString("catid") ||
//                                                                               pref.getString("catid") == null ||
//                                                                               pref.getString("catid").isEmpty) {
//                                                                             pref.setString("catid",
//                                                                                 widget.cat);
//                                                                             if (ServiceAppConstant.isLogin) {
//                                                                               String mrp_price = calDiscount(products1[index].buyPrice, products1[index].discount);
//                                                                               totalmrp = double.parse(mrp_price);
//                                                                               double dicountValue = double.parse(products1[index].buyPrice) - totalmrp;
//                                                                               String gst_sgst = calGst(mrp_price, products1[index].sgst);
//                                                                               String gst_cgst = calGst(mrp_price, products1[index].cgst);

//                                                                               String adiscount = calDiscount(products1[index].buyPrice, products1[index].msrp != null ? products1[index].msrp : "0");

//                                                                               admindiscountprice = (double.parse(products1[index].buyPrice) - double.parse(adiscount));
//                                                                               String color = "";
//                                                                               String size = "";
//                                                                               _addToproducts(products1[index].productIs, products1[index].productName, products1[index].img, int.parse(mrp_price), int.parse(products1[index].counts), color, size, products1[index].productDescription, gst_sgst, gst_cgst, products1[index].discount, dicountValue.toString(), products1[index].APMC, admindiscountprice.toString(), products1[index].buyPrice, products1[index].shipping, products1[index].quantityInStock, products1[index].youtube, products1[index].mv, products1[index].moq, products1[index].unit_type);

//                                                                               setState(() {
//                                                                                 products1[index].counts = "0";
//                                                                               });
// //                                                         setState(() {
// //
// //                                                           Foo foo= new Foo();
// //                                                           // int val=Constant.carditemCount++;
// //
// // //                                                                 Foo              cartvalue++;
// // //                                                               Constant.carditemCount=
// //                                                           Constant.carditemCount++;
// //                                                           foo.weight=Constant.carditemCount;
// //
// //                                                           cartItemcount(Constant.carditemCount);
// //
// //                                                         });

// //                                                                Navigator.push(context,
// //                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);

//                                                                             } else {
//                                                                               Navigator.push(
//                                                                                 context,
//                                                                                 MaterialPageRoute(builder: (context) => ForgetPass()),
//                                                                               );
//                                                                             }
//                                                                           } else {
//                                                                             // pref.setString("catid","");

//                                                                             showAlertDialog(context,
//                                                                                 index);
//                                                                             // showLongToast("It is in different categoryt");
//                                                                           }

// //
//                                                                         },
//                                                                         child: Padding(
//                                                                             padding: EdgeInsets.only(left: 8, top: 5, bottom: 5, right: 8),
//                                                                             child: Center(
//                                                                               child: Text(
//                                                                                 "ADD",
//                                                                                 style: TextStyle(fontSize: 12, color: ServiceAppColors.white),
//                                                                               ),
//                                                                             )),
//                                                                       ),
//                                                                     )),
//                                                               ],
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               )
//                             : Container(
//                                 margin: EdgeInsets.only(top: 160),
//                                 child:
//                                     Center(child: CircularProgressIndicator()))
//                         : Container(
//                             margin: EdgeInsets.only(top: 160),
//                             child:
//                                 Center(child: Text("No service is avaliable"))),
//                     SizedBox(
//                       height: 80,
//                     ),
//                   ],
//                 ),
//                 footer(context),
//               ],
//             )));
//   }

//   showAlertDialog(BuildContext context, int index) {
//     // set up the buttons
//     Widget cancelButton = FlatButton(
//       child: Text("Yes"),
//       onPressed: () {
//         dbmanager.deleteallProducts();

//         ServiceAppConstant.itemcount = 0;
//         ServiceAppConstant.serviceAppCartItemCount = 0;
//         serviceCartItemCount(ServiceAppConstant.serviceAppCartItemCount);

//         String mrp_price =
//             calDiscount(products1[index].buyPrice, products1[index].discount);
//         totalmrp = double.parse(mrp_price);
//         String color = "";
//         String size = "";
//         double dicountValue =
//             double.parse(products1[index].buyPrice) - totalmrp;
//         String gst_sgst = calGst(mrp_price, products1[index].sgst);
//         String gst_cgst = calGst(mrp_price, products1[index].cgst);
//         String adiscount = calDiscount(products1[index].buyPrice,
//             products1[index].msrp != null ? products1[index].msrp : "0");
//         admindiscountprice =
//             (double.parse(products1[index].buyPrice) - double.parse(adiscount));

//         pref.setString("catid", widget.cat);
//         _addToproducts(
//             products1[index].productIs,
//             products1[index].productName,
//             products1[index].img,
//             int.parse(mrp_price),
//             int.parse(products1[index].counts),
//             color,
//             size,
//             products1[index].productDescription,
//             gst_sgst,
//             gst_cgst,
//             products1[index].discount,
//             dicountValue.toString(),
//             products1[index].APMC,
//             admindiscountprice.toString(),
//             products1[index].buyPrice,
//             products1[index].shipping,
//             products1[index].quantityInStock,
//             products1[index].youtube,
//             products1[index].mv,
//             products1[index].moq,
//             products1[index].unit_type);

//         setState(() {
//           ServiceAppConstant.serviceAppCartItemCount == 1;
//           serviceCartItemCount(ServiceAppConstant.serviceAppCartItemCount);
//           products1[index].counts = "0";
//           pref.setString("catid", widget.cat);
//           Navigator.of(context).pop();
//         });

//         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductList1(widget.mv_id,widget.title)),);
//       },
//     );
//     Widget continueButton = FlatButton(
//       child: Text("No"),
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//     );

//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text(
//         "Replace cart item?",
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//       content: Text(
//           "Your cart contains services from different Category. Do you want to discard the selection and add this" +
//               products1[index].productName),
//       actions: [
//         cancelButton,
//         continueButton,
//       ],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   footer(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: GestureDetector(
//         onTap: () {
//           ServiceAppConstant.serviceAppCartItemCount > 0
//               ? Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AddAddress("0")),
//                 )
//               : showLongToast("Please add the services");
//         },
//         child: Container(
//           height: 63,
//           color: ServiceAppColors.tela1,
//           child: Column(
//             // crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//               Container(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     /* Container(
//                     width: MediaQuery.of(context).size.width/2,
//                     color: Colors.amberAccent,

//                     child: RaisedButton(
//                       onPressed: () {

//                         if(Constant.isLogin){




//                         }else{


//                           Navigator.push(context,
//                             MaterialPageRoute(builder: (context) => SignInPage()),);
//                         }


//                         // showDilogue(context);
//                         // val="can";
//                       },
//                       color: Colors.amberAccent,
//                       padding: EdgeInsets.only(top: 12, bottom: 12),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(0))),
//                       child: Text(
//                         "Add to cart",

//                       ),
//                     ),
//                   ),*/
//                     // SizedBox(width: 15.0,),

//                     Container(
//                       // width: MediaQuery.of(context).size.width,
//                       color: ServiceAppColors.tela1,

//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Text(
//                           "Book Now ",
//                           style: TextStyle(color: Colors.white, fontSize: 18),
//                         ),
//                       ),
//                     ),

//                     Stack(
//                       children: <Widget>[
//                         Padding(
//                           padding: EdgeInsets.only(top: 13),
//                           child: Icon(
//                             Icons.add_shopping_cart,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                         ),
//                         showCircle(),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(height: 8),
// //          RaisedButton(
// //            onPressed: () {
// //
// //
// //            },
// //            color: Colors.amberAccent,
// //            padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
// //            shape: RoundedRectangleBorder(
// //                borderRadius: BorderRadius.all(Radius.circular(24))),
// //            child: Text(
// //              "Buy Now",
// //
// //            ),
// //          ),
//               SizedBox(height: 8),
//             ],
//           ),
//           margin: EdgeInsets.only(top: 16),
//         ),
//       ),
//     );
//   }

//   final DbProductManager dbmanager = new DbProductManager();

//   ProductsCart products2;
// //cost_price=buyprice
//   void _addToproducts(
//       String pID,
//       String p_name,
//       String image,
//       int price,
//       int quantity,
//       String c_val,
//       String p_size,
//       String p_disc,
//       String sgst,
//       String cgst,
//       String discount,
//       String dis_val,
//       String adminper,
//       String adminper_val,
//       String cost_price,
//       String shippingcharge,
//       String totalQun,
//       String varient,
//       String mv,
//       String moq,
//       String unit) {
//     try {
//       if (products2 == null) {
// //      print(pID+"......");
// //      print(p_name);
// //      print(image);
// //      print(price);
// //      print(quantity);
// //      print(c_val);
// //      print(p_size);
// //      print(p_disc);
// //      print(sgst);
// //      print(cgst);
// //      print(discount);
// //      print(dis_val);
// //      print(adminper);
// //      print(adminper_val);
// //      print(cost_price);
//         Future<int> val;
//         int value;
//         ProductsCart st = new ProductsCart(
//           pid: pID,
//           pname: p_name,
//           pimage: image != null ? image : "",
//           pprice: (price * quantity).toString(),
//           pQuantity: quantity,
//           pcolor: c_val,
//           psize: p_size,
//           pdiscription: p_disc,
//           sgst: sgst,
//           cgst: cgst,
//           discount: discount,
//           discountValue: dis_val,
//           adminper: adminper,
//           adminpricevalue: adminper_val,
//           costPrice: cost_price,
//           shipping: shippingcharge,
//           totalQuantity: totalQun,
//           varient: varient,
//           mv: int.parse(mv),
//           moq: moq,
//         );

//         dbmanager.insertStudent(st).then((id) => {
//               showLongToast(" Products  is upadte to cart"),
//               setState(() {
//                 ServiceAppConstant.serviceAppCartItemCount++;
//                 serviceCartItemCount(
//                     ServiceAppConstant.serviceAppCartItemCount);
//               })
//             });

//         // Future<int> value= dbmanager.insertStudent(st);

//       }
//     } catch (Exception) {}
//   }

//   String calGst(String byprice, String sgst) {
//     String returnStr;
//     double discount = 0.0;
//     if (sgst.length > 1) {
//       returnStr = discount.toString();
//       double byprice1 = double.parse(byprice);
//       print(sgst);

//       double discount1 = double.parse(sgst);

//       discount = ((byprice1 * discount1) / (100.0 + discount1));

//       returnStr = discount.toStringAsFixed(2);
//       print(returnStr);
//       return returnStr;
//     } else {
//       return '0';
//     }
//   }

//   String calDiscount(String byprice, String discount2) {
//     String returnStr;
//     double discount = 0.0;
//     returnStr = discount.toString();
//     double byprice1 = double.parse(byprice);
//     double discount1 = double.parse(discount2);

//     discount = (byprice1 - (byprice1 * discount1) / 100.0);

//     returnStr = discount.toStringAsFixed(ServiceAppConstant.val);
//     print(returnStr);
//     return returnStr;
//   }
// }
