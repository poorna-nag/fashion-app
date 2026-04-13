import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:royalmart/Auth/forgetPassword.dart';
import 'package:royalmart/Auth/signup.dart';
import 'package:royalmart/Auth/widgets/CustomeAppBar1.dart';
import 'package:royalmart/Auth/widgets/customappbar.dart';
import 'package:royalmart/Auth/widgets/responsive_ui.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/General/Home.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/General/Home.dart';
import 'package:royalmart/model/LoginModal.dart';
import 'package:royalmart/screen/home_page.dart';
import 'package:royalmart/screen/vendor_categories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Form6.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: FoodAppColors.tela,
        body: SignInScreen(),
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  double? _height;
  double? _width;
  double? _pixelRatio;
  bool? _large, flag = false;
  bool? _medium;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void _showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future _getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var map = <String, dynamic>{
      'shop_id': FoodAppConstant.Shop_id,
      'mobile': nameController.text,
      'password': passwordController.text,
    };

    final uri = Uri.parse(FoodAppConstant.base_url + 'api/login.php');

    // 🟢 Debug: Print full request details
    print('================= API REQUEST =================');
    print('➡️ URL: $uri');
    print(
        '➡️ Headers: (default content-type: application/x-www-form-urlencoded)');
    print('➡️ Request Body: $map');
    print('================================================');

    try {
      final response = await http.post(uri, body: map);

      // 🟢 Debug: Print response info
      print('================= API RESPONSE =================');
      print('⬅️ Status Code: ${response.statusCode}');
      print('⬅️ Response Body: ${response.body}');
      print('================================================');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        loginModal user = loginModal.fromJson(jsonBody);

        if (user.message.toString() == "Login is Successful") {
          setState(() {
            flag = false;
          });

          _showLongToast(user.message ?? "");

          // 🟢 Debug: Successful login data
          print('✅ Login Successful');
          print('User ID: ${user.user_id}');
          print('Name: ${user.name}');
          print('Email: ${user.email}');

          FoodAppConstant.email = jsonBody["email"];
          FoodAppConstant.name = jsonBody["name"];
          FoodAppConstant.Mobile = jsonBody["username"];
          FoodAppConstant.isLogin = true;
          FoodAppConstant.image = jsonBody["pp"];
          FoodAppConstant.address = jsonBody["address"];
          FoodAppConstant.city = jsonBody["city"];
          GroceryAppConstant.user_id = jsonBody["user_id"];

          pref.setString("email", user.email ?? "");
          pref.setString("name", user.name ?? "");
          pref.setString("city", user.city ?? "");
          pref.setString("address", user.address ?? "");
          pref.setString("sex", user.sex ?? "");
          pref.setString("mobile", user.username ?? "");
          pref.setString("pin", user.pincode ?? "");
          pref.setString("user_id", user.user_id ?? "");
          pref.setString("pp", user.pp ?? "");
          pref.setBool("isLogin", true);

          pref.setString("mname", user.membershipname ?? "");
          pref.setString("mBonus", user.membershipjoinBonus ?? "");
          pref.setString("mJfee", user.membershipjoinFee ?? "");
          pref.setString("mDiscription", user.membershipdescription ?? "");
          pref.setString("mvalidity", user.membershipvalidity ?? "");
          pref.setString("mDjoinAmount", user.membershipdirectJoinAmnt ?? "");
          pref.setString("mDjoin", user.membershipdirectJoin ?? "");
          pref.setString("prime", user.prime ?? "");
          pref.setString("mID", user.membershipid ?? "");

          GroceryAppConstant.isLogin = true;
          GroceryAppConstant.email = user.email ?? "";
          GroceryAppConstant.name = user.name ?? "";
          GroceryAppConstant.user_id = user.user_id ?? "";
          GroceryAppConstant.image = user.pp ?? "";
          GroceryAppConstant.mid = user.membershipid ?? "";

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => GroceryApp()),
            (route) => false,
          );
        } else {
          _showLongToast(user.message ?? "");
          setState(() {
            flag = false;
          });
          print('❌ Login failed: ${user.message}');
        }
      } else {
        print('❌ Server Error: ${response.statusCode}');
        throw Exception("Unable to get Employee list");
      }
    } catch (e) {
      print('❗ Exception during login: $e');
      setState(() {
        flag = false;
      });
      _showLongToast("Something went wrong: $e");
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(height: _height! * 0.06),

                  // Header Section with Fashion Logo
                  Container(
                    height: _height! * 0.28,
                    child: Stack(
                      children: [
                        // Decorative elements
                        Positioned(
                          top: 30,
                          right: -15,
                          child: Container(
                            width: 60,
                            height: 60,
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
                        Positioned(
                          bottom: 40,
                          left: -20,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFE91E63).withOpacity(0.2),
                                width: 1,
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
                                padding: EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white,
                                      Color(
                                          0xFFFFF0F5), // Light pink background
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Color(0xFFE91E63).withOpacity(0.2),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Color(0xFFE91E63).withOpacity(0.15),
                                      blurRadius: 25,
                                      spreadRadius: 5,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),

                              // Brand Name
                              Text(
                                "fashion",
                                style: TextStyle(
                                  fontSize: _large! ? 36 : (_medium! ? 32 : 28),
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF2D3748),
                                  letterSpacing: 3,
                                ),
                              ),
                              Text(
                                "PASSION FOR FASHION",
                                style: TextStyle(
                                  fontSize: _large! ? 10 : (_medium! ? 9 : 8),
                                  color: Color(0xFFE91E63),
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: _height! * 0.02),

                  // Welcome Text
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: _large! ? 32 : (_medium! ? 28 : 24),
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3748),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Sign in to continue your fashion journey",
                    style: TextStyle(
                      fontSize: _large! ? 16 : (_medium! ? 14 : 12),
                      color: Color(0xFF718096),
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: _height! * 0.05),

                  // Form Container with Fashion Theme
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
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Mobile Number Field
                        fashionTextField(
                          controller: nameController,
                          label: "Mobile Number",
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 24),

                        // Password Field
                        fashionTextField(
                          controller: passwordController,
                          label: "Password",
                          icon: Icons.lock_outline_rounded,
                          obscureText: true,
                        ),
                        SizedBox(height: 20),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgetPass()),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Color(0xFFE91E63),
                                fontSize: _large! ? 14 : (_medium! ? 12 : 10),
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFFE91E63),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 35),

                        // Sign In Button
                        fashionButton(
                          text: "SIGN IN",
                          onPressed: () {
                            if (nameController.text.length != 10) {
                              _showLongToast(
                                  "Please enter a valid Mobile Number");
                            } else if (passwordController.text.length < 5) {
                              _showLongToast(
                                  "Password should contain at least 5 letter");
                            } else {
                              setState(() {
                                flag = true;
                              });
                              _getEmployee();
                            }
                          },
                          isLoading: flag ?? false,
                          isPrimary: true,
                        ),
                        SizedBox(height: 16),

                        // Skip Login Button
                        fashionButton(
                          text: "CONTINUE AS GUEST",
                          onPressed: () => _skipLoginAndNavigateToHome(),
                          isPrimary: false,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 35),

                  // Elegant Divider
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color(0xFFE91E63).withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: Color(0xFF718096),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color(0xFFE91E63).withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),

                  // Register Section with Fashion Theme
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Form6()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFE91E63).withOpacity(0.05),
                            Color(0xFFE91E63).withOpacity(0.02),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Color(0xFFE91E63).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "New to Fashion?",
                            style: TextStyle(
                              color: Color(0xFF4A5568),
                              fontSize: _large! ? 16 : (_medium! ? 14 : 12),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "CREATE ACCOUNT",
                            style: TextStyle(
                              color: Color(0xFFE91E63),
                              fontSize: _large! ? 16 : (_medium! ? 14 : 12),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget fashionTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFFFFAFD), // Very light pink
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFE91E63).withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE91E63).withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
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
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE91E63).withOpacity(0.1),
                  Color(0xFFE91E63).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Color(0xFFE91E63),
              size: _large! ? 22 : (_medium! ? 20 : 18),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }

  Widget fashionButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isPrimary = true,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: isPrimary
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE91E63),
                  Color(0xFFD81B60),
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(28),
        border: isPrimary
            ? null
            : Border.all(
                color: Color(0xFFE91E63),
                width: 2,
              ),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: Color(0xFFE91E63).withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Color(0xFFE91E63).withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: isLoading ? null : onPressed,
          splashColor: isPrimary
              ? Colors.white.withOpacity(0.2)
              : Color(0xFFE91E63).withOpacity(0.1),
          child: Container(
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isPrimary ? Colors.white : Color(0xFFE91E63),
                      ),
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: _large! ? 16 : (_medium! ? 14 : 12),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: isPrimary ? Colors.white : Color(0xFFE91E63),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _skipLoginAndNavigateToHome() async {
    // Set guest mode preferences
    SharedPreferences pref = await SharedPreferences.getInstance();

    // Set guest/skip login mode
    pref.setBool("isLogin", false);
    pref.setBool("isGuestMode", true);

    // Set minimal guest data
    pref.setString("name", "Guest User");
    pref.setString("email", "");
    pref.setString("user_id", "guest");
    pref.setString("image", "");

    // Update global constants for guest mode
    GroceryAppConstant.isLogin = false;
    GroceryAppConstant.email = "";
    GroceryAppConstant.name = "Guest User";
    GroceryAppConstant.user_id = "guest";
    GroceryAppConstant.image = "";

    // Navigate to home screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => GroceryApp()),
      (route) => false,
    );
  }
}
