import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AadharCardUpload extends StatefulWidget {
   AadharCardUpload({Key? key}) : super(key: key);

  @override
  State<AadharCardUpload> createState() => _AadharCardUploadState();
}

File? _image, imageshow1;
String? base64Image, imagevalue;

class _AadharCardUploadState extends State<AadharCardUpload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: showIcone(context),
        ),
      ),
    );
  }

  Widget showIcone(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 40,
        ),
        Container(
          height: 70,
          child: InkWell(
              onTap: () {
                getImageC(context);

                setState(() {
                  // camera = false;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 40,
                  ),
                  Text("Camera"),
                ],
              )),
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          height: 70,
          child: InkWell(
              onTap: () {
                getImage(context);
                setState(() {
                  // camera = false;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.storage,
                    size: 40,
                  ),
                  Text("Gallery"),
                ],
              )),
        ),
      ],
    );
  }

  getImageC(BuildContext context) async {
   await ImagePicker().pickImage(source: ImageSource.gallery);
    String imagevalue1 = (imageshow1).toString();
    if (imagevalue1 != null) {
      imagevalue1.length > 7
          ? imagevalue =
              imagevalue1.substring(7, (imagevalue1.lastIndexOf('') - 1)).trim()
          : imagevalue1;

//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        base64Image = base64Encode(imageshow1!.readAsBytesSync());
        _image = new File('$imagevalue');
        print('Image Path $_image');
        // _ImageUpdate();
      });
    } 
  }

  getImage(BuildContext context) async {
    await ImagePicker().pickImage(source: ImageSource.gallery);

    String imagevalue1 = (imageshow1).toString();
    if (imagevalue1 != null) {
      imagevalue = imagevalue1 != null
          ? imagevalue1.substring(7, (imagevalue1.lastIndexOf('') - 1)).trim()
          : imagevalue1;
      setState(() {
        base64Image = base64Encode(imageshow1!.readAsBytesSync());
        print(base64Image);
        _image = new File('$imagevalue');
        print('Image Path $_image');
        // _ImageUpdate();
      });
    }
  }

  Future _ImageUpdate() async {
    var map = new Map<String, dynamic>();
    map['aadhar'] = "data:image/png;base64," + base64Image!;
    map['user_id'] = "";
    map['kyc'] = "aadhar";

//    print(base64Image);
//    print(widget.userid);
//    print(mobileController.text);
    try {
      final response = await http
          .post((GroceryAppConstant.base_url + 'api/kycupload.php') as Uri, body: map);
      if (response.statusCode == 200) {
        print(response.toString());
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
}
