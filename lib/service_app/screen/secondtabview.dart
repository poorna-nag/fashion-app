// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:royalmart/service_app/Auth/signin.dart';
// import 'package:royalmart/service_app/BottomNavigation/wishlist.dart';
// import 'package:royalmart/service_app/General/AppConstant.dart';
// import 'package:royalmart/service_app/dbhelper/CarrtDbhelper.dart';
// import 'package:royalmart/service_app/dbhelper/database_helper.dart';
// import 'package:royalmart/service_app/model/productmodel.dart';
// import 'package:royalmart/service_app/screen/SearchScreen.dart';
// import 'package:royalmart/service_app/screen/detailpage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Screen2 extends StatefulWidget {
//   final String title;
//   final String id;
//   const Screen2(this.id, this.title) : super();
//   @override
//   _ScreenState createState() => _ScreenState();
// }

// class _ScreenState extends State<Screen2> {
//   final List<String> imgList = [
//     'https://www.thebalanceeveryday.com/thmb/lMeVfLyCZWVPdU5eyjFLyK4AYQs=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/metrostyle-catalog-df95d1ece06c4197b1da85e316a05f90.jpg',
//     'https://rukminim1.flixcart.com/image/400/450/k3xcdjk0pkrrdj/sari/h/d/x/free-multicolor-combosr-28001-ishin-combosr-28001-original-imafa5257bxdzm5j.jpeg?q=90',
//     'https://i.pinimg.com/474x/62/4e/ce/624ece8daf9650f1a382995b340dc1e9.jpg',
//     'https://www.liveabout.com/thmb/y4jjlx2A6PVw_QYG4un_xJSFGBQ=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/asos-plus-size-maxi-dress-56e73ba73df78c5ba05773ab.jpg'
//   ];

//   final List<String> imgList1 = [
//     'https://assets.myntassets.com/h_400,q_90,w_500/v1/assets/images/9329399/2019/4/24/8df4ed41-1e43-4a0d-97fe-eb47edbdbacd1556086871124-Libas-Women-Kurtas-6161556086869769-1.jpg',
//     'https://assets.myntassets.com/h_400,q_90,w_700/v1/assets/images/2299060/2018/7/30/7584b116-2a2c-4fb1-881c-af58cc484b181532944603854-Tokyo-Talkies-Women-Black-Printed-Maxi-Dress-4791532944603727-1.jpg',
//     'https://assets.myntassets.com/h_400,q_90,w_700/v1/assets/images/7663716/2018/10/29/501848e4-713e-44de-8253-66ea0514ea541540800411035-Shree-Women-Leggings-8771540800410950-2.jpg',
//     'https://assets.myntassets.com/h_440,q_90,w_680/v1/assets/images/10652398/2019/10/16/e95befb9-8fe0-48b4-89d5-521b5d1f98c71571221021545-The-Chennai-Silks---Pure-Kanjivaram-Silk-Saree-3611571221020-1.jpg',
//     'https://assets.myntassets.com/f_webp,dpr_2.0,q_60,w_210,c_limit,fl_progressive/assets/images/6563444/2018/5/29/61a73b47-70b1-4eb1-ab4a-fad963f2a23e1527587516269-NA-3021527587515007-1.jpg',
//     'https://assets.myntassets.com/f_webp,dpr_2.0,q_60,w_210,c_limit,fl_progressive/assets/images/productimage/2019/11/5/3fba233d-8571-46f6-a2a6-3c65ef2dce611572931484233-1.jpg'
//   ];

//   int _current = 0;
//   List<Products> products = List();
//   void gatinfoCount() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();

//     int Count = pref.getInt("itemCount");
//     setState(() {
//       if (Count == null) {
//         ServiceAppConstant.serviceAppCartItemCount = 0;
//       } else {
//         ServiceAppConstant.serviceAppCartItemCount = Count;
//       }
// //      print(Constant.carditemCount.toString()+"itemCount");
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     gatinfoCount();

//     // catby_productData(widget.id).then((usersFromServe){
//     //   setState(() {
//     //     products=usersFromServe;
//     //   });
//     // });
// //    catby_productData(widget.id)
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: ServiceAppColors.tela,
//           leading: Padding(
//               padding: EdgeInsets.only(left: 0.0),
//               child: InkWell(
//                 onTap: () {
//                   if (Navigator.canPop(context)) {
//                     Navigator.pop(context);
//                   } else {
//                     SystemNavigator.pop();
//                   }
//                 },
//                 child: Icon(
//                   Icons.arrow_back,
//                   size: 30,
//                   color: Colors.white,
//                 ),
//               )),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Center(
//                 child: Padding(
//                   padding: EdgeInsets.only(right: 20),
//                   child: Text(
//                     widget.title.isEmpty ? "Products" : widget.title,
//                     style: TextStyle(color: ServiceAppColors.white, fontSize: 15),
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       // Navigator.push(context, MaterialPageRoute(builder: (context) => UserFilterDemo()),);
//                     },
//                     child: Stack(
//                       children: <Widget>[
//                         Padding(
//                           padding: EdgeInsets.only(top: 3),
//                           child: Icon(
//                             Icons.search,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                         ),
// //                    showCircle(),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     width: 12,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => WishList()),
//                       );
//                     },
//                     child: Stack(
//                       children: <Widget>[
//                         Padding(
//                           padding: EdgeInsets.only(top: 13),
//                           child: Icon(
//                             Icons.add_shopping_cart,
//                             color: Colors.white,
//                           ),
//                         ),
//                         showCircle(),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//         body: Column(
//           children: <Widget>[
// /*
//           widget.title.isEmpty?Row(): Container(
//             child: Padding(
//               padding: EdgeInsets.only(
//                   top: 20.0, left: 10.0, right: 8.0,bottom: 10.0),
//               child: Center(
//                 child: Text(widget.title,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 17,
//                       fontFamily: 'Roboto',
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ),
// */

//             Expanded(
//               child: FutureBuilder(
//                 future: catby_productData(widget.id, "0", "1234"),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return GridView.count(
//                       shrinkWrap: true,
//                       crossAxisCount: 2,
//                       childAspectRatio: 0.7,
//                       padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 0),
//                       children: List.generate(snapshot.data.length, (index) {
//                         return Container(
//                           height: 400,
//                           child: Card(
//                             clipBehavior: Clip.antiAlias,
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => ProductDetails(snapshot.data[index])),
//                                 );
//                               },
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     height: (MediaQuery.of(context).size.width / 2 - 14),
//                                     width: double.infinity,
//                                     child: CachedNetworkImage(
//                                       fit: BoxFit.cover,
//                                       imageUrl: ServiceAppConstant.Base_Imageurl + snapshot.data[index].img,
//                                       placeholder: (context, url) => Center(child: CircularProgressIndicator()),
//                                       errorWidget: (context, url, error) => new Icon(Icons.error),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 0.0),
//                                     child: ListTile(
//                                       title: Text(
//                                         snapshot.data[index].productName,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: TextStyle(
//                                           fontSize: 11,
//                                           color: Colors.teal[200],
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       subtitle: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Row(
//                                             children: <Widget>[
//                                               Padding(
//                                                 padding: const EdgeInsets.only(top: 2.0, bottom: 1),
//                                                 child: Text('\u{20B9} ${calDiscount(snapshot.data[index].buyPrice, snapshot.data[index].discount)}',
//                                                     overflow: TextOverflow.ellipsis,
//                                                     maxLines: 2,
//                                                     style: TextStyle(
//                                                       color: Colors.green,
//                                                       fontWeight: FontWeight.w700,
//                                                     )),
//                                               ),
//                                               Expanded(
//                                                 child: Text(
//                                                   '(\u{20B9} ${snapshot.data[index].buyPrice})',
//                                                   overflow: TextOverflow.ellipsis,
//                                                   maxLines: 2,
//                                                   style: TextStyle(
//                                                       fontWeight: FontWeight.w700,
//                                                       fontStyle: FontStyle.italic,
//                                                       color: Theme.of(context).accentColor,
//                                                       decoration: TextDecoration.lineThrough),
//                                                 ),
//                                               )
//                                             ],
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
//                       }),
//                     );
//                   }
//                   return Center(child: CircularProgressIndicator());
//                 },
//               ),
//             )
//           ],
//         ));
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
