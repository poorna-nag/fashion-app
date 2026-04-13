import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:royalmart/constent/app_constent.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/grocery/BottomNavigation/wishlist.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/grocery/dbhelper/database_helper.dart';
import 'package:royalmart/grocery/dbhelper/wishlistdart.dart';
import 'package:royalmart/grocery/model/Gallerymodel.dart';
import 'package:royalmart/grocery/model/GroupProducts.dart';
import 'package:royalmart/grocery/model/Varient.dart';
import 'package:royalmart/grocery/model/aminities_model.dart';
import 'package:royalmart/grocery/model/productmodel.dart';
import 'package:royalmart/grocery/screen/Zoomimage.dart';
import 'package:royalmart/grocery/screen/detailpage1.dart';
import 'package:royalmart/grocery/screen/secondtabview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorProductDetails extends StatefulWidget {
  final Products plist;
  final String mvId;

  const VendorProductDetails(this.plist, this.mvId, {Key? key})
      : super(key: key);

  @override
  VendorProductDetailsState createState() => VendorProductDetailsState();
}

class VendorProductDetailsState extends State<VendorProductDetails> {
  List<PVariant> pvarlist = [];
  AmenitiesModel amenitiesModel = AmenitiesModel();

  String name = "";
  bool _isNavigating = false; // Add flag to prevent multiple navigations
  ScrollController _scrollController =
      ScrollController(); // Add scroll controller

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Select Variant'),
            content: Container(
              width: double.maxFinite,
              height: pvarlist.length * 50.0,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: pvarlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: pvarlist[index] != 0 ? 130.0 : 230.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            total = int.parse(pvarlist[index].price ?? "");
                            String mrp_price = calDiscount(
                                pvarlist[index].price ?? "",
                                pvarlist[index].discount ?? "");
                            totalmrp = double.parse(mrp_price);
                            textval = pvarlist[index].variant ?? "";
                            name = pvarlist[index].variant ?? "";
                            Navigator.pop(context);
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                pvarlist[index].variant ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: GroceryAppColors.black,
                                ),
                              ),
                            ),
                            Divider(
                              color: GroceryAppColors.black,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  int _current = 0;
  bool flag = true;
  int? wishid;
  bool wishflag = true;
  String url = "";
  String textval = "Select varient";

  // List<Products> products1 = List();
  List<Products> topProducts1 = [];

  final List<String> imgList1 = <String>[];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int _count = 1;
  String? _dropDownValue;
  String? _dropDownValue1, groupname = "";
  int? total;
  int? actualprice = 200;
  double? mrp, totalmrp;
  double? sgst1, cgst1, dicountValue, admindiscountprice;
  int cc = 0;
  List<Gallery>? galiryImage1 = [];
  List<GroupProducts>? group = [];
  List<Products> productdetails = [];
  List<String>? size;
  List<String>? color;
  List<String>? catid = <String>[];
  ProductsCart? products;
  WishlistsCart? nproducts;
  final DbProductManager dbmanager = new DbProductManager();
  final DbProductManager1 dbmanager1 = new DbProductManager1();
  String sharableProductName = "";
  String sharableProductId = "";

//  DatabaseHelper helper = DatabaseHelper();
//  Note note ;

  void gatinfoCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    GroceryAppConstant.isLogin = false;
    int? Count = pref.getInt("itemCount");
    bool? ligin = pref.getBool("isLogin");
    setState(() {
      if (ligin != null) {
        GroceryAppConstant.isLogin = ligin;
      }
      if (Count == null) {
        GroceryAppConstant.groceryAppCartItemCount = 0;
      } else {
        GroceryAppConstant.groceryAppCartItemCount = Count;
      }
      print(
          GroceryAppConstant.groceryAppCartItemCount.toString() + "itemCount");
    });
  }

  void getcartCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? cCount = pref.getInt("cc");
    setState(() {
      // log("cart get count------------------->>$cCount");
      if (cCount == 0 || cCount! < 0) {
        cc = 0;
        AppConstent.cc = 0;
        // log(" AppConstent.cc------------------->>${AppConstent.cc}");
      } else {
        setState(() {
          cc = cCount;
          AppConstent.cc = cCount;
        });
      }
      // log("cart count------------------->>$cc");
    });
  }

  static List<WishlistsCart>? prodctlist1;

  // final DbProductManager1 dbmanager12 = new DbProductManager1();

  @override
  void initState() {
    getcartCount();
    super.initState();
    name = widget.plist.productName ?? "";
    gatinfoCount();
    print(' product id ${widget.plist.productIs}');

    getPvarient(widget.plist.productIs ?? "").then((usersFromServe) {
      if (mounted) {
        // Add mounted check
        setState(() {
          pvarlist = usersFromServe!;
        });
      }
    });
    getAmenities();

    dbmanager1.getProductList3().then((usersFromServe) {
      if (mounted) {
        // Add mounted check
        setState(() {
          prodctlist1 = usersFromServe;
          for (var i = 0; i < prodctlist1!.length; i++) {
            if (prodctlist1![i].pid == widget.plist.productIs) {
              wishid = prodctlist1![i].id;
              wishflag = false;
            }
          }
        });
      }
    });

    catid = widget.plist.productLine!.split(',');
    size = widget.plist.productScale!.split(',');
    color = widget.plist.productColor!.split(',');

    DatabaseHelper.getImage(widget.plist.productIs ?? "")
        .then((usersFromServe) {
      if (mounted) {
        // Add mounted check
        setState(() {
          galiryImage1 = usersFromServe;
          imgList1.clear();
          for (var i = 0; i < galiryImage1!.length; i++) {
            imgList1.add(galiryImage1![i].img!);
          }
        });
      }
    });

    GroupPro(widget.plist.productIs ?? "").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          group = usersFromServe!.cast<GroupProducts>();
          print(group != null);
          if (group != null) {
            groupname = group![0].name;
          }
          print(group.toString() + "group info");
        });
      }
    });
    getTServicebymv_id(widget.mvId, "", "").then((usersFromServe) {
      if (mounted) {
        // Add mounted check
        setState(() {
          // Filter out the current product and remove duplicates to prevent infinite loops
          final currentProductId = widget.plist.productIs;
          final Set<String> seenProductIds = <String>{};

          topProducts1 = usersFromServe!.where((product) {
            // Skip if it's the current product
            if (product.productIs == currentProductId) {
              return false;
            }

            // Skip if we've already seen this product (remove duplicates)
            if (seenProductIds.contains(product.productIs)) {
              return false;
            }

            seenProductIds.add(product.productIs ?? "");
            return true;
          }).toList();

          print("Current product ID: $currentProductId");
          print("Filtered related products count: ${topProducts1.length}");
          print(
              "Related product IDs: ${topProducts1.map((p) => p.productIs).toList()}");
        });
      }
    });

    setState(() {
      actualprice = int.parse(widget.plist.buyPrice ?? "");
      total = actualprice;
      url = widget.plist.img!;
      String mrp_price =
          calDiscount(widget.plist.buyPrice ?? "", widget.plist.discount ?? "");
      totalmrp = double.parse(mrp_price);

      dicountValue = double.parse(widget.plist.buyPrice ?? "") - totalmrp!;
      String gst_sgst = calGst(totalmrp.toString(), widget.plist.sgst ?? "");
      String gst_cgst = calGst(totalmrp.toString(), widget.plist.cgst ?? "");

      sgst1 = double.parse(gst_sgst);
      cgst1 = double.parse(gst_cgst);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose scroll controller
    super.dispose();
  }

  bool showdis = false;

  Future<void> getAmenities() async {
    await DatabaseHelper.getAmenities(widget.plist.productIs ?? "")
        .then((value) {
      amenitiesModel = value!;
    });
  }

  shareProduct(String url, String title, String price) async {
    Share.share("Hi, Order Best Products From " +
        GroceryAppConstant.appname +
        " app. Click on this link  $price");
    // await Share.("my text title", "${price}", "text/plain");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.tela1,
      appBar: AppBar(
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                GroceryAppColors.tela,
                GroceryAppColors.tela.withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: Text(
          "Product Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
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
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            )),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishList()),
              );
            },
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 40, top: 17),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, bottom: 18),
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.shade500,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text('${cc}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),

      body: Container(
        child: SafeArea(
            top: false,
            left: false,
            right: false,
            child: CustomScrollView(
                controller: _scrollController, // Add scroll controller
                physics: ClampingScrollPhysics(), // Add proper physics
                slivers: <Widget>[
                  SliverList(
                    // Use a delegate to build items as they're scrolled on screen.
                    delegate: SliverChildBuilderDelegate(
                      // The builder function returns a ListTile with a title that
                      // displays the index of the current item.
                      (context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          imgList1.length > 0
                              ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 3,
                                        blurRadius: 10,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: 300,
                                      child: PageView.builder(
                                        itemCount: imgList1.length,
                                        onPageChanged: (index) {
                                          setState(() {
                                            _current = index;
                                          });
                                        },
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ZoomImage(imgList1)),
                                              );
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.white,
                                                    Colors.grey.shade50,
                                                  ],
                                                ),
                                              ),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.contain,
                                                imageUrl: GroceryAppConstant
                                                        .Product_Imageurl2 +
                                                    imgList1[index],
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            GroceryAppColors
                                                                .tela),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  color: Colors.grey.shade100,
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    size: 50,
                                                    color: Colors.grey.shade400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 300,
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_not_supported,
                                          size: 80,
                                          color: Colors.grey.shade400,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Loading Images...',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          // Modern image indicators
                          imgList1.length > 1
                              ? Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: imgList1.map<Widget>((url) {
                                      int index = imgList1.indexOf(url);
                                      return Container(
                                        width: _current == index ? 25.0 : 8.0,
                                        height: 8.0,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          color: _current == index
                                              ? GroceryAppColors.tela
                                              : Colors.grey.shade300,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : SizedBox(height: 10),

                          // Modern product info container
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name.isNotEmpty
                                      ? name
                                      : "Product Name Loading...",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    height: 1.3,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 15),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 8,
                                  children: <Widget>[
                                    // Original price with strikethrough
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '\u{20B9} $total',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.red.shade600,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ),
                                    // Sale price
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.green.shade500,
                                            Colors.green.shade600
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.green.withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '\u{20B9} ${(totalmrp! * _count).toStringAsFixed(GroceryAppConstant.val)}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Modern variant selection container
                          widget.plist.productColor!.length < 2 &&
                                  widget.plist.productScale!.length < 2
                              ? SizedBox(height: 10)
                              : Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Select Variants',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          widget.plist.productColor!.length < 2
                                              ? Container()
                                              : Expanded(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    child:
                                                        DropdownButton<String>(
                                                      value: _dropDownValue,
                                                      hint: Text('Select Color',
                                                          style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade600)),
                                                      isExpanded: true,
                                                      underline: Container(),
                                                      icon: Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          color:
                                                              GroceryAppColors
                                                                  .tela),
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 16),
                                                      items: color!.map((val) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: val,
                                                          child: Text(val),
                                                        );
                                                      }).toList(),
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _dropDownValue = val;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                          widget.plist.productColor!.length <
                                                      2 ||
                                                  widget.plist.productScale!
                                                          .length <
                                                      2
                                              ? Container()
                                              : SizedBox(width: 15),
                                          widget.plist.productScale!.length < 2
                                              ? Container()
                                              : Expanded(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    child:
                                                        DropdownButton<String>(
                                                      value: _dropDownValue1,
                                                      hint: Text('Select Size',
                                                          style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade600)),
                                                      isExpanded: true,
                                                      underline: Container(),
                                                      icon: Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          color:
                                                              GroceryAppColors
                                                                  .tela),
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 16),
                                                      items: size!.map((val) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: val,
                                                          child: Text(val),
                                                        );
                                                      }).toList(),
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _dropDownValue1 = val;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                          // Enhanced quantity and action buttons container
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Quantity selector
                                Text(
                                  'Quantity',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(25),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          onTap: () {
                                            if (_count > 1) {
                                              setState(() {
                                                _count--;
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            child: Icon(
                                              Icons.remove,
                                              color: _count > 1
                                                  ? GroceryAppColors.tela
                                                  : Colors.grey,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        child: Center(
                                          child: Text(
                                            '$_count',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          onTap: () {
                                            if (_count <
                                                int.parse(widget.plist
                                                        .quantityInStock ??
                                                    "1")) {
                                              setState(() {
                                                _count++;
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Only ${widget.plist.quantityInStock} products in stock'),
                                                  duration:
                                                      Duration(seconds: 1),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            child: Icon(
                                              Icons.add,
                                              color: GroceryAppColors.tela,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Action buttons container
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  // Add to Cart button
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              GroceryAppColors.tela,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () async {
                                          SharedPreferences pref =
                                              await SharedPreferences
                                                  .getInstance();
                                          if (GroceryAppConstant.isLogin) {
                                            if (widget.plist.productColor!
                                                        .length >
                                                    2 &&
                                                widget.plist.productScale!
                                                        .length >
                                                    2) {
                                              if (_dropDownValue != null &&
                                                  _dropDownValue1 != null) {
                                                addTocardval();
                                                GroceryAppConstant
                                                    .groceryAppCartItemCount++;
                                                groceryCartItemCount(
                                                    GroceryAppConstant
                                                        .groceryAppCartItemCount);
                                                setState(() {
                                                  AppConstent.cc++;
                                                  pref.setInt(
                                                      "cc", AppConstent.cc);
                                                });
                                              } else {
                                                showLongToast(
                                                    "Please select color and size");
                                              }
                                            } else if (widget.plist
                                                    .productColor!.length >
                                                2) {
                                              if (_dropDownValue != null) {
                                                addTocardval();
                                                GroceryAppConstant
                                                    .groceryAppCartItemCount++;
                                                groceryCartItemCount(
                                                    GroceryAppConstant
                                                        .groceryAppCartItemCount);
                                                setState(() {
                                                  AppConstent.cc++;
                                                  pref.setInt(
                                                      "cc", AppConstent.cc);
                                                });
                                              } else {
                                                showLongToast(
                                                    "Please select color");
                                              }
                                            } else if (widget.plist
                                                    .productScale!.length >
                                                2) {
                                              if (_dropDownValue1 != null) {
                                                addTocardval();
                                                GroceryAppConstant
                                                    .groceryAppCartItemCount++;
                                                groceryCartItemCount(
                                                    GroceryAppConstant
                                                        .groceryAppCartItemCount);
                                                setState(() {
                                                  AppConstent.cc++;
                                                  pref.setInt(
                                                      "cc", AppConstent.cc);
                                                });
                                              } else {
                                                showLongToast(
                                                    "Please select size");
                                              }
                                            } else {
                                              addTocardval();
                                              GroceryAppConstant
                                                  .groceryAppCartItemCount++;
                                              groceryCartItemCount(
                                                  GroceryAppConstant
                                                      .groceryAppCartItemCount);
                                              setState(() {
                                                AppConstent.cc++;
                                                pref.setInt(
                                                    "cc", AppConstent.cc);
                                              });
                                            }
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignInPage()),
                                            );
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.shopping_bag_outlined,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "Add to Bag",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  // Share button
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.blue.shade200),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          setState(() {
                                            sharableProductName =
                                                name.replaceAll(" ", "-");
                                            sharableProductName =
                                                sharableProductName.replaceAll(
                                                    "(", "");
                                            sharableProductName =
                                                sharableProductName.replaceAll(
                                                    ")", "");
                                            sharableProductId = widget
                                                .plist.productIs
                                                .toString();
                                          });
                                          shareProduct(
                                              GroceryAppConstant
                                                      .Product_Imageurl +
                                                  widget.plist.img!,
                                              widget.plist.productName ?? "",
                                              GroceryAppConstant.base_url +
                                                  "${sharableProductName}_" +
                                                  sharableProductId);
                                        },
                                        child: Icon(
                                          Icons.share_outlined,
                                          color: Colors.blue.shade600,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          pvarlist.length > 0
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, top: 18.0),
                                      child: Text(
                                        'Product Variants',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, top: 8.0),
                                        child: InkWell(
                                          onTap: () {
                                            _displayDialog(context);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 14),
                                            margin: const EdgeInsets.only(
                                              top: 5.0,
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: GroceryAppColors.tela
                                                        .withOpacity(0.3),
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.grey.shade50),
                                            child: Center(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: Text(
                                                    textval.length > 20
                                                        ? textval.substring(
                                                                0, 20) +
                                                            ".."
                                                        : textval,

                                                    overflow: TextOverflow.fade,
                                                    // maxLines: 2,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: GroceryAppColors
                                                          .black,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0),
                                                    child: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_rounded,
                                                      color:
                                                          GroceryAppColors.tela,
                                                      size: 24,
                                                    ))
                                              ],
                                            )),
                                          ),
                                        )),

                                    /*Container(
                                 color: AppColors.black,
                                   margin:EdgeInsets.only(left: 10,top: 10,right: 10) ,
                                   height: 45,
                                   child: Padding(
                                     padding: EdgeInsets.only(left: 0,top: 0,right: 0),
                                     child: TextField(
                                         minLines: 1,
                                         maxLines: 3,
                                         decoration: InputDecoration(
                                           prefixIcon: Icon(Icons.expand_more),
                                             hintText: "Select varient",
                                             border: OutlineInputBorder()
                                         )),))*/
                                  ],
                                )
                              : Row(),
                          SizedBox(
                            height: 20,
                          ),
                          // Modern Description Section
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      showdis = !showdis;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Product Details',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          showdis
                                              ? Icons.keyboard_arrow_up_rounded
                                              : Icons
                                                  .keyboard_arrow_down_rounded,
                                          color: GroceryAppColors.tela,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          showdis
                              ? Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, top: 8.0),
                                      child: Container(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            primary: false,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: amenitiesModel.data!
                                                .customFieldsValue!.length,
                                            itemBuilder: (context, index) {
                                              final name = amenitiesModel
                                                  .data!
                                                  .customFieldsValue![index]
                                                  .fieldsName;
                                              final value = amenitiesModel
                                                  .data!
                                                  .customFieldsValue![index]
                                                  .fieldValue;
                                              final key = name!
                                                  .substring(
                                                      0, name.indexOf(','))
                                                  .replaceAll("_", " ");

                                              print(
                                                  "amenitiesModel.data.customFieldsValue.length--> ${amenitiesModel.data!.customFieldsValue!.length}");
                                              return _amenitiesCard(
                                                  key: key, value: value!);
                                            }),
                                      ),
                                    ),
                                    discription("Warranty: ",
                                        widget.plist.warrantys ?? ""),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, top: 8.0),
                                          child: Text(
                                            "Return: ",
                                            overflow: TextOverflow.fade,
                                            style: new TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, top: 8.0),
                                          child: Text(
                                            widget.plist.returns == "0"
                                                ? "No"
                                                : widget.plist.returns! + "day",
                                            overflow: TextOverflow.fade,
                                            style: new TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
//                             discription("Return: ",widget.plist.returns),
                                    discription("Brand: ",
                                        widget.plist.productVendor ?? ""),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, top: 8.0),
                                          child: Text(
                                            "Cancel: ",
                                            overflow: TextOverflow.fade,
                                            style: new TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, top: 8.0),
                                          child: Text(
                                            widget.plist.cancels == "0"
                                                ? "No"
                                                : widget.plist.cancels! + "day",
                                            overflow: TextOverflow.fade,
                                            style: new TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
//                             discription("Cancel: ",widget.plist.cancels),
//                             discription("Delivery: ",widget.plist.cancels),
                                    discription("",
                                        widget.plist.productDescription ?? ""),
//                             Padding(
//                                padding: const EdgeInsets.only(left:16.0,top: 8.0),
//                                child:  Text(widget.plist.productDescription,
//                                  overflow: TextOverflow.fade,
//                                  style: new TextStyle(
//                                    color: Colors.black,
//                                    fontSize: 14.0,
//                                  ),
//                                ),
//                              ),
                                  ],
                                )
                              : Container(),
                          group == null
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    group != null
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0, top: 8.0),
                                            child: Text(
                                              groupname ?? "",
                                              style: new TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        : Row(),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      height: 78.0,
                                      child: group != null
                                          ? ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: group!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return group![index]
                                                            .img!
                                                            .length >
                                                        2
                                                    ? Container(
                                                        width: 70.0,
                                                        child: Card(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          child: InkWell(
                                                            onTap: () async {
                                                              // Prevent navigation to the same product to avoid potential loops
                                                              if (_isNavigating)
                                                                return; // Prevent multiple rapid taps

                                                              if (group![index]
                                                                      .productIs !=
                                                                  widget.plist
                                                                      .productIs) {
                                                                setState(() =>
                                                                    _isNavigating =
                                                                        true);
                                                                await Navigator
                                                                    .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ProductDetails1(group![index].productIs ??
                                                                              "")),
                                                                );
                                                                if (mounted)
                                                                  setState(() =>
                                                                      _isNavigating =
                                                                          false);
                                                              } else {
                                                                // Show a message that this is the current product
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        'This is the current product'),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            1),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .orange,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                group![index]
                                                                            .img!
                                                                            .length >
                                                                        2
                                                                    ? SizedBox(
                                                                        height:
                                                                            70,
                                                                        child: Image
                                                                            .network(
                                                                          GroceryAppConstant.Product_Imageurl1 +
                                                                              group![index].img!,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        )
                                                                        /*  CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl:Constant.Product_Imageurl1+group[index].img,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                                    placeholder: (context, url) =>
                                                        Center(
                                                            child:
                                                            CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                    new Icon(Icons.error),

                                                  ),*/
                                                                        )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Row();
                                              })
                                          : CircularProgressIndicator(),
                                    ),
                                  ],
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Text(
                                  'Related Products',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: GroceryAppColors.tela,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text('View All',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Screen2(
                                                catid!.length > 0
                                                    ? catid![0]
                                                    : "0",
                                                "RELATED PRODUCTS")),
                                      );
                                    }),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              height: 210.0,
                              child: topProducts1.isNotEmpty
                                  ? ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: topProducts1.length,
                                      physics:
                                          ClampingScrollPhysics(), // Add proper physics
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        // Add bounds checking
                                        if (index >= topProducts1.length)
                                          return SizedBox.shrink();

                                        // Double-check: Skip if this is somehow the current product
                                        if (topProducts1[index].productIs ==
                                            widget.plist.productIs) {
                                          print(
                                              "WARNING: Current product found in related products at index $index");
                                          return SizedBox.shrink();
                                        }

                                        return Container(
                                          width:
                                              150.0, // Fixed width for consistency
                                          decoration: BoxDecoration(
                                            color: GroceryAppColors.tela,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          margin: EdgeInsets.only(right: 10),
                                          child: Card(
                                            child: Column(
                                              children: <Widget>[
//                                          shape: RoundedRectangleBorder(
//                                            borderRadius: BorderRadius.circular(
//                                                10.0),
//                                          ),

                                                InkWell(
                                                  onTap: () async {
                                                    // Prevent navigation to the same product to avoid infinite loop
                                                    if (_isNavigating) {
                                                      print(
                                                          "Navigation already in progress, ignoring tap");
                                                      return;
                                                    }

                                                    // Triple check: ensure this is not the current product
                                                    final targetProductId =
                                                        topProducts1[index]
                                                            .productIs;
                                                    final currentProductId =
                                                        widget.plist.productIs;

                                                    print(
                                                        "Navigation attempt - Target: $targetProductId, Current: $currentProductId");

                                                    if (targetProductId ==
                                                        currentProductId) {
                                                      print(
                                                          "ERROR: Attempted navigation to same product blocked!");
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'This is the current product'),
                                                          duration: Duration(
                                                              seconds: 1),
                                                          backgroundColor:
                                                              Colors.orange,
                                                        ),
                                                      );
                                                      return;
                                                    }

                                                    // Set navigation flag
                                                    setState(() =>
                                                        _isNavigating = true);

                                                    try {
                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                VendorProductDetails(
                                                                    topProducts1[
                                                                        index],
                                                                    widget.mvId,
                                                                    key: ValueKey(
                                                                        'vendor_product_${topProducts1[index].productIs}'))),
                                                      );
                                                    } catch (e) {
                                                      print(
                                                          "Navigation error: $e");
                                                    } finally {
                                                      // Always reset navigation flag
                                                      if (mounted) {
                                                        setState(() =>
                                                            _isNavigating =
                                                                false);
                                                      }
                                                    }
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 150,
//                                            width: 162,

                                                        child: topProducts1[
                                                                        index]
                                                                    .img !=
                                                                null
                                                            ? Image.network(
                                                                GroceryAppConstant
                                                                        .Product_Imageurl +
                                                                    topProducts1[
                                                                            index]
                                                                        .img!,
                                                                fit:
                                                                    BoxFit.fill,
                                                              )
                                                            /*  CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: Constant
                                                            .Product_Imageurl +
                                                            topProducts1[index].img,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                                        placeholder: (context, url) =>
                                                            Center(
                                                                child:
                                                                CircularProgressIndicator()),
                                                        errorWidget:
                                                            (context, url, error) =>
                                                        new Icon(Icons.error),

                                                      )*/
                                                            : Image.asset(
                                                                "assets/images/logo.png"),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5,
                                                        right: 5,
                                                        top: 5),
                                                    padding: EdgeInsets.only(
                                                        left: 3, right: 5),
                                                    color:
                                                        GroceryAppColors.white,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          topProducts1[index]
                                                                  .productName ??
                                                              "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                GroceryAppColors
                                                                    .black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '(\u{20B9} ${topProducts1[index].buyPrice})',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  fontSize: 12,
                                                                  color:
                                                                      GroceryAppColors
                                                                          .black,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  '\u{20B9} ${calDiscount(topProducts1[index].buyPrice ?? "", topProducts1[index].discount ?? "")}',
                                                                  style: TextStyle(
                                                                      color: GroceryAppColors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          12)),
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
                                      })
                                  : Center(
                                      child: Text(
                                        'No related products available',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                        ],
                      ),
                      childCount:
                          1, // Add fixed childCount to prevent infinite builds
                    ),
                  ),
                ])),
      ),
    );
  }

//  discountValue;
//  String adminper;
//  String adminpricevalue;
//  String costPrice;
  void _addToproducts(BuildContext context) {
    if (products == null) {
      print((totalmrp! * _count).toString() + "............");
      ProductsCart st = new ProductsCart(
          pid: widget.plist.productIs,
          pname: widget.plist.productName,
          pimage: url,
          pprice: (totalmrp! * _count).toString(),
          pQuantity: _count,
          pcolor: _dropDownValue != null ? _dropDownValue : "",
          psize: _dropDownValue1 != null ? _dropDownValue1 : "",
          pdiscription: widget.plist.productDescription,
          sgst: sgst1.toString(),
          cgst: cgst1.toString(),
          discount: widget.plist.discount,
          discountValue: dicountValue.toString(),
          adminper: widget.plist.msrp,
          adminpricevalue: admindiscountprice.toString(),
          costPrice: total.toString(),
          shipping: widget.plist.shipping,
          totalQuantity: widget.plist.quantityInStock,
          varient: textval,
          mv: int.parse(widget.plist.mv ?? ""));
      dbmanager
          .insertStudent(st)
          .then((id) => {print('Student Added to Db ${id}')});
    }
  }

  _amenitiesCard({String? key, String? value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          key ?? "" + ":",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            value ?? "",
            softWrap: true,
            style: _discriptionText(),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  TextStyle _discriptionText() {
    return TextStyle(
      color: Colors.black,
      fontSize: 14.0,
    );
  }

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

  void addTocardval() {
    if (int.parse(widget.plist.quantityInStock ?? "") > 0) {
      _addToproducts(context);

      showLongToast(" Products  is added to cart ");

      setState(() {
        GroceryAppConstant.itemcount++;

//                                                  print( Constant.totalAmount);
      });
    } else {
      showLongToast("Product is out of stock");
    }
  }

  void showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Widget discription(String name, String Discription) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              name,
              overflow: TextOverflow.fade,
              style: new TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Text(
                Discription,
                overflow: TextOverflow.fade,
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
