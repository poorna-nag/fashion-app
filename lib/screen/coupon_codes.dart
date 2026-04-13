import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/model/CoupanModel.dart';
import 'package:royalmart/model/Cuponcode.dart';
import 'package:http/http.dart' as http;

class CouponCodes extends StatefulWidget {
  const CouponCodes({Key? key}) : super(key: key);

  @override
  State<CouponCodes> createState() => _CouponCodesState();
}

class _CouponCodesState extends State<CouponCodes> {
  bool isLoading = true;
  CuponCode couponCodes = CuponCode();
  List<CuponCode> couponCodesList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    await getCoupans();
    setState(() {
      isLoading = false;
    });
  }

  Future<List<CuponCode>?> getCoupans() async {
    String link = FoodAppConstant.base_url +
        "manage/api/coupon_codes/all/?X-Api-Key=" +
        FoodAppConstant.API_KEY +
        "&shop_id=" +
        FoodAppConstant.Shop_id +
        "&code=";
//      Constant.base_url + "manage/api/coupon_codes/all/?X-Api-Key=" +
//      Constant.API_KEY + "shop_id=" + Constant.Shop_id +"code="+code;
    print("coupon-----.${link}");
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      List<dynamic> galleryArray = responseData["data"]["coupon_codes"];
      List<CuponCode> list = CuponCode.getListFromJson(galleryArray);
      couponCodesList.addAll(list);
      print("hellllo");
    }
//    print("List Size: ${list.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Coupon Codes"),
          backgroundColor: FoodAppColors.tela,
        ),
        backgroundColor: FoodAppColors.tela1,
        body: isLoading
            ? (Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ))
            : Container(
                child: ListView.builder(
                    itemCount: couponCodesList.isEmpty ? 0 : couponCodesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            child: Card(
                              elevation: 5,
                              shadowColor: FoodAppColors.tela,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 90,
                                    width: 90,
                                    margin: EdgeInsets.only(left: 10),
                                    child: Card(
                                      elevation: 5,
                                      shadowColor: FoodAppColors.tela,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset("assets/images/logo.png")),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(height: 8),
                                      Container(
                                        width: 250,
                                        child: Row(
                                          children: [
                                            Text("Coupon Code: "),
                                            Text(
                                              couponCodesList[index].code ?? "",
                                              style: TextStyle(color: FoodAppColors.tela, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width: 250,
                                        child: Row(
                                          children: [
                                            Text("Max Discount: "),
                                            Text(
                                              "\u{20B9}${couponCodesList[index].maxVal}",
                                              style: TextStyle(color: FoodAppColors.tela, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width: 250,
                                        child: Row(
                                          children: [
                                            Text("Min Order: "),
                                            Text(
                                              "\u{20B9}${couponCodesList[index].minVal}",
                                              style: TextStyle(color: FoodAppColors.tela, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width: 250,
                                        child: Row(
                                          children: [
                                            Text("Expiry Date: "),
                                            Text(
                                              "${couponCodesList[index].xdate}",
                                              style: TextStyle(color: FoodAppColors.tela, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                margin: EdgeInsets.only(right: 15, top: 80),
                                height: 50,
                                width: 50,
                                child: IconButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: couponCodesList[index].code.toString()));
                                    showLongToast("Coupon code copied successfully...");
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    size: 30,
                                    color: FoodAppColors.sellp,
                                  ),
                                )),
                          ),
                        ],
                      );
                    }),
              ));
  }
}
