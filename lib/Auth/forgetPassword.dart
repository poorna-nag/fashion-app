import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/Auth/widgets/responsive_ui.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/model/RegisterModel.dart';

class ForgetPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: ForgetPassword(),
      ),
    );
  }
}

class ForgetPassword extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<ForgetPassword> {
  double? _height;
  double? _width;
  double? _pixelRatio;
  bool? _large;
  bool? _medium;
  TextEditingController nameController = TextEditingController();
//  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  void _showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future _getEmployee() async {
    var map = new Map<String, dynamic>();
    map['shop_id'] = FoodAppConstant.Shop_id;
    map['mobile'] = nameController.text;
    final response = await http.post(
        Uri.parse(FoodAppConstant.base_url + 'api/forgot.php'),
        body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      User user = User.fromJson(jsonDecode(response.body));
      print(jsonBody.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInPage()));
      if (user.message.toString() == "Password has been sent to your email") {
//
        _showLongToast(user.message);
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInPage()));
      } else {
        _showLongToast(user.message);
      }
    } else
      throw Exception("Unable to get Employee list");
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

                // Back Button
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFE91E63).withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFE91E63).withOpacity(0.08),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFFE91E63),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: _height! * 0.05),

                // Header Section with Fashion Logo and Icon
                Container(
                  height: _height! * 0.3,
                  child: Stack(
                    children: [
                      // Decorative elements
                      Positioned(
                        top: 20,
                        right: -10,
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

                      // Main Content
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Fashion Logo Container

                            SizedBox(height: 24),

                            // Lock Icon
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFE91E63).withOpacity(0.1),
                                    Color(0xFFE91E63).withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color(0xFFE91E63).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.lock_reset_outlined,
                                size: 40,
                                color: Color(0xFFE91E63),
                              ),
                            ),
                            SizedBox(height: 20),

                            // Title
                            Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontSize: _large! ? 28 : (_medium! ? 24 : 20),
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2D3748),
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Don't worry, we'll help you!",
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

                SizedBox(height: _height! * 0.02),

                // Reset Password Form
                Container(
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Color(0xFFFFFAFD),
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
                  child: Form(
                    key: _key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: _large! ? 20 : (_medium! ? 18 : 16),
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Enter your mobile number and we'll send you a new password via SMS",
                          style: TextStyle(
                            fontSize: _large! ? 14 : (_medium! ? 12 : 10),
                            color: Color(0xFF718096),
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 24),

                        // Mobile Number Input
                        _buildFashionTextField(
                          controller: nameController,
                          label: "Mobile Number",
                          icon: Icons.phone_android,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 32),

                        // Reset Button
                        _buildFashionButton(
                          text: "SEND NEW PASSWORD",
                          onPressed: () {
                            if (nameController.text.length != 10) {
                              _showLongToast(
                                  "Please enter a valid Mobile Number");
                            } else {
                              _getEmployee();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Back to Sign In Section
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
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xFFE91E63).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Color(0xFFE91E63),
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()),
                          );
                        },
                        child: Text(
                          "Back to Sign In",
                          style: TextStyle(
                            color: Color(0xFFE91E63),
                            fontSize: _large! ? 16 : (_medium! ? 14 : 12),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
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
    TextInputType keyboardType = TextInputType.text,
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
        ),
      ),
    );
  }

  Widget _buildFashionButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE91E63),
            Color(0xFFD81B60),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE91E63).withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onPressed,
          splashColor: Colors.white.withOpacity(0.2),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: _large! ? 16 : (_medium! ? 14 : 12),
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: Colors.white,
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
    TextInputType keyboardType = TextInputType.text,
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
        keyboardType: keyboardType,
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
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE91E63),
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Color(0xFFE91E63).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: Text(
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
}
