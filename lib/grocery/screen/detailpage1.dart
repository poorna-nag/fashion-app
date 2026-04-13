import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/grocery/BottomNavigation/wishlist.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/grocery/dbhelper/database_helper.dart';
import 'package:royalmart/grocery/dbhelper/wishlistdart.dart';
import 'package:royalmart/grocery/model/Gallerymodel.dart';
import 'package:royalmart/grocery/model/GroupProducts.dart';
import 'package:royalmart/grocery/model/Varient.dart';
import 'package:royalmart/grocery/model/productmodel.dart';
import 'package:royalmart/grocery/screen/Zoomimage.dart';
import 'package:royalmart/grocery/screen/detailpage.dart';
import 'package:royalmart/grocery/screen/secondtabview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails1 extends StatefulWidget {
  final String id;
  const ProductDetails1(this.id) : super();

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails1> {
  List<PVariant> pvarlist = [];
  String name = "";
  String textval = "Select varient";
  String sharableProductName = "";
  String sharableProductId = "";
  _displayDialog(BuildContext context, int position) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Select Variant'),
            content: Container(
              width: double.maxFinite,
              height: pvarlist.length * 50.0,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: pvarlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: pvarlist[index] != 0 ? 130.0 : 230.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            total = int.parse(pvarlist[index].price ?? "");
                            String mrp_price = calDiscount(
                                pvarlist[index].price ?? "",
                                pvarlist[index].discount ?? "");
                            totalmrp = double.parse(mrp_price);
                            textval = pvarlist[index].variant ?? "";
                            name = pvarlist[index].variant ?? "";
                            // imgList1[position].

                            Navigator.pop(context);
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                pvarlist[index].variant.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: GroceryAppColors.black,
                                ),
                              ),
                            ),
                            Divider(
                              color: GroceryAppColors.black,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  int? _current = 0;
  bool? flag = true;
  bool? wishflag = true;
  int? wishid;
  String? url;
  List<Products> products1 = [];
  List<String> catid = <String>[];

  final List<String> imgList1 = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  ];
  List<GroupProducts>? group = [];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int _count = 1;
  String? _dropDownValue, groupname = "";
  String? _dropDownValue1;
  int? total;
  int? actualprice = 200;
  double? mrp, totalmrp;
  double? sgst1, cgst1, dicountValue, admindiscountprice;
  List<String>? size;
  List<String>? color;

  List<Gallery> galiryImage1 = [];
  List<Products> productdetails = [];
  ProductsCart? products;
  Products? prod;
  final DbProductManager dbmanager = new DbProductManager();

//  DatabaseHelper helper = DatabaseHelper();
//  Note note ;

  void gatinfoCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    int? Count = pref.getInt("itemCount");
    bool? ligin = pref.getBool("isLogin");

    setState(() {
      GroceryAppConstant.isLogin = ligin ?? false;

      if (Count == null) {
        GroceryAppConstant.groceryAppCartItemCount = 0;
      } else {
        GroceryAppConstant.groceryAppCartItemCount = Count;
      }
//      print(Constant.carditemCount.toString()+"itemCount");
    });
  }

  String? id;
  @override
  void initState() {
    super.initState();

    gatinfoCount();
    productdetail(widget.id).then((usersFromServe) {
      setState(() {
        productdetails = usersFromServe ?? [];
        if (productdetails.length > 0) {
          setState(() {
            url = productdetails[0].img;
            id = productdetails[0].productIs;
            actualprice = int.parse(productdetails[0].buyPrice ?? "");
            total = actualprice;

            String mrp_price = calDiscount(productdetails[0].buyPrice ?? "",
                productdetails[0].discount ?? "");
            totalmrp = double.parse(mrp_price);

            String adiscount = calDiscount(
                productdetails[0].buyPrice ?? "", productdetails[0].msrp ?? "");
            admindiscountprice =
                (double.parse(productdetails[0].buyPrice ?? "") -
                    double.parse(adiscount));
            dicountValue =
                double.parse(productdetails[0].buyPrice ?? "") - totalmrp!;
            String gst_sgst =
                calGst(totalmrp.toString(), productdetails[0].sgst ?? "");
            String gst_cgst =
                calGst(totalmrp.toString(), productdetails[0].cgst ?? "");
            color = productdetails[0].productColor!.split(',');
            size = productdetails[0].productScale!.split(',');

            sgst1 = double.parse(gst_sgst);
            cgst1 = double.parse(gst_cgst);
            print(productdetails[0].productLine! + "product id");
            catid = productdetails[0].productLine!.split(',');
            DatabaseHelper.getProductsByCategory(
                    catid.length > 0 ? catid[0] : "0", "10")
                .then((usersFromServe) {
              setState(() {
                products1 = usersFromServe ?? [];
              });
            });

            GroupPro(productdetails[0].productIs ?? "").then((usersFromServe) {
              setState(() {
                group = usersFromServe?.cast<GroupProducts>() ?? [];
                group != null ? groupname = group![0].name : groupname = "";
              });
            });

            dbmanager1.getProductList3().then((usersFromServe) {
              setState(() {
                prodctlist1 = usersFromServe;
                for (var i = 0; i < prodctlist1!.length; i++) {
                  if (prodctlist1![i].pid == id) {
                    wishflag = false;
                    wishid = prodctlist1![i].id;
                    break;
                  }
                }
              });
            });
          });
        }
      });
    });
    DatabaseHelper.getImage(widget.id).then((usersFromServe) {
      setState(() {
        galiryImage1 = usersFromServe ?? [];
        imgList1.clear();
        for (var i = 0; i < galiryImage1.length; i++) {
          imgList1.add(galiryImage1[i].img!);
        }
      });
    });

    getPvarient(widget.id).then((usersFromServe) {
      setState(() {
        pvarlist = usersFromServe ?? [];
      });
    });
  }

  bool showdis = false;

  static List<WishlistsCart>? prodctlist1;
  shareProduct(String url, String title, String price) async {
    Share.share("Hi, Order Best Products From " +
        GroceryAppConstant.appname +
        " app. Click on this link  $price");
    // await Share.("my text title", "${price}", "text/plain");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                GroceryAppColors.tela,
                GroceryAppColors.tela.withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: Text(
          "Product Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: Padding(
            padding: EdgeInsets.only(left: 0.0),
            child: InkWell(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 22,
                color: Colors.white,
              ),
            )),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishList()),
              );
            },
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 40, top: 17),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, bottom: 18),
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.shade500,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child:
                          Text('${GroceryAppConstant.groceryAppCartItemCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFF8F9FA),
      bottomNavigationBar: productdetails.isNotEmpty 
        ? _buildBottomAction(productdetails[0]) 
        : null,
      body: productdetails.isEmpty 
        ? Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
        : CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeaderCarousel(),
                  _buildProductInfo(),
                  if (_hasOptions()) _buildVariantSection(productdetails[0]),
                  _buildDescriptionSection(productdetails[0]),
                  _buildRelatedItemsSection(),
                  _buildRelatedProductsSection(),
                  SizedBox(height: 50),
                ]),
              ),
            ],
          ),
    );
  }

  bool _hasOptions() {
    if (productdetails.isEmpty) return false;
    return (productdetails[0].productColor != null && productdetails[0].productColor!.length > 2) ||
           (productdetails[0].productScale != null && productdetails[0].productScale!.length > 2);
  }

  Widget _buildHeaderCarousel() {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 300,
              color: Colors.white,
              child: PageView.builder(
                itemCount: imgList1.length,
                onPageChanged: (index) => setState(() => _current = index),
                itemBuilder: (context, index) => InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ZoomImage(imgList1))),
                  child: CachedNetworkImage(
                    imageUrl: GroceryAppConstant.Product_Imageurl2 + imgList1[index],
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Color(0xFFE91E63))),
                    errorWidget: (context, url, error) => Icon(Icons.error_outline, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (imgList1.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList1.map((url) {
                int index = imgList1.indexOf(url);
                return Container(
                  width: _current == index ? 24.0 : 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: _current == index ? Color(0xFFE91E63) : Colors.grey.shade300,
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildProductInfo() {
    Products item = productdetails[0];
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name.isNotEmpty ? name : item.productName ?? "",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                totalmrp != null ? '\u{20B9}${(totalmrp! * _count).toStringAsFixed(2)}' : '---',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF2E7D32)),
              ),
              SizedBox(width: 10),
              if (item.discount != "0")
                Text(
                  '\u{20B9}${actualprice! * _count}',
                  style: TextStyle(fontSize: 16, color: Colors.grey, decoration: TextDecoration.lineThrough),
                ),
              if (item.discount != "0")
                Container(
                  padding: EdgeInsets.all(2),
                  child: Text(
                     " ${item.discount}% OFF",
                     style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
            ],
          ),
          if (item.quantityInStock != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Stock: ${item.quantityInStock}",
                style: TextStyle(color: int.parse(item.quantityInStock!) < 5 ? Colors.red : Colors.grey, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVariantSection(Products item) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("AVAILABLE OPTIONS", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey.shade700)),
          SizedBox(height: 20),
          if (item.productColor != null && item.productColor!.length > 2)
            _buildDropdown("Select Color", color, _dropDownValue, (val) => setState(() => _dropDownValue = val)),
          if (item.productScale != null && item.productScale!.length > 2)
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: _buildDropdown("Select Size", size, _dropDownValue1, (val) => setState(() => _dropDownValue1 = val)),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String>? items, String? value, Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint),
          value: value,
          icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFFE91E63)),
          items: items?.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val, style: TextStyle(fontSize: 15)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(Products item) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("DESCRIPTION", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey.shade700)),
          SizedBox(height: 12),
          Text(
            _parseHtmlString(item.productDescription ?? ""),
            style: TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedItemsSection() {
     if (group == null || group!.isEmpty) return SizedBox.shrink();
     return Container(
       margin: EdgeInsets.symmetric(vertical: 10),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20),
             child: Text("PACKAGE INCLUDES", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey.shade700)),
           ),
           SizedBox(height: 10),
           Container(
             height: 50,
             child: ListView.builder(
               padding: EdgeInsets.symmetric(horizontal: 20),
               scrollDirection: Axis.horizontal,
               itemCount: group!.length,
               itemBuilder: (context, index) => Container(
                 margin: EdgeInsets.only(right: 10),
                 child: ActionChip(
                   backgroundColor: Colors.pink.shade50,
                   side: BorderSide(color: Colors.pink.shade100),
                   label: Text(group![index].name ?? "", style: TextStyle(color: Colors.pink.shade700, fontWeight: FontWeight.w600)),
                   onPressed: () {
                     setState(() {
                       name = group![index].name ?? "";
                     });
                   },
                 ),
               ),
             ),
           ),
         ],
       ),
     );
  }

  Widget _buildRelatedProductsSection() {
    if (products1.isEmpty) return SizedBox.shrink();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("YOU MAY ALSO LIKE", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey.shade700)),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Screen2(catid.isNotEmpty ? catid[1] : "0", "RELATED"))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    elevation: 1,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text("VIEW ALL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: 220,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              itemCount: products1.length,
              itemBuilder: (context, index) => _buildRelatedProductCard(products1[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProductCard(Products prod) {
    return InkWell(
      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductDetails(prod))),
      child: Container(
        width: 150,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: CachedNetworkImage(
                imageUrl: GroceryAppConstant.Product_Imageurl + prod.img!,
                height: 120,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(prod.productName ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("\u{20B9}${prod.buyPrice}", style: TextStyle(fontSize: 14, color: Color(0xFFE91E63), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(Products item) {
    return _buildBottomNavigationBar(); // Use the existing bottom bar
  }

  Widget _buildBottomNavigationBar() {
    if (productdetails.isEmpty) return SizedBox.shrink();
    Products item = productdetails[0];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quantity row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            if (_count > 1) {
                              setState(() {
                                _count--;
                              });
                            }
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.remove,
                              color: _count > 1 ? Color(0xFFE91E63) : Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
                        child: Center(
                          child: Text(
                            '$_count',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            if (_count < int.parse(item.quantityInStock ?? "1")) {
                              setState(() {
                                _count++;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Product is not available"), duration: Duration(seconds: 1), backgroundColor: Colors.red.shade400,),
                              );
                            }
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Icon(Icons.add, color: Color(0xFFE91E63), size: 20,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            // Actions Row
            Row(
              children: [
                // Wishlist Button
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: wishflag! ? Colors.grey.shade100 : Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: wishflag! ? Colors.grey.shade300 : Colors.pink.shade200,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        if (GroceryAppConstant.isLogin) {
                          if (wishflag!) {
                            _addToproducts1(context);
                            showLongToast("Product added to wishlist");
                            setState(() {
                              wishflag = false;
                              GroceryAppConstant.wishlist++;
                              _countList(GroceryAppConstant.wishlist);
                            });
                          } else {
                            setState(() {
                              dbmanager1.deleteProducts(wishid!);
                              wishflag = true;
                            });
                          }
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
                        }
                      },
                      child: Icon(
                        wishflag! ? Icons.favorite_border : Icons.favorite,
                        color: wishflag! ? Colors.grey.shade600 : Colors.pink.shade400,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                // Add to Cart Button
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        // validation logic
                        if (GroceryAppConstant.isLogin) {
                          if (item.productColor!.length > 0 && item.productScale!.length > 0) {
                            if (_dropDownValue != null && _dropDownValue1 != null) {
                              if (int.parse(item.quantityInStock ?? "0") > 0) {
                                bool isNew = await _addToproducts(context);
                                if (isNew) {
                                  GroceryAppConstant.groceryAppCartItemCount++;
                                  groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
                                  setState(() { GroceryAppConstant.itemcount++; });
                                }
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product added to cart"), duration: Duration(seconds: 1), backgroundColor: Colors.green));
                              } else { showLongToast("Product is out of stock"); }
                            } else { showLongToast("Please select color and size"); }
                          } else if (item.productColor!.length > 2) {
                            if (_dropDownValue != null) {
                              if (int.parse(item.quantityInStock ?? "0") > 0) {
                                bool isNew = await _addToproducts(context);
                                if (isNew) {
                                  GroceryAppConstant.groceryAppCartItemCount++;
                                  groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
                                  setState(() { GroceryAppConstant.itemcount++; });
                                }
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product added to cart"), duration: Duration(seconds: 1), backgroundColor: Colors.green));
                              } else { showLongToast("Product is out of stock"); }
                            } else { showLongToast("Please select color"); }
                          } else if (item.productScale!.length > 2) {
                            if (_dropDownValue1 != null) {
                              if (int.parse(item.quantityInStock ?? "0") > 0) {
                                bool isNew = await _addToproducts(context);
                                if (isNew) {
                                  GroceryAppConstant.groceryAppCartItemCount++;
                                  groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
                                  setState(() { GroceryAppConstant.itemcount++; });
                                }
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product added to cart"), duration: Duration(seconds: 1), backgroundColor: Colors.green));
                              } else { showLongToast("Product is out of stock"); }
                            } else { showLongToast("Please select size"); }
                          } else {
                            if (int.parse(item.quantityInStock ?? "0") > 0) {
                              bool isNew = await _addToproducts(context);
                              if (isNew) {
                                GroceryAppConstant.groceryAppCartItemCount++;
                                groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
                                setState(() { GroceryAppConstant.itemcount++; });
                              }
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product added to cart"), duration: Duration(seconds: 1), backgroundColor: Colors.green));
                            } else { showLongToast("Product is out of stock"); }
                          }
                        } else { Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage())); }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE91E63),
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shadowColor: Color(0xFFE91E63).withOpacity(0.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 20),
                          SizedBox(width: 8),
                          Text("Add to Cart", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                // Share button
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          sharableProductName = name.replaceAll(" ", "-");
                          sharableProductName = sharableProductName.replaceAll("(", "");
                          sharableProductName = sharableProductName.replaceAll(")", "");
                          sharableProductId = item.productIs.toString();
                        });
                        shareProduct(
                          GroceryAppConstant.Product_Imageurl + item.img!,
                          item.productName ?? "",
                          GroceryAppConstant.base_url + "${sharableProductName}_" + sharableProductId,
                        );
                      },
                      child: Icon(
                        Icons.share_outlined,
                        color: Colors.blue.shade600,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  productName1() {
    actualprice = int.parse(productdetails[0].buyPrice ?? "");
    total = actualprice;

    String mrp_price = calDiscount(
        productdetails[0].buyPrice ?? "", productdetails[0].discount ?? "");
    totalmrp = double.parse(mrp_price);

    Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 5, left: 10),
      child: Text(
          productdetails[0].productName == null
              ? productdetails[0].productName ?? "".length.toString()
              : "sanjar",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          )),
    );
  }

  priceold() {
    Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 1),
      child: Text('\u{20B9} $total',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: GroceryAppColors.mrp,
              decoration: TextDecoration.lineThrough)),
    );
  }

  priceNew() {
    Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 1),
      child: Text(
          totalmrp != null
              ? '\u{20B9} ${(totalmrp! * _count).toStringAsFixed(2)}'
              : '1000',
//                              total.toString()==null?'\u{20B9} $total':actualprice.toString(),
          style: TextStyle(
            color: GroceryAppColors.sellp,
            fontWeight: FontWeight.w700,
          )),
    );
  }

  productDetails() {
    Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
      child: Text(
        productdetails[0].productDescription ?? "",
        style: new TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
      ),
    );
  }

//  discountValue;
//  String adminper;
//  String adminpricevalue;
//  String costPrice;

  Future<bool> _addToproducts(BuildContext context) async {
    List<ProductsCart> cartItems = await dbmanager.getProductList1(productdetails[0].productIs ?? "");
    ProductsCart? existingProduct;
    
    bool _isEqual(String? a, String? b) {
      String strA = (a == null || a == "null" || a.trim().isEmpty) ? "" : a.trim();
      String strB = (b == null || b == "null" || b.trim().isEmpty) ? "" : b.trim();
      return strA == strB;
    }

    // Check if variant matches
    for (var item in cartItems) {
      if (_isEqual(item.pcolor, _dropDownValue) && 
          _isEqual(item.psize, _dropDownValue1) && 
          _isEqual(item.varient, textval)) {
         existingProduct = item;
         break;
      }
    }

    if (existingProduct != null) {
      existingProduct.pQuantity = (existingProduct.pQuantity ?? 0) + _count;
      existingProduct.pprice = (totalmrp! * existingProduct.pQuantity!).toString();
      await dbmanager.updateStudent(existingProduct);
      return false; // Not a new item
    } else {
      ProductsCart st = new ProductsCart(
          pid: productdetails[0].productIs,
          pname: productdetails[0].productName,
          pimage: url,
          pprice: (totalmrp! * _count).toString(),
          pQuantity: _count,
          pcolor: _dropDownValue,
          psize: _dropDownValue1,
          pdiscription: productdetails[0].productDescription,
          sgst: sgst1.toString(),
          cgst: cgst1.toString(),
          discount: productdetails[0].discount,
          discountValue: dicountValue.toString(),
          adminper: productdetails[0].msrp,
          adminpricevalue: admindiscountprice.toString(),
          costPrice: total.toString(),
          shipping: productdetails[0].shipping,
          totalQuantity: productdetails[0].quantityInStock,
          varient: textval,
          mv: int.parse(productdetails[0].mv!),
          moq: '');
      dynamic id = await dbmanager.insertStudent(st);
      return true; // New item inserted
    }
  }

  WishlistsCart? nproducts;
  final DbProductManager1 dbmanager1 = new DbProductManager1();

  void _addToproducts1(BuildContext context) {
    if (nproducts == null) {
      WishlistsCart st1 = new WishlistsCart(
          id: null, // Auto-generated ID
          pid: productdetails[0].productIs,
          pname: productdetails[0].productName,
          pimage: url,
          pprice: totalmrp.toString(),
          pQuantity: _count,
          pcolor: _dropDownValue,
          psize: _dropDownValue1,
          pdiscription: productdetails[0].productDescription,
          sgst: sgst1.toString(),
          cgst: cgst1.toString(),
          discount: productdetails[0].discount,
          discountValue: dicountValue.toString(),
          adminper: productdetails[0].msrp,
          adminpricevalue: admindiscountprice.toString(),
          costPrice: productdetails[0].buyPrice);
      dbmanager1.insertStudent(st1).then((id) => {
            setState(() {
              wishid = id;

              print('Student Added to Db ${wishid}');
              print(GroceryAppConstant.totalAmount);
            })
          });
    }
  }

  String calDiscount(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = (byprice1 - (byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(2);
    print(returnStr);
    return returnStr;
  }

  String calGst(String byprice, String sgst) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(sgst);

    discount = ((byprice1 * discount1) / (100.0 + discount1));

    returnStr = discount.toStringAsFixed(2);
    print(returnStr);
    return returnStr;
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  Widget discription1(String Discription) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Text(
                '${_parseHtmlString(Discription)}',
                overflow: TextOverflow.fade,
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget discription(String name, String Discription) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              name,
              overflow: TextOverflow.fade,
              style: new TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Text(
                Discription,
                overflow: TextOverflow.fade,
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _countList(int val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("wcount", val);
  }
}
