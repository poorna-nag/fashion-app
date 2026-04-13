import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royalmart/constent/app_constent.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/grocery/BottomNavigation/wishlist.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/grocery/dbhelper/database_helper.dart';
import 'package:royalmart/grocery/model/productmodel.dart';
import 'package:royalmart/grocery/screen/SearchScreen.dart';
import 'package:royalmart/grocery/screen/detailpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductList extends StatefulWidget {
  final String cat, title;
  const ProductList(this.cat, this.title) : super();

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>
    with SingleTickerProviderStateMixin {
  bool showFab = true;
  int total = 000;
  int actualprice = 200;
  double? mrp, totalmrp = 000;
  int _count = 1;
  int cc = 0;
  double? sgst1, cgst1, dicountValue, admindiscountprice;

  List<Products> products1 = [];
  bool isLoading = true; // Add loading state

  void gatinfoCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    int? Count = pref.getInt("itemCount");
    setState(() {
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

  @override
  void initState() {
    super.initState();
    getcartCount();
    gatinfoCount();
    print(widget.title);
    print(widget.cat);

    if (widget.cat == "new") {
      DatabaseHelper.getTopProduct1(widget.cat, "1000").then((usersFromServe) {
        setState(() {
          products1 = usersFromServe!;
          isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
      });
    } else if (widget.cat == 'yes') {
      DatabaseHelper.getfeature('yes', "100").then((usersFromServe) {
        setState(() {
          products1 = usersFromServe!;
          isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
      });
    } else if (widget.cat.toLowerCase() == 'top') {
      // Handle trending products
      print("Fetching trending products with getTopProduct");
      DatabaseHelper.getTopProduct("top", "100").then((usersFromServe) {
        print("getTopProduct returned: ${usersFromServe?.length} products");
        setState(() {
          products1 = usersFromServe ?? [];
          isLoading = false;
          print("products1 length after setState: ${products1.length}");
        });
      }).catchError((error) {
        print("Error fetching trending products: $error");
        setState(() {
          isLoading = false;
        });
      });
    } else if (widget.cat.toLowerCase() == 'best') {
      // Handle best deals
      print("Fetching best deals with getTopProduct");
      DatabaseHelper.getTopProduct("best", "100").then((usersFromServe) {
        print("getTopProduct returned: ${usersFromServe?.length} products");
        setState(() {
          products1 = usersFromServe ?? [];
          isLoading = false;
          print("products1 length after setState: ${products1.length}");
        });
      }).catchError((error) {
        print("Error fetching best deals: $error");
        setState(() {
          isLoading = false;
        });
      });
    } else if (widget.cat.toLowerCase() == 'day') {
      // Handle deals of the day
      print("Fetching deals of the day with getTopProduct");
      DatabaseHelper.getTopProduct("day", "100").then((usersFromServe) {
        print("getTopProduct returned: ${usersFromServe?.length} products");
        setState(() {
          products1 = usersFromServe ?? [];
          isLoading = false;
          print("products1 length after setState: ${products1.length}");
        });
      }).catchError((error) {
        print("Error fetching deals of the day: $error");
        setState(() {
          isLoading = false;
        });
      });
    } else {
      // Use getProductsByCategory for product categories to call products/all API with cats= parameter
      print("Using getProductsByCategory with cat: ${widget.cat}");
      DatabaseHelper.getProductsByCategory(widget.cat, "100")
          .then((usersFromServe) {
        print(
            "getProductsByCategory returned: ${usersFromServe?.length} products");
        setState(() {
          products1 = usersFromServe ?? [];
          isLoading = false;
          print("products1 length after setState: ${products1.length}");
        });
      }).catchError((error) {
        print("Error in getProductsByCategory: $error");
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getcartCount();
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Color(0xFFF8F9FA),
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.5, 1.0],
                  colors: [
                    Color.fromARGB(255, 236, 21, 89),
                    Color.fromARGB(255, 184, 103, 131),
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
                )),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserFilterDemo()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 0, right: 10),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
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
                      padding: EdgeInsets.only(top: 13, right: 30),
                      child: Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, bottom: 18),
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            // color: Colors.orange,
                          ),
                          child: Text('${cc}',
                              style: TextStyle(
                                  color: Color(0xFFE91E63), fontSize: 15.0)),
                        ),
                      ),
                    ),
                    // showcartCircle(),
                  ],
                ),
              )
            ],
            title: Text(
                widget.title.isEmpty
                    ? GroceryAppConstant.appname
                    : widget.title,
                style: TextStyle(
                    color: GroceryAppColors.white,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold)),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : products1.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              scrollDirection: Axis.vertical,
                              itemCount: products1.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 6,
                                          bottom: 6),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
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
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    right: 8,
                                                    left: 8,
                                                    top: 8,
                                                    bottom: 8),
                                                width: 110,
                                                height: 110,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Color(0xFFE91E63)),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                14)),
                                                    color: Colors.blue.shade200,
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                          products1[index]
                                                                      .img !=
                                                                  null
                                                              ? GroceryAppConstant
                                                                      .Product_Imageurl +
                                                                  products1[
                                                                          index]
                                                                      .img!
                                                              : "ttps://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg",
                                                        ))),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        child: Text(
                                                          products1[index]
                                                                      .productName ==
                                                                  null
                                                              ? 'name'
                                                              : products1[index]
                                                                      .productName ??
                                                                  "",
                                                          overflow:
                                                              TextOverflow.fade,
                                                          style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black)
                                                              .copyWith(
                                                                  fontSize: 14),
                                                        ),
                                                      ),
                                                      SizedBox(height: 6),
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 2.0,
                                                                    bottom: 1),
                                                            child: Text(
                                                                '\u{20B9} ${calDiscount(products1[index].buyPrice ?? "", products1[index].discount ?? "")} ${products1[index].unit_type != null ? "/" + products1[index].unit_type.toString() : ""}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFFE91E63),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                )),
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              '(\u{20B9} ${products1[index].buyPrice})',
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
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 0.0,
                                                        height: 10.0,
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 0.0,
                                                            right: 10),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              Column(
                                                                children: <Widget>[
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: <Widget>[
                                                                      Container(
                                                                          height:
                                                                              25,
                                                                          width:
                                                                              35,
                                                                          child:
                                                                              Material(
                                                                            color:
                                                                                Color(0xFFE91E63),
                                                                            elevation:
                                                                                0.0,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(15),
                                                                              ),
                                                                            ),
                                                                            clipBehavior:
                                                                                Clip.antiAlias,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.only(bottom: 10),
                                                                              child: InkWell(
                                                                                  onTap: () {
                                                                                    print(products1[index].count);
                                                                                    if (products1[index].count != "1") {
                                                                                      setState(() {
//                                                                                _count++;

                                                                                        String quantity = products1[index].count ?? "";
                                                                                        int totalquantity = int.parse(quantity) - 1;
                                                                                        products1[index].count = totalquantity.toString();
                                                                                      });
                                                                                    }

//
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.only(
                                                                                      top: 10.0,
                                                                                    ),
                                                                                    child: Icon(
                                                                                      Icons.maximize,
                                                                                      size: 20,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  )),
                                                                            ),
                                                                          )),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                0.0,
                                                                            left:
                                                                                5.0,
                                                                            right:
                                                                                5.0),
                                                                        child:
                                                                            Center(
                                                                          child: Text(
                                                                              products1[index].count != null ? '${products1[index].count}' : '$_count',
                                                                              style: TextStyle(color: Colors.black, fontSize: 19, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                          margin: EdgeInsets.only(
                                                                              left:
                                                                                  3.0),
                                                                          height:
                                                                              25,
                                                                          width:
                                                                              35,
                                                                          child:
                                                                              Material(
                                                                            color:
                                                                                Color(0xFFE91E63),
                                                                            elevation:
                                                                                0.0,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(15),
                                                                              ),
                                                                            ),
                                                                            clipBehavior:
                                                                                Clip.antiAlias,
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                if (int.parse(products1[index].count ?? "") <= int.parse(products1[index].quantityInStock ?? "")) {
                                                                                  setState(() {
//                                                                                _count++;

                                                                                    String quantity = products1[index].count ?? "";
                                                                                    int totalquantity = int.parse(quantity) + 1;
                                                                                    products1[index].count = totalquantity.toString();
                                                                                  });
                                                                                } else {
                                                                                  showLongToast('Only  ${products1[index].count}  products in stock ');
                                                                                }
                                                                              },
                                                                              child: Icon(
                                                                                Icons.add,
                                                                                size: 20,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                          )),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              // SizedBox(width: 10,),

                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: <Widget>[
                                                                  Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              3.0),
                                                                      height:
                                                                          30,
                                                                      width: 50,
                                                                      child:
                                                                          Material(
                                                                        color: Color(
                                                                            0xFFE91E63),
                                                                        elevation:
                                                                            0.0,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          side:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0xFFE91E63),
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(2),
                                                                          ),
                                                                        ),
                                                                        clipBehavior:
                                                                            Clip.antiAlias,
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            SharedPreferences
                                                                                pref =
                                                                                await SharedPreferences.getInstance();
                                                                            if (GroceryAppConstant.isLogin) {
                                                                              String mrp_price = calDiscount(products1[index].buyPrice ?? "", products1[index].discount ?? "");
                                                                              totalmrp = double.parse(mrp_price);

                                                                              double dicountValue = double.parse(products1[index].buyPrice ?? "") - totalmrp!;
                                                                              String gst_sgst = calGst(mrp_price, products1[index].sgst ?? "");
                                                                              String gst_cgst = calGst(mrp_price, products1[index].cgst ?? "");

                                                                              String adiscount = calDiscount(products1[index].buyPrice ?? "", products1[index].msrp != null ? products1[index].msrp ?? "" : "0");

                                                                              admindiscountprice = (double.parse(products1[index].buyPrice ?? "") - double.parse(adiscount));

                                                                              String color = "";
                                                                              String size = "";
                                                                              _addToproducts(products1[index].productIs ?? "", products1[index].productName ?? "", products1[index].img ?? "", int.parse(mrp_price), int.parse(products1[index].count ?? ""), color, size, products1[index].productDescription ?? "", gst_sgst, gst_cgst, products1[index].discount ?? "", dicountValue.toString(), products1[index].APMC ?? "", admindiscountprice.toString(), products1[index].buyPrice ?? "", products1[index].shipping ?? "", products1[index].quantityInStock ?? "");

                                                                              setState(() {
//                                                                              cartvalue++;
                                                                                GroceryAppConstant.groceryAppCartItemCount++;
                                                                                groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
                                                                              });
                                                                              setState(() {
                                                                                AppConstent.cc++;

                                                                                pref.setInt("cc", AppConstent.cc);
                                                                              });

//                                                                Navigator.push(context,
//                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);
                                                                            } else {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(builder: (context) => SignInPage()),
                                                                              );
                                                                            }

//
                                                                          },
                                                                          child: Padding(
                                                                              padding: EdgeInsets.only(left: 8, top: 5, bottom: 5, right: 8),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "ADD",
                                                                                  style: TextStyle(color: GroceryAppColors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                // Icon(Icons.add_shopping_cart,color: Colors.white,),
                                                                              )),
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    double.parse(products1[index].discount ??
                                                "") >
                                            0
                                        ? showSticker(index, products1)
                                        : Row(),
                                  ],
                                );
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "No products found",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Try a different category",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ),
              ],
            ),
          ),

          /*
        }
      )*/
        ));
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

  final DbProductManager dbmanager = new DbProductManager();

  ProductsCart? products2;
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
    if (products2 == null) {
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
    }
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
}
