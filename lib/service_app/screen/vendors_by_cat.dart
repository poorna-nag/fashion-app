// import 'dart:convert';
// import 'dart:developer';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:royalmart/service_app/screen/mv_products.dart';
// import 'package:royalmart/service_app/General/AppConstant.dart';
// import 'package:http/http.dart' as http;
// import 'package:royalmart/service_app/model/vendor_details.dart';
// import 'package:royalmart/service_app/screen/vendor_product_categories.dart';
// import 'package:royalmart/utils/dimensions.dart';
// import 'package:royalmart/utils/styles.dart';

// class VendorsByCat extends StatefulWidget {
//   final catId;
//   final catName;
//   const VendorsByCat(this.catId, this.catName) : super();

//   @override
//   State<VendorsByCat> createState() => _VendorsByCatState();
// }

// class _VendorsByCatState extends State<VendorsByCat> {
//   List<VendorList> list = List();
//   VendorList vendorList = VendorList();
//   bool isLoading = true;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     init();
//   }

//   init() async {
//     await getVendorsByCatId(widget.catId);
//   }

//   getVendorsByCatId(String catId) async {
//     String link =
//         "${ServiceAppConstant.base_url}/api/mv_list?shop_id=${ServiceAppConstant.Shop_id}&lat=${ServiceAppConstant.latitude}&lng=${ServiceAppConstant.longitude}&rad=&q=&mv_cat=${catId}";
//     var response = await http.get(link);

//     if (response.statusCode == 200) {
//       var responseData = jsonDecode(response.body);
//       setState(() {
//         vendorList = VendorList.fromJson(responseData);
//         isLoading = false;
//       });
//       log("list---->${vendorList.list.length}");
//       VendorList.fromJson(responseData);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ServiceAppColors.tela,
//         title: Text(
//           widget.catName,
//           style: TextStyle(color: ServiceAppColors.white),
//         ),
//         iconTheme: IconThemeData(
//           color: ServiceAppColors.white, // <-- SEE HERE
//         ),
//       ),
//       backgroundColor: ServiceAppColors.red,
//       body: isLoading
//           ? Container(
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           : Container(
//               margin: EdgeInsets.only(left: 5, right: 5, top: 5),
//               child: GridView.builder(
//                   shrinkWrap: true,
//                   primary: false,
//                   itemCount: vendorList.list.length,
//                   gridDelegate: (SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 1,
//                     childAspectRatio: 1 / .6,
//                   )),
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => MvProducts(
//                                   vendorList.list[index].company,
//                                   vendorList.list[index].mvId,
//                                   "")),
//                         );
//                       },
//                       child: Container(
//                         //margin: EdgeInsets.only(left: 5, top: 5),
//                         height: 150,
//                         width: MediaQuery.of(context).size.width,
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).cardColor,
//                           borderRadius:
//                               BorderRadius.circular(Dimensions.RADIUS_SMALL),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey[300],
//                               blurRadius: 5,
//                               spreadRadius: 1,
//                             )
//                           ],
//                         ),
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Stack(children: [
//                                 ClipRRect(
//                                     borderRadius: BorderRadius.vertical(
//                                         top: Radius.circular(
//                                             Dimensions.RADIUS_SMALL)),
//                                     child: vendorList.list[index].pp != null
//                                         ? vendorList.list[index].pp ==
//                                                 "no-pp.png"
//                                             ? Image.asset(
//                                                 "assets/images/logo.png",
//                                                 height: 90,
//                                                 width: 200,
//                                                 fit: BoxFit.cover,
//                                               )
//                                             : CachedNetworkImage(
//                                                 imageUrl: ServiceAppConstant
//                                                         .logo_Image_mv +
//                                                     vendorList.list[index].pp,
//                                                 height: 150,
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 fit: BoxFit.cover,
//                                                 placeholder: (context, url) => Center(
//                                                     child: CircularProgressIndicator(
//                                                         // value: ServiceAppColors.tela,
//                                                         )),
//                                                 errorWidget:
//                                                     (context, url, error) =>
//                                                         new Icon(Icons.error),
//                                               )
//                                         : Image.asset(
//                                             "assets/images/logo.png",
//                                             height: 90,
//                                             width: 200,
//                                             fit: BoxFit.cover,
//                                           )),
//                               ]),
//                               Expanded(
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal:
//                                           Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                                   child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           vendorList.list[index].company ?? '',
//                                           style: robotoMedium.copyWith(
//                                               fontSize:
//                                                   Dimensions.fontSizeSmall),
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         Text(
//                                           vendorList.list[index].address ?? '',
//                                           style: robotoMedium.copyWith(
//                                               fontSize:
//                                                   Dimensions.fontSizeExtraSmall,
//                                               color: Theme.of(context)
//                                                   .disabledColor),
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: [
//                                             RatingBar.builder(
//                                               initialRating: (double.parse(
//                                                       vendorList.list[index]
//                                                           .reviews) /
//                                                   double.parse(vendorList
//                                                       .list[index]
//                                                       .reviewsTotal)),
//                                               minRating: 0,
//                                               itemSize: 15,
//                                               direction: Axis.horizontal,
//                                               allowHalfRating: true,
//                                               itemCount: 5,
//                                               itemPadding: EdgeInsets.symmetric(
//                                                   horizontal: 1.0),
//                                               itemBuilder: (context, _) => Icon(
//                                                 Icons.star,
//                                                 color: double.parse(vendorList
//                                                             .list[index]
//                                                             .reviewsTotal) >
//                                                         0
//                                                     ? ServiceAppColors.tela
//                                                     : Colors.grey,
//                                                 size: 5,
//                                               ),
//                                               /* onRatingUpdate: (rating) {
//                                                             // _ratingController=rating;
//                                                             print(rating);
//                                                           },*/
//                                             ),
//                                             SizedBox(width: 5),
//                                             Text(
//                                               "(${vendorList.list[index].reviewsTotal})",
//                                               style: TextStyle(
//                                                 fontSize: 10,
//                                                 color: Colors.grey,
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                         //rating
//                                       ]),
//                                 ),
//                               ),
//                             ]),
//                       ),
//                     );
//                   }),
//             ),
//     );
//   }
// }
