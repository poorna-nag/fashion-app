import 'dart:io';

import 'package:flutter/material.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/dbhelper/database_helper.dart';
import 'package:royalmart/grocery/model/CategaryModal.dart';
import 'package:royalmart/grocery/screen/SubCategry.dart';
import 'package:royalmart/grocery/screen/secondtabview.dart';
import 'package:royalmart/grocery/screen/SearchScreen.dart';
import 'package:royalmart/grocery/screen/vendor_Screen.dart';

class Cgategorywise extends StatefulWidget {
  final String id;
  Cgategorywise(this.id);

  @override
  _CgategorywiseState createState() => _CgategorywiseState();
}

class _CgategorywiseState extends State<Cgategorywise> {
  List<Categary> cat_list = [];
  List<Categary> sub_cat_list = [];
  bool flag = false;

  void initState() {
    super.initState();
  }
    exiAppt() async {
    await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
              title: Text('Warning'),
              content: Text('Do you really want to exit'),
              actions: [
                TextButton(
                  child: Text('Yes'),
                  onPressed: () => {
                    exit(0),
                  },
                ),
                TextButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(c),
                ),
              ],
            ));
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
     onWillPop: () async {
        return exiAppt();
        // drawer is open then first close it
        // if (_scaffoldKey.currentState.isDrawerOpen) {
        //Navigator.of(context).pop();
        //return false;
        //} else {

        //}
        // we can now close the app.
        // return true;
      },
      
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              /*Container(
              height: 50,
              margin: EdgeInsets.only(top: 50, bottom: 50),
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.only(top: 0, bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Material(
                    color: Colors.white,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserFilterDemo()),
                          );
                        },
                        child: TextField(
                          enabled: false,
                          obscureText: false,
                          decoration: InputDecoration(
                              hintText: "                        Search for any product",
                              hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
                              suffixIcon: Icon(
                                Icons.search,
                                color: AppColors.tela,
                              )),
                        )),
                  ),
                ),
              ),
            ),*/
              SingleChildScrollView(
                child: FutureBuilder(
                    future: get_Category("0"),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                          physics: ClampingScrollPhysics(),
                          controller:
                              new ScrollController(keepScrollOffset: false),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  mainAxisExtent: 140),
                          itemBuilder: (context, index) {
                            Categary item = snapshot.data![index];
                            return InkWell(
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => Screen2(item.pcatId,item.pCats)),);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VendorList(
                                          item.pcatId??"", "Vendor List")),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Container(
                                      //   width: 40.0,
                                      //   height: 40.0,
                                      //   decoration: BoxDecoration(
                                      //       border: Border.all(
                                      //           color: GroceryAppColors.tela,
                                      //           width: 2),
                                      //       borderRadius:
                                      //           BorderRadius.circular(20),
                                      //       image: DecorationImage(
                                      //         fit: BoxFit.fill,
                                      //         image: item.img.length > 0
                                      //             ? NetworkImage(
                                      //                 GroceryAppConstant
                                      //                         .logo_Image_cat +
                                      //                     item.img,
                                      //               )
                                      //             : AssetImage(
                                      //                 "assets/images/logo.png"),
                                      //       )),
                                      //   margin:
                                      //       EdgeInsets.only(left: 5, right: 10),
                                      Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                            color: GroceryAppColors.tela,
                                            shape: BoxShape.circle),
                                        child: CircleAvatar(
                                          radius: 43,
                                          backgroundImage: item.img!.length > 0
                                              ? NetworkImage(
                                                  GroceryAppConstant
                                                          .logo_Image_cat +
                                                      item.img!,
                                                )
                                              : AssetImage(
                                                  "assets/images/logo.png")as ImageProvider,
                                        ),
                                      ),

                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          item.pCats??"",
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: GroceryAppColors.tela),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: snapshot.data!.length == null
                              ? 0
                              : snapshot.data!.length,
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int val = -1;
  int grid = -1;
  ShowColor(int index) {
    setState(() {
      val = index;
    });
  }

  GridShowColor(int index) {
    setState(() {
      grid = index;
    });
  }

  Widget show_catnam() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border.all(color: GroceryAppColors.tela1),
          color: GroceryAppColors.white),
      width: 120,
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.vertical,
          itemCount: cat_list.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Screen2(
                                  cat_list[index].pcatId??"",
                                  cat_list[index].pCats??"")),
                        );
                        ShowColor(index);
                      },
                      child: Container(
                        color: val == index
                            ? GroceryAppColors.tela1
                            : GroceryAppColors.white,
                        width: 93,
                        height: 40,
                        child: Center(
                          child: Text(
                            cat_list[index].pCats
                            ??"",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: val == index
                                    ? GroceryAppColors.white
                                    : GroceryAppColors.black),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          //getlistval(cat_list[index].pcatId);
                          flag = true;
                          ShowColor(index);
                        });
                      },
                      child: Container(
                          // padding:EdgeInsets.all(1),
                          child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 25,
                        color: GroceryAppColors.black,
                      )),
                    )
                  ],
                ),
                Divider(
                  color: GroceryAppColors.tela1,
                ),
              ],
            );
          }),
    );
  }

  Widget show_cat_subnam() {
    return Container(
      // width: 150,
      margin: EdgeInsets.only(left: 100),
      child: ListView.builder(
          // separatorBuilder: (context, index) => Divider(
          //   color: Colors.grey,
          // ),
          shrinkWrap: true,
          primary: false,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: sub_cat_list.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 5, right: 5),
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    // color: Colors.grey,
                    child: ListTile(
                      title: Text(
                        sub_cat_list[index].pCats??"",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: GroceryAppColors.black, fontSize: 12),
                      ),
                      trailing: Icon(
                        grid != index
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: GroceryAppColors.black,
                      ),
                      onTap: () {
                        if (grid != index) {
                          GridShowColor(index);
                        } else {
                          setState(() {
                            grid = -1;
                          });
                        }
                      },
                    )

                    // Text(sub_cat_list[index].pCats,
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(color: AppColors.black),) ,
                    ),
                Divider(
                  color: GroceryAppColors.black,
                ),
                grid == index
                    ? Container(
                        color: GroceryAppColors.tela1,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        // height: 90,
                        child: FutureBuilder(
                            future: getData(sub_cat_list[index].pcatId??""),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  child: GridView.builder(
                                    physics: ClampingScrollPhysics(),
                                    controller: new ScrollController(
                                        keepScrollOffset: false),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(
                                      left: 6,
                                      right: 6,
                                    ),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 2,
                                      childAspectRatio: 0.7,
                                    ),
                                    itemBuilder: (context, index) {
                                      Categary item = snapshot.data![index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Screen2(
                                                    item.pcatId??"", item.pCats??"")),
                                          );
                                        },
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                child: CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: Colors.white,
                                                  child: ClipOval(
                                                    child: new SizedBox(
                                                      width: 60.0,
                                                      height: 60.0,
                                                      child: item.img!.length > 0
                                                          ? Image.network(
                                                              GroceryAppConstant
                                                                      .base_url +
                                                                  "manage/uploads/p_category/" +
                                                                  item.img!,
                                                              fit: BoxFit.fill)
                                                          : Image.asset(
                                                              "assets/images/logo.png"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(4),
                                                child: Text(
                                                  item.pCats??"",
                                                  maxLines: 2,
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: snapshot.data!.length == null
                                        ? 0
                                        : snapshot.data!.length,
                                  ),
                                );
                              }
                              return Center(child: CircularProgressIndicator());
                            }),
                      )
                    : Row(),
              ],
            );
          }),
    );
  }
}
