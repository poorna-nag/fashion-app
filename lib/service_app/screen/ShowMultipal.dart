// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:royalmart/service_app/General/AppConstant.dart';
// import 'package:royalmart/service_app/StyleDecoration/styleDecoration.dart';
// import 'package:royalmart/service_app/dbhelper/CarrtDbhelper.dart';
// import 'package:royalmart/service_app/dbhelper/database_helper.dart';
// import 'package:royalmart/service_app/model/Gallerymodel.dart';
// import 'package:royalmart/service_app/model/productmodel.dart';

// class MuliImageSelecter extends StatefulWidget {
//   final String id;
//   final String name;
//   final String price;
//   final String discount;
//   const MuliImageSelecter(this.id, this.name, this.price, this.discount) : super();

//   @override
//   _MuliImageSelecterState createState() => _MuliImageSelecterState();
// }

// class _MuliImageSelecterState extends State<MuliImageSelecter> {
//   String _dropDownValue;
//   String _dropDownValue1;
//   int total;
//   int actualprice = 200;
//   double mrp, totalmrp;
//   double sgst1, cgst1, dicountValue, admindiscountprice;
//   String url;
//   List<Gallery> galiryImage1 = List();
//   List<Products> productdetails = List();
//   ProductsCart products;
//   Products prod;
//   final DbProductManager dbmanager = new DbProductManager();
//   final List<String> imgList1 = [
//     'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
//   ];
//   @override
//   void initState() {
//     super.initState();

//     print(widget.id);
//     productdetail(widget.id).then((usersFromServe) {
//       setState(() {
//         productdetails = usersFromServe;
//         if (productdetails.length > 0) {
//           setState(() {
//             url = productdetails[0].img;
//             actualprice = int.parse(productdetails[0].buyPrice);
//             total = actualprice;

//             String mrp_price = calDiscount(productdetails[0].buyPrice, productdetails[0].discount);
//             totalmrp = double.parse(mrp_price);

//             String adiscount = calDiscount(productdetails[0].buyPrice, productdetails[0].msrp);
//             admindiscountprice = (double.parse(productdetails[0].buyPrice) - double.parse(adiscount));
//             dicountValue = double.parse(productdetails[0].buyPrice) - totalmrp;
//             String gst_sgst = calGst(totalmrp.toString(), productdetails[0].sgst);
//             String gst_cgst = calGst(totalmrp.toString(), productdetails[0].cgst);

//             sgst1 = double.parse(gst_sgst);
//             cgst1 = double.parse(gst_cgst);
//           });
//         }
//       });
//     });
//     DatabaseHelper.getImage(widget.id).then((usersFromServe) {
//       setState(() {
//         galiryImage1 = usersFromServe;
//         imgList1.clear();
//         for (var i = 0; i < galiryImage1.length; i++) {
//           imgList1.add(galiryImage1[i].img);
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal[50],
//         elevation: 0.0,
//         leading: InkWell(
//           onTap: () {
//             if (Navigator.canPop(context)) {
//               Navigator.pop(context);
//             } else {
//               SystemNavigator.pop();
//             }
//           },
//           child: Icon(
//             Icons.arrow_back,
//             size: 30,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: Column(
//         children: <Widget>[
//           createHeader(),
// //          createSubTitle(),
//           Expanded(
//             child: ListView.builder(
//                 itemCount: imgList1.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Stack(
//                     children: <Widget>[
//                       Container(
//                         margin: EdgeInsets.only(left: 16, right: 16, top: 16),
//                         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
//                               width: 110,
//                               height: 160,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.all(Radius.circular(14)),
//                                   color: Colors.blue.shade200,
//                                   image:
//                                       DecorationImage(fit: BoxFit.cover, image: NetworkImage(ServiceAppConstant.Product_Imageurl + imgList1[index]))),
//                             ),
//                             Expanded(
//                               child: Container(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.max,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     SizedBox(height: 6),
//                                     Text(
//                                       productdetails[0].buyPrice == null ? widget.price : productdetails[0].buyPrice,
//                                       style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black).copyWith(color: Colors.grey, fontSize: 14),
//                                     ),
//                                     Container(
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: <Widget>[
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               crossAxisAlignment: CrossAxisAlignment.end,
//                                               children: <Widget>[
//                                                 InkWell(
//                                                   onTap: () {
// //                                            if(prodctlist1[index].quantity!=1){
// //
// //                                              setState(() {
// //                                                String pvalue= calDiscount1(item.costPrice,item.discount);
// //                                                double price= double.parse(pvalue);
// //                                                Constant.totalAmount=Constant.totalAmount-price;
// //                                                int quantity=item.pQuantity;
// //                                                int totalquantity=quantity-1;
// //                                                double incrementprice=(price*totalquantity);
// //                                                prodctlist1[index].price=incrementprice.toString();
// //                                                prodctlist1[index].quantity=totalquantity;
// //                                                dbmanager.updateStudent(item);
// //                                              });
// //                                            }
//                                                   },
//                                                   child: Icon(
//                                                     Icons.remove,
//                                                     size: 24,
//                                                     color: Colors.grey.shade700,
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   color: Colors.grey.shade200,
//                                                   padding: const EdgeInsets.only(bottom: 2, right: 12, left: 12),
//                                                   child: Text(productdetails[0] == null
//                                                       ? '1'
//                                                       : '${(int.parse(productdetails[0].quantityInStock) + 1 - int.parse(productdetails[0].quantityInStock))}'),
//                                                 ),
//                                                 InkWell(
// //                                          onTap: (){
// //
// //                                            setState(() {
// //                                              String pvalue= calDiscount1(item.costPrice,item.discount);
// //                                              double price= double.parse(pvalue);
// //                                              Constant.totalAmount=Constant.totalAmount+price;
// //
// //                                              int quantity=item.pQuantity;
// //                                              int totalquantity=quantity+1;
// //                                              double incrementprice=(price*totalquantity);
// //                                              prodctlist1[index].price=incrementprice.toString();
// //                                              prodctlist1[index].quantity=totalquantity;
// //                                              dbmanager.updateStudent(item);
// //                                            });
// //
// //                                          },
//                                                   child: Icon(
//                                                     Icons.add,
//                                                     size: 24,
//                                                     color: Colors.grey.shade700,
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               flex: 100,
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 }),
//           ),
//         ],
//       ),
//     );
//   }

//   createHeader() {
//     return Container(
//       alignment: Alignment.topLeft,
//       child: Text(
//         widget.name,
//         style: CustomTextStyle.textFormFieldBold.copyWith(fontSize: 16, color: Colors.black),
//       ),
//       margin: EdgeInsets.only(left: 12, top: 12),
//     );
//   }

//   String calDiscount(String byprice, String discount2) {
//     String returnStr;
//     double discount = 0.0;
//     returnStr = discount.toString();
//     double byprice1 = double.parse(byprice);
//     double discount1 = double.parse(discount2);

//     discount = (byprice1 - (byprice1 * discount1) / 100.0);

//     returnStr = discount.toStringAsFixed(2);
//     print(returnStr);
//     return returnStr;
//   }

//   String calGst(String byprice, String sgst) {
//     String returnStr;
//     double discount = 0.0;
//     returnStr = discount.toString();
//     double byprice1 = double.parse(byprice);
//     double discount1 = double.parse(sgst);

//     discount = ((byprice1 * discount1) / (100.0 + discount1));

//     returnStr = discount.toStringAsFixed(2);
//     print(returnStr);
//     return returnStr;
//   }
// }
