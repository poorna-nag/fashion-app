import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:royalmart/Auth/signup.dart';
import 'package:royalmart/Auth/widgets/responsive_ui.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/model/RegisterModel.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Form6 extends StatefulWidget {
  @override
  _Form6State createState() => _Form6State();
}

class _Form6State extends State<Form6> {
  final updatephoneControler = TextEditingController();

  String result = " ";
  String photo = "", currentText = "";
  bool flag = true;
  bool flag1 = false;
  
  // Responsive design variables
  double? _height;
  double? _width;
  double? _pixelRatio;
  bool? _large;
  bool? _medium;
  
  void _onCountryChange(CountryCode countryCode) {
//    this.phoneNumber =  countryCode.toString();
    print("New Country selected: " + countryCode.toString());
  }
  @override
  void dispose() {
    updatephoneControler.dispose();
    // TODO: implement dispose
    super.dispose();
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
        height: _height,
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
          child: flag ? _buildPhoneNumberScreen() : _buildOTPScreen(),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberScreen() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            SizedBox(height: _height! * 0.08),
            
            // Header Section with Fashion Logo
            Container(
              height: _height! * 0.25,
              child: Stack(
                children: [
                  // Decorative elements
                  Positioned(
                    top: 20,
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
                            height: 60,
                            width: 60,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Brand Name
                        Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: _large! ? 28 : (_medium! ? 24 : 20),
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2D3748),
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          "Join the fashion community",
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
            
            SizedBox(height: _height! * 0.04),
            
            // Phone Number Form
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone Number",
                    style: TextStyle(
                      fontSize: _large! ? 18 : (_medium! ? 16 : 14),
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "We'll send you a verification code",
                    style: TextStyle(
                      fontSize: _large! ? 14 : (_medium! ? 12 : 10),
                      color: Color(0xFF718096),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Phone Input Container
                  Container(
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
                    child: Row(
                      children: [
                        // Country Code Picker
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: CountryCodePicker(
                              onChanged: _onCountryChange,
                              initialSelection: 'IN',
                              favorite: ['+91', 'IN'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              textStyle: TextStyle(
                                color: Color(0xFF2D3748),
                                fontWeight: FontWeight.w500,
                              ),
                              flagDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        
                        // Divider
                        Container(
                          height: 40,
                          width: 1,
                          color: Color(0xFFE91E63).withOpacity(0.2),
                        ),
                        
                        // Phone Number Input
                        Expanded(
                          flex: 7,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              onChanged: (String str) {
                                setState(() {
                                  result = str;
                                });
                              },
                              controller: updatephoneControler,
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: _large! ? 16 : (_medium! ? 14 : 12),
                                color: Color(0xFF2D3748),
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Phone number',
                                hintStyle: TextStyle(
                                  color: Color(0xFF718096),
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                counterText: '',
                                contentPadding: EdgeInsets.symmetric(vertical: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Continue Button
                  _buildFashionButton(
                    text: "CONTINUE",
                    isEnabled: result.length == 10,
                    onPressed: () async {
                      if (result.length == 10) {
                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                        sharedPreferences.setString("mobile", updatephoneControler.text);
                        _getEmployee();
                      }
                    },
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPScreen() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            SizedBox(height: _height! * 0.08),
            
            // Back Button
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      flag = true;
                    });
                  },
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
            
            SizedBox(height: _height! * 0.06),
            
            // Header Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Color(0xFFFFF0F5),
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
                height: 60,
                width: 60,
                fit: BoxFit.contain,
              ),
            ),
            
            SizedBox(height: 32),
            
            // Title
            Text(
              "Verify Your Number",
              style: TextStyle(
                fontSize: _large! ? 28 : (_medium! ? 24 : 20),
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 12),
            
            // Subtitle
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: _large! ? 16 : (_medium! ? 14 : 12),
                  color: Color(0xFF718096),
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(text: "Enter the code sent to "),
                  TextSpan(
                    text: updatephoneControler.text,
                    style: TextStyle(
                      color: Color(0xFFE91E63),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40),
            
            // OTP Input Container
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
              child: Column(
                children: [
                  // OTP Input
                  PinCodeTextField(
                    length: 5,
                    onChanged: (String pin) {
                      setState(() {
                        currentText = pin;
                      });
                    },
                    appContext: context,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12),
                      fieldHeight: 56,
                      fieldWidth: 48,
                      activeFillColor: Color(0xFFFFFAFD),
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Color(0xFFE91E63).withOpacity(0.1),
                      activeColor: Color(0xFFE91E63),
                      inactiveColor: Color(0xFFE91E63).withOpacity(0.3),
                      selectedColor: Color(0xFFE91E63),
                      borderWidth: 2,
                    ),
                    enableActiveFill: true,
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Resend Code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive the code? ",
                        style: TextStyle(
                          fontSize: _large! ? 14 : (_medium! ? 12 : 10),
                          color: Color(0xFF718096),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            flag = true;
                            result = "1234567890";
                          });
                        },
                        child: Text(
                          "RESEND",
                          style: TextStyle(
                            fontSize: _large! ? 14 : (_medium! ? 12 : 10),
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE91E63),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFE91E63),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Loading indicator
                  if (flag1) 
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                      ),
                    ),
                  
                  SizedBox(height: 16),
                  
                  // Verify Button
                  _buildFashionButton(
                    text: "VERIFY",
                    isEnabled: currentText.length == 5,
                    onPressed: () {
                      if (currentText.length == 5) {
                        _getEmployeeotp();
                      } else {
                        showLongToast("Please enter the OTP!");
                      }
                    },
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFashionButton({
    required String text,
    required bool isEnabled,
    required VoidCallback onPressed,
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
          onTap: isEnabled ? onPressed : null,
          splashColor: Colors.white.withOpacity(0.2),
          child: Container(
            alignment: Alignment.center,
            child: Text(
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

  Future _getEmployee() async {
    print(updatephoneControler.text);
    var map = new Map<String, dynamic>();
    map['shop_id'] = FoodAppConstant.Shop_id;
    map['name'] = " ";
    map['mobile'] = updatephoneControler.text;
    final response =
        await http.post(Uri.parse(FoodAppConstant.base_url + 'api/step1.php'), body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print(jsonBody.toString());
      User user = User.fromJson(jsonDecode(response.body));
      if (user.message.toString() == "OTP Sent Successfully") {
        showLongToast(user.message);
        setState(() {
          flag = false;
        });
      } else {
        showLongToast(user.message);
        print(user.message);
      }
    } else
      throw Exception("Unable to get Employee list");
  }

  void _getEmployeeotp() async {
    print(currentText);
    var map = new Map<String, dynamic>();
    map['shop_id'] = FoodAppConstant.Shop_id;
    map['otp'] = currentText;
    map['mobile'] = updatephoneControler.text;
    final response =
        await http.post(Uri.parse(FoodAppConstant.base_url + 'api/step2.php'), body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print(jsonBody);
      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
      if (user.message.toString() == "OTP Verified Successfully.") {
        showLongToast(user.message??"");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpScreen()),
        );
      } else {
        showLongToast(user.message??"");
      }
    } else
      throw Exception("Unable to get Employee list");
  }

/*
  Future<List<OtpModal>> _getEmployeeotp() async {
setState(() {
  flag1= true;
});
    var map = new Map<String, dynamic>();
    // map['shop_id']=Constant.Shop_id;
    map['otp']=currentText   ;
    map['mobile']= updatephoneControler.text;
    final response = await http.post(Constant.base_url+'api/cpsms.php',body:map);
    if (response.statusCode == 200) {

      final jsonBody = json.decode(response.body);
      print(jsonBody.toString());
      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
      if(user.message.toString()== "OTP Verified Successfully." )
      {
        setState(() {
          flag1= false;
        });
        showLongToast(user.message);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Form1()));


      }
      else {
        setState(() {
          flag1= false;
        });
        showLongToast(user.message);

      }

    } else
      throw Exception("Unable to get Employee list");
  }
*/
}
