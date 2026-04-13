// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:royalmart/grocery/screen/AddAddress.dart';
// import 'package:royalmart/service_app/Auth/forgetPassword.dart';
// import 'package:royalmart/service_app/Auth/signin.dart';
// import 'package:royalmart/service_app/General/AnimatedSplashScreen.dart';
// import 'package:royalmart/service_app/General/AppConstant.dart';
// import 'package:royalmart/service_app/dbhelper/CarrtDbhelper.dart';
// import 'package:royalmart/service_app/dbhelper/database_helper.dart';
// import 'package:royalmart/service_app/model/CategaryModal.dart';
// import 'package:royalmart/service_app/model/productmodel.dart';
// import 'package:royalmart/service_app/screen/detailpage.dart';
// import 'dart:async';

// import 'package:royalmart/service_app/screen/productlist.dart';

// class UserFilterDemo extends StatefulWidget {
//   UserFilterDemo() : super();

//  // final String mvId;

//   @override
//   UserFilterDemoState createState() => UserFilterDemoState();
// }

// class Debouncer {
//   final int milliseconds;
//   VoidCallback action;
//   Timer _timer;

//   Debouncer({this.milliseconds});

//   run(VoidCallback action) {
//     if (null != _timer) {
//       _timer.cancel();
//     }
//     _timer = Timer(Duration(milliseconds: milliseconds), action);
//   }
// }

// class UserFilterDemoState extends State<UserFilterDemo> {
//   // https://jsonplaceholder.typicode.com/users

//   final _debouncer = Debouncer(milliseconds: 500);
//   List<Products> users = List();
//   List<Products> suggestionList = List();
//   bool _progressBarActive = false;
//   int _current = 0;
//   int total = 000;
//   int actualprice = 200;
//   double mrp, totalmrp = 000;
//   int _count = 1;

//   double sgst1, cgst1, dicountValue, admindiscountprice;

//   @override
//   void initState() {
//     super.initState();
//     // setState(() {
//     //   users= SplashScreenState.filteredUsers;
//     //   print(users.toString());
//     //   suggestionList = users;
//     // });

//     DatabaseHelper.getTopProduct("top", "0").then((usersFromServe) {
//       setState(() {
//         users = usersFromServe;
//         suggestionList = users;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ServiceAppColors.tela,
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
//                         if (string != null) {
//                            DatabaseHelper.getTopProduct("top", "0")
//                               .then((usersFromServe) {
//                             setState(() {
//                               users = usersFromServe;
//                               if (users != null) {
//                                 suggestionList = users;
//                               }
//                             });
//                           });
//                         }

//                         _debouncer.run(() {
//                           setState(() {
//                             suggestionList = users
//                                 .where((u) => (u.productName
//                                     .toLowerCase()
//                                     .contains(string.toLowerCase())))
//                                 .toList();
//                           });
//                         });
//                       },
//                       style: TextStyle(color: Colors.green[900]),
//                       decoration: InputDecoration(
//                         hintText: 'Search Our Service',
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
//           ],
//         ),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: suggestionList != null
//                 ? ListView.builder(
//                     shrinkWrap: true,
//                     primary: false,
//                     scrollDirection: Axis.vertical,
//                     itemCount: suggestionList.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Container(
//                         margin: EdgeInsets.only(
//                             left: 2, right: 2, top: 6, bottom: 6),
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(16))),
//                         child: Card(
//                           child: InkWell(
//                             onTap: () {},
//                             child: Container(
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: <Widget>[
//                                       Container(
//                                         margin: EdgeInsets.only(
//                                             right: 8,
//                                             left: 8,
//                                             top: 8,
//                                             bottom: 8),
//                                         width: 80,
//                                         height: 80,
//                                         decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(14)),
//                                             color: Colors.blue.shade200,
//                                             image: DecorationImage(
//                                                 fit: BoxFit.fill,
//                                                 image: NetworkImage(
//                                                   suggestionList[index].img !=
//                                                           null
//                                                       ?   ServiceAppConstant
//                                                           .Product_Imageurl +
//                                                       suggestionList[index]
//                                                               .img
//                                                       : "ttps://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg",
//                                                 ))),
//                                       ),
//                                       Expanded(
//                                         child: Container(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             mainAxisSize: MainAxisSize.max,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: <Widget>[
//                                               Container(
//                                                 child: Text(
//                                                   suggestionList[index]
//                                                               .productName ==
//                                                           null
//                                                       ? 'name'
//                                                       : suggestionList[index]
//                                                           .productName,
//                                                   overflow: TextOverflow.fade,
//                                                   style: TextStyle(
//                                                           fontSize: 15,
//                                                           fontWeight:
//                                                               FontWeight.w400,
//                                                           color: Colors.black)
//                                                       .copyWith(fontSize: 14),
//                                                 ),
//                                               ),
//                                               SizedBox(height: 6),

//                                                 Row(
//                                           children: <Widget>[
//                                             Padding(
//                                               padding: const EdgeInsets.only(top: 2.0, bottom: 1),
//                                               child: Text('\u{20B9} ${calDiscount(suggestionList[index].buyPrice,suggestionList[index].discount)}', style: TextStyle(
//                                                 color: ServiceAppColors.sellp,
//                                                 fontWeight: FontWeight.w700,
//                                               )),
//                                             ),
//                                             SizedBox(width: 20,),
//                                             Expanded(
//                                               child: Text('(\u{20B9} ${suggestionList[index].buyPrice})',
//                                                 overflow:TextOverflow.ellipsis,
//                                                 maxLines: 2,
//                                                 style: TextStyle(
//                                                     fontWeight: FontWeight.w700,
//                                                     fontStyle: FontStyle.italic,
//                                                     color: ServiceAppColors.mrp,
//                                                     decoration: TextDecoration.lineThrough
//                                                 ),
//                                               ),
//                                             ),
//                                             Center(
//                                                       child: MaterialButton(
//                                                         onPressed: () {
//                                                           String mrp_price =
//                                                               calDiscount(
//                                                                   suggestionList[
//                                                                           index]
//                                                                       .buyPrice,
//                                                                   suggestionList[
//                                                                           index]
//                                                                       .discount);
//                                                           totalmrp =
//                                                               double.parse(
//                                                                   mrp_price);

//                                                           double dicountValue =
//                                                               double.parse(suggestionList[
//                                                                           index]
//                                                                       .buyPrice) -
//                                                                   totalmrp;
//                                                           String gst_sgst =
//                                                               calGst(
//                                                                   mrp_price,
//                                                                   suggestionList[
//                                                                           index]
//                                                                       .sgst);
//                                                           String gst_cgst =
//                                                               calGst(
//                                                                   mrp_price,
//                                                                   suggestionList[
//                                                                           index]
//                                                                       .cgst);

//                                                           String adiscount = calDiscount(
//                                                               suggestionList[index]
//                                                                   .buyPrice,
//                                                               suggestionList[index]
//                                                                           .msrp !=
//                                                                       null
//                                                                   ? suggestionList[
//                                                                           index]
//                                                                       .msrp
//                                                                   : "0");

//                                                           admindiscountprice =
//                                                               (double.parse(suggestionList[
//                                                                           index]
//                                                                       .buyPrice) -
//                                                                   double.parse(
//                                                                       adiscount));

//                                                           String color = "";
//                                                           String size = "";
//                                                           _addToproducts(
//                                                               suggestionList[index]
//                                                                   .productIs,
//                                                               suggestionList[index]
//                                                                   .productName,
//                                                               suggestionList[index]
//                                                                   .img,
//                                                               int.parse(
//                                                                   mrp_price),
//                                                               int.parse(
//                                                                   suggestionList[
//                                                                           index]
//                                                                       .count),
//                                                               color,
//                                                               size,
//                                                               suggestionList[index]
//                                                                   .productDescription,
//                                                               gst_sgst,
//                                                               gst_cgst,
//                                                               suggestionList[index]
//                                                                   .discount,
//                                                               dicountValue
//                                                                   .toString(),
//                                                               suggestionList[index]
//                                                                   .APMC,
//                                                               admindiscountprice
//                                                                   .toString(),
//                                                               suggestionList[index]
//                                                                   .buyPrice,
//                                                               suggestionList[index]
//                                                                   .shipping,
//                                                               suggestionList[index]
//                                                                   .quantityInStock);

//                                                           setState(() {
//                                                             ServiceAppConstant
//                                                                 .serviceAppCartItemCount++;
//                                                             serviceCartItemCount(
//                                                                 ServiceAppConstant
//                                                                     .serviceAppCartItemCount);
//                                                           });
//                                                         },
//                                                         color: ServiceAppColors
//                                                             .sellp,
//                                                         textColor:
//                                                             ServiceAppColors
//                                                                 .white,
//                                                         child: Text(
//                                                           "Book Now",
//                                                           style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                           ],
//                                         ),

//                                               // suggestionList[index].p_id==null?Container(): Padding(
//                                               //     padding: const EdgeInsets.only(left:6.0,top: 8.0),
//                                               //     child: InkWell(
//                                               //       onTap: (){

//                                               //      //   _displayDialog(context,suggestionList[index].productIs,index);
//                                               //         // _showSelectionDialog(context);
//                                               //       },
//                                               //       child: Container(

//                                               //         width: MediaQuery.of(context).size.width/2,
//                                               //         padding: const EdgeInsets.only(left:5.0,top: 0.0,right:5.0,),
//                                               //         margin: const EdgeInsets.only(top: 5.0,),



//                                               //         child:  Center(child:Row(
//                                               //           mainAxisAlignment: MainAxisAlignment.end,
//                                               //           children: [
//                                               //             Padding(
//                                               //               padding: EdgeInsets.only(left: 10,right: 0),
//                                               //               child: Text(
//                                               //                 // textval.length>15?textval.substring(0,15)+"..": textval,
//                                               //                 suggestionList[index].youtube.length>1? suggestionList[index].youtube.length>15?suggestionList[index].youtube.substring(0,15)+"..":suggestionList[index].youtube: "",

//                                               //                 overflow:TextOverflow.fade,
//                                               //                 // maxLines: 2,
//                                               //                 style: TextStyle(
//                                               //                   fontSize: 15,color:ServiceAppColors.black,

//                                               //                 ),
//                                               //               ),
//                                               //             ),
//                                               //             Padding(
//                                               //                 padding: EdgeInsets.only(left: 0),
//                                               //                 child:Icon(Icons.expand_more, color: Colors.black,size: 30,)
//                                               //             )

//                                               //           ],
//                                               //         )  ),

//                                               //         decoration: BoxDecoration(
//                                               //             border: Border.all(color: Colors.grey)
//                                               //         ),
//                                               //       ),
//                                               //     )
//                                               // ),

// /*
//                                         Container(
//                                           margin: EdgeInsets.only(left: 0.0,right: 10),
//                                           child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.end,
//                                               children: <Widget>[
//                                                 SizedBox(width: 0.0,height: 10.0,),

//                                                 Column(
//                                                   children: <Widget>[
//                                                     Row(
//                                                       mainAxisAlignment: MainAxisAlignment.start,
//                                                       children: <Widget>[
//                                                         GestureDetector(
//                                                           onTap: () {
//                                                             print(suggestionList[index].counts);
//                                                             if(suggestionList[index].counts!="0"&&int.parse(suggestionList[index].counts)>0){
//                                                               setState(() {
// //                                                                                _count++;

//                                                                 String  quantity=suggestionList[index].counts;
//                                                                 print(int.parse(suggestionList[index].moq));
//                                                                 int totalquantity=int.parse(quantity)-int.parse(suggestionList[index].moq);
//                                                                 suggestionList[index].counts=totalquantity.toString();

//                                                               });
//                                                             }



// //



//                                                           },
//                                                           child: Container(
//                                                               height: 35,
//                                                               width: 35,
//                                                               child:
//                                                               Material(

//                                                                 color: AppColors.teladep,
//                                                                 elevation: 0.0,
//                                                                 shape: RoundedRectangleBorder(
//                                                                   side: BorderSide(
//                                                                     color: Colors.white,
//                                                                   ),
//                                                                   borderRadius: BorderRadius.all(
//                                                                     Radius.circular(17),
//                                                                   ),
//                                                                 ),
//                                                                 clipBehavior: Clip.antiAlias,
//                                                                 child:Padding (
//                                                                   padding: EdgeInsets.only(bottom: 10),
//                                                                   child: InkWell(
//                                                                     */
// /*    onTap: () {
//                                                                         print(suggestionList[index].count);
//                                                                         if(suggestionList[index].count!="1"){
//                                                                           setState(() {
// //                                                                                _count++;

//                                                                             String  quantity=suggestionList[index].count;
//                                                                             print(int.parse(suggestionList[index].moq));
//                                                                             int totalquantity=int.parse(quantity)-int.parse(suggestionList[index].moq);
//                                                                             suggestionList[index].count=totalquantity.toString();

//                                                                           });
//                                                                         }
//                                                                         },*/
//                                               /*

//                                                                       child:Padding(padding: EdgeInsets.only(top:15.0,),

//                                                                         child:Icon(
//                                                                           Icons.maximize,size: 20,
//                                                                           color: Colors.white,
//                                                                         ),


//                                                                       )
//                                                                   ),
//                                                                 ),
//                                                               )),
//                                                         ),

//                                                         Padding(
//                                                           padding:
//                                                           EdgeInsets.only(top: 0.0, left: 15.0, right: 8.0),
//                                                           child:Center(
//                                                             child:
//                                                             Text(suggestionList[index].counts,

//                                                                 style: TextStyle(
//                                                                     color: Colors.black,
//                                                                     fontSize: 19,
//                                                                     fontFamily: 'Roboto',
//                                                                     fontWeight: FontWeight.bold)),

//                                                           ),),

//                                                         Container(
//                                                             margin: EdgeInsets.only(left: 3.0),
//                                                             height: 35,
//                                                             width: 35,
//                                                             child:
//                                                             Material(

//                                                               color: AppColors.teladep,
//                                                               elevation: 0.0,
//                                                               shape: RoundedRectangleBorder(
//                                                                 side: BorderSide(
//                                                                   color: Colors.white,
//                                                                 ),
//                                                                 borderRadius: BorderRadius.all(
//                                                                   Radius.circular(17),
//                                                                 ),
//                                                               ),
//                                                               clipBehavior: Clip.antiAlias,
//                                                               child: InkWell(
//                                                                 onTap: () {
//                                                                   if(int.parse(suggestionList[index].counts) <= int.parse(suggestionList[index].quantityInStock)){
//                                                                     setState(() {
// //                                                                                _count++;

//                                                                       String  quantity=suggestionList[index].counts;
//                                                                       // String moq=suggestionList[index].moq;
//                                                                       if(suggestionList[index].moq=="1"){
//                                                                         int totalquantity=int.parse(quantity)+int.parse(suggestionList[index].moq);
//                                                                         suggestionList[index].counts=totalquantity.toString();


//                                                                       }else{
//                                                                         int totalquantity=int.parse(quantity=="1"?"0":quantity)+int.parse(suggestionList[index].moq);
//                                                                         suggestionList[index].counts=totalquantity.toString();

//                                                                       }


//                                                                     });
//                                                                   }
//                                                                   else{
//                                                                     showLongToast('Only  ${suggestionList[index].counts}  products in stock ');
//                                                                   }


//                                                                 },


//                                                                 child:Icon(
//                                                                   Icons.add,size: 30,
//                                                                   color: Colors.white,
//                                                                 ),


//                                                               ),
//                                                             )),
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                                 // SizedBox(width: 25,),










//                                               ]
//                                           ) ,
//                                         ),
// */
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
// /*
//                 suggestionList[index].counts=="0"? Container():  Container(
//                               color: Colors.black12,
//                               padding: EdgeInsets.only(left: 20,right: 20,bottom: 5,top: 5),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 2.0, bottom: 1),
//                                     child: Text('\u{20B9} ${int.parse(calDiscount(suggestionList[index].buyPrice,suggestionList[index].discount))*int.parse((suggestionList[index].counts))}', style: TextStyle(
//                                       color: AppColors.sellp,
//                                       fontWeight: FontWeight.w700,
//                                     )),
//                                   ),
//                                   SizedBox(width: 20,),
//                                   Column(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: <Widget>[

//                                       Container(
//                                           margin: EdgeInsets.only(left: 10.0),
//                                           padding: EdgeInsets.only(left: 10.0),
//                                           height: 30,
//                                           width: 70,

//                                           child:
//                                           Material(

//                                             color: AppColors.sellp,
//                                             elevation: 0.0,
//                                             shape: RoundedRectangleBorder(
//                                               side: BorderSide(
//                                                 color: Colors.white,
//                                               ),
//                                               borderRadius: BorderRadius.all(
//                                                 Radius.circular(10),
//                                               ),
//                                             ),
//                                             clipBehavior: Clip.antiAlias,
//                                             child: InkWell(
//                                               onTap: () {
//                                                 if(Constant.isLogin){


//                                                   String  mrp_price=calDiscount(suggestionList[index].buyPrice,suggestionList[index].discount);
//                                                   totalmrp= double.parse(mrp_price);
//                                                   double dicountValue=double.parse(suggestionList[index].buyPrice)-totalmrp;
//                                                   String gst_sgst=calGst(mrp_price,suggestionList[index].sgst);
//                                                   String gst_cgst=calGst(mrp_price,suggestionList[index].cgst);

//                                                   String  adiscount=calDiscount(suggestionList[index].buyPrice,suggestionList[index].msrp!=null?suggestionList[index].msrp:"0");

//                                                   admindiscountprice=(double.parse(suggestionList[index].buyPrice)-double.parse(adiscount));
//                                                   String color="";
//                                                   String size="";
//                                                   _addToproducts(suggestionList[index].productIs,suggestionList[index].productName,suggestionList[index].img,int.parse(mrp_price),int.parse(suggestionList[index].counts),color,size,suggestionList[index].productDescription,gst_sgst,gst_cgst,
//                                                       suggestionList[index].discount,dicountValue.toString(), suggestionList[index].APMC, admindiscountprice.toString(),suggestionList[index].buyPrice,suggestionList[index].shipping,suggestionList[index].quantityInStock,suggestionList[index].youtube,suggestionList[index].mv,suggestionList[index].moq);
//                                                   setState(() {
//                                                     suggestionList[index].count="1";

//                                                   });

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

//                                                 }
//                                                 else{


//                                                   Navigator.push(context,
//                                                     MaterialPageRoute(builder: (context) => ForgetPass()),);
//                                                 }

// //

//                                               },
//                                               child:Padding(padding: EdgeInsets.only(left: 8,top: 5,bottom: 5,right: 8),
//                                                   child:Center(

//                                                     child:Text("ADD",style: TextStyle(fontSize: 12,color: AppColors.white),),

//                                                   )),),
//                                           )),









//                                     ],
//                                   ),

//                                 ],
//                               ),
//                             ),
// */
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       )

//                           /*Container(
//                   margin: EdgeInsets.only(left: 10, right: 10, top: 6,bottom: 6),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(16))),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ProductDetails(suggestionList[index])),);
//                     },
//                     child: Container(

//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
//                             width: 110,
//                             height: 110,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.all(Radius.circular(14)),
//                                 color: Colors.blue.shade200,
//                                 image: DecorationImage(
//                                     fit: BoxFit.cover,

//                                     image: NetworkImage(Constant.Product_Imageurl+suggestionList[index].img, )


//                                 )),
//                           ),

//                           Expanded(
//                             child: Container(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.max,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Container(
//                                     child:
//                                     Text(suggestionList[index].productName==null? 'name':suggestionList[index].productName,

//                                       overflow: TextOverflow.fade,
//                                       style:TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black)
//                                           .copyWith(fontSize: 14),
//                                     ),

//                                   ),
//                                   SizedBox(height: 6),

//                                   Row(
//                                     children: <Widget>[
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 2.0, bottom: 1),
//                                         child: Text('\u{20B9} ${calDiscount(suggestionList[index].buyPrice,suggestionList[index].discount)}', style: TextStyle(
//                                           color: AppColors.sellp,
//                                           fontWeight: FontWeight.w700,
//                                         )),
//                                       ),
//                                       SizedBox(width: 20,),
//                                       Expanded(
//                                         child: Text('(\u{20B9} ${suggestionList[index].buyPrice})',
//                                           overflow:TextOverflow.ellipsis,
//                                           maxLines: 2,
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w700,
//                                               fontStyle: FontStyle.italic,
//                                               color: AppColors.mrp,
//                                               decoration: TextDecoration.lineThrough
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),


//                                   Container(
//                                     margin: EdgeInsets.only(left: 0.0,right: 10),
//                                     child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.end,
//                                         children: <Widget>[
//                                           SizedBox(width: 0.0,height: 10.0,),

//                                           Column(
//                                             children: <Widget>[
//                                               Row(
//                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                 children: <Widget>[
//                                                   Container(
//                                                       height: 25,
//                                                       width: 35,
//                                                       child:
//                                                       Material(

//                                                         color: AppColors.teladep,
//                                                         elevation: 0.0,
//                                                         shape: RoundedRectangleBorder(
//                                                           side: BorderSide(
//                                                             color: Colors.white,
//                                                           ),
//                                                           borderRadius: BorderRadius.all(
//                                                             Radius.circular(15),
//                                                           ),
//                                                         ),
//                                                         clipBehavior: Clip.antiAlias,
//                                                         child:Padding (
//                                                           padding: EdgeInsets.only(bottom: 10),
//                                                           child: InkWell(
//                                                               onTap: () {
//                                                                 print(suggestionList[index].count);
//                                                                 if(suggestionList[index].count!="1"){
//                                                                   setState(() {
// //                                                                                _count++;

//                                                                     String  quantity=suggestionList[index].count;
//                                                                     int totalquantity=int.parse(quantity)-1;
//                                                                     suggestionList[index].count=totalquantity.toString();

//                                                                   });
//                                                                 }



// //



//                                                               },
//                                                               child:Padding(padding: EdgeInsets.only(top:10.0,),

//                                                                 child:Icon(
//                                                                   Icons.maximize,size: 20,
//                                                                   color: Colors.white,
//                                                                 ),


//                                                               )
//                                                           ),
//                                                         ),
//                                                       )),

//                                                   Padding(
//                                                     padding:
//                                                     EdgeInsets.only(top: 0.0, left: 15.0, right: 8.0),
//                                                     child:Center(
//                                                       child:
//                                                       Text(suggestionList[index].count!=null?'${suggestionList[index].count}':'$_count',

//                                                           style: TextStyle(
//                                                               color: Colors.black,
//                                                               fontSize: 19,
//                                                               fontFamily: 'Roboto',
//                                                               fontWeight: FontWeight.bold)),

//                                                     ),),

//                                                   Container(
//                                                       margin: EdgeInsets.only(left: 3.0),
//                                                       height: 25,
//                                                       width: 35,
//                                                       child:
//                                                       Material(

//                                                         color: AppColors.teladep,
//                                                         elevation: 0.0,
//                                                         shape: RoundedRectangleBorder(
//                                                           side: BorderSide(
//                                                             color: Colors.white,
//                                                           ),
//                                                           borderRadius: BorderRadius.all(
//                                                             Radius.circular(15),
//                                                           ),
//                                                         ),
//                                                         clipBehavior: Clip.antiAlias,
//                                                         child: InkWell(
//                                                           onTap: () {
//                                                             if(int.parse(suggestionList[index].count) <= int.parse(suggestionList[index].quantityInStock)){
//                                                               setState(() {
// //                                                                                _count++;

//                                                                 String  quantity=suggestionList[index].count;
//                                                                 int totalquantity=int.parse(quantity)+1;
//                                                                 suggestionList[index].count=totalquantity.toString();

//                                                               });
//                                                             }
//                                                             else{
//                                                               showLongToast('Only  ${suggestionList[index].count}  products in stock ');
//                                                             }


//                                                           },


//                                                           child:Icon(
//                                                             Icons.add,size: 20,
//                                                             color: Colors.white,
//                                                           ),


//                                                         ),
//                                                       )),
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                           SizedBox(width: 25,),

//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.end,
//                                             crossAxisAlignment: CrossAxisAlignment.end,
//                                             children: <Widget>[

//                                               Container(
//                                                   margin: EdgeInsets.only(left: 3.0),
//                                                   height: 25,

//                                                   child:
//                                                   Material(

//                                                     color: AppColors.sellp,
//                                                     elevation: 0.0,
//                                                     shape: RoundedRectangleBorder(
//                                                       side: BorderSide(
//                                                         color: Colors.white,
//                                                       ),
//                                                       borderRadius: BorderRadius.all(
//                                                         Radius.circular(20),
//                                                       ),
//                                                     ),
//                                                     clipBehavior: Clip.antiAlias,
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         if(Constant.isLogin){


//                                                           String  mrp_price=calDiscount(suggestionList[index].buyPrice,suggestionList[index].discount);
//                                                           totalmrp= double.parse(mrp_price);


//                                                           double dicountValue=double.parse(suggestionList[index].buyPrice)-totalmrp;
//                                                           String gst_sgst=calGst(mrp_price,suggestionList[index].sgst);
//                                                           String gst_cgst=calGst(mrp_price,suggestionList[index].cgst);

//                                                           String  adiscount=calDiscount(suggestionList[index].buyPrice,suggestionList[index].msrp!=null?suggestionList[index].msrp:"0");

//                                                           admindiscountprice=(double.parse(suggestionList[index].buyPrice)-double.parse(adiscount));



//                                                           String color="";
//                                                           String size="";
//                                                           _addToproducts(suggestionList[index].productIs,suggestionList[index].productName,suggestionList[index].img,int.parse(mrp_price),int.parse(suggestionList[index].count),color,size,suggestionList[index].productDescription,gst_sgst,gst_cgst,
//                                                               suggestionList[index].discount,dicountValue.toString(), suggestionList[index].APMC, admindiscountprice.toString(),suggestionList[index].buyPrice,suggestionList[index].shipping,suggestionList[index].quantityInStock);


//                                                           setState(() {
// //                                                                              cartvalue++;
//                                                             Constant.carditemCount++;
//                                                             cartItemcount(Constant.carditemCount);

//                                                           });

// //                                                                Navigator.push(context,
// //                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);

//                                                         }
//                                                         else{


//                                                           Navigator.push(context,
//                                                             MaterialPageRoute(builder: (context) => SignInPage()),);
//                                                         }

// //

//                                                       },
//                                                       child:Padding(padding: EdgeInsets.only(left: 8,top: 5,bottom: 5,right: 8),
//                                                           child:Center(

//                                                             child:Icon(Icons.add_shopping_cart,color: Colors.white,),

//                                                           )),),
//                                                   )),









//                                             ],
//                                           ),






//                                         ]
//                                     ) ,
//                                   ),

//                                 ],
//                               ),


//                             ),
//                           )
//                         ],
//                       ),
//                     ),







//                   ),
//                 )*/
//                           ;
//                     },
//                   )
//                 : Center(child: CircularProgressIndicator()),
//           ),
//         ],
//       ),
//     );
//   }

//   // String calDiscount(String byprice, String discount2) {
//   //   String returnStr;
//   //   double discount = 0.0;
//   //   returnStr = discount.toString();
//   //   double byprice1 = double.parse(byprice);
//   //   double discount1 = double.parse(discount2);

//   //   discount = (byprice1 - (byprice1 * discount1) / 100.0);

//   //   returnStr = discount.toStringAsFixed(ServiceAppConstant.val);
//   //   print(returnStr);
//   //   return returnStr;
//   // }

//     String calDiscount(String byprice, String discount2) {
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

//   final DbProductManager dbmanager = new DbProductManager();

//   ProductsCart products2;
// //cost_price=buyprice
//    void _addToproducts(
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
//       String totalQun) {
//     if (suggestionList != null) {
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
//       ProductsCart st = new ProductsCart(
//           pid: pID,
//           pname: p_name,
//           pimage: image,
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
//           totalQuantity: totalQun, moq: '');
//       dbmanager.insertStudent(st).then((id) => {
//         log("called"),
//             showLongToast("Service Added Successfully!..."),
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => AddAddress("0"),
//               ),
//             ),
//           });
//     }
//   }



//  String calGst(String byprice, String sgst) {
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
//   // String calGst(String byprice, String sgst) {
//   //   String returnStr;
//   //   double discount = 0.0;
//   //   if (sgst.length > 1) {
//   //     returnStr = discount.toString();
//   //     double byprice1 = double.parse(byprice);
//   //     print(sgst);

//   //     double discount1 = double.parse(sgst);

//   //     discount = ((byprice1 * discount1) / (100.0 + discount1));

//   //     returnStr = discount.toStringAsFixed(2);
//   //     print(returnStr);
//   //     return returnStr;
//   //   } else {
//   //     return '0';
//   //   }
//   // }
// }
