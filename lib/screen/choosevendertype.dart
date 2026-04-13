import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/General/Home.dart';
import 'package:royalmart/model/RegisterModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SelectButton extends StatefulWidget {
  @override
  _SelectCityState createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectButton> {
  final pincodeController = TextEditingController();

  SharedPreferences ?pref;
  void setcity() async {
    pref = await SharedPreferences.getInstance();

    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),);

    // snapshot.data[index].loc_id
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setcity();
  }

  bool flag = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.tela1,
      appBar: AppBar(
        backgroundColor: FoodAppColors.tela,
        // leading: Padding(padding: EdgeInsets.only(left: 0.0),
        //     child:InkWell(
        //       onTap: (){
        //         if (Navigator.canPop(context)) {
        //           Navigator.pop(context);
        //         } else {
        //           SystemNavigator.pop();
        //         }
        //       },
        //
        //       child: Icon(
        //         Icons.arrow_back,size: 30,
        //         color: Colors.white,
        //       ),
        //
        //     )
        // ),

        actions: <Widget>[],
        title: Text("CHOOSE VENDER TYPE",
            style: TextStyle(color: FoodAppColors.white, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
      ),

      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
        // color:  AppColors.tela1,
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // Constant.cityid==null?Container(
            //   child: Text("Yout have not selected any location ${ Constant.pinid}")
            // ): Constant.cityid.length>0?Container(
            //   child: Text("Yout selected location is ${ Constant.pinid}"),
            // ):Container(
            //   child: Text("Yout have not selected any location ${ Constant.pinid}"),
            // ),
            SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  flag = true;
                });
              },
             style: ElevatedButton.styleFrom(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
             textStyle:TextStyle(color:Colors.white, ) ,
      padding: EdgeInsets.all(0.0),
      ),

              child: Text(
                "One Day Delivery",
                style: TextStyle(color: FoodAppColors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            flag
                ? Container(
                    margin: EdgeInsets.only(left: 20),
                    width: MediaQuery.of(context).size.width / 2 + 100,
                    child: TextFormField(
                      controller: pincodeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        new LengthLimitingTextInputFormatter(6),
                      ],
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return " Please enter the pincode";
                        }
                      },
                      decoration: const InputDecoration(hintText: "Enter Pin Code"),
                    ),
                  )
                : Row(),

            flag
                ? Container(
                    margin: EdgeInsets.only(
                      right: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _gefreedelivery(pincodeController.text);
                          },
                        style: ElevatedButton.styleFrom(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
             textStyle:TextStyle(color:Colors.white, ) ,
      padding: EdgeInsets.all(0.0),
      ),

                          child: Text("Search ", style: TextStyle(color: FoodAppColors.white)
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),);
                              ),
                        ),
                      ],
                    ),
                  )
                : Row(),
            SizedBox(
              height: 30,
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  flag = false;
                  pref!.setString("cityid", "");
                  FoodAppConstant.cityid = "";
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp1()),
                  );
                });
              },
             style: ElevatedButton.styleFrom(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
             textStyle:TextStyle(color:Colors.white, ) ,
      padding: EdgeInsets.all(0.0),
      ),

              child: Text("Normal Delivery", style: TextStyle(color: FoodAppColors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _gefreedelivery(String id) async {
    // print(Constant.base_url+'searchLoc.php?shop_id='+Constant.Shop_id+"&loc="+id);

    final response = await http.get((FoodAppConstant.base_url + 'api/searchLoc.php?shop_id=' + FoodAppConstant.Shop_id + "&loc=" + id) as Uri);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print(jsonBody["loc"]);

      RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));
      if (user.success == "false") {
        showLongToast(user.message!);
      } else {
        setState(() {
          String idval = jsonBody["loc"].toString();
          // print(id);
          pref!.setString("cityid", idval);
          pref!.setString("pin", id);
          FoodAppConstant.cityid = idval;
          // print(Constant.cityid);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApp1()),
          );
        });
      }
    } else
      throw Exception("Unable to generate Employee Invoice");
//    print("123  Unable to generate Employee Invoice");
  }
}
