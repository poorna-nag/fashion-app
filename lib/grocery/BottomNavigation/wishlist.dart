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
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            createHeader(),
            createSubTitle(),
            SizedBox(height: 10),
            Expanded(
                child: prodctlist1 == null || prodctlist1!.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade300),
                            SizedBox(height: 16),
                            Text("Your Cart is Empty", style: TextStyle(fontSize: 18, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      )
                    : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: prodctlist1!.length,
              itemBuilder: (BuildContext context, int index) {
                ProductsCart item = prodctlist1![index];

                return Dismissible(
                  key: Key(UniqueKey().toString()),
                  onDismissed: (direction) async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    if (direction == DismissDirection.endToStart || direction == DismissDirection.startToEnd) {
                      dbmanager.deleteProducts(item.id!);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Color(0xFFE91E63),
                          content: Text("Product removed from cart"),
                          duration: Duration(seconds: 1)));
                    }
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
                  background: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(16)
                    ),
                    padding: EdgeInsets.all(20.0),
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.delete_outline, color: Color(0xFFE91E63), size: 30),
                  ),
                  secondaryBackground: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(16)
                    ),
                    padding: EdgeInsets.all(20.0),
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.delete_outline, color: Color(0xFFE91E63), size: 30),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        )
                      ]
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xFFF0F0F0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(GroceryAppConstant.Product_Imageurl + item.pimage!),
                            )
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.pname ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      SharedPreferences pref = await SharedPreferences.getInstance();
                                      setState(() {
                                        dbmanager.deleteProducts(item.id!);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            backgroundColor: Color(0xFFE91E63),
                                            content: Text("Product removed"),
                                            duration: Duration(seconds: 1)));
                                        prodctlist1!.removeAt(index);
                                        GroceryAppConstant.itemcount--;
                                        GroceryAppConstant.carditemCount--;
                                        GroceryAppConstant.totalAmount -= double.parse(item.pprice ?? "0");
                                        if (GroceryAppConstant.groceryAppCartItemCount > 0) {
                                          GroceryAppConstant.groceryAppCartItemCount--;
                                        }
                                        groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
                                        setState(() {
                                          AppConstent.cc--;
                                          if (AppConstent.cc < 0) AppConstent.cc = 0;
                                          pref.setInt("cc", AppConstent.cc);
                                        });
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Icon(Icons.close_rounded, color: Colors.grey.shade400, size: 20),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              if (item.pcolor != null && item.pcolor!.isNotEmpty)
                                Text('Color: ${item.pcolor}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                              if (item.psize != null && item.psize!.isNotEmpty)
                                Text('Size: ${item.psize}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    item.pprice == null ? '100' : '\u{20B9} ${double.parse(item.pprice!).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Color(0xFFE91E63),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF8F9FA),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.grey.shade200)
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            if (prodctlist1![index].quantity != 1) {
                                              setState(() {
                                                String pvalue = calDiscount1(item.costPrice ?? "", item.discount ?? "");
                                                double price = double.parse(pvalue);
                                                GroceryAppConstant.totalAmount -= price;
                                                int quantity = item.pQuantity!;
                                                int totalquantity = quantity - 1;
                                                double incrementprice = (price * totalquantity);
                                                prodctlist1![index].price = incrementprice.toString();
                                                prodctlist1![index].quantity = totalquantity;
                                                dbmanager.updateStudent(item);
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            child: Icon(Icons.remove, size: 16, color: Colors.black87),
                                          ),
                                        ),
                                        Text(
                                          '${item.pQuantity ?? 1}',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              String pvalue = calDiscount1(item.costPrice ?? "", item.discount ?? "");
                                              double price = double.parse(pvalue);
                                              GroceryAppConstant.totalAmount += price;
                                              int quantity = item.pQuantity!;
                                              int maxQty = item.totalQuantity != null && item.totalQuantity!.isNotEmpty ? int.parse(item.totalQuantity!) : 999;
                                              if (quantity < maxQty) {
                                                int totalquantity = quantity + 1;
                                                double incrementprice = (price * totalquantity);
                                                prodctlist1![index].price = incrementprice.toString();
                                                prodctlist1![index].quantity = totalquantity;
                                                dbmanager.updateStudent(item);
                                              } else {
                                                showLongToast('Only $maxQty products in stock');
                                              }
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            child: Icon(Icons.add, size: 16, color: Colors.black87),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )),
            if (prodctlist1 != null && prodctlist1!.isNotEmpty)
              footer(context),
          ],
        ),
      ),
    );
  }

  footer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, -5),
          )
        ]
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Total Amount",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                  fontSize: 16
                ),
              ),
              Text(
                '\u{20B9} ${GroceryAppConstant.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                  fontSize: 22
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 55,
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
                backgroundColor: Color(0xFFE91E63),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                "Proceed to Checkout",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  createHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Shopping Cart",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  createSubTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            '${GroceryAppConstant.itemcount} Items in your cart',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
        ],
      ),
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
