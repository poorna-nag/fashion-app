import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:royalmart/BottomNavigation/wishlist.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/model/ListModel.dart';
import 'package:royalmart/model/productmodel.dart';
import 'package:royalmart/screen/MvProduct.dart';
import 'package:royalmart/screen/SubCategry.dart';
import 'package:royalmart/utils/dimensions.dart';
import 'package:royalmart/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SearchScreen1.dart';

class ProductList extends StatefulWidget {
  final String cat, title;
  const ProductList(this.cat, this.title) : super();

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>
    with SingleTickerProviderStateMixin {
  bool flag = false;
  static const int PAGE_SIZE = 10;

  bool showFab = true;
  int _current = 0;
  List<ListModel> shoplist = <ListModel>[];

  List<Products> products1 = [];
  void gatinfoCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    int ?Count = pref.getInt("itemCount");
    setState(() {
      if (Count == null) {
        FoodAppConstant.foodAppCartItemCount = 0;
      } else {
        FoodAppConstant.foodAppCartItemCount = Count;
      }
      print(FoodAppConstant.foodAppCartItemCount.toString() + "itemCount");
    });
  }

  ScrollController _scrollController = new ScrollController();

  getdata(int count) {
    getShopListByCat(0, "700000", widget.cat).then((usersFromServe1) {
      if (this.mounted) {
        setState(() {
          shoplist.addAll(usersFromServe1);
          shoplist.length > 0 ? flag = false : flag = true;
          // print("sliderlist1.length");
          // print(shoplist.length);
        });
      }
    });
  }

  int countval = 0;
  @override
  void initState() {
    super.initState();
    gatinfoCount();

    getdata(countval);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          countval = countval + 6;
          getdata(countval);
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: FoodAppColors.tela,
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
                      size: 25,
                      color: FoodAppColors.black,
                    ),
                  )),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        widget.title.isEmpty ? "Products" : widget.title,
                        style:
                            TextStyle(color: FoodAppColors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      /* InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserVenderSerch()),
                          );
                        },
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Icon(
                                Icons.search,
                                color: AppColors.black,
                                size: 30,
                              ),
                            ),
//                    showCircle(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),*/
                      InkWell(
                        onTap: () {
                          print(
                              "itemc------>${FoodAppConstant.foodAppCartItemCount}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WishList()),
                          );
                        },
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 13),
                              child: Icon(
                                Icons.add_shopping_cart,
                                color: FoodAppColors.black,
                              ),
                            ),
                            //showCircle(),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  /* Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: 20.0, left: 10.0, right: 8.0,bottom: 10.0),
                  child: Center(
                    child: Text(widget.title,
                      style: TextStyle(
                          color: AppColors.product_title_name,
                          fontSize: 17,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
          ),
*/

                  !flag
                      ? Container(
                          // height: 500,
                          child: PagewiseListView(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          pageSize: PAGE_SIZE,
                          itemBuilder: this._itemBuilder,
                          pageFuture: (pageIndex) => getShopListByCat(
                              pageIndex! * PAGE_SIZE, "700000", widget.cat),
                        ))
                      : Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Column(
                            children: [
                              Image.asset('assets/gifs/nothing-found.gif'),
                              Center(
                                child: Text("No Vendors Available"),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            )));
  }

  String calDiscount(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = (byprice1 - (byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(FoodAppConstant.val);
    print(returnStr);
    return returnStr;
  }

  Widget _itemBuilder(context, ListModel entry, int index) {
    return Padding(
      padding: EdgeInsets.only(
        right: Dimensions.PADDING_SIZE_SMALL,
        bottom: Dimensions.PADDING_SIZE_SMALL,
        left: Dimensions.PADDING_SIZE_SMALL,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MV_products(entry.company??"", entry.mvId??"", "")),
          );
        },
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 5,
                spreadRadius: 1,
              )
            ],
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Dimensions.RADIUS_SMALL)),
                      child: entry.pp != null
                          ? entry.pp == "no-pp.png"
                              ? Image.asset(
                                  "assets/images/logo.png",
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      FoodAppConstant.logo_Image_mv + entry.pp!,
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          GroceryAppColors.tela),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                )
                          : Image.asset(
                              "assets/images/logo.png",
                              height: 120,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            )),
                ]),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            entry.name ?? '',
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            entry.address ?? '',
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: Theme.of(context).disabledColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RatingBar.builder(
                                initialRating: (double.parse(entry.reviews1!) /
                                    double.parse(entry.reviews_total!)),
                                minRating: 0,
                                itemSize: 15,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: double.parse(entry.reviews_total!) > 0
                                      ? FoodAppColors.tela
                                      : Colors.grey,
                                  size: 5,
                                ), onRatingUpdate: (double value) {  },
                                /* onRatingUpdate: (rating) {
                                                            // _ratingController=rating;
                                                            print(rating);
                                                          },*/
                              ),
                              SizedBox(width: 5),
                              Text(
                                "(${entry.reviews_total})",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                          //rating
                        ]),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
