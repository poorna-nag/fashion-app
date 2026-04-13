import 'package:flutter/material.dart';

import 'AppConstant.dart';

class OpenFlutterMenuLine extends StatelessWidget {
  final String? title;
  final String ?subtitle;
  final VoidCallback? onTap;

  const OpenFlutterMenuLine({Key ?key,  this.title,  this.subtitle,  this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(
          title??"",
          style: TextStyle(
            color: ServiceAppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle??"",
          style: TextStyle(color: ServiceAppColors.lightGray, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.chevron_right),
      ),
      onTap: onTap,
    );
  }
}
