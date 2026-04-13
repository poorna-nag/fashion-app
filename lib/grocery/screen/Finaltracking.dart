import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/dbhelper/database_helper.dart';
import 'package:royalmart/grocery/model/CancleandRefundmodel.dart';
import 'package:royalmart/grocery/model/InvoiceTrackmodel.dart';
import 'package:royalmart/grocery/screen/detailpage.dart';
import 'package:http/http.dart' as http;
import 'package:royalmart/grocery/screen/detailpage1.dart';
import 'package:royalmart/grocery/screen/myorder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:royalmart/grocery/StyleDecoration/styleDecoration.dart';

class FinalOrderTracker extends StatelessWidget {
  final String? invoiceno;
  final String? dateval;
  final String? status;
  int? difference;
  int? daliverydate;
  FinalOrderTracker(this.invoiceno, this.dateval, this.status);
  List<String>? list;
  getSuvstring() {
    String date = dateval!.substring(0, 10);
    list = date.split("-");
    int a = int.parse(list![0]);
    int b = int.parse(list![1]);
    int c = int.parse(list![2]);
    daliverydate = int.parse(list![2]);
    final birthday = DateTime(a, b, c);
    final date2 = DateTime.now();

    difference = date2.difference(birthday).inDays;
  }

  @override
  Widget build(BuildContext context) {
    getSuvstring();
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.5, 1.0],
              colors: [
                Color(0xFFF8F9FA),
                Color(0xFFFFE8F0),
                Color(0xFFE91E63),
              ],
            ),
          ),
        ),
        leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "My Orders",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Column(
        children: <Widget>[
//          createHeader(),
//        createSubTitle(),
          Expanded(
              child: FutureBuilder(
                  future: trackInvoiceOrder(invoiceno ?? ""),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length == null
                            ? 0
                            : snapshot.data?.length,
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          InvoiceInvoice item = snapshot.data![index];
                          return Stack(
                            children: <Widget>[
//                              Expanded(
////              padding: EdgeInsets.only(right: 8, top: 4),
//                                child: Container(
//                                  margin: EdgeInsets.only(left: 10,right: 10),
//                                  child: Text(item.productName==null? 'name':item.productName,
//                                    maxLines: 2,
//                                    softWrap: true,
//                                    style:TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black)
//                                        .copyWith(fontSize: 14),
//                                  ),
//                                ),
//                              ),

                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetails1(
                                            item.productId ?? "")),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 16, top: 16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 8,
                                            left: 0,
                                            top: 8,
                                            bottom: 8),
                                        width: 90,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xFFE91E63)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14)),
                                            color: Colors.blue.shade200,
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                  GroceryAppConstant
                                                          .Product_Imageurl1 +
                                                      item.image.toString(),
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
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    child: Expanded(
                                                      child: Text(
                                                        item.productName == null
                                                            ? 'name'
                                                            : item.productName ??
                                                                "",
                                                        maxLines: 2,
                                                        softWrap: true,
                                                        style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black)
                                                            .copyWith(
                                                                fontSize: 14),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: 6),
                                              Row(
                                                children: <Widget>[
                                                  item.color != null
                                                      ? item.color!.length > 0
                                                          ? Text(
                                                              'COLOR: ${item.color}',
                                                              style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black)
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          14),
                                                            )
                                                          : Row()
                                                      : Row(),
                                                  SizedBox(width: 20),
                                                ],
                                              ),

                                              item.quantity != null
                                                  ? Text(
                                                      'Quantity: ${item.quantity}',
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
                                                  : Row(),
//                      SizedBox(height: 3),
                                              item.size != null
                                                  ? item.size!.length > 0
                                                      ? Text(
                                                          'Size: ${item.size}',
                                                          style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black)
                                                              .copyWith(
                                                                  color: Colors
                                                                      .grey,
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
                                                      item.price == null
                                                          ? '100'
                                                          : '\u{20B9} ${calDiscount(item.price ?? "", item.userPer ?? "")}',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ).copyWith(
                                                          color: Colors.green),
                                                    ),
                                                    status == "Delivered"
                                                        ? ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Color(
                                                                      0xFFE91E63),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              24))),
                                                            ),
                                                            onPressed: () {
                                                              showDilogueReviw(
                                                                  context,
                                                                  item.productId ??
                                                                      "");
                                                            },
                                                            child: Text(
                                                              "Review",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          )
                                                        : Row(),

                                                    //Add review Button
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
                            ],
                          );
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  })),
          footer(context),
        ],
      ),
    );
  }

  footer(BuildContext context) {
    bool isCancelled = status?.toLowerCase() == 'cancelled';
    bool isDelivered = status?.toLowerCase() == 'delivered';
    bool isShipped = status?.toLowerCase() == 'shipped' || status?.toLowerCase() == 'out for delivery';
    bool isReturned = status?.toLowerCase() == 'returned';

    // Show Cancel button if not delivered, not cancelled, not shipped, and not returned
    bool showCancel = !isDelivered && !isCancelled && !isShipped && !isReturned;
    // Show Return button ONLY if delivered
    bool showReturn = isDelivered;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (showCancel)
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  elevation: 0,
                ),
                onPressed: () {
                  val = "can";
                  showReasonDialog(context);
                },
                child: Text(
                  "Cancel Order",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          if (showReturn)
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  elevation: 0,
                ),
                onPressed: () {
                  val = "rep";
                  showReasonDialog(context);
                },
                child: Text(
                  "Return Item",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          if (!showCancel && !showReturn && !isCancelled && !isReturned)
             Text(
                "Status: ${status ?? 'Updating...'}",
                style: TextStyle(
                  color: Color(0xFFE91E63),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
        ],
      ),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "SHOPPING CART",
      ),
      margin: EdgeInsets.only(left: 12, top: 12),
    );
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

  var _formKey12 = GlobalKey<FormState>();
  String val = "";
  final resignofcause = TextEditingController();
  final resignofcause1 = TextEditingController();
  double? _ratingController;

  showReasonDialog(BuildContext context) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              val == "can" ? "Cancel Order" : "Return Order",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey12,
              child: TextFormField(
                  maxLines: 4,
                  controller: resignofcause,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter the reason";
                    }
                    if (value.trim().length < 5) {
                      return "Reason must be at least 5 characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Reason for ${val == "can" ? "cancellation" : "return"}',
                    labelText: 'Reason',
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFE91E63), width: 2.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                          width: 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  )),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE91E63),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (_formKey12.currentState!.validate()) {
                        cancleandRefund(val, context);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  cancleandRefund(String val, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? mobile = pref.getString("mobile");

    String link = GroceryAppConstant.base_url + "api/order_status.php";
    var map = new Map<String, dynamic>();
    map['user_id'] = mobile;
    map['order_id'] = invoiceno;
    map['status'] = val;
    map['note'] = resignofcause.text;
    map['api_id'] = GroceryAppConstant.Shop_id;
    final response = await http.post(Uri.parse(link), body: map);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(responseData.toString());
      CancleandRefund user =
          CancleandRefund.fromJson(jsonDecode(response.body));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TrackOrder()),
      );

      showLongToast(user.message.toString());
    }
  }

  senReview(BuildContext context, String id) async {
    String link = GroceryAppConstant.base_url + "manage/api/reviews/add";

    print(GroceryAppConstant.user_id);
    print(GroceryAppConstant.API_KEY);
    print(_ratingController.toString());
    print(resignofcause1.text);
    print(id);
    var map = new Map<String, dynamic>();
    map['user_id'] = GroceryAppConstant.user_id;
    map['X-Api-Key'] = GroceryAppConstant.API_KEY;
    map['stars'] =
        (_ratingController!.toStringAsFixed(GroceryAppConstant.val)).toString();
    map['review'] = resignofcause1.text;
    map['shop_id'] = GroceryAppConstant.Shop_id;
    map['product'] = id;
    map['dates'] = " ";
    final response = await http.post(Uri.parse(link), body: map);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(responseData.toString());
      CancleandRefund1 user =
          CancleandRefund1.fromJson(jsonDecode(response.body));
//        Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) => TrackOrder()),);

//        showLongToast("Rivew submitted successfully");
      showLongToast(user.message ?? "");
    } else {
      throw Exception("Nothing is generated");
    }
  }

  showDilogueReviw(BuildContext context, String id) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 250.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey12,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                      maxLines: 4,
//                      keyboardType: TextInputType.number, // Use mobile input type for emails.
                      controller: resignofcause1,
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return " Please enter the review";
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                        hintText: 'Review',
                        labelText: 'Please mention review',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 3.0),
                        ),

//                                      icon: new Icon(Icons.queue_play_next),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 3.0),
                        ),
                      ))),
            ),
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _ratingController = rating;
                print(_ratingController);
              },
            ),
            TextButton(
                onPressed: () {
                  senReview(context, id);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Submit !',
                  style: TextStyle(color: Color(0xFFE91E63), fontSize: 18.0),
                ))
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }
}

//  createSubTitle() {
//    return Container(
//      alignment: Alignment.topLeft,
//      child: Text(
//        'Total (${Constant.itemcount}) Items',
//        style: CustomTextStyle.textFormFieldBold
//            .copyWith(fontSize: 12, color: Colors.grey),
//      ),
//      margin: EdgeInsets.only(left: 12, top: 4),
//    );
//  }
