import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/grocery/BottomNavigation/wishlist.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/grocery/dbhelper/database_helper.dart';
import 'package:royalmart/grocery/dbhelper/wishlistdart.dart';
import 'package:royalmart/grocery/model/Gallerymodel.dart';
import 'package:royalmart/grocery/model/GroupProducts.dart';
import 'package:royalmart/grocery/model/Varient.dart';
import 'package:royalmart/grocery/model/productmodel.dart';
import 'package:royalmart/grocery/screen/Zoomimage.dart';
import 'package:royalmart/grocery/screen/detailpage1.dart';
import 'package:royalmart/grocery/screen/secondtabview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  final Products plist;

  const ProductDetails(this.plist, {Key? key}) : super(key: key);

  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  List<PVariant> pvarlist = [];
  String name = "";
  String textval = "Select varient";
  String sharableProductName = "";
  String sharableProductId = "";
  _displayDialog(BuildContext context, int position) async {
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
                            // imgList1[position].

                            Navigator.pop(context);
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                pvarlist[index].variant.toString(),
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

  int? _current = 0;
  bool? flag = true;
  bool? wishflag = true;
  int? wishid;
  String? url;
  List<Products> products1 = [];
  List<String> catid = <String>[];

  final List<String> imgList1 = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  ];
  List<GroupProducts>? group = [];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int _count = 1;
  String? _dropDownValue, groupname = "";
  String? _dropDownValue1;
  int? total;
  int? actualprice = 200;
  double? mrp, totalmrp;
  double? sgst1, cgst1, dicountValue, admindiscountprice;
  List<String>? size;
  List<String>? color;

  List<Gallery> galiryImage1 = [];
  List<Products> productdetails = [];
  ProductsCart? products;
  Products? prod;
  final DbProductManager dbmanager = new DbProductManager();

//  DatabaseHelper helper = DatabaseHelper();
//  Note note ;

  void gatinfoCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    int? Count = pref.getInt("itemCount");
    bool? ligin = pref.getBool("isLogin");

    setState(() {
      GroceryAppConstant.isLogin = ligin!;

      if (Count == null) {
        GroceryAppConstant.groceryAppCartItemCount = 0;
      } else {
        GroceryAppConstant.groceryAppCartItemCount = Count;
      }
//      print(Constant.carditemCount.toString()+"itemCount");
    });
  }

  String? id;
  @override
  void initState() {
    super.initState();

    gatinfoCount();
    productdetail(widget.plist.productIs ?? "").then((usersFromServe) {
      setState(() {
        productdetails = usersFromServe!;
        if (productdetails.length > 0) {
          setState(() {
            url = productdetails[0].img;
            id = productdetails[0].productIs;
            actualprice = int.parse(productdetails[0].buyPrice ?? "");
            total = actualprice;

            String mrp_price = calDiscount(productdetails[0].buyPrice ?? "",
                productdetails[0].discount ?? "");
            totalmrp = double.parse(mrp_price);

            String adiscount = calDiscount(
                productdetails[0].buyPrice ?? "", productdetails[0].msrp ?? "");
            admindiscountprice =
                (double.parse(productdetails[0].buyPrice ?? "") -
                    double.parse(adiscount));
            dicountValue =
                double.parse(productdetails[0].buyPrice ?? "") - totalmrp!;
            String gst_sgst =
                calGst(totalmrp.toString(), productdetails[0].sgst ?? "");
            String gst_cgst =
                calGst(totalmrp.toString(), productdetails[0].cgst ?? "");
            color = productdetails[0].productColor!.split(',');
            size = productdetails[0].productScale!.split(',');

            sgst1 = double.parse(gst_sgst);
            cgst1 = double.parse(gst_cgst);
            print(productdetails[0].productLine! + "product id");
            catid = productdetails[0].productLine!.split(',');
            DatabaseHelper.getProductsByCategory(
                    catid.length > 0 ? catid[0] : "0", "10")
                .then((usersFromServe) {
              setState(() {
                products1 = usersFromServe ?? [];
              });
            });

            GroupPro(productdetails[0].productIs ?? "").then((usersFromServe) {
              setState(() {
                group = usersFromServe!.cast<GroupProducts>();
                group != null ? groupname = group![0].name : groupname = "";
              });
            });

            dbmanager1.getProductList3().then((usersFromServe) {
              setState(() {
                prodctlist1 = usersFromServe;
                for (var i = 0; i < prodctlist1!.length; i++) {
                  if (prodctlist1![i].pid == id) {
                    wishflag = false;
                    wishid = prodctlist1![i].id;
                    break;
                  }
                }
              });
            });
          });
        }
      });
    });
    DatabaseHelper.getImage(widget.plist.productIs ?? "")
        .then((usersFromServe) {
      setState(() {
        galiryImage1 = usersFromServe!;
        imgList1.clear();
        for (var i = 0; i < galiryImage1.length; i++) {
          imgList1.add(galiryImage1[i].img!);
        }
      });
    });

    getPvarient(widget.plist.productIs ?? "").then((usersFromServe) {
      setState(() {
        pvarlist = usersFromServe!;
      });
    });
  }

  bool showdis = false;

  static List<WishlistsCart>? prodctlist1;
  shareProduct(String url, String title, String price) async {
    Share.share("Hi, Order Best Products From " +
        GroceryAppConstant.appname +
        " app. Click on this link  $price");
    // await Share.("my text title", "${price}", "text/plain");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE91E63),
                Color(0xFFE91E63).withOpacity(0.8),
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
                Icons.arrow_back_ios,
                size: 22,
                color: Colors.white,
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
                      child:
                          Text('${GroceryAppConstant.groceryAppCartItemCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFF8F9FA),
      body: Container(
        child: SafeArea(
            top: false,
            left: false,
            right: false,
            child: CustomScrollView(slivers: <Widget>[
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
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xFFE91E63),
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
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
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                      // Image indicators
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: _current == index
                                          ? Color(0xFFE91E63)
                                          : Colors.grey.shade300,
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : SizedBox(height: 10),
                      // Product name with enhanced styling
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                                  : productdetails.isNotEmpty
                                      ? productdetails[0].productName ??
                                          "Product Name"
                                      : "Product Name",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
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
                                    '\u{20B9} ${total ?? 0}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.red.shade600,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
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
                                        color: Colors.green.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '\u{20B9} ${totalmrp != null ? (totalmrp! * _count).toStringAsFixed(GroceryAppConstant.val) : "0"}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                // Discount badge
                                if (total != null &&
                                    totalmrp != null &&
                                    total! > totalmrp!)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.orange.shade300),
                                    ),
                                    child: Text(
                                      '${((total! - totalmrp!) / total! * 100).toStringAsFixed(0)}% OFF',
                                      style: TextStyle(
                                        color: Colors.orange.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: productdetail(widget.plist.productIs ?? ""),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                shrinkWrap: true,
                                primary: false,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  Products item = snapshot.data![index];
                                  return Container(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: map<Widget>(imgList1,
                                              (index, url) {
                                            return Container(
                                              width: 25.0,
                                              height: 0.0,
                                              child: Container(),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 4.0,
                                                  vertical: 7.0),
//                                decoration: BoxDecoration(
//                                  shape: BoxShape.rectangle,
//                                  color: _current == index ? Colors.orange : Colors.grey,
//                                ),
                                            );
                                          }),
                                        ),

//                          productName1(),

                                        // Enhanced variant selection container
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
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
                                              if (item.productColor!.length >
                                                      2 ||
                                                  item.productScale!.length > 2)
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
                                                  // Color selection
                                                  if (item.productColor!
                                                          .length >
                                                      2)
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Color',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors.grey
                                                                  .shade700,
                                                            ),
                                                          ),
                                                          SizedBox(height: 8),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey.shade50,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              border:
                                                                  Border.all(
                                                                color: _dropDownValue !=
                                                                        null
                                                                    ? GroceryAppColors
                                                                        .tela
                                                                        .withOpacity(
                                                                            0.5)
                                                                    : Colors
                                                                        .grey
                                                                        .shade300,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton<
                                                                      String>(
                                                                isExpanded:
                                                                    true,
                                                                hint: Text(
                                                                  'Select Color',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                                value:
                                                                    _dropDownValue,
                                                                icon: Icon(
                                                                  Icons
                                                                      .keyboard_arrow_down,
                                                                  color:
                                                                      GroceryAppColors
                                                                          .tela,
                                                                ),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                items: color!
                                                                    .map((val) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value: val,
                                                                    child: Text(
                                                                        val),
                                                                  );
                                                                }).toList(),
                                                                onChanged:
                                                                    (val) {
                                                                  setState(() {
                                                                    _dropDownValue =
                                                                        val;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                  if (item.productColor!
                                                              .length >
                                                          2 &&
                                                      item.productScale!
                                                              .length >
                                                          2)
                                                    SizedBox(width: 15),

                                                  // Size selection
                                                  if (item.productScale!
                                                          .length >
                                                      2)
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Size',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors.grey
                                                                  .shade700,
                                                            ),
                                                          ),
                                                          SizedBox(height: 8),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey.shade50,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              border:
                                                                  Border.all(
                                                                color: _dropDownValue1 !=
                                                                        null
                                                                    ? GroceryAppColors
                                                                        .tela
                                                                        .withOpacity(
                                                                            0.5)
                                                                    : Colors
                                                                        .grey
                                                                        .shade300,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton<
                                                                      String>(
                                                                isExpanded:
                                                                    true,
                                                                hint: Text(
                                                                  'Select Size',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                                value:
                                                                    _dropDownValue1,
                                                                icon: Icon(
                                                                  Icons
                                                                      .keyboard_arrow_down,
                                                                  color:
                                                                      GroceryAppColors
                                                                          .tela,
                                                                ),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                items: size!
                                                                    .map((val) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value: val,
                                                                    child: Text(
                                                                        val),
                                                                  );
                                                                }).toList(),
                                                                onChanged:
                                                                    (val) {
                                                                  setState(() {
                                                                    _dropDownValue1 =
                                                                        val;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        // SizedBox(height: 15,),

                                        // Enhanced quantity and action buttons container
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              // Quantity selector
                                              Row(
                                                children: [
                                                  Text(
                                                    'Quantity',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
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
                                                                color: _count >
                                                                        1
                                                                    ? GroceryAppColors
                                                                        .tela
                                                                    : Colors
                                                                        .grey,
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
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            onTap: () {
                                                              if (_count <
                                                                  int.parse(item
                                                                          .quantityInStock ??
                                                                      "1")) {
                                                                setState(() {
                                                                  _count++;
                                                                });
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        "Product is not available"),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            1),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red
                                                                            .shade400,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            child: Container(
                                                              width: 40,
                                                              height: 40,
                                                              child: Icon(
                                                                Icons.add,
                                                                color:
                                                                    GroceryAppColors
                                                                        .tela,
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
                                              SizedBox(height: 20),
                                              // Action buttons row
                                              Row(
                                                children: [
                                                  // Add to Cart button
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      height: 50,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          if (GroceryAppConstant
                                                              .isLogin) {
                                                            // Same validation logic as before
                                                            if (item.productColor!
                                                                        .length >
                                                                    0 &&
                                                                item.productScale!
                                                                        .length >
                                                                    0) {
                                                              if (_dropDownValue !=
                                                                      null &&
                                                                  _dropDownValue1 !=
                                                                      null) {
                                                                if (int.parse(
                                                                        item.quantityInStock ??
                                                                            "") >
                                                                    0) {
                                                                  _addToproducts(
                                                                      context);
                                                                  GroceryAppConstant
                                                                      .groceryAppCartItemCount++;
                                                                  groceryCartItemCount(
                                                                      GroceryAppConstant
                                                                          .groceryAppCartItemCount);
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content: Text(
                                                                          "Product added to cart"),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              1),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green,
                                                                    ),
                                                                  );
                                                                  setState(() {
                                                                    GroceryAppConstant
                                                                        .itemcount++;
                                                                  });
                                                                } else {
                                                                  showLongToast(
                                                                      "Product is out of stock");
                                                                }
                                                              } else {
                                                                showLongToast(
                                                                    "Please select color and size");
                                                              }
                                                            } else if (item
                                                                    .productColor!
                                                                    .length >
                                                                2) {
                                                              if (_dropDownValue !=
                                                                  null) {
                                                                if (int.parse(
                                                                        item.quantityInStock ??
                                                                            "") >
                                                                    0) {
                                                                  _addToproducts(
                                                                      context);
                                                                  GroceryAppConstant
                                                                      .groceryAppCartItemCount++;
                                                                  groceryCartItemCount(
                                                                      GroceryAppConstant
                                                                          .groceryAppCartItemCount);
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content: Text(
                                                                          "Product added to cart"),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              1),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green,
                                                                    ),
                                                                  );
                                                                  setState(() {
                                                                    GroceryAppConstant
                                                                        .itemcount++;
                                                                  });
                                                                } else {
                                                                  showLongToast(
                                                                      "Product is out of stock");
                                                                }
                                                              } else {
                                                                showLongToast(
                                                                    "Please select color");
                                                              }
                                                            } else if (item
                                                                    .productScale!
                                                                    .length >
                                                                2) {
                                                              if (_dropDownValue1 !=
                                                                  null) {
                                                                if (int.parse(
                                                                        item.quantityInStock ??
                                                                            "") >
                                                                    0) {
                                                                  _addToproducts(
                                                                      context);
                                                                  GroceryAppConstant
                                                                      .groceryAppCartItemCount++;
                                                                  groceryCartItemCount(
                                                                      GroceryAppConstant
                                                                          .groceryAppCartItemCount);
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content: Text(
                                                                          "Product added to cart"),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              1),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green,
                                                                    ),
                                                                  );
                                                                  setState(() {
                                                                    GroceryAppConstant
                                                                        .itemcount++;
                                                                  });
                                                                } else {
                                                                  showLongToast(
                                                                      "Product is out of stock");
                                                                }
                                                              } else {
                                                                showLongToast(
                                                                    "Please select size");
                                                              }
                                                            } else {
                                                              if (int.parse(
                                                                      item.quantityInStock ??
                                                                          "") >
                                                                  0) {
                                                                _addToproducts(
                                                                    context);
                                                                GroceryAppConstant
                                                                    .groceryAppCartItemCount++;
                                                                groceryCartItemCount(
                                                                    GroceryAppConstant
                                                                        .groceryAppCartItemCount);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        "Product added to cart"),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            1),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                  ),
                                                                );
                                                                setState(() {
                                                                  GroceryAppConstant
                                                                      .itemcount++;
                                                                });
                                                              } else {
                                                                showLongToast(
                                                                    "Product is out of stock");
                                                              }
                                                            }
                                                          } else {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          SignInPage()),
                                                            );
                                                          }
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Color(0xFFE91E63),
                                                          foregroundColor:
                                                              Colors.white,
                                                          elevation: 3,
                                                          shadowColor: Color(
                                                                  0xFFE91E63)
                                                              .withOpacity(0.5),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .shopping_bag_outlined,
                                                                size: 20),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              "Add to Cart",
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  // Wishlist button
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: wishflag!
                                                          ? Colors.grey.shade100
                                                          : Colors.pink.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                        color: wishflag!
                                                            ? Colors
                                                                .grey.shade300
                                                            : Colors
                                                                .pink.shade200,
                                                      ),
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        onTap: () {
                                                          if (GroceryAppConstant
                                                              .isLogin) {
                                                            if (wishflag!) {
                                                              _addToproducts1(
                                                                  context);
                                                              showLongToast(
                                                                  "Product added to wishlist");
                                                              setState(() {
                                                                wishflag =
                                                                    false;
                                                                GroceryAppConstant
                                                                    .wishlist++;
                                                                _countList(
                                                                    GroceryAppConstant
                                                                        .wishlist);
                                                              });
                                                            } else {
                                                              setState(() {
                                                                dbmanager1
                                                                    .deleteProducts(
                                                                        wishid!);
                                                                wishflag = true;
                                                              });
                                                            }
                                                          } else {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          SignInPage()),
                                                            );
                                                          }
                                                        },
                                                        child: Icon(
                                                          wishflag!
                                                              ? Icons
                                                                  .favorite_border
                                                              : Icons.favorite,
                                                          color: wishflag!
                                                              ? Colors
                                                                  .grey.shade600
                                                              : Colors.pink
                                                                  .shade400,
                                                          size: 24,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  // Share button
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.blue.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: Colors
                                                              .blue.shade200),
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        onTap: () {
                                                          setState(() {
                                                            sharableProductName =
                                                                name.replaceAll(
                                                                    " ", "-");
                                                            sharableProductName =
                                                                sharableProductName
                                                                    .replaceAll(
                                                                        "(",
                                                                        "");
                                                            sharableProductName =
                                                                sharableProductName
                                                                    .replaceAll(
                                                                        ")",
                                                                        "");
                                                            sharableProductId =
                                                                item.productIs
                                                                    .toString();
                                                          });
                                                          shareProduct(
                                                            GroceryAppConstant
                                                                    .Product_Imageurl +
                                                                item.img!,
                                                            item.productName ??
                                                                "",
                                                            GroceryAppConstant
                                                                    .base_url +
                                                                "${sharableProductName}_" +
                                                                sharableProductId,
                                                          );
                                                        },
                                                        child: Icon(
                                                          Icons.share_outlined,
                                                          color: Colors
                                                              .blue.shade600,
                                                          size: 24,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Enhanced variant selection section
                                        pvarlist.length > 0
                                            ? Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.05),
                                                      spreadRadius: 1,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.tune,
                                                      color: Color(0xFFE91E63),
                                                      size: 20,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      'Variant:',
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(width: 15),
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          _displayDialog(
                                                              context, index);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 12),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey.shade50,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  textval.length >
                                                                          20
                                                                      ? textval.substring(
                                                                              0,
                                                                              20) +
                                                                          ".."
                                                                      : textval,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: textval ==
                                                                            "Select varient"
                                                                        ? Colors
                                                                            .grey
                                                                            .shade600
                                                                        : Colors
                                                                            .black87,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .keyboard_arrow_down,
                                                                color:
                                                                    GroceryAppColors
                                                                        .tela,
                                                                size: 20,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox.shrink(),

                                        SizedBox(height: 10),

                                        // Enhanced product details section
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                spreadRadius: 1,
                                                blurRadius: 10,
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
                                                child: Container(
                                                  padding: EdgeInsets.all(20),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.info_outline,
                                                        color: GroceryAppColors
                                                            .tela,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        'Product Details',
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Icon(
                                                        showdis
                                                            ? Icons
                                                                .keyboard_arrow_up
                                                            : Icons
                                                                .keyboard_arrow_down,
                                                        color: GroceryAppColors
                                                            .tela,
                                                        size: 24,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              if (showdis)
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      20, 0, 20, 20),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 1,
                                                        color: Colors
                                                            .grey.shade200,
                                                        margin: EdgeInsets.only(
                                                            bottom: 15),
                                                      ),
                                                      // Return policy
                                                      _buildDetailRow(
                                                        'Return Policy:',
                                                        item.returns == "0"
                                                            ? "No Returns"
                                                            : "${item.returns} days",
                                                        Icons.keyboard_return,
                                                      ),
                                                      SizedBox(height: 12),
                                                      // Cancellation policy
                                                      _buildDetailRow(
                                                        'Cancellation:',
                                                        item.cancels == "0"
                                                            ? "No Cancellation"
                                                            : "${item.cancels} days",
                                                        Icons.cancel_outlined,
                                                      ),
                                                      SizedBox(height: 15),
                                                      // Product description
                                                      Container(
                                                        width: double.infinity,
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .grey.shade50,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .description_outlined,
                                                                  color:
                                                                      GroceryAppColors
                                                                          .tela,
                                                                  size: 18,
                                                                ),
                                                                SizedBox(
                                                                    width: 8),
                                                                Text(
                                                                  'Description',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              _parseHtmlString(item
                                                                      .productDescription ??
                                                                  "No description available"),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontSize: 14,
                                                                height: 1.5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                      // Enhanced Group Products Section
                      group != null && group!.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.category_outlined,
                                        color: Color(0xFFE91E63),
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        groupname ?? "Related Items",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Container(
                                    height: 100.0,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: group!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return group![index].img!.length > 2
                                              ? Container(
                                                  width: 80.0,
                                                  margin: EdgeInsets.only(
                                                      right: 12),
                                                  child: Material(
                                                    elevation: 3,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProductDetails1(
                                                                      group![index]
                                                                          .productIs!)),
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                            colors: [
                                                              Colors.white,
                                                              Colors
                                                                  .grey.shade50,
                                                            ],
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child:
                                                              CachedNetworkImage(
                                                            fit: BoxFit.contain,
                                                            imageUrl:
                                                                GroceryAppConstant
                                                                        .Product_Imageurl1 +
                                                                    group![index]
                                                                        .img!,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  GroceryAppColors
                                                                      .tela,
                                                                ),
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .image_not_supported,
                                                                size: 30,
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox.shrink();
                                        }),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      // Enhanced Related Products Section
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: [
                                Icon(
                                  Icons.recommend_outlined,
                                  color: Color(0xFFE91E63),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Related Products',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Color(0xFFE91E63).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color(0xFFE91E63).withOpacity(0.3),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  print(catid.length);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Screen2(
                                            catid.length > 0 ? catid[0] : "0",
                                            "RELATED PRODUCTS")),
                                  );
                                },
                                child: Text(
                                  'View All',
                                  style: TextStyle(
                                    color: Color(0xFFE91E63),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        height: 280.0,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products1.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                width: 160.0,
                                margin: EdgeInsets.only(left: 15, right: 5),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                                    products1[index])),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 150,
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
                                                    .Product_Imageurl +
                                                products1[index].img!,
                                            placeholder: (context, url) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xFFE91E63),
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                              ),
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                                color: Colors.grey.shade400,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  products1[index].productName!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.3,
                                                  ),
                                                ),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '₹${products1[index].buyPrice}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 11,
                                                        color:
                                                            Colors.red.shade600,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                    SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        '₹${calDiscount(products1[index].buyPrice ?? "", products1[index].discount ?? "")}',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .green.shade600,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 13,
                                                        ),
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
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                  childCount:
                      1, // Fix: Prevent infinite loop by specifying single item
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 30), // Bottom padding
              ),
            ])),
      ),
    );
  }

  productName1() {
    actualprice = int.parse(productdetails[0].buyPrice ?? "");
    total = actualprice;

    String mrp_price = calDiscount(
        productdetails[0].buyPrice ?? "", productdetails[0].discount ?? "");
    totalmrp = double.parse(mrp_price);

    Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 5, left: 10),
      child: Text(
          productdetails[0].productName == null
              ? productdetails[0].productName ?? "".length.toString()
              : "sanjar",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          )),
    );
  }

  priceold() {
    Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 1),
      child: Text('\u{20B9} $total',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: GroceryAppColors.mrp,
              decoration: TextDecoration.lineThrough)),
    );
  }

  priceNew() {
    Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 1),
      child: Text(
          totalmrp != null
              ? '\u{20B9} ${(totalmrp! * _count).toStringAsFixed(2)}'
              : '1000',
//                              total.toString()==null?'\u{20B9} $total':actualprice.toString(),
          style: TextStyle(
            color: GroceryAppColors.sellp,
            fontWeight: FontWeight.w700,
          )),
    );
  }

  productDetails() {
    Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
      child: Text(
        productdetails[0].productDescription ?? "",
        style: new TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
      ),
    );
  }

//  discountValue;
//  String adminper;
//  String adminpricevalue;
//  String costPrice;

  void _addToproducts(BuildContext context) {
    if (products == null) {
      ProductsCart st = new ProductsCart(
          pid: productdetails[0].productIs,
          pname: productdetails[0].productName,
          pimage: url,
          pprice: (totalmrp! * _count).toString(),
          pQuantity: _count,
          pcolor: _dropDownValue,
          psize: _dropDownValue1,
          pdiscription: productdetails[0].productDescription,
          sgst: sgst1.toString(),
          cgst: cgst1.toString(),
          discount: productdetails[0].discount,
          discountValue: dicountValue.toString(),
          adminper: productdetails[0].msrp,
          adminpricevalue: admindiscountprice.toString(),
          costPrice: total.toString(),
          shipping: productdetails[0].shipping,
          totalQuantity: productdetails[0].quantityInStock,
          varient: textval,
          mv: int.parse(productdetails[0].mv!),
          moq: '');
      dbmanager
          .insertStudent(st)
          .then((id) => {print('Student Added to Db ${id}')});
    }
  }

  WishlistsCart? nproducts;
  final DbProductManager1 dbmanager1 = new DbProductManager1();

  void _addToproducts1(BuildContext context) {
    if (nproducts == null) {
      WishlistsCart st1 = new WishlistsCart(
          id: null, // Auto-generated ID
          pid: productdetails[0].productIs,
          pname: productdetails[0].productName,
          pimage: url,
          pprice: totalmrp.toString(),
          pQuantity: _count,
          pcolor: _dropDownValue,
          psize: _dropDownValue1,
          pdiscription: productdetails[0].productDescription,
          sgst: sgst1.toString(),
          cgst: cgst1.toString(),
          discount: productdetails[0].discount,
          discountValue: dicountValue.toString(),
          adminper: productdetails[0].msrp,
          adminpricevalue: admindiscountprice.toString(),
          costPrice: productdetails[0].buyPrice);
      dbmanager1.insertStudent(st1).then((id) => {
            setState(() {
              wishid = id;

              print('Student Added to Db ${wishid}');
              print(GroceryAppConstant.totalAmount);
            })
          });
    }
  }

  String calDiscount(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = (byprice1 - (byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(2);
    print(returnStr);
    return returnStr;
  }

  String calGst(String byprice, String sgst) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(sgst);

    discount = ((byprice1 * discount1) / (100.0 + discount1));

    returnStr = discount.toStringAsFixed(2);
    print(returnStr);
    return returnStr;
  }

  void showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  Widget discription1(String Discription) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Text(
                '${_parseHtmlString(Discription)}',
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

  Future _countList(int val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("wcount", val);
  }

  // Helper method for building detail rows
  Widget _buildDetailRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color(0xFFE91E63),
          size: 18,
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}
