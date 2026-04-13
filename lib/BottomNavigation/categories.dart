import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/model/CategaryModal.dart';
import 'package:royalmart/screen/editprofile.dart';
import 'package:royalmart/screen/productlist.dart';

class Cgategorywise extends StatefulWidget {
  @override
  _CgategorywiseState createState() => _CgategorywiseState();
}

class _CgategorywiseState extends State<Cgategorywise> {
  List<Categary> list =[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodAppColors.white,
      body: Container(
          child: FutureBuilder(
        future: get_Category("925"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                Categary cat = snapshot.data![index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        var i = cat.pcatId;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductList(i!, "Vendor List")),
                        );

                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Sbcategory(cat.pCats, i)),);
                      },
                      child: Stack(
                        children: [
                          Container(
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(16.0),),

                            margin: EdgeInsets.only(top: 3, bottom: 10, left: 10, right: 10),
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: FoodAppColors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                          ),
                                        ),
                                        width: (MediaQuery.of(context).size.width / 2) - 14,
                                      ),
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.only(left: ((MediaQuery.of(context).size.width) / 2) - 210),
                                          height: 150,
                                          width: 195,
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(top: 35),
                                                  child: Text(
                                                    cat.pCats.toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: new TextStyle(fontWeight: FontWeight.bold, color: FoodAppColors.black, fontSize: 20),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  height: 40,
                                                  width: 100,
                                                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                                                  child: Center(
                                                      child: Text(
                                                    "Shop Now",
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: FoodAppColors.white, fontSize: 12),
                                                  )),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context).size.width / 2) - 14,
                                    child: Center(
                                      child: Container(
                                        height: 120,
                                        width: 120,
                                        child: Card(
                                          shadowColor: FoodAppColors.tela,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(60),
                                          ),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(60),
                                              child: cat.img!.isEmpty
                                                  ? Image.asset(
                                                      "assets/images/logo.png",
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      FoodAppConstant.logo_Image_cat + cat.img!,
                                                      fit: BoxFit.cover,
                                                    )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
                // ExpandableListView(cat.pCats,cat.pcatId);
              },
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      )),
    );
  }
}

/*


class ExpandableListView extends StatefulWidget {
  final String title;
  final String id;

  const ExpandableListView(this.title,this.id) : super();
  @override
  _ExpandableListViewState createState() => new _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;
  bool expandFlag1 = false;
  List<Categary> list = List();
  static int size;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    list.clear();
  }
  @override
  void initState() {

    DatabaseHelper.getData(widget.id).then((usersFromServe){
      if(this.mounted) {
        setState(() {
          list = usersFromServe;
          size = list.length;
//        for(var i=0;i<list.length;i++){
//          print(list[i].img);
//        }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: new Column(
        children: <Widget>[
          new Container(
            color: AppColors.white,
            padding: new EdgeInsets.symmetric(horizontal: 5.0),
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Screen2(widget.id,widget.title)),
                );
              },
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new IconButton(
                        icon: new Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: new BoxDecoration(
                            color: AppColors.category_button_Icon_color,
                            shape: BoxShape.circle,
                          ),
                          child: new Center(
                            child: new Icon(
                              expandFlag ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            expandFlag = !expandFlag;
                          });
                        }),
                    Expanded(
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ) ,


                  ],
                ),),
            ),
          ),
          new ExpandableContainer(
              expanded: expandFlag,

              expandedHeight:list.length>0?list.length*60.0:1.0,
              child:  ListView.builder(
                physics: ClampingScrollPhysics(),
                 itemBuilder: (BuildContext context, int index) {
                  return new Container(
                    decoration:
                    new BoxDecoration(border: new Border.all(width: 1.0, color: AppColors.tela), color: AppColors.tela),
                    child: InkWell(
                      onTap: (){

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Screen2(list[index].pcatId,list[index].pCats)),
                        );
                      },
                      child:  Column(
                        children: <Widget>[
                          ListTile(
                            title:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    list[index].pCats,
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.black ),
                                  ),
                                ),

                                IconButton(
                                    icon: new Container(
                                      height: 50.0,
                                      width: 50.0,
                                      decoration: new BoxDecoration(
                                        color: AppColors.category_button_Icon_color,
                                        shape: BoxShape.circle,
                                      ),
                                      child: new Center(
                                        child: new Icon(
                                          list[index].ff=="1" ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                          color: Colors.white,
                                          size: 30.0,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {

                                        if(list[index].ff=="1"){
                                          list[index].ff="0";

                                        }
                                        else{
                                          list[index].ff="1";

                                        }
                                        expandFlag1 = !expandFlag1;
                                      });
                                    }),

                              ],
                            ),
                            leading:ClipOval(
                              child:list[index].img!=""?  Image.network(
                                Constant.base_url+"manage/uploads/p_category/"+
                                    list[index].img,
                                fit: BoxFit.cover,
                                height: 40.0,
                                width: 40.0,
                              ):new Icon(Icons.image,color: Colors.black,),

                            ),


                          ),

                          list[index].ff=="1"?Row():Container(
//                            height: 100,
                            child: FutureBuilder(
                              future: getData(list[index].pcatId),
                              builder: (context,snapshot){
                                if(snapshot.hasData){
                                  return ListView.builder(
                                    physics: ClampingScrollPhysics(),

                                    itemBuilder: (BuildContext context, int index) {
                                      Categary cat =snapshot.data[index];
                                      return Container(
                                        color: AppColors.white,
                                        child: InkWell(
                                          onTap: (){

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => Screen2(cat.pcatId,cat.pCats)),
                                            );
                                          },
                                          child: ListTile(
                                            title:  Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    cat.pCats,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.black ),
                                                  ),
                                                ),



                                              ],
                                            ),
                                            leading:ClipOval(
                                              child:cat!=""?  Image.network(
                                                Constant.base_url+"manage/uploads/p_category/"+
                                                    cat.img,
                                                fit: BoxFit.cover,
                                                height: 40.0,
                                                width: 40.0,
                                              ):new Icon(Icons.image,color: Colors.black,),

                                            ),


                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: snapshot.data.length,
                                    shrinkWrap: true,
                                  );
                                }
                                return Center(child: CircularProgressIndicator());
                              },
                            ),
                          )


                        ],
                      ),
                    ),
                  );
                },
                itemCount: list.length,
              )),




        ],
      ),
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded ;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight,
    this.expanded,
  });


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: new Container(
        child: child,
        decoration: new BoxDecoration(border: new Border.all(width: 1.0, color: AppColors.telamoredeep)),
      ),
    );
  }
}*/
