import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/BottomNavigation/wishlist.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/model/productmodel.dart';
import 'package:royalmart/screen/SearchScreen.dart';
import 'package:royalmart/screen/detailpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OneDAyDelivwery extends StatefulWidget {
  // final String cat, title;
  // const ProductList(this.cat,this.title) : super();

  @override
  _OneDAyProductListState createState() => _OneDAyProductListState();
}

class _OneDAyProductListState extends State<OneDAyDelivwery> with SingleTickerProviderStateMixin {
  TabController ?_tabController;
  bool showFab = true;
  int _current = 0;
  String textval = "Select Variant";

  List<Products> products1 =[];
  void gatinfoCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    int? Count = pref.getInt("itemCount");
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
    getAllProducts(count.toString()).then((usersFromServe) {
      setState(() {
        products1.addAll(usersFromServe!);
        print("" + products1.length.toString());
      });
    });
  }

  int countval = 0;
  @override
  void initState() {
    super.initState();
    gatinfoCount();

    getdata(countval);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          countval = countval + 10;
          getdata(countval);
        });
      }
    });
  }

  int total = 000;
  int actualprice = 00;
  double ?mrp, totalmrp = 00;
  int _count = 1;

  double? sgst1, cgst1, dicountValue, admindiscountprice;

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
            /* appBar: AppBar(
              backgroundColor: AppColors.tela,
              leading: Padding(padding: EdgeInsets.only(left: 0.0),
                  child:InkWell(
                    onTap: (){
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        SystemNavigator.pop();
                      }
                    },

                    child: Icon(
                      Icons.arrow_back,size: 30,
                      color: Colors.white,
                    ),

                  )
              ),



              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text('One Day Delivery',style: TextStyle(color: AppColors.white),),
                    ),
                  ),


                  Row(
                    children: [
                     */
            /* InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserFilterDemo()),
                          );
                        },
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Icon(Icons.search,color: Colors.white,size: 30,),
                            ),
//                    showCircle(),
                          ],
                        ),

                      ),*/
            /*
                      SizedBox(width: 12,),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WishList()),
                          );
                        },
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 13),
                              child: Icon(Icons.add_shopping_cart,color: Colors.white,),
                            ),
                            showCircle(),
                          ],
                        ),
                      )
                    ],
                  ),

                ],
              ),





            ),*/

            floatingActionButton: FloatingActionButton(
              backgroundColor: FoodAppColors.tela,
              onPressed: () {
                // Add your onPressed code here!
              },
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WishList()),
                  );
                },
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20, right: 0, left: 10),
                      child: Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, bottom: 25, top: 0),
                        child: Container(
                          margin: EdgeInsets.only(right: 10, top: 5),
                          padding: const EdgeInsets.all(5.0),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: FoodAppColors.tela1,
                          ),
                          child: Text('${FoodAppConstant.foodAppCartItemCount}', style: TextStyle(color: FoodAppColors.tela, fontSize: 15.0)),
                        ),
                      ),
                    ),
                    // ScreenState.showCircle(),
                  ],
                ),
              ),

              /*Container(

              padding: const EdgeInsets.all(5.0),
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.telamoredeep,
              ),
              child: Text('${Constant.carditemCount}',
                  style: TextStyle(color: Colors.white, fontSize: 15.0)),
            ),*/
            ),
            body: Column(
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

                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemCount: products1.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(left: 2, right: 2, top: 6, bottom: 6),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(products1[index])),);
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                                        width: 110,
                                        height: 110,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(14)),
                                            color: Colors.blue.shade200,
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                  products1[index].img != null
                                                      ? FoodAppConstant.Product_Imageurl + products1[index].img!
                                                      : "https://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg",
                                                ))),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  products1[index].productName == null ? 'name' : products1[index].productName??"",
                                                  overflow: TextOverflow.fade,
                                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black)
                                                      .copyWith(fontSize: 14),
                                                ),
                                              ),
                                              SizedBox(height: 6),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                                                child: Text('${products1[index].moq} kg',
                                                    style: TextStyle(
                                                      color: FoodAppColors.mrp,
                                                      // fontWeight: FontWeight.w700,
                                                    )),
                                              ),
                                              SizedBox(height: 6),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                                                    child: Text('\u{20B9} ${calDiscount(products1[index].buyPrice??"", products1[index].discount??"")}',
                                                        style: TextStyle(
                                                          color: FoodAppColors.sellp,
                                                          // fontWeight: FontWeight.w700,
                                                        )),
                                                  ),
                                                  // SizedBox(width: 20,),
                                                  Expanded(
                                                    child: Text(
                                                      ' /kg',
                                                      // child: Text('(\u{20B9} ${products1[index].buyPrice})',
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.w700,
                                                        // fontStyle: FontStyle.italic,
                                                        color: FoodAppColors.sellp,
                                                        // decoration: TextDecoration.lineThrough
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),

                                              /*products1[index].p_id==null?Container(): Padding(
                                                  padding: const EdgeInsets.only(left:6.0,top: 8.0),
                                                  child: InkWell(
                                                    onTap: (){

                                                      _displayDialog(context,products1[index].productIs,index);
                                                      // _showSelectionDialog(context);
                                                    },
                                                    child: Container(

                                                      width: MediaQuery.of(context).size.width/2,
                                                      padding: const EdgeInsets.only(left:5.0,top: 0.0,right:5.0,),
                                                      margin: const EdgeInsets.only(top: 5.0,),



                                                      child:  Center(child:Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(left: 10,right: 0),
                                                            child: Text(
                                                              // textval.length>15?textval.substring(0,15)+"..": textval,
                                                              products1[index].youtube.length>1? products1[index].youtube.length>15?products1[index].youtube.substring(0,15)+"..":products1[index].youtube: textval,

                                                              overflow:TextOverflow.fade,
                                                              // maxLines: 2,
                                                              style: TextStyle(
                                                                fontSize: 15,color:AppColors.black,

                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets.only(left: 0),
                                                              child:Icon(Icons.expand_more, color: Colors.black,size: 30,)
                                                          )

                                                        ],
                                                      )  ),

                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey)
                                                      ),
                                                    ),
                                                  )
                                              ),*/

                                              Container(
                                                margin: EdgeInsets.only(left: 0.0, right: 10),
                                                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                                                  SizedBox(
                                                    width: 0.0,
                                                    height: 10.0,
                                                  ),

                                                  Column(
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: <Widget>[
                                                          GestureDetector(
                                                            onTap: () {
                                                              print(products1[index].count);
                                                              if (products1[index].count != "1" && int.parse(products1[index].count??"") > 1) {
                                                                setState(() {
                                                                  print("products1[index].count");
                                                                  print(products1[index].count);
                                                                  print(products1[index].count != "0");
//                                                                                _count++;

                                                                  String quantity = products1[index].count??"";
                                                                  print(int.parse(products1[index].moq??""));
                                                                  int totalquantity = int.parse(quantity) - int.parse(products1[index].moq??"");
                                                                  products1[index].count = totalquantity.toString();
                                                                });
                                                              }

//
                                                            },
                                                            child: Container(
                                                                height: 35,
                                                                width: 35,
                                                                child: Material(
                                                                  color: FoodAppColors.teladep,
                                                                  elevation: 0.0,
                                                                  shape: RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                      color: Colors.white,
                                                                    ),
                                                                    borderRadius: BorderRadius.all(
                                                                      Radius.circular(17),
                                                                    ),
                                                                  ),
                                                                  clipBehavior: Clip.antiAlias,
                                                                  child: Padding(
                                                                    padding: EdgeInsets.only(bottom: 10),
                                                                    child: InkWell(
                                                                        child: Padding(
                                                                      padding: EdgeInsets.only(
                                                                        top: 15.0,
                                                                      ),
                                                                      child: Icon(
                                                                        Icons.maximize,
                                                                        size: 20,
                                                                        color: Colors.white,
                                                                      ),
                                                                    )),
                                                                  ),
                                                                )),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 0.0, left: 15.0, right: 8.0),
                                                            child: Center(
                                                              child: Text(
                                                                  products1[index].count != null
                                                                      ? products1[index].count == "1"
                                                                          ? "0"
                                                                          : '${products1[index].count}'
                                                                      : '$_count',
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 19,
                                                                      fontFamily: 'Roboto',
                                                                      fontWeight: FontWeight.bold)),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              if (int.parse(products1[index].count??"") <= int.parse(products1[index].quantityInStock??"")) {
                                                                setState(() {
//                                                                                _count++;

                                                                  String quantity = products1[index].count??"";
                                                                  int totalquantity =
                                                                      int.parse(quantity == "1" ? "0" : quantity) + int.parse(products1[index].moq??"");
                                                                  products1[index].count = totalquantity.toString();
                                                                });
                                                              } else {
                                                                showLongToast('Only  ${products1[index].count}  product(s) in stock ');
                                                              }
                                                            },
                                                            child: Container(
                                                                margin: EdgeInsets.only(left: 3.0),
                                                                height: 35,
                                                                width: 35,
                                                                child: Material(
                                                                  color: FoodAppColors.teladep,
                                                                  elevation: 0.0,
                                                                  shape: RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                      color: Colors.white,
                                                                    ),
                                                                    borderRadius: BorderRadius.all(
                                                                      Radius.circular(17),
                                                                    ),
                                                                  ),
                                                                  clipBehavior: Clip.antiAlias,
                                                                  child: InkWell(
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      size: 20,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  // SizedBox(width: 25,),
                                                ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  products1[index].count == "1" || products1[index].count == "0"
                                      ? Container()
                                      : Container(
                                          // height: 30,
                                          color: Colors.black12,
                                          padding: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                                                child: Text(
                                                    '\u{20B9} ${int.parse(calDiscount(products1[index].buyPrice??"", products1[index].discount??"")) * int.parse((products1[index].count??""))}',
                                                    style: TextStyle(
                                                      color: FoodAppColors.sellp,
                                                      fontWeight: FontWeight.w700,
                                                    )),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Container(
                                                      margin: EdgeInsets.only(left: 10.0),
                                                      padding: EdgeInsets.only(left: 10.0),
                                                      height: 30,
                                                      width: 70,
                                                      child: Material(
                                                        color: FoodAppColors.sellp,
                                                        elevation: 0.0,
                                                        shape: RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                        ),
                                                        clipBehavior: Clip.antiAlias,
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (FoodAppConstant.isLogin) {
                                                              String mrp_price = calDiscount(products1[index].buyPrice??"", products1[index].discount??"");
                                                              totalmrp = double.parse(mrp_price);
                                                              double dicountValue = double.parse(products1[index].buyPrice??"") - totalmrp!;
                                                              String gst_sgst = calGst(mrp_price, products1[index].sgst??"");
                                                              String gst_cgst = calGst(mrp_price, products1[index].cgst??"");

                                                              String adiscount = calDiscount(products1[index].buyPrice??"",
                                                                  products1[index].msrp != null ? products1[index].msrp ??"": "0");

                                                              admindiscountprice =
                                                                  (double.parse(products1[index].buyPrice??"") - double.parse(adiscount));
                                                              String color = "";
                                                              String size = "";
                                                              _addToproducts(
                                                                  products1[index].productIs??"",
                                                                  products1[index].productName??"",
                                                                  products1[index].img??"",
                                                                  int.parse(mrp_price),
                                                                  int.parse(products1[index].count??""),
                                                                  color,
                                                                  size,
                                                                  products1[index].productDescription??"",
                                                                  gst_sgst,
                                                                  gst_cgst,
                                                                  products1[index].discount??"",
                                                                  dicountValue.toString(),
                                                                  products1[index].APMC??"",
                                                                  admindiscountprice.toString(),
                                                                  products1[index].buyPrice??"",
                                                                  products1[index].shipping??"",
                                                                  products1[index].quantityInStock??"",
                                                                  products1[index].youtube??"",
                                                                  products1[index].mv??"",
                                                                  products1[index].moq??"");

                                                              setState(() {
                                                                products1[index].count = "1";
                                                              });
//                                                         setState(() {
//
//                                                           Foo foo= new Foo();
//                                                           // int val=Constant.carditemCount++;
//
// //                                                                 Foo              cartvalue++;
// //                                                               Constant.carditemCount=
//                                                           Constant.carditemCount++;
//                                                           foo.weight=Constant.carditemCount;
//
//                                                           cartItemcount(Constant.carditemCount);
//
//                                                         });

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
                                                                  style: TextStyle(fontSize: 12, color: FoodAppColors.white),
                                                                ),
                                                              )),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )));
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
      String totalQun,
      String varient,
      String mv,
      String moq) {
    try {
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
        Future<int> val;
        int value;
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
            totalQuantity: totalQun,
            varient: varient,
            mv: int.parse(mv),
            moq: moq);

        dbmanager.insertStudent(st).then((id) => {
              showLongToast(" Products  is upadte to cart ${id}' "),
              setState(() {
                FoodAppConstant.foodAppCartItemCount++;
                foodCartItemCount(FoodAppConstant.foodAppCartItemCount);
              })
            });

        // Future<int> value= dbmanager.insertStudent(st);

      }
    } catch (Exception) {}
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

/*
  _displayDialog(BuildContext context, String id, int index1) async {
    return showDialog(
        context: context,
        barrierDismissible:false,
        builder: (context) {
          return AlertDialog(
            scrollable:true,
            title: Text('Select Variant'),
            content: Container(
              width: double.maxFinite,
              height: 200,
              child: FutureBuilder(
                  future: getPvarient(id),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      return  ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.length == null
                              ? 0
                              : snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return
                              Container(
                                width: snapshot.data[index]!=0?130.0:230.0,
                                color: Colors.white,
                                margin: EdgeInsets.only(right: 10),

                                child: InkWell(
                                  onTap: () {
                                    setState(() {

                                      products1[index1].buyPrice=snapshot.data[index].price;
                                      products1[index1].discount=snapshot.data[index].discount;


                                      // total= int.parse(snapshot.data[index].price);
                                      // String  mrp_price=calDiscount(snapshot.data[index].price,snapshot.data[index].discount);
                                      // totalmrp= double.parse(mrp_price);
                                      products1[index1].youtube=snapshot.data[index].variant;

                                      Navigator.pop(context);

                                    });

                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10,right: 10),
                                        child: Text(
                                          snapshot.data[index].variant,
                                          overflow:TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 15,color:AppColors.black,

                                          ),
                                        ),
                                      ),
                                      Divider(

                                        color: AppColors.black,
                                      ),





                                    ],
                                  ),
                                ),







                              )
                            ;
                          });

                    }
                    return Center(child: CircularProgressIndicator());


                  }
              )


              ,
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
*/

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
