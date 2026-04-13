// import 'package:flutter/material.dart';
// import 'package:royalmart/constent/app_constent.dart';
// import 'package:royalmart/grocery/General/AppConstant.dart';
// import 'package:royalmart/grocery/dbhelper/CarrtDbhelper.dart';
// import 'package:royalmart/grocery/model/Gallerymodel.dart';
// import 'package:royalmart/grocery/model/Varient.dart';
// import 'package:royalmart/grocery/model/aminities_model.dart';
// import 'package:royalmart/grocery/model/productmodel.dart';
// import 'package:royalmart/grocery/screen/Zoomimage.dart';
// import 'package:share_plus/share_plus.dart';

// class ProductDetails extends StatefulWidget {
//   final Products plist;

//   const ProductDetails(this.plist, {Key? key}) : super(key: key);

//   @override
//   _ProductDetailsState createState() => _ProductDetailsState();
// }

// class _ProductDetailsState extends State<ProductDetails>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
  
//   List<PVariant> pvarlist = [];
//   AmenitiesModel amenitiesModel = AmenitiesModel();
//   List<String> imgList1 = [];
//   List<Gallery>? galiryImage1;
  
//   String name = "";
//   String sharableProductName = "";
//   String sharableProductId = "";
//   String? textval = "";
//   String? url;
//   int total = 0;
//   int actualprice = 0;
//   int? cc = 0;
//   double? totalmrp = 0.0;
//   double dicountValue = 0.0;
//   double sgst1 = 0.0;
//   double cgst1 = 0.0;
//   bool wishflag = true;
//   String? wishid;
//   String mv = "";
//   int selectedImageIndex = 0;
//   int quantity = 1;
//   String selectedVariant = "";
  
//   final DbProductManager dbmanager1 = new DbProductManager();

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _initializeData();
//   }

//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 800),
//       vsync: this,
//     );
    
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
    
//     _slideAnimation = Tween<Offset>(
//       begin: Offset(0, 0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutCubic,
//     ));
    
//     _animationController.forward();
//   }

//   void _initializeData() {
//     name = widget.plist.productName ?? "";
//     url = widget.plist.img;
//     actualprice = int.parse(widget.plist.buyPrice ?? "0");
//     total = actualprice;
    
//     String mrpPrice = _calculateDiscount(widget.plist.buyPrice ?? "0", widget.plist.discount ?? "0");
//     totalmrp = double.parse(mrpPrice);
//     dicountValue = double.parse(widget.plist.buyPrice ?? "0") - totalmrp!;
    
//     _loadProductVariants();
//     _loadProductImages();
//     _loadCartCount();
//   }

//   void _loadProductVariants() {
//     // Simplified variant loading
//     setState(() {
//       pvarlist = [];
//     });
//   }

//   void _loadProductImages() {
//     // Simplified image loading
//     setState(() {
//       galiryImage1 = [];
//       imgList1.clear();
//       if (url != null) {
//         imgList1.add(url!);
//       }
//     });
//   }

//   void _loadCartCount() {
//     // Simplified cart count loading
//     setState(() {
//       cc = 0;
//       AppConstent.cc = 0;
//     });
//   }

//   String _calculateDiscount(String price, String discount) {
//     double originalPrice = double.parse(price);
//     double discountPercent = double.parse(discount);
//     double discountedPrice = originalPrice - (originalPrice * discountPercent / 100);
//     return discountedPrice.toString();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   String name = "";
//   String sharableProductName = "";
//   String sharableProductId = "";

//   _displayDialog(BuildContext context) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             scrollable: true,
//             title: Text('Select Variant'),
//             content: Container(
//               width: double.maxFinite,
//               height: pvarlist.length * 50.0,
//               child: ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   itemCount: pvarlist.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Container(
//                       width: pvarlist[index] != 0 ? 130.0 : 230.0,
//                       color: Colors.white,
//                       margin: EdgeInsets.only(right: 10),
//                       child: InkWell(
//                         onTap: () {
//                           setState(() {
//                             total = int.parse(pvarlist[index].price ?? "");
//                             String mrp_price = calDiscount(
//                                 pvarlist[index].price ?? "",
//                                 pvarlist[index].discount ?? "");
//                             totalmrp = double.parse(mrp_price);
//                             textval = pvarlist[index].variant ?? "";
//                             name = pvarlist[index].variant ?? "";
//                             Navigator.pop(context);
//                           });
//                         },
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Padding(
//                               padding: EdgeInsets.only(left: 10, right: 10),
//                               child: Text(
//                                 pvarlist[index].variant ?? "",
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 2,
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: GroceryAppColors.black,
//                                 ),
//                               ),
//                             ),
//                             Divider(
//                               color: GroceryAppColors.black,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//             ),
//             actions: <Widget>[
//               new TextButton(
//                 child: new Text('CANCEL'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               )
//             ],
//           );
//         });
//   }

//   int? _current = 0;
//   bool? flag = true;
//   int? wishid;
//   bool? wishflag = true;
//   String? url = "";
//   String? textval = "Select varient";

//   // List<Products> products1 = List();
//   List<Products> topProducts1 = [];

//   final List<String> imgList1 = <String>[];

//   List<T> map<T>(List list, Function handler) {
//     List<T> result = [];
//     for (var i = 0; i < list.length; i++) {
//       result.add(handler(i, list[i]));
//     }
//     return result;
//   }

//   final List<String> _currencies = ['ram', 'mohan'];
//   int _count = 1;
//   String? _dropDownValue;
//   String? _dropDownValue2;
//   String? _dropDownValue1, groupname = "";
//   int? total;
//   int? actualprice = 200;
//   double? mrp, totalmrp;
//   double? sgst1, cgst1, dicountValue, admindiscountprice;

//   List<Gallery>? galiryImage1 = [];
//   List<GroupProducts>? group = [];
//   List<Products> productdetails = [];
//   List<String>? size;
//   List<String>? color;
//   List<String>? catid = <String>[];
//   ProductsCart? products;
//   WishlistsCart? nproducts;
//   final DbProductManager dbmanager = new DbProductManager();
//   final DbProductManager1 dbmanager1 = new DbProductManager1();
//   int cc = 0;
// //  DatabaseHelper helper = DatabaseHelper();
// //  Note note ;

//   void getcartCount() async {
//     SharedPreferences? pref = await SharedPreferences.getInstance();
//     int? cCount = pref.getInt("cc");
//     setState(() {
//       // log("cart get count------------------->>$cCount");
//       if (cCount == 0 || cCount! < 0) {
//         cc = 0;
//       } else {
//         setState(() {
//           cc = cCount;
//           AppConstent.cc = cCount;
//         });
//       }
//       // log("cart count------------------->>$cc");
//     });
//   }

//   void gatinfoCount() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     GroceryAppConstant.isLogin = false;
//     int? Count = pref.getInt("itemCount");
//     bool? ligin = pref.getBool("isLogin");
//     setState(() {
//       if (ligin != null) {
//         GroceryAppConstant.isLogin = ligin;
//       }
//       if (Count == null) {
//         GroceryAppConstant.groceryAppCartItemCount = 0;
//       } else {
//         GroceryAppConstant.groceryAppCartItemCount = Count;
//       }
//       print(
//           GroceryAppConstant.groceryAppCartItemCount.toString() + "itemCount");
//     });
//   }

//   static List<WishlistsCart>? prodctlist1;

//   // final DbProductManager1 dbmanager12 = new DbProductManager1();

//   @override
//   void initState() {
//     super.initState();
//     getcartCount();
//     name = widget.plist.productName ?? "";
//     gatinfoCount();
//     print(' === ProductDetails initState called === ');
//     print(' product id ${widget.plist.productIs}');
//     print(' product name: ${widget.plist.productName}');
//     print(' product buy price: ${widget.plist.buyPrice}');
//     print(' widget hash: ${widget.hashCode}');

//     getPvarient(widget.plist.productIs ?? "").then((usersFromServe) {
//       setState(() {
//         pvarlist = usersFromServe!;
//       });
//     });
//     getAmenities();

//     dbmanager1.getProductList3().then((usersFromServe) {
//       setState(() {
//         prodctlist1 = usersFromServe;
//         for (var i = 0; i < prodctlist1!.length; i++) {
//           if (prodctlist1![i].pid == widget.plist.productIs) {
//             wishid = prodctlist1![i].id;
//             wishflag = false;
//           }
//         }
//       });
//     });

//     catid = widget.plist.productLine!.split(',');
//     size = widget.plist.productScale!.split(',');
//     color = widget.plist.productColor!.split(',');

//     DatabaseHelper.getImage(widget.plist.productIs ?? "")
//         .then((usersFromServe) {
//       setState(() {
//         galiryImage1 = usersFromServe;
//         imgList1.clear();
//         for (var i = 0; i < galiryImage1!.length; i++) {
//           imgList1.add(galiryImage1![i].img!);
//         }
//       });
//     });

//     GroupPro(widget.plist.productIs ?? "").then((usersFromServe) {
//       if (this.mounted) {
//         setState(() {
//           group = usersFromServe!.cast<GroupProducts>();
//           print(group != null);
//           if (group != null) {
//             groupname = group![0].name;
//           }
//           print(group.toString() + "group info");
//         });
//       }
//     });
//     DatabaseHelper.getProductsByCategory(
//             catid!.length > 0 ? catid![0] : "0", "15")
//         .then((usersFromServe) {
//       setState(() {
//         // Filter out the current product from related products to avoid showing the same product
//         topProducts1 = usersFromServe
//                 ?.where(
//                     (product) => product.productIs != widget.plist.productIs)
//                 .toList() ??
//             [];
//         print('Related products count: ${topProducts1.length}');
//         print('Current product ID: ${widget.plist.productIs}');
//         if (topProducts1.isNotEmpty) {
//           print(
//               'First related product: ${topProducts1[0].productName} - ID: ${topProducts1[0].productIs}');
//           // Print all related product IDs to check for duplicates
//           for (int i = 0; i < topProducts1.length; i++) {
//             print(
//                 'Related product $i: ${topProducts1[i].productName} - ID: ${topProducts1[i].productIs}');
//           }
//         }
//       });
//     });

//     setState(() {
//       actualprice = int.parse(widget.plist.buyPrice ?? "");
//       total = actualprice;
//       url = widget.plist.img;
//       String mrp_price =
//           calDiscount(widget.plist.buyPrice ?? "", widget.plist.discount ?? "");
//       totalmrp = double.parse(mrp_price);

//       dicountValue = double.parse(widget.plist.buyPrice ?? "") - totalmrp!;
//       String gst_sgst = calGst(totalmrp.toString(), widget.plist.sgst ?? "");
//       String gst_cgst = calGst(totalmrp.toString(), widget.plist.cgst ?? "");

//       sgst1 = double.parse(gst_sgst);
//       cgst1 = double.parse(gst_cgst);
//     });
//   }

//   bool showdis = false;

//   Future<void> getAmenities() async {
//     await DatabaseHelper.getAmenities(widget.plist.productIs ?? "")
//         .then((value) {
//       amenitiesModel = value!;
//     });
//   }

//   shareProduct(String url, String title, String price) async {
//     Share.share("Hi, Order Best Products From " +
//         GroceryAppConstant.appname +
//         " app. Click on this link  $price");
//     // await Share.("my text title", "${price}", "text/plain");
//   }

//   @override
//   Widget build(BuildContext context) {
//     getcartCount();
//     return Scaffold(
//       // backgroundColor: AppColors.tela1,
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         elevation: 0.0,
//         backgroundColor: GroceryAppColors.tela,
//         title: Text(
//           "Product Details",
//           style: TextStyle(color: GroceryAppColors.white),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//             setState(() {});
//           },
//           icon: Icon(
//             Icons.arrow_back,
//           ),
//         ),
//         actions: <Widget>[
//           InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => WishList()),
//               );
//             },
//             child: Stack(
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.only(right: 40, top: 17),
//                   child: Icon(
//                     Icons.add_shopping_cart,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
// //                showCircle(),
//                 Align(
//                   alignment: Alignment.center,
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 15, bottom: 18),
//                     child: Container(
//                       padding: const EdgeInsets.all(5.0),
//                       decoration: new BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: GroceryAppColors.homeiconcolor,
//                       ),
//                       child: Text('${cc}',
//                           style:
//                               TextStyle(color: Colors.white, fontSize: 15.0)),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),

//       body: Container(
//         width: double.infinity,
//         child: SafeArea(
//             top: false,
//             left: false,
//             right: false,
//             child: CustomScrollView(slivers: <Widget>[
//               SliverList(
//                 // Use a delegate to build items as they're scrolled on screen.
//                 delegate: SliverChildBuilderDelegate(
//                   // The builder function returns a ListTile with a title that
//                   // displays the index of the current item.
//                   (context, index) => Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         SizedBox(height: 10),
//                         imgList1.length > 0
//                             ? Container(
//                                 height: 280,
//                                 child: PageView.builder(
//                                     itemCount: imgList1.length,
//                                     itemBuilder: (ctx, index) {
//                                       return InkWell(
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     ZoomImage(imgList1)),
//                                           );
//                                         },
//                                         child: Container(
//                                           decoration: new BoxDecoration(
//                                             color: GroceryAppColors.tela,
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                           ),
//                                           child: Container(
//                                               width: double.infinity,
//                                               margin: EdgeInsets.all(4.0),
//                                               constraints: BoxConstraints(
//                                                 maxWidth: 300,
//                                                 maxHeight: 300,
//                                               ),
//                                               child: ClipRRect(
//                                                 borderRadius: BorderRadius.all(
//                                                     Radius.circular(8.0)),
//                                                 child:
//                                                     /*Image.network(
//                                                 Constant.Product_Imageurl+imgUrl,
//                                                   fit: BoxFit.fill,
//                                               ),*/
//                                                     CachedNetworkImage(
//                                                   fit: BoxFit.fill,
//                                                   imageUrl: GroceryAppConstant
//                                                           .Product_Imageurl2 +
//                                                       imgList1[index],
//                                                   placeholder: (context, url) =>
//                                                       Center(
//                                                           child:
//                                                               CircularProgressIndicator()),
//                                                   errorWidget:
//                                                       (context, url, error) =>
//                                                           new Icon(Icons.error),
//                                                 ),
//                                               )),
//                                         ),
//                                       );
//                                     }))
//                             : Container(
//                                 height: 280,
//                                 child:
//                                     Center(child: Text("No images available"))),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: map<Widget>(imgList1, (index, url) {
//                             return Padding(
//                               padding: const EdgeInsets.only(left: 120, top: 8),
//                               child: Container(
//                                 width: 25.0,
//                                 height: 0.0,

//                                 child: Divider(
//                                   height: 20,
//                                   color: _current == index
//                                       ? GroceryAppColors.tela
//                                       : GroceryAppColors.darkGray,

//                                   thickness: 2.0,
// //                                  endIndent: 30.0,
//                                 ),

//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: 4.0, vertical: 7.0),
// //                                decoration: BoxDecoration(
// //                                  shape: BoxShape.rectangle,
// //                                  color: _current == index ? Colors.orange : Colors.grey,
// //                                ),
//                               ),
//                             );
//                           }),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               top: 10.0, bottom: 5, left: 15, right: 15),
//                           child: Text(name,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w400,
//                               )),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(left: 18, top: 10, right: 18),
//                           child: Row(
//                             children: <Widget>[
//                               Flexible(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       top: 2.0, bottom: 1),
//                                   child: Text('\u{20B9} $total',
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w700,
//                                           fontStyle: FontStyle.italic,
//                                           color: Colors.grey,
//                                           decoration:
//                                               TextDecoration.lineThrough)),
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Flexible(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       top: 2.0, bottom: 1),
//                                   child: Text(
//                                       '\u{20B9} ${(totalmrp! * _count).toStringAsFixed(GroceryAppConstant.val)}',
// //                              total.toString()==null?'\u{20B9} $total':actualprice.toString(),
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         color: GroceryAppColors.green,
//                                         fontWeight: FontWeight.w700,
//                                       )),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           margin: EdgeInsets.only(left: 10, right: 20),
//                           padding: EdgeInsets.all(10),
//                           child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 widget.plist.productColor!.length < 2
//                                     ? Container(
//                                         height: 5,
//                                       )
//                                     : Container(),
//                                 widget.plist.productColor!.length < 2
//                                     ? Container()
//                                     : Container(
//                                         width: 120,
//                                         child: Padding(
//                                           padding: EdgeInsets.all(5),
//                                           child: DropdownButton(
//                                             elevation: 0,
//                                             hint: _dropDownValue == null
//                                                 ? Text('Select color')
//                                                 : Text(
//                                                     _dropDownValue!,
//                                                     style: TextStyle(
//                                                         color: Colors.blue),
//                                                   ),
//                                             isExpanded: true,
//                                             iconSize: 30.0,
//                                             style:
//                                                 TextStyle(color: Colors.blue),
//                                             items: color!.map(
//                                               (val) {
//                                                 return DropdownMenuItem<String>(
//                                                   value: val,
//                                                   child: Text(val),
//                                                 );
//                                               },
//                                             ).toList(),
//                                             onChanged: (val) {
//                                               setState(
//                                                 () {
//                                                   _dropDownValue = val;
//                                                 },
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                 SizedBox(
//                                   width: 30,
//                                 ),
//                                 Expanded(
//                                   child: widget.plist.productScale!.length < 2
//                                       ? Container()
//                                       : Container(
//                                           width: 120,
//                                           child: DropdownButton(
//                                             hint: _dropDownValue1 == null
//                                                 ? Text('Select Size')
//                                                 : Text(
//                                                     _dropDownValue1!,
//                                                     style: TextStyle(
//                                                         color: Colors.blue),
//                                                   ),
//                                             isExpanded: true,
//                                             iconSize: 30.0,
//                                             style:
//                                                 TextStyle(color: Colors.blue),
//                                             items: size!.map(
//                                               (val) {
//                                                 return DropdownMenuItem<String>(
//                                                   value: val,
//                                                   child: Text(val),
//                                                 );
//                                               },
//                                             ).toList(),
//                                             onChanged: (val) {
//                                               setState(
//                                                 () {
//                                                   _dropDownValue1 = val;
//                                                 },
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                 )
//                               ]),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(left: 5, bottom: 10),
//                           child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: <Widget>[
//                                 SizedBox(
//                                   width: 0.0,
//                                   height: 0.0,
//                                 ),
//                                 Column(
//                                   children: <Widget>[
//                                     Row(
//                                       children: <Widget>[
//                                         Container(
//                                             margin: EdgeInsets.only(left: 10),
//                                             height: 33,
//                                             child: Material(
//                                               color: GroceryAppColors.tela,
//                                               elevation: 0.0,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.all(
//                                                   Radius.circular(2),
//                                                 ),
//                                               ),
//                                               clipBehavior: Clip.antiAlias,
//                                               child: InkWell(
//                                                   onTap: () {
//                                                     if (_count != 1) {
//                                                       setState(() {
//                                                         _count--;
// //                                                        totalmrp=mrp * _count;
//                                                       });
//                                                     }
//                                                   },
//                                                   child: Padding(
//                                                     padding: EdgeInsets.only(
//                                                       top: 10.0,
//                                                     ),
//                                                     child: Icon(
//                                                       Icons.maximize,
//                                                       size: 30,
//                                                       color: Colors.white,
//                                                     ),
//                                                   )),
//                                             )),
//                                         Padding(
//                                           padding: EdgeInsets.only(
//                                               top: 0.0, left: 10.0, right: 8.0),
//                                           child: Center(
//                                             child: Text('$_count',
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 19,
//                                                     fontFamily: 'Roboto',
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                           ),
//                                         ),
//                                         Container(
//                                             margin: EdgeInsets.only(left: 3.0),
//                                             height: 33,
//                                             child: Material(
//                                               color: GroceryAppColors.tela,
//                                               elevation: 0.0,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.all(
//                                                   Radius.circular(2),
//                                                 ),
//                                               ),
//                                               clipBehavior: Clip.antiAlias,
//                                               child: InkWell(
//                                                 onTap: () {
//                                                   if (_count <=
//                                                       int.parse(widget.plist
//                                                               .quantityInStock ??
//                                                           "")) {
//                                                     setState(() {
//                                                       _count++;
// //                                                     totalmrp=mrp * _count;
//                                                     });
//                                                   } else {
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(SnackBar(
//                                                             content: Text(
//                                                                 " Products  is not avaliable "),
//                                                             duration: Duration(
//                                                                 seconds: 1)));
//                                                   }
//                                                 },
//                                                 child: Icon(
//                                                   Icons.add,
//                                                   size: 30,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             )),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                                 Column(
//                                   children: <Widget>[
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         SizedBox(width: 5),
//                                         Container(
//                                             margin: EdgeInsets.only(left: 3.0),
//                                             height: 35,
//                                             child: Material(
//                                               color: GroceryAppColors.tela,
//                                               elevation: 0.0,
//                                               shape: RoundedRectangleBorder(
//                                                 side: BorderSide(
//                                                     color:
//                                                         GroceryAppColors.tela),
//                                                 borderRadius: BorderRadius.all(
//                                                   Radius.circular(2),
//                                                 ),
//                                               ),
//                                               clipBehavior: Clip.antiAlias,
//                                               child: InkWell(
//                                                 onTap: () async {
//                                                   SharedPreferences pref =
//                                                       await SharedPreferences
//                                                           .getInstance();
//                                                   if (GroceryAppConstant
//                                                       .isLogin) {
//                                                     if (widget
//                                                                 .plist
//                                                                 .productColor!
//                                                                 .length >
//                                                             2 &&
//                                                         widget
//                                                                 .plist
//                                                                 .productScale!
//                                                                 .length >
//                                                             2) {
//                                                       if (_dropDownValue !=
//                                                               null &&
//                                                           _dropDownValue1 !=
//                                                               null) {
//                                                         addTocardval();
//                                                         GroceryAppConstant
//                                                             .groceryAppCartItemCount++;
//                                                         groceryCartItemCount(
//                                                             GroceryAppConstant
//                                                                 .groceryAppCartItemCount);

//                                                         setState(() {
//                                                           AppConstent.cc++;

//                                                           pref.setInt("cc",
//                                                               AppConstent.cc);
//                                                         });
//                                                       } else {
//                                                         showLongToast(
//                                                             "Please select coor and size");
//                                                       }
//                                                     } else if (widget
//                                                             .plist
//                                                             .productColor!
//                                                             .length >
//                                                         2) {
//                                                       if (_dropDownValue !=
//                                                           null) {
//                                                         addTocardval();
//                                                         GroceryAppConstant
//                                                             .groceryAppCartItemCount++;
//                                                         groceryCartItemCount(
//                                                             GroceryAppConstant
//                                                                 .groceryAppCartItemCount);
//                                                         setState(() {
//                                                           AppConstent.cc++;

//                                                           pref.setInt("cc",
//                                                               AppConstent.cc);
//                                                         });
//                                                         setState(() {});
//                                                       } else {
//                                                         showLongToast(
//                                                             "Please select color");
//                                                       }
//                                                     } else if (widget
//                                                             .plist
//                                                             .productScale!
//                                                             .length >
//                                                         2) {
//                                                       if (_dropDownValue1 !=
//                                                           null) {
//                                                         addTocardval();
//                                                         GroceryAppConstant
//                                                             .groceryAppCartItemCount++;
//                                                         groceryCartItemCount(
//                                                             GroceryAppConstant
//                                                                 .groceryAppCartItemCount);
//                                                         setState(() {
//                                                           AppConstent.cc++;

//                                                           pref.setInt("cc",
//                                                               AppConstent.cc);
//                                                           setState(() {});
//                                                         });
//                                                       } else {
//                                                         showLongToast(
//                                                             "Please select size");
//                                                       }
//                                                     } else {
//                                                       addTocardval();
//                                                       GroceryAppConstant
//                                                           .groceryAppCartItemCount++;
//                                                       groceryCartItemCount(
//                                                           GroceryAppConstant
//                                                               .groceryAppCartItemCount);
//                                                       setState(() {
//                                                         AppConstent.cc++;

//                                                         pref.setInt("cc",
//                                                             AppConstent.cc);
//                                                       });
//                                                       setState(() {});
//                                                     }

// //                                                      if(widget.plist.productColor.length>1 && widget.plist.productScale.length>1 ){
// //                                                        if(_dropDownValue!=null&&_dropDownValue1!=null) {
// ////
// //                                                          _addToproducts(context);
// //                                                          Scaffold.of(context)
// //                                                              .showSnackBar(
// //                                                              SnackBar(
// //                                                                  content: Text(
// //                                                                      " Products  is added to cart "),
// //                                                                  duration: Duration(
// //                                                                      seconds: 1)));
// //                                                          setState(() {
// //                                                            Constant.itemcount++;
// //
// ////                                                  print( Constant.totalAmount);
// //
// //                                                          });
// ////                                                      }
// //                                                        } else{
// //                                                          showLongToast("Please Select color & Size");
// //                                                        }
// //                                                      }
// //                                                      else{
// //
// //                                                        addTocardval();
// ////                                                        _addToproducts(context);
// ////                                                        Scaffold.of(context)
// ////                                                            .showSnackBar(
// ////                                                            SnackBar(
// ////                                                                content: Text(
// ////                                                                    " Products  is added to cart "),
// ////                                                                duration: Duration(
// ////                                                                    seconds: 1)));
// //                                                      }
//                                                   } else {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               SignInPage()),
//                                                     );
//                                                   }
//                                                   setState(() {});

// //                                                    Navigator.push(
// //                                                      context,
// //                                                      MaterialPageRoute(builder: (context) => DeliveryInfo()),
// //                                                    );
//                                                 },
//                                                 child: Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 8,
//                                                         top: 5,
//                                                         bottom: 5,
//                                                         right: 8),
//                                                     child: Center(
//                                                       child: Text(
//                                                         "Add to Bag",
//                                                         style: TextStyle(
//                                                             color:
//                                                                 GroceryAppColors
//                                                                     .white),
//                                                       ),
//                                                     )),
//                                               ),
//                                             )),
//                                         /*wishflag
//                                       ? InkWell(
//                                           onTap: () {
//                                             if (Constant.isLogin) {
//                                               _addToproducts1(context);
//                                               Scaffold.of(context).showSnackBar(
//                                                   SnackBar(content: Text(" Products  is added to wishlist "), duration: Duration(seconds: 1)));
//                                               setState(() {
//                                                 Constant.wishlist++;
//                                                 _countList(Constant.wishlist);

// //                                                  print( Constant.totalAmount);
//                                                 wishflag = false;
//                                               });
//                                             } else {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(builder: (context) => SignInPage()),
//                                               );
//                                             }
//                                           },
//                                           child: Container(
//                                             margin: EdgeInsets.only(left: 3.0),
//                                             height: 33,
//                                             width: 45,
//                                             child: Icon(Icons.favorite_border, size: 30, color: Colors.red),
//                                           ),
//                                         )
//                                       : InkWell(
//                                           onTap: () {
//                                             setState(() {
//                                               dbmanager1.deleteProducts(wishid);
//                                               wishflag = true;
//                                             });
//                                           },
//                                           child: Container(
//                                             margin: EdgeInsets.only(left: 3.0),
//                                             height: 33,
//                                             width: 45,
//                                             child: Icon(Icons.favorite, size: 30, color: AppColors.pink),
//                                           ),
//                                         ),*/
//                                         IconButton(
//                                           onPressed: () {
//                                             setState(() {
//                                               sharableProductName =
//                                                   name.replaceAll(" ", "-");
//                                               sharableProductName =
//                                                   sharableProductName
//                                                       .replaceAll("(", "");
//                                               sharableProductName =
//                                                   sharableProductName
//                                                       .replaceAll(")", "");
//                                               sharableProductId = widget
//                                                   .plist.productIs
//                                                   .toString();
//                                             });
//                                             shareProduct(
//                                                 GroceryAppConstant
//                                                         .Product_Imageurl +
//                                                     widget.plist.img!,
//                                                 widget.plist.productName ?? "",
//                                                 GroceryAppConstant.base_url +
//                                                     "${sharableProductName}_" +
//                                                     sharableProductId);
//                                           },
//                                           icon: Icon(Icons.share),
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ]),
//                         ),
//                         pvarlist.length > 0
//                             ? Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 12.0, top: 18.0),
//                                     child: new Text(
//                                       ' Variant:',
//                                       style: new TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 16.0,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 16.0, top: 8.0),
//                                       child: InkWell(
//                                         onTap: () {
//                                           _displayDialog(context);
//                                           // _showSelectionDialog(context);
//                                         },
//                                         child: Container(
//                                           // width: MediaQuery.of(context).size.width/1.5,
//                                           padding: const EdgeInsets.only(
//                                             left: 10.0,
//                                             top: 0.0,
//                                             right: 10.0,
//                                           ),
//                                           margin: const EdgeInsets.only(
//                                             top: 5.0,
//                                           ),

//                                           child: Center(
//                                               child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                             children: [
//                                               Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: 10, right: 10),
//                                                 child: Text(
//                                                   textval!.length > 20
//                                                       ? textval!.substring(
//                                                               0, 20) +
//                                                           ".."
//                                                       : textval.toString(),

//                                                   overflow: TextOverflow.fade,
//                                                   // maxLines: 2,
//                                                   style: TextStyle(
//                                                     fontSize: 15,
//                                                     color:
//                                                         GroceryAppColors.black,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Padding(
//                                                   padding:
//                                                       EdgeInsets.only(left: 0),
//                                                   child: Icon(
//                                                     Icons.expand_more,
//                                                     color: Colors.black,
//                                                     size: 30,
//                                                   ))
//                                             ],
//                                           )),

//                                           decoration: BoxDecoration(
//                                               border: Border.all(
//                                                   color: Colors.black)),
//                                         ),
//                                       )),

//                                   /*Container(
//                                  color: AppColors.black,
//                                    margin:EdgeInsets.only(left: 10,top: 10,right: 10) ,
//                                    height: 45,
//                                    child: Padding(
//                                      padding: EdgeInsets.only(left: 0,top: 0,right: 0),
//                                      child: TextField(
//                                          minLines: 1,
//                                          maxLines: 3,
//                                          decoration: InputDecoration(
//                                            prefixIcon: Icon(Icons.expand_more),
//                                              hintText: "Select varient",
//                                              border: OutlineInputBorder()
//                                          )),))*/
//                                 ],
//                               )
//                             : Row(),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         InkWell(
//                           onTap: () {
//                             if (showdis) {
//                               setState(() {
//                                 showdis = false;
//                               });
//                             } else {
//                               setState(() {
//                                 showdis = true;
//                               });
//                             }
//                           },
//                           child: Container(
//                             width: MediaQuery.of(context).size.width / 2,
//                             child: Row(
//                               children: <Widget>[
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                     left: 14.0,
//                                   ),
//                                   child: new Text(
//                                     'Product Details:',
//                                     style: new TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                     padding:
//                                         EdgeInsets.only(left: 16.0, top: 8.0),
//                                     child: Icon(
//                                         showdis
//                                             ? Icons.keyboard_arrow_up
//                                             : Icons.keyboard_arrow_down,

// //                                        Icons.keyboard_arrow_down,
//                                         size: 30,
//                                         color: GroceryAppColors.black))
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         showdis
//                             ? Column(
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 16.0, top: 8.0),
//                                     child: Container(
//                                       child: ListView.builder(
//                                           shrinkWrap: true,
//                                           primary: false,
//                                           physics:
//                                               NeverScrollableScrollPhysics(),
//                                           itemCount: amenitiesModel
//                                               .data!.customFieldsValue!.length,
//                                           itemBuilder: (context, index) {
//                                             final name = amenitiesModel
//                                                 .data!
//                                                 .customFieldsValue![index]
//                                                 .fieldsName;
//                                             final value = amenitiesModel
//                                                 .data!
//                                                 .customFieldsValue![index]
//                                                 .fieldValue;
//                                             final key = name!
//                                                 .substring(0, name.indexOf(','))
//                                                 .replaceAll("_", " ");

//                                             print(
//                                                 "amenitiesModel.data.customFieldsValue.length--> ${amenitiesModel.data!.customFieldsValue!.length}");
//                                             return _amenitiesCard(
//                                                 key: key, value: value!);
//                                           }),
//                                     ),
//                                   ),
//                                   discription("Warranty: ",
//                                       widget.plist.warrantys.toString()),

//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: <Widget>[
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 16.0, top: 8.0),
//                                         child: Text(
//                                           "Return: ",
//                                           overflow: TextOverflow.fade,
//                                           style: new TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 16.0, top: 8.0),
//                                         child: Text(
//                                           widget.plist.returns == "0"
//                                               ? "No"
//                                               : widget.plist.returns! + "day",
//                                           overflow: TextOverflow.fade,
//                                           style: new TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 14.0,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
// //                             discription("Return: ",widget.plist.returns),
//                                   discription("Brand: ",
//                                       widget.plist.productVendor.toString()),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: <Widget>[
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 16.0, top: 8.0),
//                                         child: Text(
//                                           "Cancel: ",
//                                           overflow: TextOverflow.fade,
//                                           style: new TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 16.0, top: 8.0),
//                                         child: Text(
//                                           widget.plist.cancels == "0"
//                                               ? "No"
//                                               : widget.plist.cancels! + "day",
//                                           overflow: TextOverflow.fade,
//                                           style: new TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 14.0,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
// //                             discription("Cancel: ",widget.plist.cancels),
// //                             discription("Delivery: ",widget.plist.cancels),
//                                   discription(
//                                       "",
//                                       widget.plist.productDescription
//                                           .toString()),
// //                             Padding(
// //                                padding: const EdgeInsets.only(left:16.0,top: 8.0),
// //                                child:  Text(widget.plist.productDescription,
// //                                  overflow: TextOverflow.fade,
// //                                  style: new TextStyle(
// //                                    color: Colors.black,
// //                                    fontSize: 14.0,
// //                                  ),
// //                                ),
// //                              ),
//                                 ],
//                               )
//                             : Container(),
//                         group == null
//                             ? Container()
//                             : Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   group != null
//                                       ? Padding(
//                                           padding: EdgeInsets.only(
//                                               left: 10.0, top: 8.0),
//                                           child: Text(
//                                             groupname.toString(),
//                                             style: new TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 16.0,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         )
//                                       : Row(),
//                                   Container(
//                                     margin: EdgeInsets.symmetric(vertical: 8.0),
//                                     height: 78.0,
//                                     child: group != null
//                                         ? ListView.builder(
//                                             scrollDirection: Axis.horizontal,
//                                             itemCount: group!.length,
//                                             itemBuilder: (BuildContext context,
//                                                 int index) {
//                                               return group![index].img!.length >
//                                                       2
//                                                   ? Container(
//                                                       width: 70.0,
//                                                       child: Card(
//                                                         shape:
//                                                             RoundedRectangleBorder(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       10.0),
//                                                         ),
//                                                         clipBehavior:
//                                                             Clip.antiAlias,
//                                                         child: InkWell(
//                                                           onTap: () {
// //                                              setState(() {
// //
// //                                                url=imgList1[index];
// //                                                showLongToast("Product is selected ");
// //                                              });
//                                                             Navigator.push(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                   builder: (context) =>
//                                                                       ProductDetails1(
//                                                                           group![index].productIs ??
//                                                                               "")),
//                                                             );
// //
//                                                           },
//                                                           child: Column(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: <Widget>[
//                                                               group![index]
//                                                                           .img!
//                                                                           .length >
//                                                                       2
//                                                                   ? SizedBox(
//                                                                       height:
//                                                                           70,
//                                                                       child: Image
//                                                                           .network(
//                                                                         GroceryAppConstant.Product_Imageurl1 +
//                                                                             group![index].img!,
//                                                                         fit: BoxFit
//                                                                             .fill,
//                                                                       )
//                                                                       /*  CachedNetworkImage(
//                                                     fit: BoxFit.cover,
//                                                     imageUrl:Constant.Product_Imageurl1+group[index].img,
// //                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
//                                                     placeholder: (context, url) =>
//                                                         Center(
//                                                             child:
//                                                             CircularProgressIndicator()),
//                                                     errorWidget:
//                                                         (context, url, error) =>
//                                                     new Icon(Icons.error),

//                                                   ),*/
//                                                                       )
//                                                                   : Container(),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     )
//                                                   : Row();
//                                             })
//                                         : CircularProgressIndicator(),
//                                   ),
//                                 ],
//                               ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Padding(
//                               padding: EdgeInsets.only(
//                                   top: 8.0, left: 14.0, right: 8.0),
//                               child: Text(
//                                 'RELATED PRODUCTS',
//                                 style: TextStyle(
//                                     color: Colors.black45,
//                                     fontSize: 13,
//                                     fontFamily: 'Roboto',
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                   right: 8.0, top: 8.0, left: 5.0),
//                               child: TextButton(
//                                   child: Text('View All',
//                                       style: TextStyle(
//                                           color: GroceryAppColors.white)),
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => Screen2(
//                                               catid!.length > 0
//                                                   ? catid![0]
//                                                   : "0",
//                                               "RELATED PRODUCTS")),
//                                     );
//                                   }),
//                             )
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 20),
//                           child: Container(
//                             margin: EdgeInsets.symmetric(vertical: 8.0),
//                             height: 210.0,
//                             child: topProducts1.length > 0
//                                 ? ListView.builder(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: topProducts1.length,
//                                     itemBuilder:
//                                         (BuildContext context, int index) {
//                                       return Container(
//                                         width: topProducts1[index] != 0
//                                             ? 150.0
//                                             : 230.0,
//                                         decoration: BoxDecoration(
//                                           color: GroceryAppColors.tela,
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                         ),
//                                         margin: EdgeInsets.only(right: 10),
//                                         child: Card(
//                                           child: Column(
//                                             children: <Widget>[
// //                                          shape: RoundedRectangleBorder(
// //                                            borderRadius: BorderRadius.circular(
// //                                                10.0),
// //                                          ),

//                                               InkWell(
//                                                 onTap: () {
//                                                   print(
//                                                       'Navigating to related product: ${topProducts1[index].productName} - ID: ${topProducts1[index].productIs}');
//                                                   print(
//                                                       'Current product ID: ${widget.plist.productIs}');

//                                                   // Additional validation to prevent navigation to same product
//                                                   if (topProducts1[index]
//                                                           .productIs ==
//                                                       widget.plist.productIs) {
//                                                     print(
//                                                         'ERROR: Attempting to navigate to same product! Blocking navigation.');
//                                                     return;
//                                                   }

//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             ProductDetails(
//                                                                 topProducts1[
//                                                                     index],
//                                                                 key: ValueKey(
//                                                                     'product_${topProducts1[index].productIs}'))),
//                                                   );
// //
//                                                 },
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: <Widget>[
//                                                     SizedBox(
//                                                       height: 150,
// //                                            width: 162,

//                                                       child: topProducts1[index]
//                                                                   .img !=
//                                                               null
//                                                           ? Image.network(
//                                                               GroceryAppConstant
//                                                                       .Product_Imageurl +
//                                                                   topProducts1[
//                                                                           index]
//                                                                       .img!,
//                                                               fit: BoxFit.fill,
//                                                             )
//                                                           /*  CachedNetworkImage(
//                                                         fit: BoxFit.cover,
//                                                         imageUrl: Constant
//                                                             .Product_Imageurl +
//                                                             topProducts1[index].img,
// //                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
//                                                         placeholder: (context, url) =>
//                                                             Center(
//                                                                 child:
//                                                                 CircularProgressIndicator()),
//                                                         errorWidget:
//                                                             (context, url, error) =>
//                                                         new Icon(Icons.error),

//                                                       )*/
//                                                           : Image.asset(
//                                                               "assets/images/logo.png"),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),

//                                               Expanded(
//                                                 child: Container(
//                                                   margin: EdgeInsets.only(
//                                                       left: 5,
//                                                       right: 5,
//                                                       top: 5),
//                                                   padding: EdgeInsets.only(
//                                                       left: 3, right: 5),
//                                                   color: GroceryAppColors.white,
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: <Widget>[
//                                                       Text(
//                                                         topProducts1[index]
//                                                             .productName
//                                                             .toString(),
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         maxLines: 1,
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           color:
//                                                               GroceryAppColors
//                                                                   .black,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 8,
//                                                       ),
//                                                       Row(
//                                                         children: [
//                                                           Text(
//                                                             '(\u{20B9} ${topProducts1[index].buyPrice})',
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             maxLines: 2,
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w700,
//                                                                 fontStyle:
//                                                                     FontStyle
//                                                                         .italic,
//                                                                 fontSize: 12,
//                                                                 color:
//                                                                     GroceryAppColors
//                                                                         .black,
//                                                                 decoration:
//                                                                     TextDecoration
//                                                                         .lineThrough),
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     left: 10),
//                                                             child: Text(
//                                                                 '\u{20B9} ${calDiscount(topProducts1[index].buyPrice.toString(), topProducts1[index].discount.toString())}',
//                                                                 style: TextStyle(
//                                                                     color: GroceryAppColors
//                                                                         .green,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w700,
//                                                                     fontSize:
//                                                                         12)),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     })
//                                 : CircularProgressIndicator(),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 7,
//                         ),
//                       ],
//                     ),
//                   ),
//                   childCount: 1, // Only show one product details
//                 ),
//               ),
//             ])),
//       ),
//     );
//   }

// //  discountValue;
// //  String adminper;
// //  String adminpricevalue;
// //  String costPrice;
//   void _addToproducts(BuildContext context) {
//     if (products == null) {
//       print((totalmrp! * _count).toString() + "............");
//       ProductsCart st = new ProductsCart(
//           pid: widget.plist.productIs,
//           pname: widget.plist.productName,
//           pimage: url,
//           pprice: (totalmrp! * _count).toString(),
//           pQuantity: _count,
//           pcolor: _dropDownValue != null ? _dropDownValue : "",
//           psize: _dropDownValue1 != null ? _dropDownValue1 : "",
//           pdiscription: widget.plist.productDescription,
//           sgst: sgst1.toString(),
//           cgst: cgst1.toString(),
//           discount: widget.plist.discount,
//           discountValue: dicountValue.toString(),
//           adminper: widget.plist.msrp,
//           adminpricevalue: admindiscountprice.toString(),
//           costPrice: total.toString(),
//           shipping: widget.plist.shipping,
//           totalQuantity: widget.plist.quantityInStock,
//           varient: textval,
//           mv: int.parse(widget.plist.mv ?? ""));
//       dbmanager
//           .insertStudent(st)
//           .then((id) => {print('Student Added to Db ${id}')});
//     }
//   }

//   void _addToproducts1(BuildContext context) {
//     if (nproducts == null) {
//       WishlistsCart st1 = new WishlistsCart(
//           pid: widget.plist.productIs,
//           pname: widget.plist.productName,
//           pimage: url,
//           pprice: totalmrp.toString(),
//           pQuantity: _count,
//           pcolor: _dropDownValue,
//           psize: _dropDownValue1,
//           pdiscription: widget.plist.productDescription,
//           sgst: sgst1.toString(),
//           cgst: cgst1.toString(),
//           discount: widget.plist.discount,
//           discountValue: dicountValue.toString(),
//           adminper: widget.plist.msrp,
//           adminpricevalue: admindiscountprice.toString(),
//           costPrice: widget.plist.buyPrice);
//       dbmanager1.insertStudent(st1).then((id) => {
//             setState(() {
//               wishid = id;

//               print('Student Added to Db ${wishid}');
//               print(GroceryAppConstant.totalAmount);
//             })
//           });
//     }
//   }

//   _amenitiesCard({String? key, String? value}) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Text(
//           key! + ":",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 15.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(
//           width: 10,
//         ),
//         Flexible(
//           child: Text(
//             value.toString(),
//             softWrap: true,
//             style: _discriptionText(),
//           ),
//         ),
//         SizedBox(
//           width: 10,
//         ),
//       ],
//     );
//   }

//   TextStyle _discriptionText() {
//     return TextStyle(
//       color: Colors.black,
//       fontSize: 14.0,
//     );
//   }

//   String calDiscount(String byprice, String discount2) {
//     String returnStr;
//     double discount = 0.0;
//     returnStr = discount.toString();
//     double byprice1 = double.parse(byprice);
//     double discount1 = double.parse(discount2);

//     discount = (byprice1 - (byprice1 * discount1) / 100.0);

//     returnStr = discount.toStringAsFixed(GroceryAppConstant.val);
//     print(returnStr);
//     return returnStr;
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

//   void addTocardval() {
//     if (int.parse(widget.plist.quantityInStock ?? "") > 0) {
//       _addToproducts(context);

//       showLongToast(" Products  is added to cart ");

//       setState(() {
//         GroceryAppConstant.itemcount++;

// //                                                  print( Constant.totalAmount);
//       });
//     } else {
//       showLongToast("Product is out of stock");
//     }
//   }

//   void showLongToast(String s) {
//     Fluttertoast.showToast(
//       msg: s,
//       toastLength: Toast.LENGTH_LONG,
//     );
//   }

//   Future _countList(int val) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     pref.setInt("wcount", val);
//   }

//   Widget discription(String name, String Discription) {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(left: 16.0, top: 8.0),
//             child: Text(
//               name,
//               overflow: TextOverflow.fade,
//               style: new TextStyle(
//                 color: Colors.black,
//                 fontSize: 15.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16.0, top: 8.0),
//               child: Text(
//                 Discription,
//                 overflow: TextOverflow.fade,
//                 style: new TextStyle(
//                   color: Colors.black,
//                   fontSize: 14.0,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
