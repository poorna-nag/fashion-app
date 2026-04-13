import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:royalmart/grocery/Auth/forgetPassword.dart';
import 'package:royalmart/grocery/Auth/signup.dart';
import 'package:royalmart/grocery/Auth/widgets/custom_shape.dart';
import 'package:royalmart/grocery/Auth/widgets/customappbar.dart';
import 'package:royalmart/grocery/Auth/widgets/register.dart';
import 'package:royalmart/grocery/Auth/widgets/responsive_ui.dart';
import 'package:royalmart/grocery/Auth/widgets/textformfield.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/General/Home.dart';
import 'package:royalmart/grocery/model/LoginModal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
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
  bool _large = false, flag = false;
  bool _medium = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();

  void _showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future _getEmployee() async {
    http.Response response = await http.post(
      Uri.parse(GroceryAppConstant.base_url + "getEmployee.php"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_email': nameController.text,
        'user_password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      print("Successfully Check" + response.body.toString());
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      // Simple success check
      if (responseJson['success'] == 1) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString(
            "user_id", responseJson['data']['id'].toString());
        sharedPreferences.setString(
            "user_name", responseJson['data']['fname'].toString());
        sharedPreferences.setString(
            "user_mobile", responseJson['data']['mobile'].toString());
        sharedPreferences.setString(
            "user_email", responseJson['data']['email'].toString());
        sharedPreferences.setString(
            "user_image", responseJson['data']['image'].toString());
        sharedPreferences.setString("is_login", "yes");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GroceryApp()),
        );
      } else {
        _showLongToast(responseJson['message'].toString());
      }
    } else {
      print("Failed Check");
      _showLongToast("Login failed. Please try again.");
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
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                GroceryAppColors.homeiconcolor.withOpacity(0.8),
                GroceryAppColors.homeiconcolor.withOpacity(0.6),
                GroceryAppColors.bg,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Custom App Bar
                  Container(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: GroceryAppColors.black,
                            size: 24,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: GroceryAppColors.black,
                          ),
                        ),
                        SizedBox(width: 48), // Balance the row
                      ],
                    ),
                  ),

                  // Main Content
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Form(
                          key: _key,
                          child: Column(
                            children: <Widget>[
                              // Welcome Text
                              Container(
                                margin: EdgeInsets.only(bottom: 30),
                                child: Column(
                                  children: [
                                    Text(
                                      'Welcome Back!',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: GroceryAppColors.homeiconcolor,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Sign in to your account',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: GroceryAppColors.lightGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Email Field
                              _modernTextField(
                                controller: nameController,
                                hintText: 'Email Address',
                                icon: Icons.email_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 20),

                              // Password Field
                              _modernTextField(
                                controller: passwordController,
                                hintText: 'Password',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 15),

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ForgetPassword(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: GroceryAppColors.homeiconcolor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 30),

                              // Sign In Button
                              _modernButton(
                                text: 'Sign In',
                                onPressed: () {
                                  if (_key.currentState!.validate()) {
                                    _getEmployee();
                                  }
                                },
                              ),

                              SizedBox(height: 30),

                              // Divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: GroceryAppColors.lightGray
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                        color: GroceryAppColors.lightGray,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: GroceryAppColors.lightGray
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 30),

                              // Sign Up Button
                              _modernOutlineButton(
                                text: 'Create New Account',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Register(),
                                    ),
                                  );
                                },
                              ),

                              SizedBox(height: 20),

                              // Skip Option
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GroceryApp(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Skip for now',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: GroceryAppColors.lightGray,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: GroceryAppColors.lightGray,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _modernTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: GroceryAppColors.lightGray.withOpacity(0.3),
        ),
        color: GroceryAppColors.bg.withOpacity(0.5),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        style: TextStyle(
          fontSize: 16,
          color: GroceryAppColors.black,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: GroceryAppColors.lightGray,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: GroceryAppColors.homeiconcolor,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _modernButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            GroceryAppColors.homeiconcolor,
            GroceryAppColors.homeiconcolor.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: GroceryAppColors.homeiconcolor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _modernOutlineButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: GroceryAppColors.homeiconcolor,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: GroceryAppColors.homeiconcolor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget circularIndi() {
    return Align(
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
