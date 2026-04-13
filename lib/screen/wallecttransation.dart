import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/model/check_plan_active.dart';
import 'package:royalmart/model/CustmerModel.dart';
import 'package:royalmart/model/OrderShow.dart';
import 'package:royalmart/model/banktransation.dart';
import 'package:royalmart/screen/add_money.dart';
import 'package:royalmart/screen/send_money_new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WalltReport extends StatefulWidget {
  bool? ShowAppBar;
  WalltReport({@required this.ShowAppBar});
  @override
  _WalltReportState createState() => _WalltReportState();
}

class _WalltReportState extends State<WalltReport> {
  List<ShowOrderDetail> orderlist = <ShowOrderDetail>[];
  static const int PAGE_SIZE = 10;
  int _current = 0;
  List<String>? list;
  var newDate;
  String wallet = "0";
  String? md5Key;
  ValueNotifier dialogLoader = ValueNotifier(false);
  TextEditingController amountController = TextEditingController();
  TextEditingController userNoteController = TextEditingController();
  List<CustmerModel> walletlist = [];
  bool isLoading = false;

  Future<void> getvalue() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String? wal = pre.getString("wallet");
    String? user_id = pre.getString("user_id");
    print("user--------->${user_id}");

    setState(() {
      wallet = wal ?? '';
      GroceryAppConstant.user_id = user_id!;
    });
  }

  String? membership_id;
  Future checkPlanActivate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var username = pref.getString("mobile");
    log(username.toString());
    var map = new Map<String, dynamic>();
    map['shop_id'] = GroceryAppConstant.Shop_id;
    map['username'] = username;

    String link = GroceryAppConstant.base_url + "api/user_mlm_plan.php";

    final response = await http.post(Uri.parse(link), body: map);
    log(response.body.toString() + map.toString());
    if (response.statusCode == 200) {
      CheckPlanActive user =
          CheckPlanActive.fromJson(jsonDecode(response.body));
      log("idvs  res" + response.body.toString());
      if (user.success == "true") {
        membership_id = user.membershipId;
        log("idvs" + membership_id.toString());
      }
    } else
      throw Exception("Unable to get Employee list");
  }

  @override
  void initState() {
    super.initState();
    checkPlanActivate();
    getvalue();
    init();
  }

  init() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    SharedPreferences preff = await SharedPreferences.getInstance();
    String? user_id = pre.getString("user_id");
    print("user id wallet function--------->$user_id");
    setState(() {
      isLoading = true;
    });
    await mywallet(user_id!).then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          isLoading = true;
          if (usersFromServe!.length > 0) {
            walletlist = usersFromServe;
            wallet = walletlist[0].wallet ?? "";
            log('wallet--------' + wallet.toString());
            preff.setString("walletsend", wallet);
            isLoading = false;
          } else {}
        });

        isLoading = false;
      }
      isLoading = false;
    });
    setState(() {
      md5Key =
          generateMd5(GroceryAppConstant.Shop_id + GroceryAppConstant.user_id);
      // isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GroceryAppColors.white,
      appBar: widget.ShowAppBar == true
          ? AppBar(
              backgroundColor: GroceryAppColors.tela,
              leading: IconButton(
                  color: Colors.white,
                  icon: Icon(
                    Icons.arrow_back,
                    color: GroceryAppColors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: Text(
                "Wallet Balance",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: isLoading
              ? Container(
                  height: MediaQuery.of(context).size.height * .8,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFff1717),
                    ),
                  ),
                )
              :

              //  wallet.isEmpty
              //     ? SizedBox(
              //         height: 600,
              //         child: Center(
              //           child: Text("Wallet Empty"),
              //         ),
              //       )
              //     :

              Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      height: 135,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: const Color.fromARGB(255, 249, 3, 89),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Wallet Balance: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: GroceryAppColors.white,
                                      fontSize: 17),
                                ),
                                Text(
                                  "${wallet.isNotEmpty ? wallet : "0"}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: GroceryAppColors.white,
                                      fontSize: 17),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddMoney(),
                                      ),
                                    );
                                  },
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: GroceryAppColors.white,
                                  textColor: const Color.fromARGB(255, 0, 0, 0),
                                  child: Container(
                                    width: 100,
                                    child: Text(
                                      "Add Amount",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    membership_id == "" || membership_id == null
                                        ? showLongToast(
                                            "Please Activate Any Package...")
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SendMoneyNew(),
                                            ),
                                          );
                                  },
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: GroceryAppColors.white,
                                  textColor: const Color.fromARGB(255, 3, 5, 4),
                                  child: Container(
                                    width: 100,
                                    child: Text(
                                      "Transfer",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            MaterialButton(
                              onPressed: () {
                                membership_id == "" || membership_id == null
                                    ? showLongToast(
                                        "Please Activate Any Package...")
                                    : showBottomDialog(context);
                              },
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: GroceryAppColors.white,
                              textColor: const Color.fromARGB(255, 4, 8, 5),
                              child: Container(
                                width: 100,
                                child: Text(
                                  "Withdraw",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   height: MediaQuery.of(context).size.height - 90,
                    //   child: PagewiseListView(
                    //       pageSize: PAGE_SIZE,
                    //       itemBuilder: this._itemBuilder,
                    //       pageFuture: (pageIndex) => get_walletrecord(
                    // GroceryAppConstant.user_id,
                    // pageIndex * PAGE_SIZE)),
                    // ),
                    FutureBuilder(
                      future: get_walletrecord(GroceryAppConstant.user_id, 0),
                      builder: (context, snapshot) {
                        return snapshot.data == null
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return _itemBuilder(
                                      context, snapshot.data![index], "");
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 10,
                                  );
                                },
                                itemCount: snapshot.data!.length);
                      },
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _itemBuilder(context, WalletUser entry, _) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 241, 1, 73),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 10,
                        ),
                        child: Text(
                          "Invoice Id",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Container(
                          width: 240,
                          child: Text(
                            entry.wInvoiceId ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 30,
                    width: 70,
                    child: Card(
                      child: Center(
                        child: Text(
                          double.parse(entry.wIn!) > 0 ? "Credit" : "Debit",
                          style: TextStyle(
                              color: double.parse(entry.wIn!) > 0
                                  ? GroceryAppColors.sellp
                                  : Color(0xFFff1717),
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 15),
                child: Text(entry.wNote ?? ""),
              ),
            ),
            Divider(),
            Container(
              height: 50,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: () {
                            print("amount------>${entry.wOut}");
                            print("amount------>${entry.wIn}");
                          },
                          child: Text(
                            "Amount",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          "\u{20B9}${double.parse(entry.wIn ?? "") > 0 ? entry.wIn : entry.wOut}",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Date",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          entry.wDate ?? "",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _displayDialog(BuildContext context, WalletUser entry) async {
    bool flag = false;
    StateSetter _setState;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              'Transation Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            entry.wDate == null ? '' : entry.wDate ?? "",
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)
                                .copyWith(fontSize: 18),
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          child: Text(
                            entry.wTransactionId == "0"
                                ? ''
                                : entry.wTransactionId ?? "",
                            overflow: TextOverflow.fade,
                            style: TextStyle(fontSize: 15, color: Colors.grey)
                                .copyWith(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            entry.wIn != "0"
                                ? entry.wIn ?? ""
                                : entry.wOut ?? "",
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)
                                .copyWith(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          child: Text(
                            entry.wOut == "0" ? "Cr." : "Dr.",
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: entry.wIn == "0"
                                        ? Colors.orange
                                        : Colors.grey)
                                .copyWith(fontSize: 15),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 6),
                Text("Note: ${entry.wNote}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 15, color: GroceryAppColors.darkGray)),
                SizedBox(height: 6),
                Text(" Invoice Id:  ${entry.wInvoiceId}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 15, color: GroceryAppColors.darkGray)),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text(
                  'Cancel',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  String textval1 = "Start date";
  DateTime? selectedDate;
/*
   bool _decideWhichDayToEnable(DateTime day) {
     if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
         day.isBefore(DateTime.now().add(Duration(days: 30))))) {
       return true;
     }
     return false;
   }

   showCalander(ShowOrderDetail entry){

     showDatePicker(
       context: context,
       initialDate: DateTime.now(),
       firstDate: DateTime(2000),
       lastDate: DateTime(2025),
       selectableDayPredicate: _decideWhichDayToEnable,
     ).then((date){
       setState(() {

         selectedDate=date;
         String formattedDate = DateFormat('yyyy-MM-dd ').format(selectedDate!=null?selectedDate:DateTime.now());
         entry.subDate=formattedDate;
         textval1=formattedDate;
         print(formattedDate);
       });
     });
   }*/
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future requestWithdrwal(String amount, String userNote) async {
    print("working-----<");
    String link = "${GroceryAppConstant.base_url}api/request_withdrawal.php";
    Map body = {
      "key": md5Key,
      "shop_id": GroceryAppConstant.Shop_id,
      "user_id": GroceryAppConstant.user_id,
      "amount": amount,
      "user_note": userNote,
    };
    var response = await http.post(Uri.parse(link), body: body);
    var responseData = jsonDecode(response.body);
    print("response---->${responseData}");
    if (response.statusCode == 200) {
      if (responseData['success'] == false) {
        showLongToast(responseData["msg"]);
        setState(() {
          dialogLoader.value = false;
        });
      } else {
        setState(() {
          dialogLoader.value = false;
        });
        showLongToast(responseData["msg"]);
      }
    } else {
      showLongToast(responseData['msg']);
      setState(() {
        dialogLoader.value = false;
      });
    }
  }

  void showBottomDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: _buildDialogContent(),
        );
      },
      transitionBuilder: (_, animation1, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }

  Widget _buildDialogContent() {
    return IntrinsicHeight(
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height / 1.5,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Material(
          color: GroceryAppColors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    child: Card(
                      elevation: 0.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: dialogLoader,
                builder: (BuildContext? context, value, Widget? child) {
                  return Container(
                    child: dialogLoader.value
                        ? CircularProgressIndicator()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                controller: amountController,
                                decoration: InputDecoration(
                                  labelText: 'Enter withdrawal amount',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 3,
                                        color: GroceryAppColors.sellp),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 3,
                                        color: GroceryAppColors.boxColor1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: userNoteController,
                                decoration: InputDecoration(
                                  labelText: 'Enter note',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 50.0, horizontal: 10.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 3,
                                        color: GroceryAppColors.sellp),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 3,
                                        color: GroceryAppColors.boxColor1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 50,
                                width: 100,
                                child: InkWell(
                                  onTap: () {
                                    print(
                                        "amount----->${amountController.text}");
                                    print(
                                        "amount----->${userNoteController.text}");
                                    if (amountController.text.isNotEmpty) {
                                      dialogLoader.value = true;
                                      requestWithdrwal(amountController.text,
                                          userNoteController.text);
                                    } else {
                                      showLongToast(
                                          "Amount field can't be empty...");
                                    }
                                  },
                                  child: Card(
                                    color: GroceryAppColors.sellp,
                                    child: Center(
                                      child: Text(
                                        "Confirm",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: GroceryAppColors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:convert';

// import 'package:crypto/crypto.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pagewise/flutter_pagewise.dart';
// import 'package:intl/intl.dart';
// import 'package:royalmart/General/AppConstant.dart';
// import 'package:royalmart/StyleDecoration/styleDecoration.dart';
// import 'package:royalmart/dbhelper/database_helper.dart';
// import 'package:royalmart/model/CustmerModel.dart';
// import 'package:http/http.dart' as http;
// import 'package:royalmart/model/OrderShow.dart';
// import 'package:royalmart/model/banktransation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'add_money.dart';

// class WalltReport extends StatefulWidget {
//   // final String invoiceno;
//   // final String status;
//   // Subscription(this.invoiceno,this.status);

//   @override
//   _WalltReportState createState() => _WalltReportState();
// }

// class _WalltReportState extends State<WalltReport> {
//   List<ShowOrderDetail> orderlist = new List<ShowOrderDetail>();
//   static const int PAGE_SIZE = 10;
//   int _current = 0;
//   List<String> list;
//   var newDate;
//   String wallet = "0";
//   String md5Key;
//   ValueNotifier dialogLoader = ValueNotifier(false);
//   TextEditingController amountController = TextEditingController();
//   TextEditingController userNoteController = TextEditingController();

//   List<CustmerModel> walletlist = [];

//   Future<void> getvalue() async {
//     SharedPreferences pre = await SharedPreferences.getInstance();
//     String wal = pre.getString("wallet");
//     String user_id = pre.getString("user_id");

//     setState(() {
//       wallet = wal;
//       Constant.user_id = user_id;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getvalue();

//     mywallet(Constant.user_id).then((usersFromServe) {
//       if (this.mounted) {
//         setState(() {
//           walletlist = usersFromServe;
//           wallet = walletlist[0].wallet;
//         });
//       }
//     });
//     setState(() {
//       md5Key = generateMd5(Constant.Shop_id + Constant.user_id);
//     });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: GroceryAppColors.white,
//       appBar: AppBar(
//         backgroundColor: GroceryAppColors.tela,
//         leading: IconButton(
//             color: Colors.white,
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(context);
//             }),
//         title: Text(
//           "Wallet Points",
//           textAlign: TextAlign.center,
//           maxLines: 2,
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 15.0),
//             child: Center(
//                 child: MaterialButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AddMoney(),
//   }
// import 'dart:convert';

// import 'package:crypto/crypto.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pagewise/flutter_pagewise.dart';
// import 'package:intl/intl.dart';
// import 'package:royalmart/General/AppConstant.dart';
// import 'package:royalmart/StyleDecoration/styleDecoration.dart';
// import 'package:royalmart/dbhelper/database_helper.dart';
// import 'package:royalmart/model/CustmerModel.dart';
// import 'package:http/http.dart' as http;
// import 'package:royalmart/model/OrderShow.dart';
// import 'package:royalmart/model/banktransation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'add_money.dart';

// class WalltReport extends StatefulWidget {
//   @override
//   _WalltReportState createState() => _WalltReportState();
// }

// class _WalltReportState extends State<WalltReport> {
//   List<ShowOrderDetail> orderlist = new List<ShowOrderDetail>();
//   static const int PAGE_SIZE = 10;
//   int _current = 0;
//   List<String> list;
//   var newDate;
//   String wallet = "0";
//   String md5Key;
//   ValueNotifier dialogLoader = ValueNotifier(false);
//   TextEditingController amountController = TextEditingController();
//   TextEditingController userNoteController = TextEditingController();
//   List<CustmerModel> walletlist = [];
//   bool isLoading = true;

//   Future<void> getvalue() async {
//     SharedPreferences pre = await SharedPreferences.getInstance();
//     String wal = pre.getString("wallet");
//     String user_id = pre.getString("user_id");
//     print("user--------->${user_id}");

//     setState(() {
//       wallet = wal;
//       FoodAppConstant.user_id = user_id;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getvalue();
//     init();
//   }

//   init() async {
//     await mywallet(FoodAppConstant.user_id).then((usersFromServe) {
//       if (this.mounted) {
//         setState(() {
//           walletlist = usersFromServe;
//           wallet = walletlist[0].wallet;
//           // isLoading = false;
//         });
//       }
//     });
//     setState(() {
//       md5Key = generateMd5(FoodAppConstant.Shop_id + FoodAppConstant.user_id);
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: FoodGroceryAppColors.white,
//       /* appBar: AppBar(
//         backgroundColor: FoodGroceryAppColors.tela,
//         leading: IconButton(
//             color: Colors.white,
//             icon: Icon(
//               Icons.arrow_back,
//               color: FoodGroceryAppColors.black,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             }),
//         title: Text(
//           "Wallet Points",
//           textAlign: TextAlign.center,
//           maxLines: 2,
//           style: TextStyle(color: Colors.black, fontSize: 20),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 15.0),
//             child: Center(
//                 child: MaterialButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AddMoney(),
//                   ),
//                 );
//               },
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               color: FoodGroceryAppColors.white,
//               textColor: FoodGroceryAppColors.sellp,
//               child: Text(
//                 "Add",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//               ),
//             )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 15.0),
//             child: Center(
//               child: Text(
//                 "${wallet != null ? wallet : "0"}",
//                 style: TextStyle(color: Colors.black, fontSize: 20),
//               ),
//             ),
//           ),
//         ],
//       ),*/
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: isLoading
//               ? Container(
//                   height: MediaQuery.of(context).size.height * .8,
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 )
//               : wallet.isEmpty
//                   ? Center(
//                       child: Text("Wallet Empty"),
//                     )
//                   : Column(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.all(10),
//                           height: 100,
//                           width: MediaQuery.of(context).size.width,
//                           child: Card(
//                             color: FoodGroceryAppColors.sellp,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       "Wallet Points: ",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: FoodGroceryAppColors.white,
//                                           fontSize: 17),
//                                     ),
//                                     Text(
//                                       "${wallet != null ? wallet : "0"}",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: FoodGroceryAppColors.white,
//                                           fontSize: 17),
//                                     ),
//                                   ],
//                                 ),
//                                 MaterialButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => AddMoney(),
//                                       ),
//                                     );
//                                   },
//                                   elevation: 3,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   color: FoodGroceryAppColors.white,
//                                   textColor: FoodGroceryAppColors.sellp,
//                                   child: Text(
//                                     "Add",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 15),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: MediaQuery.of(context).size.height - 90,
//                           child: PagewiseListView(
//                               pageSize: PAGE_SIZE,
//                               itemBuilder: this._itemBuilder,
//                               pageFuture: (pageIndex) => get_walletrecord(
//                                   FoodAppConstant.user_id,
//                                   pageIndex * PAGE_SIZE)),
//                         ),
//                       ],
//                     ),
//         ),
//       ),
//     );
//   }

//   Widget _itemBuilder(context, WalletUser entry, _) {
//     return Container(
//       margin: EdgeInsets.only(left: 10, right: 10),
//       height: 180,
//       width: MediaQuery.of(context).size.width,
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 60,
//               decoration: BoxDecoration(
//                 color: FoodGroceryAppColors.red,
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(10),
//                   topLeft: Radius.circular(10),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           left: 10,
//                           top: 10,
//                         ),
//                         child: Text(
//                           "Invoice Id",
//                           style: TextStyle(
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           left: 10,
//                         ),
//                         child: Text(
//                           entry.wInvoiceId,
//                           style: TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(right: 10),
//                     height: 30,
//                     width: 70,
//                     child: Card(
//                       child: Center(
//                         child: Text(
//                           double.parse(entry.wIn) > 0 ? "Credit" : "Debit",
//                           style: TextStyle(
//                               color: double.parse(entry.wIn) > 0
//                                   ? FoodGroceryAppColors.sellp
//                                   : Colors.red,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: 40,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 15),
//                 child: Text(entry.wNote),
//               ),
//             ),
//             Divider(),
//             Container(
//               height: 50,
//               child: Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 10),
//                         child: InkWell(
//                           onTap: () {
//                             print("amount------>${entry.wOut}");
//                             print("amount------>${entry.wIn}");
//                           },
//                           child: Text(
//                             "Amount",
//                             style: TextStyle(color: Colors.black54),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 10, top: 5),
//                         child: Text(
//                           "\u{20B9}${double.parse(entry.wIn) > 0 ? entry.wIn : entry.wOut}",
//                           style: TextStyle(fontSize: 13),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     width: 100,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 10),
//                         child: Text(
//                           "Date",
//                           style: TextStyle(color: Colors.black54),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 10, top: 5),
//                         child: Text(
//                           entry.wDate,
//                           style: TextStyle(color: Colors.black, fontSize: 13),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   _displayDialog(BuildContext context, WalletUser entry) async {
//     bool flag = false;
//     StateSetter _setState;

//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDialog(
//             scrollable: true,
//             title: Text(
//               'Transation Details',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Container(
//                           child: Text(
//                             entry.wDate == null ? '' : entry.wDate,
//                             overflow: TextOverflow.fade,
//                             style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black)
//                                 .copyWith(fontSize: 18),
//                           ),
//                         ),
//                         SizedBox(height: 6),
//                         Container(
//                           child: Text(
//                             entry.wTransactionId == "0"
//                                 ? ''
//                                 : entry.wTransactionId,
//                             overflow: TextOverflow.fade,
//                             style: TextStyle(fontSize: 15, color: Colors.grey)
//                                 .copyWith(fontSize: 15),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           child: Text(
//                             entry.wIn != "0" ? entry.wIn : entry.wOut,
//                             overflow: TextOverflow.fade,
//                             style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.green)
//                                 .copyWith(fontSize: 18),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 8,
//                         ),
//                         Container(
//                           child: Text(
//                             entry.wOut == "0" ? "Cr." : "Dr.",
//                             overflow: TextOverflow.fade,
//                             style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: entry.wIn == "0"
//                                         ? Colors.orange
//                                         : Colors.grey)
//                                 .copyWith(fontSize: 15),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 6),
//                 Text("Note: ${entry.wNote}",
//                     textAlign: TextAlign.start,
//                     style:
//                         TextStyle(fontSize: 15, color: FoodGroceryAppColors.darkGray)),
//                 SizedBox(height: 6),
//                 Text(" Invoice Id:  ${entry.wInvoiceId}",
//                     textAlign: TextAlign.start,
//                     style:
//                         TextStyle(fontSize: 15, color: FoodGroceryAppColors.darkGray)),
//               ],
//             ),
//             actions: <Widget>[
//               new FlatButton(
//                 child: new Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.green),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   String textval1 = "Start date";
//   DateTime selectedDate;
// /*
//    bool _decideWhichDayToEnable(DateTime day) {
//      if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
//          day.isBefore(DateTime.now().add(Duration(days: 30))))) {
//        return true;
//      }
//      return false;
//    }

//    showCalander(ShowOrderDetail entry){

//      showDatePicker(
//        context: context,
//        initialDate: DateTime.now(),
//        firstDate: DateTime(2000),
//        lastDate: DateTime(2025),
//        selectableDayPredicate: _decideWhichDayToEnable,
//      ).then((date){
//        setState(() {

//          selectedDate=date;
//          String formattedDate = DateFormat('yyyy-MM-dd ').format(selectedDate!=null?selectedDate:DateTime.now());
//          entry.subDate=formattedDate;
//          textval1=formattedDate;
//          print(formattedDate);
//        });
//      });
//    }*/
//   String generateMd5(String input) {
//     return md5.convert(utf8.encode(input)).toString();
//   }

//   Future requestWithdrwal(String amount, String userNote) async {
//     print("working-----<");
//     String link = "${FoodAppConstant.base_url}api/request_withdrawal.php";
//     Map body = {
//       "key": md5Key,
//       "shop_id": FoodAppConstant.Shop_id,
//       "user_id": FoodAppConstant.user_id,
//       "amount": amount,
//       "user_note": userNote,
//     };
//     var response = await http.post(link, body: body);
//     var responseData = jsonDecode(response.body);
//     print("response---->${responseData}");
//     if (response.statusCode == 200) {
//       if (responseData['success'] == false) {
//         showLongToast(responseData["msg"]);
//         setState(() {
//           dialogLoader.value = false;
//         });
//       } else {
//         setState(() {
//           dialogLoader.value = false;
//         });
//         showLongToast(responseData["msg"]);
//       }
//     } else {
//       showLongToast(responseData['msg']);
//       setState(() {
//         dialogLoader.value = false;
//       });
//     }
//   }

//   void showBottomDialog(BuildContext context) {
//     showGeneralDialog(
//       barrierLabel: "showGeneralDialog",
//       barrierDismissible: true,
//       barrierColor: Colors.black.withOpacity(0.6),
//       transitionDuration: const Duration(milliseconds: 400),
//       context: context,
//       pageBuilder: (context, _, __) {
//         return Align(
//           alignment: Alignment.bottomCenter,
//           child: _buildDialogContent(),
//         );
//       },
//       transitionBuilder: (_, animation1, __, child) {
//         return SlideTransition(
//           position: Tween(
//             begin: const Offset(0, 1),
//             end: const Offset(0, 0),
//           ).animate(animation1),
//           child: child,
//         );
//       },
//     );
//   }

//   Widget _buildDialogContent() {
//     return IntrinsicHeight(
//       child: Container(
//         width: double.maxFinite,
//         height: MediaQuery.of(context).size.height / 1.5,
//         clipBehavior: Clip.antiAlias,
//         padding: const EdgeInsets.all(16),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(16),
//             topRight: Radius.circular(16),
//           ),
//         ),
//         child: Material(
//           color: FoodAppColors.white,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 child: Align(
//                   alignment: Alignment.topRight,
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 70,
//                     child: Card(
//                       elevation: 0.3,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Icon(
//                               Icons.close,
//                               size: 35,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               ValueListenableBuilder(
//                 valueListenable: dialogLoader,
//                 builder: (BuildContext context, value, Widget child) {
//                   return Container(
//                     child: dialogLoader.value
//                         ? CircularProgressIndicator()
//                         : Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               TextField(
//                                 controller: amountController,
//                                 decoration: InputDecoration(
//                                   labelText: 'Enter withdrawal amount',
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                         width: 3, color: FoodAppColors.sellp),
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                         width: 3,
//                                         color: FoodAppColors.boxColor1),
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                 ),
//                                 keyboardType: TextInputType.number,
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               TextField(
//                                 controller: userNoteController,
//                                 decoration: InputDecoration(
//                                   labelText: 'Enter note',
//                                   contentPadding: const EdgeInsets.symmetric(
//                                       vertical: 50.0, horizontal: 10.0),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                         width: 3, color: FoodAppColors.sellp),
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                         width: 3,
//                                         color: FoodAppColors.boxColor1),
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Container(
//                                 height: 50,
//                                 width: 100,
//                                 child: InkWell(
//                                   onTap: () {
//                                     print(
//                                         "amount----->${amountController.text}");
//                                     print(
//                                         "amount----->${userNoteController.text}");
//                                     if (amountController.text.isNotEmpty) {
//                                       dialogLoader.value = true;
//                                       requestWithdrwal(amountController.text,
//                                           userNoteController.text);
//                                     } else {
//                                       showLongToast(
//                                           "Amount field can't be empty...");
//                                     }
//                                   },
//                                   child: Card(
//                                     color: FoodAppColors.sellp,
//                                     child: Center(
//                                       child: Text(
//                                         "Confirm",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             color: FoodAppColors.white),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                   );
//                 },
//               ),
//               SizedBox(
//                 height: 100,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
