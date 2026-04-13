import 'package:flutter/material.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        height: height / 10,
        width: width,
        padding: EdgeInsets.only(left: 15, top: 25),
        decoration: BoxDecoration(color: GroceryAppColors.tela),
        child: Row(
          children: <Widget>[
            IconButton(
                color: Colors.white,
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  print("pop");
                  Navigator.of(context).pop();
                })
          ],
        ),
      ),
    );
  }
}
