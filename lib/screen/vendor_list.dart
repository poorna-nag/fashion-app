import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/model/ListModel.dart';
import 'package:royalmart/utils/dimensions.dart';
import 'package:royalmart/utils/styles.dart';

import 'SubCategry.dart';

class VendorList extends StatefulWidget {
  const VendorList({Key? key}) : super(key: key);

  @override
  State<VendorList> createState() => _VendorListState();
}

class _VendorListState extends State<VendorList> {
  static List<ListModel> shopList = [];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    await getShopList1(0, FoodAppConstant.citname).then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          shopList = usersFromServe!;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FoodAppColors.tela,
        title: Text("Vendor List"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor:
                    AlwaysStoppedAnimation<Color>(GroceryAppColors.tela),
              ),
            )
          : shopList.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    controller: ScrollController(),
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    padding:
                        EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                    itemCount: shopList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Sbcategory(
                                      shopList[index].company??"",
                                      shopList[index].mvId??"",
                                      shopList[index].cat??"")),
                            );
                          },
                          child: Container(
                            height: 180,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SMALL),
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
                                            top: Radius.circular(
                                                Dimensions.RADIUS_SMALL)),
                                        child: shopList[index].pp != null
                                            ? shopList[index].pp == "no-pp.png"
                                                ? Image.asset(
                                                    "assets/images/logo.png",
                                                    height: 120,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fit: BoxFit.cover,
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: FoodAppConstant
                                                            .logo_Image_mv +
                                                        shopList[index].pp!,
                                                    height: 120,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) =>
                                                            Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2.0,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                GroceryAppColors
                                                                    .tela),
                                                      ),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        new Icon(Icons.error),
                                                  )
                                            : Image.asset(
                                                "assets/images/logo.png",
                                                height: 120,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                fit: BoxFit.cover,
                                              )),
                                  ]),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              shopList[index].name ?? '',
                                              style: robotoMedium.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            /* Text(
                                      shopList[index].address ?? '',
                                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),*/
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                RatingBar.builder(
                                                  initialRating: (double.parse(
                                                          shopList[index]
                                                              .reviews1??"") /
                                                      double.parse(
                                                          shopList[index]
                                                              .reviews_total??"")),
                                                  minRating: 0,
                                                  itemSize: 15,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 1.0),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: double.parse(shopList[
                                                                    index]
                                                                .reviews_total!) >
                                                            0
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
                                                  "(${shopList[index].reviews_total})",
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
                    },
                  ),
                )
              : Container(),
    );
  }
}
