import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/model/RegisterModel.dart';
import 'package:royalmart/grocery/model/UserUpdateModel.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../model/profile_details.dart';

class EditProfilePage extends StatefulWidget {
  final String userid;
  const EditProfilePage(this.userid) : super();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<EditProfilePage> {
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  Future<File>? file;
  String? status = '';
  String? base64Image, imagevalue;
  File? _image, imageshow1;
  String? errMessage = 'Error Uploading Image';
  String? user_id;
  String url =
      "http://chuteirafc.cartacapital.com.br/wp-content/uploads/2018/12/15347041965884.jpg";

  var _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final passwordController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final profilescaffoldkey = new GlobalKey<ScaffoldState>();
  final resignofcause = TextEditingController();
  String _dropDownValue1 = "Male"; // Default value to prevent null issues
  Future<File>? profileImg;
  String? accountName;
  String? accountNumber;
  String? bankName;
  String? bankBranch;
  String? ifscCode;
  String? accountType;

  @override
  void initState() {
    getUserInfo();
    bankDetails();
    super.initState();
//    getImaformation();
  }

//  getImage(BuildContext context) async {
//    imageshow1 = await ImagePicker.pickImage(source: ImageSource.gallery);
//    if(imageshow1 != null) {
//      File cropped = await ImageCropper.cropImage(
//          sourcePath: imageshow1.path,
//          aspectRatio: CropAspectRatio(
//              ratioX: 1, ratioY: 1),
//          compressQuality: 85,
//          maxWidth: 800,
//          maxHeight: 800,
//          compressFormat: ImageCompressFormat.jpg,
//          androidUiSettings: AndroidUiSettings(
//              toolbarTitle: 'Cropper',
//              toolbarColor: Colors.deepOrange,
//              toolbarWidgetColor: Colors.white,
//              initAspectRatio: CropAspectRatioPreset.original,
//              lockAspectRatio: false
//
//          ),
//
//          iosUiSettings: IOSUiSettings(
//            minimumAspectRatio: 1.0,
//          )
//      );
//
//      this.setState((){
//        imageshow1 = cropped;
//
//      });
//      Navigator.of(context).pop();
//    }
//    String imagevalue1 = (imageshow1).toString();
//    imagevalue = imagevalue1.substring(7,(imagevalue1.lastIndexOf('')-1)).trim();
//
////    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//    setState(() {
//      base64Image = base64Encode(imageshow1.readAsBytesSync());
//      _image = new File('$imagevalue');
//      print('Image Path $_image');
//    });
//  }

//  Future<void> _sowchoiceDiloge(){
//
//    return showDialog(context: context,builder: (BuildContext context){
//      return AlertDialog(
//        title: Text('MAke a Choice'),
//        content: SingleChildScrollView(
//          child: ListBody(
//            children: <Widget>[
//              GestureDetector(
//                child: Text('Gallery'),
//                onTap: (){
//                  getImage(context);
//                },
//              ),
//              Padding(padding: EdgeInsets.all(8.0),),
//              GestureDetector(
//                child: Text('Camera'),
//                onTap: (){
////                  _OpenCamera(context);
//                  getImagefromCamera();
//                },
//              )
//            ],
//          ),
//        ),
//      );
//
//    });
//  }

//  Future getImagefromCamera() async{
//
//    var image = await ImagePicker.pickImage(source: ImageSource.camera);
//
//    setState(() {
//      _image = image;
//    });
//  }
//
//  _OpenCamera(BuildContext context) async{
//  var newImage = await ImagePicker.pickImage(source: ImageSource.camera);
//
//if(newImage!=null) {
//  String imagevalue1 = (newImage).toString();
//  imagevalue =
//      imagevalue1.substring(7, (imagevalue1.lastIndexOf('') - 1)).trim();
//
////    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//  this.setState(() {
//    base64Image = base64Encode(imageshow1.readAsBytesSync());
//    _image = new File('$imagevalue');
//    print('Image Path $_image');
//  });
//}
//
//}

  Future<void> getUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String? name = pre.getString("name");
    String? email = pre.getString("email");
    String? mobile = pre.getString("mobile");
    String? pin = pre.getString("pin");
    String? city = pre.getString("city");
    String? address = pre.getString("address");
    String? sex = pre.getString("sex");
    String? image = pre.getString("pp");
    user_id = pre.getString("user_id");
    print(user_id);

    this.setState(() {
      nameController.text = GroceryAppConstant.name;
      emailController.text = GroceryAppConstant.email;
      stateController.text = 'Karnataka';
      pincodeController.text = pin ?? "";
      mobileController.text = mobile ?? "";
      cityController.text = city ?? "";
      resignofcause.text = address ?? "";
      _dropDownValue1 = sex ?? "Male"; // Default to Male if null
      GroceryAppConstant.image = image ?? "";

      url = GroceryAppConstant.image;
      print("DEBUG: name = '${GroceryAppConstant.name}'");
      print("DEBUG: email = '${GroceryAppConstant.email}'");
      print("DEBUG: sex = '$sex', _dropDownValue1 = '$_dropDownValue1'");
      print(url);
      print("Constant.image");
      print(GroceryAppConstant.image);
      print(GroceryAppConstant.image.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
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
            "Profile Details",
            style: TextStyle(color: Colors.white),
          )),
      key: profilescaffoldkey,
      backgroundColor: Color(0xFFF8F9FA),
      body: Container(
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  child: new Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20),
                        child:
                            new Stack(fit: StackFit.loose, children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
//                              alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (camera) {
                                        camera = false;
                                      } else {
                                        camera = true;
                                      }
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Color(0xFFE91E63),
                                    child: ClipOval(
                                      child: new SizedBox(
                                        width: 150.0,
                                        height: 150.0,
                                        child: _image != null
                                            ? Image.file(
                                                _image!,
                                                fit: BoxFit.fill,
                                              )
                                            : Image.network(
                                                GroceryAppConstant.image,
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              camera ? showIcone(context) : Container(),
//                              camera?Container():submitImage(),

//                              Padding(
//                                padding: EdgeInsets.only(top: 85.0),
//                                child: Card(
//                                  color:AppColors.pink,
//                                  shape: RoundedRectangleBorder(
//                                    borderRadius: BorderRadius.circular(20.0),
//                                  ),
//                                  child: IconButton(
//                                    color: Colors.white,
//                                    icon: Icon(
//                                      Icons.edit,
//                                      size: 15.0,
//                                    ),
//                                    onPressed: () {
////                                      _sowchoiceDiloge();
//                                    },
//                                  ),
//                                ),
//                              ),
                            ],
                          ),
                          /* Padding(
                            padding: EdgeInsets.only(top: 90.0, right: 100.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _status ? _getEditIcon1() : new Container(),
//                                new CircleAvatar(
//                                  backgroundColor: Colors.red,
//                                  radius: 25.0,
//                                  child: new Icon(
//                                    Icons.camera_alt,
//                                    color: Colors.white,
//                                  ),
//                                )
                              ],
                            )),*/
                        ]),
                      )
                    ],
                  ),
                ),
                new Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF8F9FA).withOpacity(.9),
                          Color(0xFFFFE8F0).withOpacity(.3),
                        ]),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
//                          profile(context),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: TextFormField(
                                      controller: nameController,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the name";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Name",
                                      ),
                                      enabled: !_status,
                                      autofocus: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Email Id',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: TextFormField(
                                      controller: emailController,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the email id";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email ID"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Mobile No',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextFormField(
                                      controller: mobileController,
                                      keyboardType: TextInputType.number,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the mobile No";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Mobile Number"),
                                      enabled: true,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Pin Code',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'State',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: TextFormField(
                                        controller: pincodeController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(6)
                                        ],
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return " Please enter the pincode";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter Pin Code"),
                                        enabled: !_status,
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      controller: stateController,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the state";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter State"),
                                      enabled: !_status,
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'City',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Gender',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20),
                            padding: EdgeInsets.all(0.0),
                            child: Row(children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: TextFormField(
                                      controller: cityController,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the city";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter City"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 3),
                                  child: Container(
                                    width: 100,
                                    height: 80,
                                    child: DropdownButton(
                                      hint: _dropDownValue1.isEmpty
                                          ? Text('Select gender')
                                          : Text(
                                              _dropDownValue1,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                      value: _dropDownValue1.isEmpty
                                          ? null
                                          : _dropDownValue1,
                                      isExpanded: true,
                                      iconSize: 30.0,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      items: [
                                        'Male',
                                        'Female',
                                      ].map(
                                        (val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(val),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (val) {
                                        setState(
                                          () {
                                            _dropDownValue1 = val ?? "Male";
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12, bottom: 12, top: 4),
                            child: Card(
                              elevation: 0,
                              color: Color.fromARGB(255, 255, 255, 255),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8),
                                    child: Text(
                                      'Bank Details ',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, right: 8, left: 8, bottom: 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Account Name : ',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          accountName ?? "",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8, bottom: 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Account Number : ',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          accountNumber ?? "",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8, bottom: 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Bank Name : ',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          bankName ?? "",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8, bottom: 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Bank Branch : ',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          bankBranch ?? "",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8, bottom: 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          'IFSC Code : ',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          ifscCode ?? "",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8, bottom: 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Account Type : ',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          accountType ?? "",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 15.0),
                            child: Container(
                                child: new TextFormField(
                                    maxLines: 8,
                                    keyboardType: TextInputType
                                        .text, // Use mobile input type for emails.
                                    controller: resignofcause,
                                    validator: (String? value) {
                                      print("Length${value!.length}");
                                      if (value.isEmpty && value.length > 10) {
                                        return " Please enter the  address";
                                      }
                                      return null;
                                    },
                                    decoration: new InputDecoration(
                                      hintText: 'Address',
                                      labelText: 'Enter the address',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFE91E63),
                                            width: 2.0),
                                      ),

//                                      icon: new Icon(Icons.queue_play_next),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFE91E63)
                                                .withOpacity(0.5),
                                            width: 1.0),
                                      ),
                                    ))),
                          ),

                          _getActionButtons(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: new Text("Submit"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (resignofcause.text.length > 5) {
                      _getEmployee();
                    } else {
                      showLongToast("Please add the address");
                    }
                  }

//                        _status = true;
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE91E63),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(0.0),
                ),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: new Text("Cancel"),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade600,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(0.0),
                ),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

//

  Future _ImageUpdate() async {
    var map = new Map<String, dynamic>();
    map['pp'] = "data:image/png;base64," + base64Image!;
    map['user_id'] = widget.userid;
    map['mobile'] = mobileController.text;
    map['type'] = "base64";
//    print(base64Image);
//    print(widget.userid);
//    print(mobileController.text);
    try {
      final response = await http.post(
          Uri.parse(GroceryAppConstant.base_url + 'api/ppupload.php'),
          body: map);
      if (response.statusCode == 200) {
        print(response.toString());
        U_updateModal user = U_updateModal.fromJson(jsonDecode(response.body));
        _showLongToast(user.message);
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("pp", user.img);
        setState(() {
          GroceryAppConstant.image = user.img;
          GroceryAppConstant.check = true;
        });
        print(user.img);
      } else
        throw Exception("Unable to get Employee list");
    } catch (Exception) {}
  }

  Future _getEmployee() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      var map = new Map<String, dynamic>();
      map['name'] = nameController.text.trim();
      map['X-Api-Key'] = GroceryAppConstant.API_KEY;
      map['email'] = emailController.text.trim();
      map['phone'] = mobileController.text.trim();
      map['pincode'] = pincodeController.text.trim();
      map['city'] = cityController.text.trim();
      map['sex'] = _dropDownValue1.trim();
      map['address'] = resignofcause.text.trim();
      map['state'] = stateController.text.trim();
      map['username'] = mobileController.text.trim();
      map['user_id'] = GroceryAppConstant.user_id;

      // Additional validation for specific fields that might cause 406
      if (map['email'].toString().isNotEmpty &&
          !map['email'].toString().contains('@')) {
        _showLongToast("Please enter a valid email address");
        return;
      }
      if (map['phone'].toString().length < 10) {
        _showLongToast("Phone number must be at least 10 digits");
        return;
      }
      if (map['pincode'].toString().isNotEmpty &&
          map['pincode'].toString().length != 6) {
        _showLongToast("Pincode must be 6 digits");
        return;
      }

      // Add validation to ensure required fields are not empty
      if (map['name'].toString().isEmpty) {
        _showLongToast("Name cannot be empty");
        return;
      }
      if (map['email'].toString().isEmpty) {
        _showLongToast("Email cannot be empty");
        return;
      }
      if (map['phone'].toString().isEmpty) {
        _showLongToast("Phone cannot be empty");
        return;
      }
      if (map['address'].toString().isEmpty ||
          map['address'].toString().length < 5) {
        _showLongToast("Address must be at least 5 characters");
        return;
      }

      // Check if any changes were made by comparing with stored values
      String? storedName = pref.getString("name");
      String? storedEmail = pref.getString("email");
      String? storedMobile = pref.getString("mobile");
      String? storedCity = pref.getString("city");
      String? storedAddress = pref.getString("address");
      String? storedSex = pref.getString("sex");
      String? storedPin = pref.getString("pin");

      bool hasChanges = false;
      if (storedName != map['name']) hasChanges = true;
      if (storedEmail != map['email']) hasChanges = true;
      if (storedMobile != map['phone']) hasChanges = true;
      if (storedCity != map['city']) hasChanges = true;
      if (storedAddress != map['address']) hasChanges = true;
      if (storedSex != map['sex']) hasChanges = true;
      if (storedPin != map['pincode']) hasChanges = true;

      // Ensure all required fields have valid values to prevent 406 error
      map['name'] = map['name'].toString().isNotEmpty
          ? map['name']
          : GroceryAppConstant.name;
      map['email'] = map['email'].toString().isNotEmpty
          ? map['email']
          : GroceryAppConstant.email;
      map['phone'] = map['phone'].toString().isNotEmpty ? map['phone'] : '';
      map['state'] =
          map['state'].toString().isNotEmpty ? map['state'] : 'Karnataka';
      map['sex'] = map['sex'].toString().isNotEmpty ? map['sex'] : 'Male';

      log('Has changes detected: $hasChanges');
      log('Stored name: "$storedName" vs New: "${map['name']}"');
      log('Stored email: "$storedEmail" vs New: "${map['email']}"');
      log('Stored mobile: "$storedMobile" vs New: "${map['phone']}"');

      log('Request body: ${map.toString()}');
      log('API URL: ${GroceryAppConstant.base_url}manage/api/customers/update');
      log('User ID: ${GroceryAppConstant.user_id}');
      log('API Key: ${GroceryAppConstant.API_KEY}');

      final response = await http.post(
          Uri.parse(
              GroceryAppConstant.base_url + 'manage/api/customers/update'),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
          },
          body: map);

      log('Response status code: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final jsonBody = json.decode(response.body);
          log('Parsed JSON: ${jsonBody.toString()}');

          // Add validation for required JSON fields
          if (jsonBody == null) {
            _showLongToast("Invalid response from server");
            return;
          }

          U_updateModal user = U_updateModal.fromJson(jsonBody);
          log('Parsed user model - Success: ${user.success}, Message: ${user.message}');

          if (user.message.toString().contains("successfully updated") ||
              user.message.toString().contains("success") ||
              user.success.toString() == "true" ||
              user.success.toString() == "1") {
            _showLongToast(user.message);

            // Update shared preferences
            await pref.setString("email", emailController.text);
            await pref.setString("name", nameController.text);
            await pref.setString("city", cityController.text);
            await pref.setString("address", resignofcause.text);
            await pref.setString("sex", _dropDownValue1);
            await pref.setString("mobile", mobileController.text);
            await pref.setString("pin", pincodeController.text);
            await pref.setString("state", stateController.text);
            await pref.setBool("isLogin", true);

            // Update app constants
            GroceryAppConstant.isLogin = true;
            GroceryAppConstant.email = emailController.text;
            GroceryAppConstant.name = nameController.text;

            // Navigate back on success
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          } else {
            // Show the server message even if it's not the exact success message
            _showLongToast(user.message);
            log('Server message: ${user.message}');
            log('Success field: ${user.success}');

            // If the message is not an obvious error, still try to update local storage
            if (!user.message.toLowerCase().contains("error") &&
                !user.message.toLowerCase().contains("failed") &&
                !user.message.toLowerCase().contains("invalid")) {
              log('Treating as partial success, updating local storage');

              // Update shared preferences anyway
              await pref.setString("email", emailController.text.trim());
              await pref.setString("name", nameController.text.trim());
              await pref.setString("city", cityController.text.trim());
              await pref.setString("address", resignofcause.text.trim());
              await pref.setString("sex", _dropDownValue1.trim());
              await pref.setString("mobile", mobileController.text.trim());
              await pref.setString("pin", pincodeController.text.trim());
              await pref.setString("state", stateController.text.trim());
              await pref.setBool("isLogin", true);

              // Update app constants
              GroceryAppConstant.isLogin = true;
              GroceryAppConstant.email = emailController.text.trim();
              GroceryAppConstant.name = nameController.text.trim();
            }
          }
        } catch (parseError) {
          log('JSON parsing error: $parseError');
          log('Raw response body: ${response.body}');
          _showLongToast("Error parsing server response. Please try again.");
        }
      } else if (response.statusCode == 406) {
        _showLongToast(
            "Request format not accepted. Please check your data and try again.");
        log('406 Error - Request not acceptable. Response: ${response.body}');
        log('Request headers: ${response.request?.headers}');
      } else {
        _showLongToast("Server error: ${response.statusCode}");
        log('Server error - Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      log('Exception in _getEmployee: $e');
      _showLongToast("Network error: ${e.toString()}");
    }
  }

  void _showLongToast(String message) {
    final snackbar = new SnackBar(content: Text("$message"));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget profile(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 140),
      child: Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  if (camera) {
                    camera = false;
                  } else {
                    camera = true;
                  }
                });
              },
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Color(0xFFE91E63),
                child: ClipOval(
                  child: new SizedBox(
                    width: 150.0,
                    height: 150.0,
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            url,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            camera ? showIcone(context) : Container(),
          ],
        ),
      ),
    );
  }

  bool camera = false;

  Widget submitImage() {
    return Container(
      child: InkWell(
          onTap: () {
            _ImageUpdate();
          },
          child: Text("Submit")),
    );
  }

  Widget showIcone(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40,
        ),
        InkWell(
            onTap: () {
              getImageC(context);
//              getImage12();

              setState(() {
                camera = false;
              });
            },
            child: Icon(
              Icons.camera_alt,
              size: 35,
              color: Color(0xFFE91E63),
            )),
        SizedBox(
          height: 10,
        ),
        InkWell(
            onTap: () {
              getImage(context);
              setState(() {
                camera = false;
              });
            },
            child: Icon(
              Icons.storage,
              size: 35,
              color: Color(0xFFE91E63),
            )),
      ],
    );
  }

  getImage(BuildContext context) async {
    final data = await ImagePicker().pickImage(source: ImageSource.gallery);
    imageshow1 = File(data!.path);

    String imagevalue1 = (imageshow1).toString();
    if (imagevalue1 != null) {
      imagevalue = imagevalue1 != null
          ? imagevalue1.substring(7, (imagevalue1.lastIndexOf('') - 1)).trim()
          : imagevalue1;

//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        base64Image = base64Encode(imageshow1!.readAsBytesSync());
        _image = new File('$imagevalue');
        print('Image Path $_image');
        _ImageUpdate();
      });
    }
  }

  getImageC(BuildContext context) async {
    final data = await ImagePicker().pickImage(source: ImageSource.camera);
    imageshow1 = File(data!.path);
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
        _ImageUpdate();
      });
    }
  }

  final picker = ImagePicker();

  Future getImage12() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile!.path);
      base64Image = base64Encode(_image!.readAsBytesSync());
      _ImageUpdate();
    });
  }

  Future bankDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(GroceryAppConstant.base_url +
          'manage/api/customers/all?X-Api-Key=${GroceryAppConstant.API_KEY}&shop_id=${GroceryAppConstant.Shop_id}&user_id=${GroceryAppConstant.user_id}'),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      log(jsonBody['data']['customers'].toString());
      Customers user = Customers.fromJson(jsonBody['data']['customers'][0]);
      // List<Customers> customers=[];

      // jsonBody['data']['customers'].forEach((element){
      //   customers.add(Customers(
      //     aadhar: element['anumber'],
      //   ));
      // });
      log(user.aname.toString());
      setState(() {
        accountName = user.aname;
        accountNumber = user.anumber;
        bankName = user.bankname;
        bankBranch = user.bankbranch;
        ifscCode = user.ifsc;
        accountType = user.ifsc;
      });
      print(jsonBody.toString());
    } else
      throw Exception("Unable to get Employee list");
  }
}
