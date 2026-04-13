import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:royalmart/Auth/widgets/textformfield.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/grocery/dbhelper/database_helper.dart';
// import 'package:royalmart/grocery/General/AppConstant.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFFE91E63),
        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.white),
        ),
      ),
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
                if (passwordController.text.length > 4 &&
                    passwordController.text == confirmPasswordController.text) {
                  setState(() {
                    isLoading = true;
                  });
                  updateAny('customers', 'password',
                          confirmPasswordController.text)
                      .then((value) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                } else {
                  showLongToast('Check your password fields again...');
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
                  "Change",
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
      hint: 'Enter new password',
      textEditingController: passwordController,
      keyboardType: TextInputType.text,
      icon: Icons.lock,
      obscureText: true,
    );
  }

  Widget confirmPasswordTextField() {
    return CustomTextField(
      hint: 'Confirm password',
      textEditingController: confirmPasswordController,
      keyboardType: TextInputType.text,
      icon: Icons.lock,
      obscureText: true,
    );
  }
}
