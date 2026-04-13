import 'package:flutter/material.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/BottomNavigation/wishlist.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/model/productmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryWiseProducts extends StatefulWidget {
  final String? dealName;
  final String? dealType;
  const CategoryWiseProducts({Key? key, this.dealName, this.dealType})
      : super(key: key);

  @override
  State<CategoryWiseProducts> createState() => _CategoryWiseProductsState();
}

class _CategoryWiseProductsState extends State<CategoryWiseProducts> {
  static List<Products> categoryWiseProductList = [];
  bool ?isLoading = true;
  String? textval = "Select variant";
  int? _count = 1;
  SharedPreferences? pref;
  double? mrp, totalmrp = 000;
  double ?sgst1, cgst1, dicountValue, admindiscountprice;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    pref = await SharedPreferences.getInstance();
    if (widget.dealType == "top") {
      DatabaseHelper.getCategoryWiseProducts("top", "0").then((usersFromServe) {
        if (this.mounted) {
          setState(() {
            categoryWiseProductList = usersFromServe!;
            setState(() {
              isLoading = false;
            });
          });
        }
      });
    } else if (widget.dealType == "&featured=yes") {
      DatabaseHelper.getfeature("&featured=yes", "1000").then((usersFromServe) {
        if (this.mounted) {
          setState(() {
            categoryWiseProductList = usersFromServe!;
            setState(() {
              isLoading = false;
            });
          });
        }
      });
    } else if (widget.dealType == "best") {
      DatabaseHelper.getCategoryWiseProducts("best", "0")
          .then((usersFromServe) {
        if (this.mounted) {
          setState(() {
            categoryWiseProductList = usersFromServe!;
            setState(() {
              isLoading = false;
            });
          });
        }
      });
    } else if (widget.dealType == "day") {
      DatabaseHelper.getCategoryWiseProducts("day", "0").then((usersFromServe) {
        if (this.mounted) {
          setState(() {
            categoryWiseProductList = usersFromServe!;
            setState(() {
              isLoading = false;
            });
          });
        }
      });
    } else if (widget.dealType == "new") {
      DatabaseHelper.getNewArrivals().then((usersFromServe) {
        if (this.mounted) {
          setState(() {
            categoryWiseProductList = usersFromServe!;
            setState(() {
              isLoading = false;
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: FoodAppColors.tela,
          title: Text(widget.dealName??""),
        ),
        body: isLoading!
            ? Container(
                child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ))
            : Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  scrollDirection: Axis.vertical,
                  itemCount: categoryWiseProductList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin:
                          EdgeInsets.only(left: 0, right: 0, top: 6, bottom: 6),
                      // decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: InkWell(
                        onTap: () {
                          _modalBottomSheetMenu(index);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(products1[index])),);
                        },
                        child: Card(
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 20,
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
                                        child: Text(
                                          categoryWiseProductList[index]
                                                      .productName ==
                                                  null
                                              ? 'name'
                                              : categoryWiseProductList[index]
                                                  .productName??"",
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black)
                                              .copyWith(fontSize: 14),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2.0, bottom: 1),
                                            child: Text(
                                                '\u{20B9} ${calDiscount(categoryWiseProductList[index].buyPrice??"", categoryWiseProductList[index].discount??"")}',
                                                style: TextStyle(
                                                  color: FoodAppColors.sellp,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '(\u{20B9} ${categoryWiseProductList[index].buyPrice})',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.italic,
                                                  color: FoodAppColors.mrp,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                          )
                                        ],
                                      ),
                                      categoryWiseProductList[index].p_id ==
                                              null
                                          ? Container()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0, top: 8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  _displayDialog(
                                                      context,
                                                      categoryWiseProductList[
                                                              index]
                                                          .productIs??"",
                                                      index);
                                                  // _showSelectionDialog(context);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 5.0,
                                                    top: 0.0,
                                                    right: 5.0,
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                    top: 5.0,
                                                  ),
                                                  child: Center(
                                                      child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 0),
                                                        child: Text(
                                                          // textval.length>15?textval.substring(0,15)+"..": textval,
                                                          categoryWiseProductList[
                                                                          index]
                                                                      .youtube!
                                                                      .length >
                                                                  1
                                                              ? categoryWiseProductList[
                                                                              index]
                                                                          .youtube!
                                                                          .length >
                                                                      15
                                                                  ? categoryWiseProductList[
                                                                              index]
                                                                          .youtube!
                                                                          .substring(
                                                                              0,
                                                                              15) +
                                                                      ".."
                                                                  : categoryWiseProductList[
                                                                          index]
                                                                      .youtube??""
                                                              : textval!,

                                                          overflow:
                                                              TextOverflow.fade,
                                                          // maxLines: 2,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: FoodAppColors
                                                                .black,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 0),
                                                          child: Icon(
                                                            Icons.expand_more,
                                                            color: Colors.black,
                                                            size: 30,
                                                          ))
                                                    ],
                                                  )),
                                                ),
                                              )),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 0.0, right: 10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 0.0,
                                                height: 10.0,
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                margin: EdgeInsets.only(
                                                    left: 0.0, right: 10),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Card(
                                                        color:
                                                            FoodAppColors.white,
                                                        elevation: 0.0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            color: FoodAppColors
                                                                .tela,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(15),
                                                          ),
                                                        ),
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              GestureDetector(
                                                                onTap: () {
                                                                  print(categoryWiseProductList[
                                                                          index]
                                                                      .count);
                                                                  if (categoryWiseProductList[index]
                                                                              .count !=
                                                                          "1" &&
                                                                      int.parse(
                                                                              categoryWiseProductList[index].count??"") >
                                                                          1) {
                                                                    setState(
                                                                        () {
//                                                                                _count++;

                                                                      String?
                                                                          quantity =
                                                                          categoryWiseProductList[index]
                                                                              .count;
                                                                      print(int.parse(
                                                                          categoryWiseProductList[index]
                                                                              .moq??""));
                                                                      int totalquantity = int.parse(
                                                                              quantity??"") -
                                                                          int.parse(
                                                                              categoryWiseProductList[index].moq??"");
                                                                      categoryWiseProductList[index]
                                                                              .count =
                                                                          totalquantity
                                                                              .toString();
                                                                    });
                                                                  }

//
                                                                },
                                                                child:
                                                                    Container(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            20,
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              FoodAppColors.white,
                                                                          elevation:
                                                                              0.0,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            side:
                                                                                BorderSide(
                                                                              color: Colors.white,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.all(
                                                                              Radius.circular(17),
                                                                            ),
                                                                          ),
                                                                          clipBehavior:
                                                                              Clip.antiAlias,
                                                                          child: InkWell(
                                                                              onTap: () {
                                                                                print(categoryWiseProductList[index].count);
                                                                                if (categoryWiseProductList[index].count != "1") {
                                                                                  setState(() {
//                                                                                _count++;

                                                                                    String? quantity = categoryWiseProductList[index].count;
                                                                                    print(int.parse(categoryWiseProductList[index].moq??""));
                                                                                    int totalquantity = int.parse(quantity!) - int.parse(categoryWiseProductList[index].moq??"");
                                                                                    categoryWiseProductList[index].count = totalquantity.toString();
                                                                                  });
                                                                                }
                                                                              },
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(
                                                                                  top: 8.0,
                                                                                ),
                                                                                child: Icon(
                                                                                  Icons.maximize,
                                                                                  size: 20,
                                                                                  color: FoodAppColors.tela,
                                                                                ),
                                                                              )),
                                                                        )),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            0.0,
                                                                        left:
                                                                            15.0,
                                                                        right:
                                                                            8.0),
                                                                child: Center(
                                                                  child: Text(
                                                                      categoryWiseProductList[index].count !=
                                                                              null
                                                                          ? categoryWiseProductList[index].count ==
                                                                                  "1"
                                                                              ? "1"
                                                                              : '${categoryWiseProductList[index].count}'
                                                                          : '$_count',
                                                                      style: TextStyle(
                                                                          color: FoodAppColors
                                                                              .tela,
                                                                          fontSize:
                                                                              15,
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                ),
                                                              ),
                                                              Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              3.0),
                                                                  height: 20,
                                                                  width: 20,
                                                                  child:
                                                                      Material(
                                                                    color: FoodAppColors
                                                                        .white,
                                                                    elevation:
                                                                        0.0,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            17),
                                                                      ),
                                                                    ),
                                                                    clipBehavior:
                                                                        Clip.antiAlias,
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (int.parse(categoryWiseProductList[index].count??"") <=
                                                                            int.parse(categoryWiseProductList[index].quantityInStock??"")) {
                                                                          setState(
                                                                              () {
//                                                                                _count++;

                                                                            String
                                                                                quantity =
                                                                                categoryWiseProductList[index].count??"";
                                                                            int totalquantity =
                                                                                int.parse(quantity) + 1;

                                                                            // int totalquantity=int.parse(quantity=="1"?"0":quantity)+int.parse(products1[index].moq);
                                                                            categoryWiseProductList[index].count =
                                                                                totalquantity.toString();
                                                                          });
                                                                        } else {
                                                                          showLongToast(
                                                                              'Only  ${categoryWiseProductList[index].count}  products in stock ');
                                                                        }
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        size:
                                                                            20,
                                                                        color: FoodAppColors
                                                                            .tela,
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      // SizedBox(width: 25,),
                                                    ]),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: 8, left: 8, top: 8, bottom: 8),
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14)),
                                        color: FoodAppColors.tela1,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              categoryWiseProductList[index]
                                                          .img !=
                                                      null
                                                  ? FoodAppConstant
                                                          .Product_Imageurl +
                                                      categoryWiseProductList[
                                                              index]
                                                          .img!
                                                  : "https://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg",
                                            ))),
                                  ),
                                  /*Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[

                                            Container(
                                                margin: EdgeInsets.only(top: 100.0,left:30.0),
                                                height: 30,
                                                width: 70,

                                                child:
                                                Material(

                                                  color: AppColors.white,
                                                  elevation: 0.0,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      color: AppColors.tela,
                                                    ),
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                  ),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: InkWell(
                                                    onTap: () {


                                                      if(Constant.isLogin){

                                                        String mv=  pref.getString("mvid",);
                                                        if(mv==null||mv.isEmpty||products1[index].mv==pref.getString("mvid")) {
                                                          pref.setString("mvid",products1[index].mv);
                                                          print(pref.getString("mvid"));



                                                          String mrp_price = calDiscount(
                                                              products1[index]
                                                                  .buyPrice,
                                                              products1[index]
                                                                  .discount);
                                                          totalmrp =
                                                              double
                                                                  .parse(
                                                                  mrp_price);


                                                          double dicountValue = double
                                                              .parse(
                                                              products1[index]
                                                                  .buyPrice) -
                                                              totalmrp;
                                                          String gst_sgst = calGst(
                                                              mrp_price,
                                                              products1[index]
                                                                  .sgst);
                                                          String gst_cgst = calGst(
                                                              mrp_price,
                                                              products1[index]
                                                                  .cgst);

                                                          String adiscount = calDiscount(
                                                              products1[index]
                                                                  .buyPrice,
                                                              products1[index]
                                                                  .msrp !=
                                                                  null
                                                                  ? products1[index]
                                                                  .msrp
                                                                  : "0");

                                                          admindiscountprice =
                                                          (double
                                                              .parse(
                                                              products1[index]
                                                                  .buyPrice) -
                                                              double
                                                                  .parse(
                                                                  adiscount));


                                                          String color = "";
                                                          String size = "";

                                                          // String mv=  pref.getString("mvid",);

                                                          _addToproducts(
                                                              products1[index]
                                                                  .productIs,
                                                              products1[index]
                                                                  .productName,
                                                              products1[index]
                                                                  .img,
                                                              int
                                                                  .parse(
                                                                  mrp_price),
                                                              int
                                                                  .parse(
                                                                  products1[index]
                                                                      .count),
                                                              color,
                                                              size,
                                                              products1[index]
                                                                  .productDescription,
                                                              gst_sgst,
                                                              gst_cgst,
                                                              products1[index]
                                                                  .discount,
                                                              dicountValue
                                                                  .toString(),
                                                              products1[index]
                                                                  .APMC,
                                                              admindiscountprice
                                                                  .toString(),
                                                              products1[index]
                                                                  .buyPrice,
                                                              products1[index]
                                                                  .shipping,
                                                              products1[index]
                                                                  .quantityInStock,
                                                              products1[index]
                                                                  .youtube,
                                                              products1[index]
                                                                  .mv);




//                                                                Navigator.push(context,
//                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);
                                                        }



                                                        else{



                                                          showAlertDialog(context,products1[index]);



                                                        }


                                                      }





                                                      else{


                                                        Navigator.push(context,
                                                          MaterialPageRoute(builder: (context) => SignInPage()),);
                                                      }

//

                                                    },
                                                    child:Padding(padding: EdgeInsets.only(left: 5,top: 5,bottom: 5,right: 5),
                                                        child:Center(

                                                            child:Text("ADD",style: TextStyle(color: AppColors.tela),)
                                                          // Icon(Icons.add_shopping_cart,color: Colors.white,),

                                                        )),),
                                                )),









                                          ],
                                        ),

                                      ],
                                    ),*/

                                  addProduct(index, 0)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ));
  }

  void _modalBottomSheetMenu(int index) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return new Container(
            height: MediaQuery.of(context).size.height / 2,

            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      color: Colors.blue.shade200,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            categoryWiseProductList[index].img != null
                                ? FoodAppConstant.Base_Imageurl +
                                    categoryWiseProductList[index].img!
                                : "ttps://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg",
                          ))),
                ),
                Container(
                  margin:
                      EdgeInsets.only(right: 8, left: 10, top: 8, bottom: 8),
                  child: Text(
                    categoryWiseProductList[index].productName == null
                        ? 'name'
                        : categoryWiseProductList[index].productName??"",
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)
                        .copyWith(fontSize: 14),
                  ),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Text(
                    "${categoryWiseProductList[index].productDescription}",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 2.0, bottom: 1, left: 10),
                      child: Text(
                          '\u{20B9} ${calDiscount(categoryWiseProductList[index].buyPrice??"", categoryWiseProductList[index].discount??"")}',
                          style: TextStyle(
                            color: FoodAppColors.sellp,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        '(\u{20B9} ${categoryWiseProductList[index].buyPrice})',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            color: FoodAppColors.mrp,
                            decoration: TextDecoration.lineThrough),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 20),
                        child: addProduct(index, 1)),
                  ],
                ),
              ],
            ),
          );
        });
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

  _displayDialog(BuildContext context, String id, int index1) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Select Varant'),
            content: Container(
              width: double.maxFinite,
              height: 200,
              child: FutureBuilder(
                  future: getPvarient(id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length == null
                              ? 0
                              : snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: snapshot.data![index] != 0 ? 130.0 : 230.0,
                              color: Colors.white,
                              margin: EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    categoryWiseProductList[index1].buyPrice =
                                        snapshot.data![index].price;
                                    categoryWiseProductList[index1].discount =
                                        snapshot.data![index].discount;

                                    // total= int.parse(snapshot.data[index].price);
                                    // String  mrp_price=calDiscount(snapshot.data[index].price,snapshot.data[index].discount);
                                    // totalmrp= double.parse(mrp_price);
                                    categoryWiseProductList[index1].youtube =
                                        snapshot.data![index].variant;

                                    Navigator.pop(context);
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        snapshot.data![index].variant??"",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: FoodAppColors.black,
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: FoodAppColors.black,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                    return Center(child: CircularProgressIndicator());
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

  Widget addProduct(int index, int val) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(
                      top: val == 0 ? 100.0 : 10, left: val == 0 ? 30.0 : 20),
                  height: 30,
                  width: 70,
                  child: Material(
                    color: FoodAppColors.white,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: FoodAppColors.tela,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        if (FoodAppConstant.isLogin) {
                          String? mv = pref!.getString(
                            "mvid",
                          );
                          if (mv == null ||
                              mv.isEmpty ||
                              categoryWiseProductList[index].mv ==
                                  pref!.getString("mvid")) {
                            pref!.setString(
                                "mvid", categoryWiseProductList[index].mv??"");
                            print(pref!.getString("mvid"));

                            String mrp_price = calDiscount(
                                categoryWiseProductList[index].buyPrice??"",
                                categoryWiseProductList[index].discount??"");
                            totalmrp = double.parse(mrp_price);

                            double dicountValue = double.parse(
                                    categoryWiseProductList[index].buyPrice??"") -
                                totalmrp!;
                            String gst_sgst = calGst(
                                mrp_price, categoryWiseProductList[index].sgst??"");
                            String gst_cgst = calGst(
                                mrp_price, categoryWiseProductList[index].cgst??"");

                            String adiscount = calDiscount(
                                categoryWiseProductList[index].buyPrice??"",
                                categoryWiseProductList[index].msrp != null
                                    ? categoryWiseProductList[index].msrp??""
                                    : "0");

                            admindiscountprice = (double.parse(
                                    categoryWiseProductList[index].buyPrice??"") -
                                double.parse(adiscount));

                            String color = "";
                            String size = "";

                            // String mv=  pref.getString("mvid",);

                            _addToproducts(
                                categoryWiseProductList[index].productIs??"",
                                categoryWiseProductList[index].productName??"",
                                categoryWiseProductList[index].img!,
                                int.parse(mrp_price),
                                int.parse(categoryWiseProductList[index].count??""),
                                color,
                                size,
                                categoryWiseProductList[index]
                                    .productDescription??"",
                                gst_sgst,
                                gst_cgst,
                                categoryWiseProductList[index].discount??"",
                                dicountValue.toString(),
                                categoryWiseProductList[index].APMC??"",
                                admindiscountprice.toString(),
                                categoryWiseProductList[index].buyPrice??"",
                                categoryWiseProductList[index].shipping??"",
                                categoryWiseProductList[index].quantityInStock??"",
                                categoryWiseProductList[index].youtube??"",
                                categoryWiseProductList[index].mv??"");

//                                                                Navigator.push(context,
//                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);
                          } else {
                            showAlertDialog(
                                context, categoryWiseProductList[index]);
                          }
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()),
                          );
                        }

//
                      },
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 5, top: 5, bottom: 5, right: 5),
                          child: Center(
                              child: Text(
                            "ADD",
                            style: TextStyle(color: FoodAppColors.tela),
                          )
                              // Icon(Icons.add_shopping_cart,color: Colors.white,),

                              )),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
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

  final DbProductManager dbmanager = new DbProductManager();

  ProductsCart? products2;
//cost_price=buyprice

  void _addToproducts(
      String? pID,
      String? p_name,
      String? image,
      int? price,
      int? quantity,
      String? c_val,
      String? p_size,
      String? p_disc,
      String? sgst,
      String? cgst,
      String? discount,
      String? dis_val,
      String? adminper,
      String? adminper_val,
      String? cost_price,
      String? shippingcharge,
      String? totalQun,
      String? varient,
      String? mv) {
    ProductsCart st = new ProductsCart(
        pid: pID,
        pname: p_name,
        pimage: image,
        pprice: (price !* quantity!).toString(),
        pQuantity: quantity,
        pcolor: c_val ?? "",
        psize: p_size ?? "",
        pdiscription: p_disc,
        sgst: sgst,
        cgst: cgst,
        discount: discount,
        discountValue: dis_val,
        adminper: adminper,
        adminpricevalue: adminper_val,
        costPrice: cost_price,
        shipping: shippingcharge,
        totalQuantity: totalQun,
        varient: varient,
        mv: int.parse(mv!));
    dbmanager.getProductList1(pID!).then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          if (usersFromServe.length > 0) {
            products2 = usersFromServe[0];
            st.quantity = products2!.quantity! + st.quantity!;
            st.pprice = (double.parse(products2!.pprice!) + (totalmrp! * quantity))
                .toString();

            // st.quantity++;
            if (st.quantity!<= int.parse(totalQun!)) {
              dbmanager.updateStudent1(st).then((id) => {
                    showLongToast('Product added to your cart'),
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WishList(),
                      ),
                    ),
                  });
            } else {
              showLongToast('Product added to your cart');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WishList(),
                ),
              );
            }
          } else {
            dbmanager.insertStudent(st).then((id) => {
                  showLongToast('Product added to your cart'),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WishList(),
                    ),
                  ),
                  setState(() {
                    FoodAppConstant.foodAppCartItemCount++;
                    foodCartItemCount(FoodAppConstant.foodAppCartItemCount);
                  })
                });
          }
        });
      }
    });
  }

  showAlertDialog(BuildContext context, Products pro) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        dbmanager.deleteallProducts();

        FoodAppConstant.itemcount = 0;
        FoodAppConstant.foodAppCartItemCount = 0;
        foodCartItemCount(FoodAppConstant.foodAppCartItemCount);

        String mrp_price = calDiscount(pro.buyPrice??"", pro.discount??"");
        totalmrp = double.parse(mrp_price);
        String color = "";
        String size = "";
        double dicountValue = double.parse(pro.buyPrice??"") - totalmrp!;
        String gst_sgst = calGst(mrp_price, pro.sgst??"");
        String gst_cgst = calGst(mrp_price, pro.cgst??"");
        String adiscount =
            calDiscount(pro.buyPrice??"", pro.msrp != null ? pro.msrp??"" : "0");
        admindiscountprice =
            (double.parse(pro.buyPrice??"") - double.parse(adiscount));

        pref!.setString("mvid", pro.mv??"");
        _addToproducts(
            pro.productIs,
            pro.productName,
            pro.img,
            int.parse(mrp_price),
            int.parse(pro.count??""),
            color,
            size,
            pro.productDescription,
            gst_sgst,
            gst_cgst,
            pro.discount,
            dicountValue.toString(),
            pro.APMC,
            admindiscountprice.toString(),
            pro.buyPrice,
            pro.shipping,
            pro.quantityInStock,
            pro.youtube,
            pro.mv);

        setState(() {
//                                                                              cartvalue++;
//           Constant.carditemCount++;
//           cartItemcount(Constant.carditemCount);

          Navigator.of(context).pop();
          // _ProductList1Stateq.val=Constant.carditemCount++;
        });

        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductShow(widget.cat,widget.title)),);
      },
    );
    Widget continueButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Replace cart item?",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
          "Your cart contains dishes from different Restaurant. Do you want to discard the selection and add this " +
              pro.productName!),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
