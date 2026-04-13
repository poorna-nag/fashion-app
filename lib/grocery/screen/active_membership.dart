import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:royalmart/grocery/General/Home.dart';
import 'package:royalmart/grocery/model/check_plan_active.dart';
import 'package:royalmart/grocery/screen/screen_memebership.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dbhelper/database_helper.dart';
import '../../model/RegisterModel.dart';
import '../../model/active_membership_model.dart';
import '../General/AppConstant.dart';

class ActiveMembership extends StatefulWidget {
  const ActiveMembership(this.mId, this.appbarbool) : super();
  final String mId;
  final bool appbarbool;
  @override
  _ActiveMembershipState createState() => _ActiveMembershipState();
}

class _ActiveMembershipState extends State<ActiveMembership> {
  List<MembershipPlan> memberships = <MembershipPlan>[];

  bool isLoading = false;
  bool _status = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    checkPlanActivate();
    getMembershipsList().then((usersFromServe) {
      setState(() {
        memberships = usersFromServe!;
        print(memberships.toString());
        isLoading = false;
      });
    });
// log(membership_id);
//     log("mid acti" + membership_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appbarbool == true
          ? AppBar(
              backgroundColor: Color(0xFFE91E63),
              leading: IconButton(
                  color: Colors.white,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: Text(
                "Memberships",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FA), // Light elegant background like sign-in page
              Color(0xFFFFE8F0), // Soft pink tint
              Color(0xFFF8F9FA),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : memberships.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Membership Plans"),
                        SizedBox(
                          height: 5,
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => ActiveMembership()),
                        //     );
                        //   },
                        //   child: Text("Activate here"),
                        // )
                      ],
                    ),
                  )
                : memberships.length > 0
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount:
                            memberships.length == null ? 0 : memberships.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              elevation: 5.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  memberships[index].name != null
                                      ? Container(
                                          color: membership_id ==
                                                  memberships[index].memId
                                              ? Colors.green
                                              : Color(0xFFE91E63),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  memberships[index].name !=
                                                          null
                                                      ? memberships[index]
                                                              .name ??
                                                          ""
                                                      : "",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(2.0),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      log(memberships[index]
                                                              .memId ??
                                                          "");
                                                      log(memberships[index]
                                                              .name ??
                                                          "");
                                                      log(memberships[index]
                                                              .joinBonus ??
                                                          "");
                                                      log(memberships[index]
                                                              .joinFee ??
                                                          "");
                                                      log(memberships[index]
                                                              .description ??
                                                          "");
                                                      log(memberships[index]
                                                              .validity ??
                                                          "");
                                                      log(memberships[index]
                                                              .xMemJoin ??
                                                          "");
                                                      log(memberships[index]
                                                              .xMemJoinBunus ??
                                                          "");
                                                      membership_id ==
                                                              memberships[index]
                                                                  .memId
                                                          ? showLongToast(
                                                              "Plan Already Activated")
                                                          : membership_id !=
                                                                      "" ||
                                                                  membership_id!
                                                                      .isNotEmpty
                                                              ? showLongToast(
                                                                  "Please Try After Validity Expires...")
                                                              : activeConfirmation(
                                                                  membership_id ??
                                                                      "",
                                                                  memberships[
                                                                              index]
                                                                          .memId ??
                                                                      "",
                                                                  memberships[
                                                                              index]
                                                                          .name ??
                                                                      "",
                                                                  memberships[
                                                                              index]
                                                                          .joinBonus ??
                                                                      "",
                                                                  memberships[
                                                                              index]
                                                                          .joinFee ??
                                                                      "",
                                                                  memberships[
                                                                              index]
                                                                          .description ??
                                                                      "",
                                                                  memberships[index]
                                                                          .validity ??
                                                                      "",
                                                                  memberships[index]
                                                                          .xMemJoin ??
                                                                      "",
                                                                  memberships[index]
                                                                          .xMemJoinBunus ??
                                                                      "");
                                                      // : await activatePlan(
                                                      //     memberships[
                                                      //             index]
                                                      //         .memId,
                                                      //     memberships[
                                                      //             index]
                                                      //         .name,
                                                      //     memberships[
                                                      //             index]
                                                      //         .joinBonus,
                                                      //     memberships[
                                                      //             index]
                                                      //         .joinFee,
                                                      //     memberships[
                                                      //             index]
                                                      //         .description,
                                                      //     memberships[
                                                      //             index]
                                                      //         .validity,
                                                      //     memberships[
                                                      //             index]
                                                      //         .xMemJoin,
                                                      //     memberships[
                                                      //             index]
                                                      //         .xMemJoinBunus);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0,
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0)),
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(0.0),
                                                    ),
                                                    child: Text(
                                                      membership_id ==
                                                              memberships[index]
                                                                  .memId
                                                          ? "Activated"
                                                          : "Activate",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Row(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        memberships[index].joinFee != null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "JoinFee",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    memberships[index]
                                                                .joinFee !=
                                                            null
                                                        ? "₹${memberships[index].joinFee}"
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                height: 0,
                                              ),
                                        Divider(
                                          thickness: .8,
                                        ),
                                        memberships[index].validity != null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Validity",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    memberships[index]
                                                                .validity !=
                                                            null
                                                        ? "${memberships[index].validity} days"
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                height: 0,
                                              ),
                                        Divider(
                                          thickness: .8,
                                        ),
                                        memberships[index].joinBonus != null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "JoinBonus",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    memberships[index]
                                                                .joinBonus !=
                                                            null
                                                        ? "₹${memberships[index].joinBonus}"
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                height: 0,
                                              ),
                                        Divider(
                                          thickness: .8,
                                        ),
                                        memberships[index].xMemJoin != null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Direct Joining Target",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    memberships[index]
                                                                .validity !=
                                                            null
                                                        ? "${memberships[index].xMemJoin}"
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                height: 0,
                                              ),
                                        Divider(
                                          thickness: .8,
                                        ),
                                        memberships[index].xMemJoinBunus != null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Direct Joining Bonus",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    memberships[index]
                                                                .validity !=
                                                            null
                                                        ? "₹${memberships[index].xMemJoinBunus}"
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                height: 0,
                                              ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: .8,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            memberships[index].description !=
                                                    null
                                                ? "${memberships[index].description}"
                                                : "",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                    : Center(
                        child: CircularProgressIndicator(
                        color: Color(0xFFff1717),
                      )),
      ),
    );
  }

  //---------------------------------------CONFORMATION POPUP------------------------------//

  void activeConfirmation(
      String mId,
      String planID,
      String mname,
      String mBonus,
      String mJfee,
      String mDiscription,
      String mvalidity,
      String mDjoinAmount,
      String mDjoin) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  //color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage("assets/images/confirmation.png"))),
            ),
            Center(
              child: Text(
                "CONFIRMATION?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            mId.isEmpty
                ? SizedBox()
                : Center(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "Already Plan Activated!",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            SizedBox(
              height: 10,
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                mId.isEmpty
                    ? "Are You Sure To Activate Plan?"
                    : "Are You Sure To Activate New Plan?",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            )),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.pop(context);
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      "No",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    activatePlan(planID, mname, mBonus, mJfee, mDiscription,
                        mvalidity, mDjoinAmount, mDjoin);
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      "Yes",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    )),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }

  //---------------------------------------CONFORMATION POPUP EXIT------------------------------//

  //-------------------------------------ACTIVATE PLAN POST METHODE--------------------------------//

  Future activatePlan(
      String planID,
      String mname,
      String mBonus,
      String mJfee,
      String mDiscription,
      String mvalidity,
      String mDjoinAmount,
      String mDjoin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var username = pref.getString("mobile");
    log(username.toString());
    var map = new Map<String, dynamic>();
    map['shop_id'] = GroceryAppConstant.Shop_id;
    map['username'] = username;
    map['plan_id'] = planID;

    String link = GroceryAppConstant.base_url + "api/userMemAct.php";

    print("link =====> $link");

    log("link =====> ${map.toString()}");
    final response = await http.post(Uri.parse(link), body: map);
    log("response =====> ${response.body.toString()}");
    if (response.statusCode == 200) {
      log("response =====> ${response.body.toString()}");
      final jsonBody = json.decode(response.body);
      // OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
      if (jsonBody['success'] == "true") {
        showLongToast(jsonBody['message'] ?? "");
        setState(() {
          pref.setString("mname", mname);
          pref.setString("mBonus", mBonus);
          pref.setString("mJfee", mJfee);
          pref.setString("mDiscription", mDiscription);
          pref.setString("mvalidity", mvalidity);
          pref.setString("mDjoinAmount", mDjoinAmount);
          pref.setString("mDjoin", mDjoin);
          pref.setString("prime", "Active");
          pref.setString("mID", planID);
          GroceryAppConstant.mid = planID;
        });
        //Navigator.pop(context);
        // Navigator.pop(context);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => GroceryApp()));
      } else {
        showLongToast(jsonBody['message'] ?? "");
      }
    } else
      throw Exception("Unable to get Employee list");
  }

  String? membership_id = '';
  Future checkPlanActivate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var username = pref.getString("mobile");
    log(username.toString());
    var map = new Map<String, dynamic>();
    map['shop_id'] = GroceryAppConstant.Shop_id;
    map['username'] = username;

    String link = GroceryAppConstant.base_url + "api/user_mlm_plan.php";

    final response = await http.post(Uri.parse(link), body: map);
    log(response.body.toString() + map.toString() + link.toString());
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

  //-------------------------------------ACTIVATE PLAN POST METHODE EXIT--------------------------------//
}

class string {}
