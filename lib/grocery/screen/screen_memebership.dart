import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/screen/active_membership.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MembershipList extends StatefulWidget {
  final bool appbarbool;
  const MembershipList(this.appbarbool) : super();
  @override
  _MembershipListState createState() => _MembershipListState();
}

class _MembershipListState extends State<MembershipList> {
  // List<UserAddress> memberships = new List<UserAddress>();
  bool? _status = false;
  String? name = "";
  String? joinBonus = "";
  String? joinFee = "";
  String? validity = "";
  String? djoingiTargert = "";
  String? djoingiBonus = "";
  String? discription = "";
  String? prime = "";
  String? mId = "";

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString("mname");
      joinBonus = pref.getString("mBonus");
      joinFee = pref.getString("mJfee");
      discription = pref.getString("mDiscription");
      validity = pref.getString("mvalidity");
      djoingiBonus = pref.getString("mDjoinAmount");
      djoingiTargert = pref.getString("mDjoin");
      prime = pref.getString("prime");
      mId = pref.getString("mID");
    });
    log(name ?? "");
    log(joinBonus ?? "");
    log(discription ?? "");
    log(joinFee ?? "");
    log(validity ?? "");
    log(djoingiTargert ?? "");
    log(djoingiBonus ?? "");
    log(prime ?? "");
    log(mId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: widget.appbarbool == true
          ? AppBar(
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
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ActiveMembership(mId ?? "", true)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE91E63),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(0.0),
                    ),
                    child: Text(
                      prime == "Active" ? "Upgrade" : "ADD",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
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
                "Active Plan",
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
              Color(0xFFF8F9FA),
              Color(0xFFFFE8F0),
              Color(0xFFF8F9FA),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            prime == "Active"
                ? Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          name != null
                              ? Container(
                                  height: 50,
                                  color: Color(0xFFE91E63),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        name != null ? name ?? "" : "",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Row(),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                joinFee!.length != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "JoinFee",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            joinFee != null ? "₹$joinFee" : "",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        height: 0,
                                      ),
                                Divider(
                                  thickness: 1,
                                ),
                                validity!.length != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Validity",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            validity != null
                                                ? "$validity days"
                                                : "",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        height: 0,
                                      ),
                                Divider(
                                  thickness: 1,
                                ),
                                joinBonus!.length != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "JoinBonus",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            joinBonus != null
                                                ? "₹$joinBonus"
                                                : "",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        height: 0,
                                      ),
                                Divider(
                                  thickness: 1,
                                ),
                              ],
                            ),
                          ),
                          // Divider(
                          //       thickness: 1,
                          //     ),

                          djoingiTargert!.length != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Direct Joining Target",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        djoingiTargert != null
                                            ? "₹$djoingiTargert"
                                            : "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 0,
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),

                          djoingiBonus!.length != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Direct Joining Bonus",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        djoingiBonus != null
                                            ? "₹$djoingiBonus"
                                            : "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 0,
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      discription != null ? "$discription" : "",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          widget.appbarbool == false
                              ? Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 36,
                                    height: 45,
                                    padding: EdgeInsets.only(bottom: 6),
                                    // margin: EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ActiveMembership(
                                                      mId ?? "", true)),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        padding: EdgeInsets.all(0.0),
                                      ),
                                      child: Text(
                                        prime == "Active"
                                            ? "Upgrade Plan"
                                            : "ADD Plan",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Row(),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Active Plans Click On👇"),
                        SizedBox(
                          height: 5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ActiveMembership("", true)),
                            );
                          },
                          child: Text("Activate here"),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget setContainer(String title, String value) {
    return Container(
      //  margin: EdgeInsets.only(left: 10, top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:royalmart/General/AppConstant.dart';
// import 'package:royalmart/grocery/screen/active_membership.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class MembershipList extends StatefulWidget {
//   bool showaAppbar;
//   MembershipList({@required this.showaAppbar}) : super();
//   @override
//   _MembershipListState createState() => _MembershipListState();
// }

// class _MembershipListState extends State<MembershipList> {
//   // List<UserAddress> memberships = new List<UserAddress>();
//   bool _status = false;
//   String name = "";
//   String joinBonus = "";
//   String joinFee = "";
//   String validity = "";
//   String djoingiTargert = "";
//   String djoingiBonus = "";
//   String discription = "";
//   String prime = "";
//   String mId = "";

//   @override
//   void initState() {
//     getData();
//     super.initState();
//   }

//   getData() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     setState(() {
//       name = pref.getString("mname");
//       joinBonus = pref.getString("mBonus");
//       joinFee = pref.getString("mJfee");
//       discription = pref.getString("mDiscription");
//       validity = pref.getString("mvalidity");
//       djoingiBonus = pref.getString("mDjoinAmount");
//       djoingiTargert = pref.getString("mDjoin");
//       prime = pref.getString("prime");
//       mId = pref.getString("mID");
//     });
//     log(name);
//     log(joinBonus);
//     log(discription);
//     log(joinFee);
//     log(validity);
//     log(djoingiTargert);
//     log(djoingiBonus);
//     log(prime);
//     log(mId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: widget.showaAppbar == null
//             ? AppBar(
//                 backgroundColor: FoodAppColors.tela,
//                 actions: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(8.0),
//                     child: RaisedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   ActiveMembership(mId ?? "")),
//                         );
//                       },
//                       color: FoodAppColors.telamoredeep,
//                       shape: new RoundedRectangleBorder(
//                           borderRadius: new BorderRadius.circular(20.0)),
//                       child: Text(
//                         prime == "Active" ? "Upgrade" : "ADD",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//                 leading: IconButton(
//                     color: Colors.white,
//                     icon: Icon(
//                       Icons.arrow_back,
//                       color: Colors.white,
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     }),
//                 title: Text(
//                   "Active Plan",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               )
//             : null,
//         body: prime == "Active"
//             ? Container(
//                 height: 350,
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   elevation: 10.0,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       name != null
//                           ? Container(
//                               height: 50,
//                               color: Colors.green,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   Text(
//                                     name != null ? name : "",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : Row(),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             joinFee.length != null
//                                 ? Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: <Widget>[
//                                       Text(
//                                         "JoinFee",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text(
//                                         joinFee != null ? "₹$joinFee" : "",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   )
//                                 : Container(
//                                     height: 0,
//                                   ),
//                             Divider(
//                               thickness: 1,
//                             ),
//                             validity.length != null
//                                 ? Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: <Widget>[
//                                       Text(
//                                         "Validity",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text(
//                                         validity != null
//                                             ? "$validity days"
//                                             : "",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   )
//                                 : Container(
//                                     height: 0,
//                                   ),
//                             Divider(
//                               thickness: 1,
//                             ),
//                             joinBonus.length != null
//                                 ? Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: <Widget>[
//                                       Text(
//                                         "JoinBonus",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text(
//                                         joinBonus != null ? "₹$joinBonus" : "",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   )
//                                 : Container(
//                                     height: 0,
//                                   ),
//                             Divider(
//                               thickness: 1,
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Divider(
//                       //       thickness: 1,
//                       //     ),

//                       djoingiTargert.length != null
//                           ? Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Text(
//                                     "Direct Joining Target",
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     djoingiTargert != null
//                                         ? "₹$djoingiTargert"
//                                         : "",
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : Container(
//                               height: 0,
//                             ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: Divider(
//                           thickness: 1,
//                         ),
//                       ),

//                       djoingiBonus.length != null
//                           ? Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Text(
//                                     "Direct Joining Bonus",
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     djoingiBonus != null
//                                         ? "₹$djoingiBonus"
//                                         : "",
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : Container(
//                               height: 0,
//                             ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: Divider(
//                           thickness: 1,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: Container(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: <Widget>[
//                               Expanded(
//                                 child: Text(
//                                   discription != null ? "$discription" : "",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             : Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("No Active Plans Click On👇"),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ActiveMembership("")),
//                         );
//                       },
//                       child: Text("Activate here"),
//                     )
//                   ],
//                 ),
//               ));
//   }

//   Widget setContainer(String title, String value) {
//     return Container(
//       //  margin: EdgeInsets.only(left: 10, top: 2),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.all(2.0),
//             child: Text(
//               title != null ? title : "",
//               style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(2.0),
//             child: Text(
//               value != null ? value : "",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
