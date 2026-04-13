import 'package:flutter/material.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.only(top: 100),
          child: Image.asset("assets/gifs/coming-soon.gif"),
        ),
      ),
    );
  }
}
