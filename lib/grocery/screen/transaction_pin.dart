import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:royalmart/Auth/widgets/textformfield.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/dbhelper/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:royalmart/grocery/General/AppConstant.dart';

class TransactionPin extends StatefulWidget {
  const TransactionPin({Key? key}) : super(key: key);

  @override
  State<TransactionPin> createState() => _TransactionPinState();
}

class _TransactionPinState extends State<TransactionPin> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
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
        title: Text(
          "Transaction Password",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 1.0],
            colors: [
              Color(0xFFF8F9FA),
              Color(0xFFFFE8F0),
              Color(0xFFF8F9FA),
            ],
          ),
        ),
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width / 1.8,
            ),
            enterNewPasswordTextField(),
            SizedBox(
              height: 10,
            ),
            confirmPasswordTextField(),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                print("len----->${passwordController.text.length}");
                if (passwordController.text.length < 5) {
                  showLongToast1('Enter min. 5 digit PIN');
                } else if (passwordController.text !=
                    confirmPasswordController.text) {
                  showLongToast1('Confirm Transaction Password Not Matched!');
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  generateTransactionPin();
                }
              },
              color: Color(0xFFE91E63),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Update",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget enterNewPasswordTextField() {
    return CustomTextField(
      hint: 'Enter new Transaction Password',
      textEditingController: passwordController,
      keyboardType: TextInputType.number,
      icon: Icons.lock,
      obscureText: true,
    );
  }

  Widget confirmPasswordTextField() {
    return CustomTextField(
      hint: 'Confirm Transaction Password',
      textEditingController: confirmPasswordController,
      keyboardType: TextInputType.number,
      icon: Icons.lock,
      obscureText: true,
    );
  }

  Future generateTransactionPin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? mobile = pref.get("mobile").toString();
    print("Mobile number ${mobile}");
    print("Mobile number ${confirmPasswordController}");
    print("Mobile number ${passwordController}");
    var map = new Map<String, dynamic>();
    map['username'] = mobile;
    map['pin'] = passwordController.text;
    map['cpin'] = confirmPasswordController.text;

    try {
      final response = await http.post(
          Uri.parse("${GroceryAppConstant.base_url}api/userTransactionPin.php"),
          body: map);
      if (response.statusCode == 200) {
        print(response.toString());
        showLongToast1("Transaction Password Saved Successfully");
        // U_updateModal user = U_updateModal.fromJson(jsonDecode(response.body));
        // _showLongToast(user.message);
        // SharedPreferences pref = await SharedPreferences.getInstance();
        // pref.setString("pp", user.img);
        // setState(() {
        //   GroceryAppConstant.image = user.img;
        //   GroceryAppConstant.check = true;
        // });
        // print(user.img);
      } else
        throw Exception("Unable to get Employee list");
    } catch (Exception) {}
  }

  void _showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
