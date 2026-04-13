import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royalmart/General/AppConstant.dart' as general;
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/model/send_money_model.dart';
import 'package:royalmart/screen/wallecttransation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendMoneyNew extends StatefulWidget {
  @override
  _SendMoneyNewState createState() => _SendMoneyNewState();
}

class _SendMoneyNewState extends State<SendMoneyNew> {
  TextEditingController amount = TextEditingController();
  TextEditingController sendorMobController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  String? mobile;
  bool flag = false;
  String? wallet;

  bool isFocused = false;
  Future sendMoney_() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    mobile = pref.getString("mobile");
    log(mobile!);

    var map = new Map<String, dynamic>();
    map['shop_id'] = GroceryAppConstant.Shop_id;
    map['sender'] = mobile;
    map['receiver'] = sendorMobController.text;
    map['amount'] = amount.text;
    map['tpassword'] = messageController.text;
    log(map.toString());
    final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'api/userSendMoney.php'),
        body: map);
    log("${map}");
    log(response.body.toString());
    if (response.statusCode == 200) {
      print(response.toString());
      final jsonBody = json.decode(response.body);

      SendMoneyModel user = SendMoneyModel.fromJson(jsonDecode(response.body));
      log(jsonBody.toString());
      if (user.message.toString() == "Send Money Successfully") {
        setState(() {
          flag = false;
        });
        // Navigator.pop(context, true);
        // Navigator.pop(context, true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WalltReport()),
        );
      } else if (user.message.toString() ==
          "Please Enter Correct Transaction Password!") {
        showLongToast("Please Enter Correct Transaction Password!");
      } else if (user.message.toString() == "Send Money Successfully") {
       // showLongToastWithColour("Send Money Successfully");
      } else if (user.message.toString() == "Insufficient Balance!") {
        //showLongToastWithColour("Insufficient Balance!");
      }
    } else
      throw Exception("Unable to get Employee list");
  }

  @override
  void initState() {
    super.initState();
    getvalue();
  }

  Future<void> getvalue() async {
    SharedPreferences preff = await SharedPreferences.getInstance();

    String ?wal = preff.getString("walletsend");

    print("user--------->${wal}");

    setState(() {
      wallet = wal;
      log(wallet!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Transfer Money',
            style: TextStyle(color: Colors.black),
          ),
          leading: BackButton(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: 130,
                  height: 130,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset("assets/images/logo.png")),
                ),

                SizedBox(
                  height: 50,
                ),
                Text(
                  "Transfer Money To:",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextField(
                      controller: sendorMobController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          hintText: "Enter Mobile Number",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          )),
                    ),
                  ),
                ),

                Text(
                  "Amount:",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextField(
                      controller: amount,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          hintText: "0",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          )),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Text(
                  "Transaction Password:",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextField(
                      obscureText: true,
                      controller: messageController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          hintText: ". . . . . .",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          )),
                    ),
                  ),
                ),
                // note textfield
                // AnimatedContainer(
                //   margin: EdgeInsets.symmetric(horizontal: 30),
                //   duration: Duration(milliseconds: 500),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(8),
                //     border: Border.all(
                //         color: isFocused
                //             ? Colors.indigo.shade400
                //             : Colors.grey.shade200,
                //         width: 2),
                //     // // boxShadow:
                //   ),
                //   child: TextField(
                //     maxLines: 3,
                //     controller: messageController,
                //     keyboardType: TextInputType.text,
                //     cursorColor: Colors.black,
                //     style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 18,
                //         fontWeight: FontWeight.w500),
                //     decoration: InputDecoration(
                //         contentPadding:
                //             EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                //         hintText: "Message ...",
                //         hintStyle: TextStyle(
                //             color: Colors.grey,
                //             fontSize: 15,
                //             fontWeight: FontWeight.w500),
                //         border: InputBorder.none),
                //   ),
                // ),

                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                    child: MaterialButton(
                      onPressed: () {
                        if (sendorMobController.text.length != 10) {
                          showLongToast("Enter a Valid Mobile Number");
                        } else if (amount == "" ||
                            amount == "" ||
                            amount == null) {
                          showLongToast("Enter Amount");
                        } else if (num.parse(amount.text) <=
                            num.parse(wallet!).round()) {
                          sendMoney_();
                        } else {
                          showLongToast("Not Enough Balance");
                        }

                        // Navigator.of(context).pushReplacementNamed('/');
                      },
                      minWidth: double.infinity,
                      height: 50,
                      child: Text(
                        "Send",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
