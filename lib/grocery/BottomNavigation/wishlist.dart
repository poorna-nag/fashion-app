import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:royalmart/constent/app_constent.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/StyleDecoration/styleDecoration.dart';
import 'package:royalmart/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/grocery/screen/ShowAddress.dart';

import 'package:shared_preferences/shared_preferences.dart';

class WishList extends StatefulWidget {
  final bool? check;

  const WishList({Key ?key,  this.check}) : super(key: key);
  @override
  WishlistState createState() => WishlistState();
}

class WishlistState extends State<WishList> {
  final DbProductManager dbmanager = new DbProductManager();
  static List<ProductsCart>? prodctlist;
  static List<ProductsCart>? prodctlist1;
  double totalamount = 0;

  int _count = 1;
  bool islogin = false;
  int? totalquantity;
  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    islogin = pref!.getBool("isLogin")!;
    setState(() {
      GroceryAppConstant.isLogin = islogin;
    });
  }

  @override
  void initState() {
//    openDBBB();
    super.initState();
    gatinfo();
    dbmanager.getProductList().then((usersFromServe) {
      print("CART ITEMS FETCHED");
      if (this.mounted) {
        print("OBJECT IS MOUNTED");
        setState(() {
          print("server list ===>" + usersFromServe.toString());
          prodctlist1 = usersFromServe;
          print(prodctlist1.toString());
          for (var i = 0; i < prodctlist1!.length; i++) {
            print(prodctlist1![i].pprice);
            totalamount = totalamount + double.parse(prodctlist1![i].pprice??"");
          }

          GroceryAppConstant.totalAmount = totalamount;
          GroceryAppConstant.itemcount = prodctlist1!.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf2f2f2),
      body: Container(
        child: Column(
          children: <Widget>[
            createHeader(),
            createSubTitle(),
            Expanded(
                child: ListView.builder(
              itemCount: prodctlist1 == null ? 0 : prodctlist1!.length,
              itemBuilder: (BuildContext context, int index) {
                ProductsCart item = prodctlist1![index];
                var i = item.pQuantity;

                return Dismissible(
                  key: Key(UniqueKey().toString()),
                  onDismissed: (direction) async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    if (direction == DismissDirection.endToStart) {
                      dbmanager.deleteProducts(item.id!);

                      // Then show a snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(" Product is remove"),
                          duration: Duration(seconds: 1)));
                    } else {
                      dbmanager.deleteProducts(item.id!);
                      setState(() {
//                        Constant.itemcount--;
////                              Constant.totalAmount= Constant.totalAmount-double.parse(item.pprice);
//                        Constant.carditemCount--;
//                        cartItemcount(Constant.carditemCount);
                      });

                      // Then show a snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(" Product is remove "),
                          duration: Duration(seconds: 1)));
                    }
                    // Remove the item from the data source.
                    setState(() {
                      prodctlist1!.removeAt(index);
                      GroceryAppConstant.totalAmount =
                          GroceryAppConstant.totalAmount -
                              double.parse(item.pprice!);
                      GroceryAppConstant.itemcount--;

                      setState(() {
                        AppConstent.cc--;

                        pref.setInt("cc", AppConstent.cc);
                      });

                      GroceryAppConstant.groceryAppCartItemCount--;
                      groceryCartItemCount(
                          GroceryAppConstant.groceryAppCartItemCount);
                    });
                  },
                  // Show a red background as the item is swiped away.
                  background: Container(
                    decoration: BoxDecoration(color: Colors.red),
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    height: 100.0,
                    decoration: BoxDecoration(color: Colors.red),
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  child: InkWell(
                      onTap: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => ProductDetails()),
//                );
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 16),
                            child: Card(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: 0, left: 4, top: 8, bottom: 8),
                                    width: 110,
                                    height: 130,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: GroceryAppColors.tela),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14)),
                                        color: Colors.blue.shade200,
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              GroceryAppConstant
                                                      .Product_Imageurl +
                                                  item.pimage!,
                                            ))),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: 8, top: 4),
                                            child: Text(
                                              item.pname == null
                                                  ? 'name'
                                                  : item.pname??"",
                                              maxLines: 2,
                                              softWrap: true,
                                              style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black)
                                                  .copyWith(fontSize: 14),
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          item.pcolor != null
                                              ? item.pcolor!.length > 0
                                                  ? Text(
                                                      'COLOR ${item.pcolor}',
                                                      style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black)
                                                          .copyWith(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 14),
                                                    )
                                                  : Row()
                                              : Row(),
                                          SizedBox(height: 6),
                                          item.psize != null
                                              ? item.psize!.length > 0
                                                  ? Text(
                                                      'Size ${item.psize}',
                                                      style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black)
                                                          .copyWith(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 14),
                                                    )
                                                  : Row()
                                              : Row(),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  item.pprice == null
                                                      ? '100'
                                                      : '\u{20B9} ${double.parse(item.pprice??"").toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme.secondary,
                                                    fontWeight: FontWeight.w700,
                                                  ).copyWith(
                                                      color: Colors.green),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          if (prodctlist1![index]
                                                                  .quantity !=
                                                              1) {
                                                            setState(() {
                                                              String pvalue =
                                                                  calDiscount1(
                                                                      item.costPrice??"",
                                                                      item.discount??"");
                                                              double price =
                                                                  double.parse(
                                                                      pvalue);
                                                              GroceryAppConstant
                                                                      .totalAmount =
                                                                  GroceryAppConstant
                                                                          .totalAmount -
                                                                      price;
                                                              int quantity =
                                                                  item.pQuantity!;
                                                              int totalquantity =
                                                                  quantity - 1;
                                                              double
                                                                  incrementprice =
                                                                  (price *
                                                                      totalquantity);
                                                              prodctlist1![index]
                                                                      .price =
                                                                  incrementprice
                                                                      .toString();
                                                              prodctlist1![index]
                                                                      .quantity =
                                                                  totalquantity;
                                                              dbmanager
                                                                  .updateStudent(
                                                                      item);
                                                            });
                                                          }
                                                        },
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 24,
                                                          color: Colors
                                                              .grey.shade700,
                                                        ),
                                                      ),
                                                      Container(
                                                        color: Colors
                                                            .grey.shade200,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 2,
                                                                right: 12,
                                                                left: 12),
                                                        child: Text(item
                                                                    .pQuantity ==
                                                                null
                                                            ? '1'
                                                            : '${prodctlist1![index].quantity}'),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            String pvalue =
                                                                calDiscount1(
                                                                    item.costPrice??"",
                                                                    item.discount??"");
                                                            double price =
                                                                double.parse(
                                                                    pvalue);
                                                            GroceryAppConstant
                                                                    .totalAmount =
                                                                GroceryAppConstant
                                                                        .totalAmount +
                                                                    price;

                                                            int quantity =
                                                                item.pQuantity!;
                                                            if (quantity <=
                                                                int.parse(prodctlist1![
                                                                        index]
                                                                    .totalQuantity??"")) {
                                                              totalquantity =
                                                                  quantity + 1;
                                                            } else {
                                                              showLongToast(
                                                                  'Only  ${quantity}  products in stock ');
                                                            }

                                                            double
                                                                incrementprice =
                                                                (price *
                                                                    totalquantity!);
                                                            prodctlist1![index]
                                                                    .price =
                                                                incrementprice
                                                                    .toString();
                                                            prodctlist1![index]
                                                                    .quantity =
                                                                totalquantity!;
                                                            dbmanager
                                                                .updateStudent(
                                                                    item);
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 24,
                                                          color: Colors
                                                              .grey.shade700,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    flex: 100,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 10, top: 8),
                              child: InkWell(
                                onTap: () async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    dbmanager.deleteProducts(item.id!);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(" Product is remove"),
                                        duration: Duration(seconds: 1)));
                                    prodctlist1!.removeAt(index);
                                    GroceryAppConstant.itemcount--;
                                    GroceryAppConstant.carditemCount--;
                                    GroceryAppConstant.totalAmount =
                                        GroceryAppConstant.totalAmount -
                                            double.parse(item.pprice??"");
                                    GroceryAppConstant
                                                .groceryAppCartItemCount <=
                                            0
                                        ? GroceryAppConstant
                                            .groceryAppCartItemCount = 0
                                        : GroceryAppConstant
                                            .groceryAppCartItemCount--;

                                    log(GroceryAppConstant
                                        .groceryAppCartItemCount
                                        .toString());
                                    groceryCartItemCount(GroceryAppConstant
                                        .groceryAppCartItemCount);

                                    setState(() {
                                      AppConstent.cc--;

                                      if (AppConstent.cc == 0 ||
                                          AppConstent.cc < 0) {
                                        AppConstent.cc = 0;
                                      }
                                      log(AppConstent.cc.toString());

                                      pref.setInt("cc", AppConstent.cc);
                                    });
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  color: Colors.red),
                            ),
                          )
                        ],
                      )),
                );
              },
            )),
            footer(context),
          ],
        ),
      ),
    );
  }

  footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  "Total",
                  style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.black)
                      .copyWith(color: Colors.black, fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  '\u{20B9} ${GroceryAppConstant.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.greenAccent.shade700,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            height: 40,
            width: 160,
            child: ElevatedButton(
              
             
              onPressed: () {
                if (GroceryAppConstant.itemcount > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowAddress("0")),
                  );
                } else {
                  showLongToast('Please add some products first!...');
                }
              },
             style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 240, 55, 141),
                  elevation: 0,
                  shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
               textStyle:TextStyle(color:Colors.white, ) ,
                padding: EdgeInsets.all(0.0),
                ),
          
              child: Text(
                "Buy Now",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "SHOPPING CART",
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 16, color: Colors.black),
      ),
      margin: EdgeInsets.only(left: 12, top: 35),
    );
  }

  createSubTitle() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        'Total (${GroceryAppConstant.itemcount}) Items',
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 12, color: Colors.grey),
      ),
      margin: EdgeInsets.only(left: 12, top: 4),
    );
  }

  String calDiscount1(String byprice, String discount2) {
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

  String calDiscount(String totalamount) {
    setState(() {
      GroceryAppConstant.totalAmount = double.parse(totalamount);
    });
    return GroceryAppConstant.totalAmount.toStringAsFixed(2).toString();
  }
}
