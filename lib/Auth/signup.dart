import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:royalmart/Auth/Form5.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/Auth/widgets/custom_shape.dart';
import 'package:royalmart/Auth/widgets/responsive_ui.dart';
import 'package:royalmart/Auth/widgets/textformfield.dart';
import 'package:royalmart/General/AppConstant.dart';

import 'package:geolocator/geolocator.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/model/UserUpdateModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? name;
  String? mobile;
  bool checkBoxValue = false, flag = false;
  double? _height;
  double? _width;
  double? _pixelRatio;
  bool? _large;
  bool? _medium;
  TextEditingController namelController = TextEditingController();
  TextEditingController ShopnamelController = TextEditingController();
  TextEditingController SHOPADDRESSController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController sponsorController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController panController = TextEditingController();
  String? pinval = "";
  String? message;
  bool isLoading = false;
  File? _image, imageshow1;
  String? base64Image, imagevalue;
  File? _image1, imageshow11;
  String? base64Image1, imagevalue1;
  Future<void> getLocation() async {
    // PermissionStatus permission = await PermissionHandler()
    //     .checkPermissionStatus(PermissionGroup.location);

    // if (permission == PermissionStatus.denied) {
    //   await PermissionHandler()
    //       .requestPermissions([PermissionGroup.locationAlways]);
    // } else if (permission == PermissionStatus.granted) {
    //   _getCurrentLocation();
    //   // showToast('Access granted');
    // }

    // var geolocator = Geolocator();

    //
    // GeolocationStatus geolocationStatus =
    // await geolocator.checkGeolocationPermissionStatus();
    //
    // switch (geolocationStatus) {
    //   case GeolocationStatus.denied:
    //     showToast('denied');
    //     break;
    //   case GeolocationStatus.disabled:
    //     showToast('disabled');
    //     break;
    //   case GeolocationStatus.restricted:
    //     showToast('restricted');
    //     break;
    //   case GeolocationStatus.unknown:
    //     showToast('unknown');
    //     break;
    //   case GeolocationStatus.granted:
    //     showToast('Access granted');
    //     _getCurrentLocation();
    // }
  }

  Position? position;
  double? lat, long;

  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      lat = position!.latitude;
      long = position!.longitude;
      FoodAppConstant.latitude = lat!;
      FoodAppConstant.longitude = long!;

      getAddress();
      print(lat);
      print(long);
    });
  }

  String? valArea;
  getAddress() async {
    var addresses = await placemarkFromCoordinates(lat!, long!);
    var first = addresses.first;

    setState(() {
      var address = first.subLocality.toString() +
          " " +
          first.subAdministrativeArea.toString() +
          " " +
          first.subThoroughfare.toString() +
          " " +
          first.thoroughfare.toString();
    });

    return first;
  }

  Future _getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(FoodAppConstant.Shop_id);
    print(namelController.text);
    print(mobileController.text);
    print(emailController.text);
    print(passwordController.text);
    print(SHOPADDRESSController.text);
    print(FoodAppConstant.latitude.toString());
    print(FoodAppConstant.longitude.toString());
    print(cityController.text);
    print(pinval);
    try {
      // -------------employeee list start
      var map = new Map<String, dynamic>();
      map['shop_id'] = FoodAppConstant.Shop_id;
      map['name'] = namelController.text;
      map['mobile'] = mobileController.text;
      map['email'] = emailController.text;
      map['password'] = passwordController.text;
      map['address'] = SHOPADDRESSController.text;
      map['lat'] = FoodAppConstant.latitude.toString();
      map['lng'] = FoodAppConstant.longitude.toString();
      map['cities'] = cityController.text;
      map['pin'] = pinval;
      map['sponsor'] = sponsorController.text;
      // map['aadhar'] = aadharController.text;
      // map['pan'] = panController.text;
      log(map.toString());
      final response = await http.post(
          (Uri.parse(FoodAppConstant.base_url + 'api/step3.php')),
          body: map);

      if (response.statusCode == 200) {
        log(response.body.toString());
        final jsonBody = json.decode(response.body);
        log("json body======>${jsonBody}");
        log(jsonBody["message"].toString());
        // RegisterModel user =
        //     RegisterModel.fromJson(jsonBody);

        if (jsonBody["message"].toString() == "User Registered Successfully") {
          // Aadhar Upload
          getAdhar(jsonBody["user_id"]);
          // pan Upload
          getPan(jsonBody["user_id"]);
          setState(() {
            flag = false;
            FoodAppConstant.user_id = jsonBody["user_id"];
          });
          _showLongToast(jsonBody["message"]);
          pref.setString("email", jsonBody["email"]);
          pref.setString("name", jsonBody["name"]);
          pref.setString("city", jsonBody["city"]);
          pref.setString("address", jsonBody["address"]);
          pref.setString("mobile", jsonBody["username"]);
          pref.setString("user_id", jsonBody["user_id"]);
          pref.setString("pp", jsonBody["pp"]);
          pref.setString("lat", FoodAppConstant.latitude.toString());
          pref.setString("lng", FoodAppConstant.longitude.toString());

          pref.setBool("isLogin", true);
          FoodAppConstant.email = jsonBody["email"];
          FoodAppConstant.name = jsonBody["name"];
          FoodAppConstant.Mobile = jsonBody["username"];
          FoodAppConstant.isLogin = true;
          FoodAppConstant.image = jsonBody["pp"];
          FoodAppConstant.address = jsonBody["address"];
          FoodAppConstant.city = jsonBody["city"];
          if (jsonBody["pp"] == null) {
            FoodAppConstant.image = "";
          } else {
            FoodAppConstant.image = jsonBody["pp"];
          }
          FoodAppConstant.image = jsonBody["pp"];

//        pref.setString("mobile",phoneController.text);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SignInPage()),
              (route) => false);

          // Navigator.push(context, MaterialPageRoute(builder: (context) => Uploadimage(user.userId,user.username)),);
        } else
          throw Exception("Unable to get Employee list");
        // -------------employeee list end
      } else {
        setState(() {
          message = "Something went wrong...";
          sponsorController.clear();
        });
      }
    } catch (e, s) {}

//     var map = new Map<String, dynamic>();
//     map['shop_id'] = FoodAppConstant.Shop_id;
//     map['name'] = namelController.text;
//     map['mobile'] = mobileController.text;
//     map['email'] = emailController.text;
//     map['password'] = passwordController.text;
//     map['address'] = SHOPADDRESSController.text;
//     map['lat'] = FoodAppConstant.latitude.toString();
//     map['lng'] = FoodAppConstant.longitude.toString();
//     map['cities'] = cityController.text;
//     map['pin'] = pinval;
//     map['sponsor'] = sponsorController.text;
//     final response =
//         await http.post(FoodAppConstant.base_url + 'api/step3.php', body: map);
//     if (response.statusCode == 200) {
//       final jsonBody = json.decode(response.body);
//       RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));
//       if (user.message.toString() == "User Registered Successfully") {
//         setState(() {
//           flag = false;
//           FoodAppConstant.user_id = user.userId;
//         });
//         _showLongToast(user.message);
//         pref.setString("email", user.email);
//         pref.setString("name", user.name);
//         pref.setString("city", user.city);
//         pref.setString("address", user.address);
//         pref.setString("mobile", user.username);
//         pref.setString("user_id", user.userId);
//         pref.setString("pp", user.pp);
//         pref.setString("lat", FoodAppConstant.latitude.toString());
//         pref.setString("lng", FoodAppConstant.longitude.toString());

//         pref.setBool("isLogin", true);
//         FoodAppConstant.email = user.email;
//         FoodAppConstant.name = user.name;
//         FoodAppConstant.isLogin = true;
//         FoodAppConstant.image = user.pp;
//         if (user.pp == null) {
//           FoodAppConstant.image = "";
//         } else {
//           FoodAppConstant.image = user.pp;
//         }
//         FoodAppConstant.image = user.pp;

// //        pref.setString("mobile",phoneController.text);

//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => SignInPage()),
//             (route) => false);

//         // Navigator.push(context, MaterialPageRoute(builder: (context) => Uploadimage(user.userId,user.username)),);
//       } else {
//         _showLongToast(user.message);
//       }
//     } else
    // throw Exception("Unable to get Employee list");
  }

  Future getAdhar(userId) async {
    var map = new Map<String, dynamic>();
    map['aadhar'] = "data:image/png;base64," + base64Image!;
    map['user_id'] = userId;
    map['kyc'] = "aadhar";

//    print(base64Image);
//    print(widget.userid);
//    print(mobileController.text);
    try {
      final response = await http
          .post("${ GroceryAppConstant.base_url}api/kycupload.php" as Uri, body: map);
      if (response.statusCode == 200) {
        print(response.toString());
        U_updateModal user = U_updateModal.fromJson(jsonDecode(response.body));
        _showLongToast(user.message);
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("pp", user.img);
        setState(() {
          // GroceryAppConstant.image = user.img;
          // GroceryAppConstant.check = true;
        });
        print(user.img);
      } else
        throw Exception("Unable to get Employee list");
    } catch (Exception) {}
  }

  Future getPan(userId) async {
    var map = new Map<String, dynamic>();
    map['pan'] = "data:image/png;base64," + base64Image1!;
    map['user_id'] = userId;
    map['kyc'] = "pan";

//    print(base64Image);
//    print(widget.userid);
//    print(mobileController.text);
    try {
      final response = await http
          .post("${ GroceryAppConstant.base_url}api/kycupload.php" as Uri, body: map);
      if (response.statusCode == 200) {
        print(response.toString());
        U_updateModal user = U_updateModal.fromJson(jsonDecode(response.body));
        _showLongToast(user.message);
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("pp", user.img);
        setState(() {
          // GroceryAppConstant.image = user.img;
          // GroceryAppConstant.check = true;
        });
        print(user.img);
      } else
        throw Exception("Unable to get Employee list");
    } catch (Exception) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gatinfo();
    getLocation();
  }

  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString("name");
    mobile = pref.getString("mobile");
    String? add = pref.getString("address");
    String? lat = pref.getString("lat");
    String? lng = pref.getString("lng");
    String? pin = pref.getString("pin");
    String? city = pref.getString("city");
    setState(() {
      // namelController.text= name;
      mobileController.text = mobile ?? "";

      add != null
          ? SHOPADDRESSController.text = add
          : SHOPADDRESSController.text = valArea ?? "";
      pinval = pin != null ? pin : "";
      cityController.text = city != null ? city : "";
      FoodAppConstant.latitude = double.parse(lat!);
      FoodAppConstant.longitude = double.parse(lng!);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // _showPasswordDialog();
      print("Hii RAhul");
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width!, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(_width!, _pixelRatio!);

    return Material(
      child: Container(
        height: _height!,
        width: _width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FA), // Light elegant background
              Color(0xFFFFE8F0), // Soft pink tint
              Color(0xFFF8F9FA),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: <Widget>[
                SizedBox(height: _height! * 0.05),
                
                // Header Section with Fashion Logo
                Container(
                  height: _height! * 0.2,
                  child: Stack(
                    children: [
                      // Decorative elements
                      Positioned(
                        top: 10,
                        right: -10,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Color(0xFFE91E63).withOpacity(0.15),
                                Colors.transparent,
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      
                      // Logo and Brand
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Fashion Logo Container
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Color(0xFFFFF0F5), // Light pink background
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Color(0xFFE91E63).withOpacity(0.2),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFE91E63).withOpacity(0.15),
                                    blurRadius: 20,
                                    spreadRadius: 3,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/logo.png',
                                height: 50,
                                width: 50,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 16),
                            
                            // Brand Name
                            Text(
                              "Join Fashion",
                              style: TextStyle(
                                fontSize: _large! ? 28 : (_medium! ? 24 : 20),
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2D3748),
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              "Create your fashion account",
                              style: TextStyle(
                                fontSize: _large! ? 14 : (_medium! ? 12 : 10),
                                color: Color(0xFF718096),
                                letterSpacing: 1,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: _height! * 0.03),
                
                // Registration Form
                Container(
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Color(0xFFFFFAFD), // Very light pink
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Color(0xFFE91E63).withOpacity(0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE91E63).withOpacity(0.08),
                        blurRadius: 30,
                        spreadRadius: 0,
                        offset: Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Name Field
                      _buildFashionTextField(
                        controller: namelController,
                        label: "Full Name",
                        icon: Icons.person_outline,
                      ),
                      SizedBox(height: 20),
                      
                      // Shop Name Field
                      _buildFashionTextField(
                        controller: ShopnamelController,
                        label: "Shop Name (Optional)",
                        icon: Icons.store_outlined,
                      ),
                      SizedBox(height: 20),
                      
                      // Mobile Field
                      _buildFashionTextField(
                        controller: mobileController,
                        label: "Mobile Number",
                        icon: Icons.phone_android,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      SizedBox(height: 20),
                      
                      // Email Field
                      _buildFashionTextField(
                        controller: emailController,
                        label: "Email Address",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 20),
                      
                      // Password Field
                      _buildFashionTextField(
                        controller: passwordController,
                        label: "Password",
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      
                      // City Field
                      _buildFashionTextField(
                        controller: cityController,
                        label: "City",
                        icon: Icons.location_city_outlined,
                      ),
                      SizedBox(height: 20),
                      
                      // Address Field
                      _buildFashionTextField(
                        controller: SHOPADDRESSController,
                        label: "Address",
                        icon: Icons.home_outlined,
                        maxLines: 2,
                      ),
                      SizedBox(height: 20),
                      
                      // Sponsor/Referral Field
                      _buildFashionTextField(
                        controller: sponsorController,
                        label: "Referral Code (Optional)",
                        icon: Icons.card_giftcard_outlined,
                      ),
                      SizedBox(height: 24),
                      
                      // Terms and Conditions
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF5F8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFE91E63).withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: checkBoxValue ? Color(0xFFE91E63) : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Color(0xFFE91E63),
                                  width: 2,
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    checkBoxValue = !checkBoxValue;
                                  });
                                },
                                child: checkBoxValue
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "I agree to the Terms and Conditions & Privacy Policy",
                                style: TextStyle(
                                  fontSize: _large! ? 14 : (_medium! ? 12 : 10),
                                  color: Color(0xFF2D3748),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Create Account Button
                      _buildFashionButton(
                        text: "CREATE ACCOUNT",
                        isEnabled: checkBoxValue,
                        onPressed: () {
                          if (namelController.text.isEmpty) {
                            _showLongToast("Please enter your name");
                          } else if (mobileController.text.length != 10) {
                            _showLongToast("Please enter a valid mobile number");
                          } else if (emailController.text.isEmpty || !emailController.text.contains('@')) {
                            _showLongToast("Please enter a valid email");
                          } else if (passwordController.text.length < 5) {
                            _showLongToast("Password should contain at least 5 characters");
                          } else if (SHOPADDRESSController.text.isEmpty) {
                            _showLongToast("Please enter your address");
                          } else {
                            setState(() {
                              flag = true;
                            });
                            _getEmployee();
                          }
                        },
                        isLoading: flag,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 30),
                
                // Sign In Section
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFF5F8),
                        Color(0xFFFFE8F0),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Color(0xFFE91E63).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Color(0xFF718096),
                          fontSize: _large! ? 14 : (_medium! ? 12 : 10),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignInPage()),
                          );
                        },
                        child: Text(
                          "SIGN IN",
                          style: TextStyle(
                            color: Color(0xFFE91E63),
                            fontSize: _large! ? 14 : (_medium! ? 12 : 10),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFE91E63),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFashionTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFFFFAFD),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFE91E63).withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE91E63).withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        style: TextStyle(
          fontSize: _large! ? 16 : (_medium! ? 14 : 12),
          color: Color(0xFF2D3748),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Color(0xFF718096),
            fontSize: _large! ? 14 : (_medium! ? 12 : 10),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE91E63).withOpacity(0.1),
                  Color(0xFFE91E63).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Color(0xFFE91E63),
              size: _large! ? 20 : (_medium! ? 18 : 16),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Color(0xFFE91E63),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          counterText: "", // Hide the character counter
        ),
      ),
    );
  }

  Widget _buildFashionButton({
    required String text,
    required bool isEnabled,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: isEnabled 
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE91E63),
                Color(0xFFD81B60),
              ],
            )
          : LinearGradient(
              colors: [
                Color(0xFFE2E8F0),
                Color(0xFFCBD5E0),
              ],
            ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: isEnabled 
          ? [
              BoxShadow(
                color: Color(0xFFE91E63).withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 0,
                offset: Offset(0, 8),
              ),
            ]
          : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: isEnabled && !isLoading ? onPressed : null,
          splashColor: Colors.white.withOpacity(0.2),
          child: Container(
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: _large! ? 16 : (_medium! ? 14 : 12),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: isEnabled ? Colors.white : Color(0xFF94A3B8),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget modernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFE91E63).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE91E63).withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: _large! ? 16 : (_medium! ? 14 : 12),
          color: Color(0xFF2D3748),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Color(0xFF718096),
            fontSize: _large! ? 14 : (_medium! ? 12 : 10),
          ),
          prefixIcon: Icon(
            icon,
            color: Color(0xFFE91E63),
            size: _large! ? 24 : (_medium! ? 22 : 20),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(0xFFE91E63),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget modernButton({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null ? Color(0xFFE91E63) : Color(0xFFE2E8F0),
          foregroundColor: Colors.white,
          elevation: onPressed != null ? 8 : 0,
          shadowColor: Color(0xFFE91E63).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: _large! ? 16 : (_medium! ? 14 : 12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large!
                  ? _height! / 4
                  : (_medium! ? _height! / 3.75 : _height! / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [FoodAppColors.tela, FoodAppColors.tela],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large!
                  ? _height! / 4.5
                  : (_medium! ? _height! / 4.25 : _height! / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [FoodAppColors.tela, FoodAppColors.tela],
                ),
              ),
            ),
          ),
        ),
        Container(
          // color: Colors.grey,
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large!
                  ? _height! / 30
                  : (_medium! ? _height! / 25 : _height! / 20)),
          child: Image.asset(
            'assets/images/logo.png',
            height: 120,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width! / 12.0, right: _width! / 12.0, top: _height! / 60.0),
      child: Form(
        child: Column(
          children: <Widget>[
            lastNameTextFormField(),
            SizedBox(height: _height! / 60.0),
            firstNameTextFormField(),
            SizedBox(height: _height! / 60.0),
            phoneTextFormField(),
            SizedBox(height: _height! / 60.0),
            emailTextFormField(),
            SizedBox(height: _height! / 60.0),
            passwordTextFormField(),
            //  SizedBox(height: _height! / 60.0),
            // aadharTextFormField(),
            // SizedBox(height: _height! / 60.0),
            // panTextFormField(),
            // SizedBox(height: _height! / 60.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     InkWell(
            //       onTap: () {
            //         showDialog(
            //           context: context,
            //           builder: (ctx) {
            //             return SimpleDialog(
            //               insetPadding: const EdgeInsets.symmetric(
            //                 horizontal: 100,
            //               ),
            //               children: [
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     InkWell(
            //                       onTap: () async {
            //                         getImage(context);
            //                         Navigator.of(context).pop();
            //                       },
            //                       child: Column(
            //                         children: const [
            //                           Icon(
            //                             Icons.image,
            //                             size: 40,
            //                           ),
            //                           Text('Gallery'),
            //                         ],
            //                       ),
            //                     ),
            //                     // AppSpacing.ksizedBoxW30,
            //                     SizedBox(
            //                       width: 30,
            //                     ),
            //                     InkWell(
            //                       onTap: () async {
            //                         getImageC(context);

            //                         Navigator.of(context).pop();
            //                       },
            //                       child: Column(
            //                         children: const [
            //                           Icon(
            //                             Icons.camera_alt,
            //                             size: 40,
            //                           ),
            //                           Text('Camera'),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             );
            //           },
            //         );
            //       },
            //       child: Container(
            //         child: Row(
            //           children: [
            //             _image == null
            //                 ? Text("Aadhar Card")
            //                 : Text(_image!.path
            //                     .toString()
            //                     .split("_")
            //                     .last
            //                     .substring(_image!.path
            //                             .toString()
            //                             .split("_")
            //                             .last
            //                             .length -
            //                         10)),
            //             // uploadAadharCard()
            //             Icon(Icons.upload_rounded),
            //           ],
            //         ),
            //       ),
            //     ),
            //     InkWell(
            //       onTap: () {
            //         showDialog(
            //           context: context,
            //           builder: (ctx) {
            //             return SimpleDialog(
            //               insetPadding: const EdgeInsets.symmetric(
            //                 horizontal: 100,
            //               ),
            //               children: [
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     InkWell(
            //                       onTap: () async {
            //                         getImage1(context);
            //                         Navigator.of(context).pop();
            //                       },
            //                       child: Column(
            //                         children: const [
            //                           Icon(
            //                             Icons.image,
            //                             size: 40,
            //                           ),
            //                           Text('Gallery'),
            //                         ],
            //                       ),
            //                     ),
            //                     // AppSpacing.ksizedBoxW30,
            //                     SizedBox(
            //                       width: 30,
            //                     ),
            //                     InkWell(
            //                       onTap: () async {
            //                         getImageC1(context);

            //                         Navigator.of(context).pop();
            //                       },
            //                       child: Column(
            //                         children: const [
            //                           Icon(
            //                             Icons.camera_alt,
            //                             size: 40,
            //                           ),
            //                           Text('Camera'),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             );
            //           },
            //         );
            //       },
            //       child: Container(
            //         child: Row(
            //           children: [
            //             _image1 == null
            //                 ? Text("Pan Card")
            //                 : Text(_image1!.path
            //                     .toString()
            //                     .split("_")
            //                     .last
            //                     .substring(_image1!.path
            //                             .toString()
            //                             .split("_")
            //                             .last
            //                             .length -
            //                         10)),
            //             // uploadPanCard()
            //             Icon(Icons.upload_rounded),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: _height! / 60.0),
            sponsorTextFormField(),
            SizedBox(height: _height! / 60.0),

            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: FoodAppColors.tela,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Check Referral Code",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          getRefferalDetails(sponsorController.text);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: FoodAppColors.sellp,
                        textColor: FoodAppColors.white,
                        child: Text("Check"),
                      )
                    ],
                  ),
            message != null
                ? Text(
                    "${message}",
                    style: TextStyle(
                        color: message == "Incorrect Referral Code..."
                            ? Colors.red
                            : message == "User Membership Not Activated...!"
                                ? Colors.red
                                : FoodAppColors.sellp,
                        fontWeight: FontWeight.bold),
                  )
                : Container(),
            // _image == null
            //     ? Text(
            //         "Upload Aadhar Card",
            //         style: TextStyle(
            //             color: Colors.red, fontWeight: FontWeight.bold),
            //       )
            //     : Container(),
            // _image1 == null
            //     ? Text(
            //         "Upload Pan Card",
            //         style: TextStyle(
            //             color: Colors.red, fontWeight: FontWeight.bold),
            //       )
            //     : Container(),
            flag ? circularIndi() : Row(),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      obscureText: false,
      keyboardType: TextInputType.text,
      textEditingController: namelController,
      icon: Icons.person,
      hint: "Name",
    );
  }

  Widget lastNameTextFormField() {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyMap1()),
          );
        },
        child: Card(
          color: FoodAppColors.tela,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.location_on_outlined,
                    size: 30, color: FoodAppColors.black),
              ),
              Expanded(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 3, right: 3, bottom: 5),
                      child: Text(
                        "Use Current Location",
                        style: TextStyle(
                            fontSize: 20,
                            color: FoodAppColors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10,
                        left: 3,
                        right: 3,
                      ),
                      child: Text(
                        "Add New Address  ",
                        style: TextStyle(
                          fontSize: 15,
                          color: FoodAppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              Padding(
                padding: EdgeInsets.all(5),
                child:
                    Icon(Icons.forward, size: 30, color: FoodAppColors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      obscureText: false,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget phoneTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: mobileController,
      obscureText: false,
      icon: Icons.phone,
      hint: "Mobile Number",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: passwordController,
      obscureText: true,
      icon: Icons.lock,
      hint: "Password",
    );
  }

  Widget sponsorTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: sponsorController,
      icon: Icons.person,
      obscureText: false,
      hint: "Referral Code ",
    );
  }

  Widget aadharTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: aadharController,
      icon: Icons.notes_outlined,
      obscureText: false,
      hint: "Aadhar card no ",
    );
  }

  Widget panTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: panController,
      icon: Icons.notes_outlined,
      obscureText: false,
      hint: "Pan card no ",
    );
  }

  Widget uploadAadharCard() {
    return IconButton(
      onPressed: () {},
      icon: Icon(Icons.upload_rounded),
    );
  }

  Widget uploadPanCard() {
    return IconButton(
      onPressed: () {},
      icon: Icon(Icons.upload_rounded),
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.redAccent,
              value: checkBoxValue,
              onChanged: (bool? newValue) {
                setState(() {
                  checkBoxValue = newValue!;
                });
              }),
          Text(
            "I accept all the terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large! ? 12 : (_medium! ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          textStyle: TextStyle(
            color: Colors.white,
          ),
          padding: EdgeInsets.all(0.0),
        ),
        onPressed: () {
          // getRefferalDetails(sponsorController.text);

          if (namelController.text.length < 1) {
            _showLongToast("Name is Empty !");
          } else if (SHOPADDRESSController.text.isEmpty ||
              SHOPADDRESSController.text.isEmpty) {
            _showLongToast("Please enter Address");
          } else if (mobileController.text.length != 10) {
            _showLongToast("Please enter ten digit No ");
          } else if (emailController.text.length < 1) {
            _showLongToast("Enter the email");
          } else if (passwordController.text.length <= 4) {
            _showLongToast("Password should be at least 5 digit");
            // } else if (aadharController.text.length != 12) {
            //   _showLongToast("Please enter correct aadhar card no ");
            // } else if (panController.text.length != 10) {
            //   _showLongToast("Please enter correct pan card no ");
            // } else if (sponsorController.text.length != 10) {
            //   _showLongToast("Please enter ten digit Referral Code ");
            // } else if (_image == null) {
            //   _showLongToast("Please Upload Aadhar card ");
            // } else if (_image1 == null) {
            //   _showLongToast("Please Upload Pan card ");
          } else {
            setState(() {
              flag = true;
            });
            _getEmployee().then((value) {
              setState(() {
                flag = false;
              });
            });
          }
        },
        child: Container(
          alignment: Alignment.center,
//        height: _height / 20,
          width: _large!
              ? _width! / 4
              : (_medium! ? _width! / 3.75 : _width! / 3.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            gradient: LinearGradient(
              colors: <Color>[FoodAppColors.boxColor1, FoodAppColors.tela],
            ),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'SIGN UP',
            style: TextStyle(fontSize: _large! ? 14 : (_medium! ? 12 : 10)),
          ),
        ),
      ),
    );
  }

  Widget infoTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Or create using social media",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large! ? 12 : (_medium! ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget socialIconsRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 80.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/googlelogo.png"),
          ),
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/fblogo.jpg"),
          ),
          SizedBox(
            width: 20,
          ),
          /* CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/twitterlogo.jpg"),
          ),*/
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                  (route) => false);
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.redAccent[200],
                  fontSize: 19),
            ),
          )
        ],
      ),
    );
  }

  void _showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  getRefferalDetails(String username) async {
    try {
      var link =
          "${FoodAppConstant.base_url}api/username.php?reffer_id=${username}";
      var response = await http.get(Uri.parse(link));
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        print(response.body);
        var responseData = jsonDecode(response.body);
        if (responseData["success"] == "true") {
          setState(() {
            message = responseData["name"];
          });
        } else if (responseData["message"] == "User Not Found...!") {
          setState(() {
            message = "Incorrect Referral Code...";
            sponsorController.clear();
          });
        } else if (responseData["message"] ==
            "User Membership Not Activated...!") {
          setState(() {
            message = "User Membership Not Activated...!";
            sponsorController.clear();
          });
          _showLongToast("User Membership Not Activated...!");
        }
      } else {
        setState(() {
          message = "Something went wrong...";
          sponsorController.clear();
        });
      }
      var responseData = jsonDecode(response.body);
      if (responseData["success"] == "true") {
        return message = responseData["name"];
      }
    } catch (e, s) {}
  }

  Widget circularIndi() {
    return Align(
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  getImageC(BuildContext context) async {
    XFile? data = await ImagePicker().pickImage(source: ImageSource.camera);
    imageshow1 = File(data!.path);
    String imagevalue1 = (imageshow1).toString();
    if (imagevalue1 != null) {
      imagevalue1.length > 7
          ? imagevalue =
              imagevalue1.substring(7, (imagevalue1.lastIndexOf('') - 1)).trim()
          : imagevalue1;

//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
// List<int> imageBytes = await imageshow1.readAsBytes();
      setState(() {
        base64Image = base64Encode(imageshow1!.readAsBytesSync());
        _image = new File('$imagevalue');
        print('Image Path $_image');
        FoodAppConstant.aadhar = base64Image!;
        // _ImageUpdate();
      });
    }
  }

  getImage(BuildContext context) async {
    XFile? data = (await ImagePicker().pickImage(source: ImageSource.gallery));
    imageshow1 = File(data!.path);
    String imagevalue1 = (imageshow1).toString();
    if (imagevalue1 != null) {
      imagevalue1.length > 7
          ? imagevalue =
              imagevalue1.substring(7, (imagevalue1.lastIndexOf('') - 1)).trim()
          : imagevalue1;

      // if (imagevalue1 != null) {
      //   imagevalue = imagevalue1 != null
      //       ? imagevalue1.substring(7, (imagevalue1.lastIndexOf('') - 1)).trim()
      //       : imagevalue1;
      setState(() {
        base64Image = base64Encode(imageshow1!.readAsBytesSync());
        print(base64Image);
        _image = new File('$imagevalue');
        print('Image Path $_image');
        FoodAppConstant.aadhar = base64Image!;
        // _ImageUpdate();
      });
    }
  }

  getImageC1(BuildContext context) async {
    XFile? data = (await ImagePicker().pickImage(source: ImageSource.camera));
    imageshow11 = File(data!.path);
    String imagevalue11 = (imageshow11).toString();
    if (imagevalue11 != null) {
      imagevalue11.length > 7
          ? imagevalue1 = imagevalue11
              .substring(7, (imagevalue11.lastIndexOf('') - 1))
              .trim()
          : imagevalue11;

//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        base64Image1 = base64Encode(imageshow11!.readAsBytesSync());
        _image1 = new File('$imagevalue1');
        print('Image Path $_image1');
        FoodAppConstant.pan = base64Image1!;
        // _ImageUpdate();
      });
    }
  }

  getImage1(BuildContext context) async {
    XFile? data = (await ImagePicker().pickImage(source: ImageSource.gallery));
    imageshow11 = File(data!.path);

    String imagevalue11 = (imageshow11).toString();
    if (imagevalue11 != null) {
      imagevalue11.length > 7
          ? imagevalue1 = imagevalue11
              .substring(7, (imagevalue11.lastIndexOf('') - 1))
              .trim()
          : imagevalue11;
      setState(() {
        base64Image1 = base64Encode(imageshow11!.readAsBytesSync());
        print(base64Image1);
        _image1 = new File('$imagevalue1');
        print('Image Path $_image1');
        FoodAppConstant.pan = base64Image1!;
        // _ImageUpdate();
      });
    }
  }
}
