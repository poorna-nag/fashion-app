import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';


import 'package:http/http.dart' as http;
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/model/RegisterModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:royalmart/Auth/newMap.dart';

import 'ShowAddress.dart';

class AddAddress extends StatefulWidget {
  final String valu;
  const AddAddress(this.valu) : super();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AddAddress> {
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  Future<File> ?file;
  String? status = '';
  String? user_id;

  var _formKeyad = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final profilescaffoldkey = new GlobalKey<ScaffoldState>();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final labelController = TextEditingController();

  int selectedRadio = 1;

  setSelectRadio(int val) {
    setState(() {
      selectedRadio = val;
      if (3 == selectedRadio) {
        setState(() {
          _status = true;
        });
      } else if (2 == selectedRadio) {
        setState(() {
          _status = false;
          labelController.text = "Office";
        });
      } else {
        setState(() {
          _status = false;
          labelController.text = "Home";
        });
      }
    });
  }

  SharedPreferences? pre;
  Future<void> getUserInfo() async {
    pre = await SharedPreferences.getInstance();
    String? name = pre!.getString("name");
    String? email = pre!.getString("email");
    String? mobile = pre!.getString("mobile");
    String? pin = pre!.getString("pin");
    String? city = pre!.getString("city");
    String? address = pre!.getString("address");
    String? image = pre!.getString("pp");
    user_id = pre!.getString("user_id");
    print(user_id);

    this.setState(() {
      nameController.text = name??"";
      emailController.text = email??"";
      stateController.text = 'Karnatka';
      pincodeController.text = pin??"";
      mobileController.text = mobile??"";
      cityController.text = city??"";
      address1.text = address??"";

      print("Constant.image");
      print(FoodAppConstant.image);
      print(FoodAppConstant.image.length);
    });
  }

  late Position position;

  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      FoodAppConstant.latitude = position.latitude;
      FoodAppConstant.longitude = position.longitude;
    });
  }

  @override
  void initState() {
    getUserInfo();
    _getCurrentLocation();
    super.initState();
    if (selectedRadio == 1) {
      setState(() {
        labelController.text = "Home";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: FoodAppColors.tela,
          title: Text(
            "My Address",
            style: TextStyle(color: FoodAppColors.black),
          )),
      key: profilescaffoldkey,
      body: Container(
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  color: Color(0xffFFFFFF),
                  child: Form(
                    key: _formKeyad,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          RadioListTile(
                            value: 1,
                            groupValue: selectedRadio,
                            title: Text("Home"),
                            onChanged: (val) {
                              print("Radio $val");
                              setSelectRadio(val!);
                            },
                            activeColor: Colors.red,
                          ),
                          RadioListTile(
                            value: 2,
                            groupValue: selectedRadio,
                            title: Text("${"Office"} "),
                            onChanged: (val) {
                              print("Radio $val");
                              setSelectRadio(val!);
                            },
                            activeColor: Colors.red,
                          ),
                          RadioListTile(
                            value: 3,
                            groupValue: selectedRadio,
                            title: Text("${"Others"} "),
                            onChanged: (val) {
                              print("Radio $val");
                              setSelectRadio(val!);
                            },
                            activeColor: Colors.red,
                          ),
                          _status ? getLabel() : Row(),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 0.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        '${"Name"}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: TextFormField(
                                      controller: nameController,
                                      validator: (String ?value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the name";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Name",
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 5.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            '${"Address"}',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MapClass(
                                                textEditingController: address1,
                                                cityController: cityController,
                                                stateController:
                                                    stateController,
                                                pincodeController:
                                                    pincodeController,
                                              )),
                                    );
                                  },
                                  child: _getEditIcon()),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 15.0),
                            child: Container(
                                child: new TextFormField(
                                    maxLines: 2,
                                    keyboardType: TextInputType
                                        .text, // Use mobile input type for emails.
                                    controller: address1,
                                    validator: (String ?value) {
                                      print("Length${value!.length}");
                                      if (value.isEmpty && value.length > 10) {
                                        return " Please enter the  address";
                                      }
                                    },
                                    decoration: new InputDecoration(
                                      hintText: '${"Address"}',
                                      labelText: 'Enter the address1',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black54, width: 3.0),
                                      ),

//                                      icon: new Icon(Icons.queue_play_next),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black54, width: 3.0),
                                      ),
                                    ))),
                          ),
/*
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        '${getTranslated(context, 'add6')}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),

                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 15.0),
                            child: Container(

                                child: new TextFormField(
                                    maxLines: 2,
                                    keyboardType: TextInputType.text, // Use mobile input type for emails.
                                    controller: address2,
                                    validator: (String value){
                                      print("Length${value.length}");
                                      if(value.isEmpty && value.length>10){
                                        return " Please enter the  address";
                                      }
                                    },


                                    decoration: new InputDecoration(
                                      hintText: 'Address',
                                      labelText: 'Enter the address2',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54, width: 3.0),
                                      ),

//                                      icon: new Icon(Icons.queue_play_next),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54, width: 3.0),
                                      ),
                                    )

                                )
                            ),
                          ),*/

                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        '${"Email"}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: TextFormField(
                                      controller: emailController,
                                      validator: (String ?value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the email id";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email ID"),
                                    ),
                                  ),
                                ],
                              )),
                          /*Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextFormField(
                                      controller:mobileController,
                                      keyboardType: TextInputType.number,
                                      validator: (String value){
                                        if(value.isEmpty){
                                          return " Please enter the mobile No";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Mobile Number"),
                                      enabled: false,
                                    ),
                                  ),
                                ],
                              )),*/
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        '${"Mobile"}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        '${"State"}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: TextFormField(
                                        controller: mobileController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          new LengthLimitingTextInputFormatter(
                                              10),
                                        ],
                                        validator: (String ?value) {
                                          if (value!.isEmpty && value == 10) {
                                            return " Please enter the mobile No";
                                          }
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter Mobile No"),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      controller: stateController,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the state";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter State"),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        '${"City"}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        '${"Pin Code"}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20),
                            padding: EdgeInsets.all(0.0),
                            child: Row(children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: TextFormField(
                                      controller: cityController,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the city";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter City"),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: TextFormField(
                                      controller: pincodeController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly,
                                        LengthLimitingTextInputFormatter(6)
                                      ],
                                      validator: (String ?value) {
                                        if (value!.isEmpty &&
                                            value.length == 6) {
                                          return " Please enter the pin code";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Pin Code"),
                                    ),
                                  ),
                                ),
                              ),
//                              Expanded(child:
//
//                              DropdownButton(
//                                hint: _dropDownValue1 == null
//                                    ? Text('Select gender')
//                                    : Text(
//                                  _dropDownValue1,
//                                  style: TextStyle(color: Colors.black),
//                                ),
//                                isExpanded: true,
//                                iconSize: 30.0,
//                                style: TextStyle(color: Colors.black,),
//                                items: [
//                                  'Male',
//                                  'Femail',
//                                ].map(
//                                      (val) {
//                                    return DropdownMenuItem<String>(
//                                      value: val,
//                                      child: Text(val),
//                                    );
//                                  },
//                                ).toList(),
//                                onChanged: (val) {
//                                  setState(
//                                        () {
//                                      _dropDownValue1 = val;
//                                    },
//                                  );
//                                },
//                              ),
//
//                              )
                            ]),
                          ),
                          _getActionButtons(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: Center(
                child: ElevatedButton(
                  child: new Text("${"Save"}"),
                  
                  onPressed: () {
                    setState(() {
                      if (_formKeyad.currentState!.validate()) {
                        if (pincodeController.text.length == 6) {
                          _AddAddress();
                        } else {
                          showLongToast("Please Enter a valid pin");
                        }

//                              setInfo();

                      }

//                        _status = true;
//                          FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  },
                style: ElevatedButton.styleFrom(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
             textStyle:TextStyle(color:Colors.white, ) ,
      padding: EdgeInsets.all(0.0),
      ),

                ),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

//

/*  Future setInfo() async {
    SharedPreferences pref= await SharedPreferences.getInstance();
    pref.setString("email", emailController.text);
    pref.setString("name", nameController.text);
    pref.setString("city", cityController.text);
    pref.setString("address", address1.text);
    pref.setString("sex", _dropDownValue1);
    pref.setString("mobile", mobileController.text);
    pref.setString("pin", pincodeController.text);
    pref.setString("state", stateController.text);
    pref.setBool("isLogin", true);
//        print(user.name);
    Constant.email=emailController.text;
    Constant.name=nameController.text;

    if(Constant.isLogin){
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => CheckOutPage()));


    }
    else{
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignInPage()),);
    }

  }*/

  Future _AddAddress() async {
     SharedPreferences pref = await SharedPreferences.getInstance();

   final userId = pref.get("mobile");
// print(Constant.Shop_id);
// print(Constant.API_KEY);
 print(FoodAppConstant.User_ID);
// print(nameController.text);
// print(mobileController.text);
// print(emailController.text);
// print(address1.text);
// print(address2.text);
// print(cityController.text);
// print(stateController.text);
// print(pincodeController.text);
// print(labelController.text);
    log(FoodAppConstant.user_id.toString());
    var map = new Map<String, dynamic>();
    map['shop_id'] = FoodAppConstant.Shop_id;
    map['X-Api-Key'] = FoodAppConstant.API_KEY;
    map['user_id'] = user_id;
    map['full_name'] = nameController.text;
    map['mobile'] = mobileController.text;
    map['email'] = emailController.text;
    map['address1'] = address1.text;
    map['address2'] = address2.text != null ? address2.text : "";
    map['city'] = cityController.text;
    map['state'] = stateController.text;
    map['pincode'] = pincodeController.text;
    map['label'] = labelController.text;
    map['lat'] = pre!.getString("lat") != null
        ? pre!.getString("lat")
        : FoodAppConstant.latitude.toString();
    map['lng'] = pre!.getString("lng") != null
        ? pre!.getString("lng")
        : FoodAppConstant.longitude.toString();
    String link = FoodAppConstant.base_url + "manage/api/user_address/add";

    log(link.toString());
    final response = await http.post(Uri.parse(link), body: map);
    // log(response.body.toString());
    // log(response.statusCode.toString());
    if (response.statusCode == 200) {
      // log(response.body.toString());
      final jsonBody = json.decode(response.body);
      print(response.body);
      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));

      showLongToast(user.message??"");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShowAddress(widget.valu)),
      );
//      RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));

    } else
      throw Exception("Unable to get Employee list");
  }

  Widget getLabel() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
      child: TextFormField(
        controller: labelController,
        validator: (String? value) {
          if (value!.isEmpty) {
            return " Please enter the label";
          }
        },
        decoration: const InputDecoration(hintText: "Enter Label"),
      ),
    );
  }

  Widget _getEditIcon() {
    return Container(
      margin: EdgeInsets.only(top: 23),
      child: new CircleAvatar(
        backgroundColor: FoodAppColors.tela,
        radius: 18.0,
        child: new Icon(
          Icons.location_on,
          color: Colors.white,
          size: 20.0,
        ),
      ),
    );
  }
}
