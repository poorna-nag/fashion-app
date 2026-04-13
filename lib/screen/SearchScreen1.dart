import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/model/ListModel.dart';
import 'package:royalmart/screen/SubCategry.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class UserVenderSerch extends StatefulWidget {
  UserVenderSerch() : super();

//  final String title = "Requet Users";

  @override
  UserVenderSerchState createState() => UserVenderSerchState();
}

class Debouncer {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}

class UserVenderSerchState extends State<UserVenderSerch> {
  // https://jsonplaceholder.typicode.com/users
  double _currentSliderValue = 10;

  final _debouncer = Debouncer(milliseconds: 500);
  List<ListModel> users =[];
  List<ListModel> suggestionList =[];
  bool _progressBarActive = false;
  int _current = 0;
  int total = 000;
  int actualprice = 200;
  double ?mrp, totalmrp = 000;
  int _count = 1;
  double? distance;
  bool flag = false;

  double? sgst1, cgst1, dicountValue, admindiscountprice;

  @override
  void initState() {
    super.initState();

    searchvender("", FoodAppConstant.rad).then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          users = usersFromServe!;
          suggestionList = users;
          suggestionList.length > 0 ? flag = false : flag = true;

          // print(filteredUsers.length.toString()+" jkjg");
        });
      }
    });

//    search("").then((usersFromServe) {
//      setState(() {
//        users = usersFromServe;
//        suggestionList = users;
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                size: 30,
                color: Colors.white,
              ),
            )),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width - 90,
              padding: EdgeInsets.symmetric(
//              vertical: 10,
//                  horizontal: 10,
                  ),
              child: Material(
                color: Colors.white,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                    child: Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: TextField(
                    onChanged: (string) {
                      if (string != null) {
                        searchvender(string, FoodAppConstant.rad).then((usersFromServe) {
                          setState(() {
                            users = usersFromServe!;
                            if (users != null) {
                              suggestionList = users;
                              suggestionList.length > 0 ? flag = false : flag = true;
                            }
                          });
                        });
                      }

                      _debouncer.run(() {
                        setState(() {
                          suggestionList = users
                              .where((u) => (u.company!.toLowerCase().contains(string.toLowerCase()) ||
                                  u.address!.toLowerCase().contains(string.toLowerCase()) ||
                                  u.name!.toLowerCase().contains(string.toLowerCase())))
                              .toList();
                          suggestionList.length > 0 ? flag = false : flag = true;
                        });
                      });
                    },
                    style: TextStyle(color: Colors.green[900]),
                    decoration: InputDecoration(
                      hintText: 'Search  Shop',
                      hintStyle: TextStyle(color: Colors.teal[200]),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "Select distance ${FoodAppConstant.rad} km ",
              style: TextStyle(fontSize: 17),
            ),
          ),
          Slider(
            value: double.parse(FoodAppConstant.rad),
            min: 10,
            max: 200,
            divisions: 20,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
                distance = value;
                FoodAppConstant.rad = _currentSliderValue.toStringAsFixed(2).toString();
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserVenderSerch()),);
              });
            },
            onChangeEnd: (double value) {
              setState(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserVenderSerch()),
                );
              });
            },
          ),
          flag
              ? Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("NO SHOP IS AVALIABLE "),
                    ),
                  ),
                )
              : Expanded(
                  child: suggestionList.length > 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          itemCount: suggestionList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(left: 5, right: 5, top: 6, bottom: 6),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                              child: InkWell(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailofSafe(suggestionList[index].mvId,suggestionList[index].pp)),);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Sbcategory(suggestionList[index].company??"", suggestionList[index].mvId??"", suggestionList[index].cat??"")),
                                  );
                                },
                                child: Card(
                                  shadowColor: Colors.grey,
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(right: 5, left: 3, top: 8, bottom: 8),
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(14)),
                                              color: Colors.blue.shade200,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: suggestionList[index].pp != null
                                                      ? suggestionList[index].pp == "no-pp.png"
                                                          ? AssetImage("assets/images/logo.png")as ImageProvider
                                                          : NetworkImage(FoodAppConstant.logo_Image_mv + suggestionList[index].pp!)
                                                      : AssetImage("assets/images/logo.png"))),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 3.0, top: 5, right: 4, bottom: 5),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    suggestionList[index].company??"",
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black)
                                                        .copyWith(fontSize: 17),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    suggestionList[index].address ??""+ " " + suggestionList[index].city!,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey)
                                                        .copyWith(fontSize: 14),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            suggestionList[index].mobile.toString(),
                                                            maxLines: 2,
                                                            overflow: TextOverflow.fade,
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.black,
                                                            ).copyWith(fontSize: 14),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                          width: 10,
                                                        ),

                                                        // SizedBox(width:10 ),
                                                        /*RatingBarIndicator(
                                              rating: 3.5,
                                              itemCount: 5,
                                              itemSize: 20.0,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            ),*/
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
        ],
      ),
    );
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

  final DbProductManager dbmanager = new DbProductManager();

  ProductsCart? products1;
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
      String varient) {
    if (products1 == null) {
      print(cost_price);
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
          varient: varient);
      dbmanager.insertStudent(st).then((id) => {showLongToast(" Products  is added to cart "), print(' Added to Db ${id}')});
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

  String textVal = "Select Variant";

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
/* _displayDialog(BuildContext context, String id, int index1) async {
    return showDialog(
        context: context,
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

                                      suggestionList[index1].buyPrice=snapshot.data[index].price;
                                      suggestionList[index1].discount=snapshot.data[index].discount;


                                      // total= int.parse(snapshot.data[index].price);
                                      // String  mrp_price=calDiscount(snapshot.data[index].price,snapshot.data[index].discount);
                                      // totalmrp= double.parse(mrp_price);
                                      suggestionList[index1].youtube=snapshot.data[index].variant;

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
  }*/

}
