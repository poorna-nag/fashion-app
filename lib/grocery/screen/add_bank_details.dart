import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/model/RegisterModel.dart';
import 'package:royalmart/grocery/model/UserUpdateModel.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class AddBankDetails extends StatefulWidget {
  final String userid;
  const AddBankDetails(this.userid) : super();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AddBankDetails> {
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  Future<File>? file;
  String? status = '';
  String? base64Image, imagevalue;
  File? _image, imageshow1;
  String? errMessage = 'Error Uploading Image';
  String? user_id;
  String? city1;
  String? address1;
  String? _userProfileName; // Store user's actual name from API
  String? url =
      "http://chuteirafc.cartacapital.com.br/wp-content/uploads/2018/12/15347041965884.jpg";

  var _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final passwordController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final profilescaffoldkey = new GlobalKey<ScaffoldState>();
  final resignofcause = TextEditingController();
  String _dropDownValue1 = " ";
  Future<File>? profileImg;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  Future<void> getUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    user_id = pre.getString("user_id");

    // First load from shared preferences as fallback
    String? name = pre.getString("name");
    String? email = pre.getString("email");
    String? mobile = pre.getString("mobile");
    String? pin = pre.getString("pin");
    String? city = FoodAppConstant.city;
    String? address = pre.getString("address");
    String? sex = pre.getString("sex");
    String? image = pre.getString("pp");

    String? accountName = pre.getString("aname");
    String? accountNumber = pre.getString("anumber");
    String? bankName = pre.getString("bankname");
    String? bankBranch = pre.getString("bankbranch");
    String? ifscCode = pre.getString("ifsc");
    String? type = pre.getString("atype");

    print("User ID: $user_id");

    // Now fetch fresh data from API
    await _fetchUserProfileFromAPI();

    this.setState(() {
      city1 = city;
      address1 = address;
      // Bank details from shared preferences (user input fields)
      nameController.text = accountName ?? "";
      emailController.text = accountNumber ?? "";
      stateController.text = bankBranch ?? "";
      mobileController.text = bankName ?? "";
      cityController.text = ifscCode ?? "";
      _dropDownValue1 = type ?? "";

      if (image != null) {
        GroceryAppConstant.image = image;
        url = GroceryAppConstant.image;
      }
    });
  }

  Future<void> _fetchUserProfileFromAPI() async {
    if (user_id == null || user_id!.isEmpty) {
      print("User ID is null or empty, cannot fetch profile");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(GroceryAppConstant.base_url +
            'manage/api/customers/all?X-Api-Key=${GroceryAppConstant.API_KEY}&shop_id=${GroceryAppConstant.Shop_id}&user_id=$user_id'),
      );

      print("Profile API Response: ${response.statusCode}");
      print("Profile API Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        if (jsonBody['data'] != null &&
            jsonBody['data']['customers'] != null &&
            jsonBody['data']['customers'].isNotEmpty) {
          var customerData = jsonBody['data']['customers'][0];

          // Update profile constants that will be sent to API (not form fields)
          setState(() {
            _userProfileName =
                customerData['name'] ?? ""; // Store user's actual name
            GroceryAppConstant.email = customerData['email'] ?? "";
            FoodAppConstant.mobile =
                customerData['username'] ?? customerData['phone'] ?? "";
            FoodAppConstant.city = customerData['city'] ?? "";
            FoodAppConstant.address = customerData['address'] ?? "";

            print("✅ Profile data loaded from API:");
            print(
                "Name: ${customerData['name']} (will be sent as 'name' parameter)");
            print("Email: ${customerData['email']}");
            print("Mobile: ${customerData['username']}");
            print("City: ${customerData['city']}");
            print("Address: ${customerData['address']}");
          });
        }
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
          backgroundColor: Color(0xFFE91E63),
          title: Text(
            "Bank Details",
            style: TextStyle(color: Colors.white),
          )),
      key: profilescaffoldkey,
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
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(
                            0xFFF8F9FA), // Light elegant background like sign-in page
                        Color(0xFFFFE8F0), // Soft pink tint
                        Color(0xFFF8F9FA),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
//                          profile(context),
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
                                        'Name',
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
                                      controller: pincodeController,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter your name";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Enter name",
                                      ),
                                      enabled: !_status,
                                      autofocus: !_status,
                                    ),
                                  ),
                                ],
                              )),
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
                                        'Account Name',
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
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter account name";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Account Name"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
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
                                        'Account Number',
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
                                      keyboardType: TextInputType.number,
                                      controller: emailController,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter account number";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Account Number"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
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
                                        'Bank Name',
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
                                      controller: mobileController,
                                      keyboardType: TextInputType.name,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the bank name";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Bank Name"),
                                      enabled: true,
                                    ),
                                  ),
                                ],
                              )),
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
                                        'Bank Branch',
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
                                      controller: stateController,
                                      keyboardType: TextInputType.name,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the bank branch";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Bank Branch"),
                                      enabled: true,
                                    ),
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
                                        'IFSC Code',
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
                                        'Account Type',
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
                                          return " Please enter IFSC Code";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter IFSC Code"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 3),
                                  child: Container(
                                    width: 100,
                                    height: 80,
                                    child: DropdownButton(
                                      hint: _dropDownValue1 == null
                                          ? Text('Select Account ')
                                          : Text(
                                              _dropDownValue1,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                      isExpanded: true,
                                      iconSize: 30.0,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      items: [
                                        'Savings',
                                        'Current',
                                      ].map(
                                        (val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(val),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (val) {
                                        setState(
                                          () {
                                            _dropDownValue1 = val!;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
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
                  child: new ElevatedButton(
                child: new Text("Submit"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // if (resignofcause.text.length > 5) {
                    _getEmployee();
                    // } else {
                    //   showLongToast("Please add the Details Correctly");
                    // }
                  }

//                        _status = true;
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(0.0),
                ),
              )),
            ),
            flex: 2,
          ),
          // Expanded(
          //   child: Padding(
          //     padding: EdgeInsets.only(left: 10.0),
          //     child: Container(
          //         child: new RaisedButton(
          //       child: new Text("Cancel"),
          //       textColor: Colors.white,
          //       color: Colors.red,
          //       onPressed: () {
          //         if (Navigator.canPop(context)) {
          //           Navigator.pop(context);
          //         } else {
          //           SystemNavigator.pop();
          //         }
          //         setState(() {});
          //       },
          //       shape: new RoundedRectangleBorder(
          //           borderRadius: new BorderRadius.circular(20.0)),
          //     )),
          //   ),
          //   flex: 2,
          // ),
        ],
      ),
    );
  }

//

  Future _getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var map = new Map<String, dynamic>();
    map['name'] = _userProfileName ?? ""; // Use actual user name from API
    map['X-Api-Key'] = GroceryAppConstant.API_KEY;
    map['email'] = GroceryAppConstant.email;
    map['phone'] = FoodAppConstant.mobile;
    map['city'] = FoodAppConstant.city == "" ? "City" : FoodAppConstant.city;
    map['address'] =
        FoodAppConstant.address == "" ? "a" : FoodAppConstant.address;
    map['username'] = FoodAppConstant.mobile;
    map['anumber'] = emailController.text;
    map['aname'] = nameController.text;
    map['atype'] = _dropDownValue1;
    map['ifsc'] = cityController.text;
    map['bankbranch'] = stateController.text;
    map['bankname'] = mobileController.text;

    print("=== BANK DETAILS BEFORE SENDING TO API ===");
    print("URL: ${GroceryAppConstant.base_url}manage/api/customers/update");
    print("User Profile Data (from API):");
    print("  name: ${_userProfileName} (user's actual name)");
    print("  email: ${GroceryAppConstant.email}");
    print("  phone: ${FoodAppConstant.mobile}");
    print("  city: ${FoodAppConstant.city}");
    print("  address: ${FoodAppConstant.address}");
    print("  username: ${FoodAppConstant.mobile}");
    print("");
    print("Bank Details (user input):");
    print(
        "  Account Holder Name (pincodeController): ${pincodeController.text}");
    print("  Account Name (aname): ${nameController.text}");
    print("  Account Number (anumber): ${emailController.text}");
    print("  Bank Name (bankname): ${mobileController.text}");
    print("  Bank Branch (bankbranch): ${stateController.text}");
    print("  IFSC Code (ifsc): ${cityController.text}");
    print("  Account Type (atype): $_dropDownValue1");
    print("");
    print("Complete API Payload:");
    log(map.toString());
    print("==========================================");

    final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'manage/api/customers/update'),
        body: map);

    print("=== API RESPONSE ===");
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    print("===================");

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print("Parsed JSON Response:");
      print(jsonBody.toString());
      print("Message from API: ${jsonBody["message"]}");

      if (jsonBody["message"] ==
          "Your data has been successfully updated into the database") {
        print("✅ SUCCESS: Data updated successfully");
        _showLongToast(jsonBody["message"]);

        pref.setString("anumber", emailController.text);
        pref.setString("aname", nameController.text);
        pref.setString("ifsc", cityController.text);
        pref.setString("atype", _dropDownValue1);
        pref.setString("bankbranch", stateController.text);
        pref.setString("bankname", mobileController.text);
        pref.setString("name", pincodeController.text);

        pref.setBool("isLogin", true);
        GroceryAppConstant.isLogin = true;
        GroceryAppConstant.email = emailController.text;
        GroceryAppConstant.name = nameController.text;
        Navigator.pop(context);
      } else {
        print("❌ API returned different message: ${jsonBody["message"]}");
        _showLongToast(jsonBody["message"] ?? "Update failed");
      }
    } else {
      print("❌ API request failed with status code: ${response.statusCode}");
      _showLongToast(
          "Failed to connect to server. Status: ${response.statusCode}");
    }
  }

  void _showLongToast(String message) {
    final snackbar = new SnackBar(content: Text("$message"));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
