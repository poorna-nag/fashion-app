import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:royalmart/constent/app_constent.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/grocery/dbhelper/database_helper.dart';
import 'package:royalmart/grocery/model/CategaryModal.dart';
import 'package:royalmart/grocery/model/Gallerymodel.dart';
import 'package:royalmart/grocery/model/productmodel.dart';
import 'package:royalmart/grocery/model/slidermodal.dart';
import 'package:royalmart/grocery/screen/SearchScreen.dart';
import 'package:royalmart/grocery/screen/detailpage.dart';
import 'package:royalmart/grocery/screen/detailpage1.dart';
import 'package:royalmart/grocery/screen/productlist.dart';
import 'package:royalmart/grocery/screen/secondtabview.dart';
import 'package:new_version/new_version.dart';
import 'package:royalmart/grocery/screen/vendor_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<PromotionBanner> createAlbum(String shop_id) async {
  var body = {"shop_id": GroceryAppConstant.Shop_id};
  final response = await http.post(
      Uri.parse('https://www.bigwelt.com/api/app-promo-banner.php'),
      body: body);
  print("response------>" + response.body);

  print("jsonDecode(response.body)---> ${jsonDecode(response.body)}");
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return PromotionBanner.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class PromotionBanner {
  String? shopId;
  String? images;
  bool? status;
  String? msg;
  String? path;

  PromotionBanner({this.shopId, this.images, this.status, this.msg, this.path});

  PromotionBanner.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    images = json['images'];
    status = json['status'];
    msg = json['msg'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_id'] = this.shopId;
    data['images'] = this.images;
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['path'] = this.path;
    return data;
  }
}

class GroceryAppHomeScreen extends StatefulWidget {
  @override
  GroceryAppHomeScreenState createState() => GroceryAppHomeScreenState();
}

class GroceryAppHomeScreenState extends State<GroceryAppHomeScreen> {
  static int cartvalue = 0;

  bool progressbar = true;

  static List<String> imgList5 = [
    'https://www.liveabout.com/thmb/y4jjlx2A6PVw_QYG4un_xJSFGBQ=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/asos-plus-size-maxi-dress-56e73ba73df78c5ba05773ab.jpg',
    'https://www.thebalanceeveryday.com/thmb/lMeVfLyCZWVPdU5eyjFLyK4AYQs=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/metrostyle-catalog-df95d1ece06c4197b1da85e316a05f90.jpg',
    'https://rukminim1.flixcart.com/image/400/450/k3xcdjk0pkrrdj/sari/h/d/x/free-multicolor-combosr-28001-ishin-combosr-28001-original-imafa5257bxdzm5j.jpeg?q=90',
    'https://i.pinimg.com/474x/62/4e/ce/624ece8daf9650f1a382995b340dc1e9.jpg'
  ];

  static List<Categary> list = <Categary>[]; // Product categories
  static List<Categary> list1 = <Categary>[]; // Vendor categories
  static List<Categary> list2 = <Categary>[];
  static List<Slider1> sliderlist = <Slider1>[];

  static List<Products> topProducts = [];
  static List<Products> topProducts1 = [];

  static List<Products> dilofdayProducts = [];
  static List<Slider1> bannerSlider = [];
  List<Gallery> galiryImage = [];
  final List<String> imgL = [];
  List<Products> products1 = [];
  List<Products> products3 = [];
  List<Products> bestProducts = [];
  static List reversedilofdayProducts = [];
  static List reversedtopProducts = [];
  static List revesreProducts3 = [];

  double? sgst1, cgst1, dicountValue, admindiscountprice;
  PromotionBanner promotionBanner = PromotionBanner();
  String imageUrl = '';

  double? mrp, totalmrp = 000;

  // PackageInfo packageInfo ;
  // AppUpdateInfo _updateInfo;
  String lastversion = "0";
  int? valcgeck;

  // Infinite scrolling variables for trending products
  ScrollController _trendingScrollController = ScrollController();
  bool _isLoadingMoreTrending = false;
  int _trendingPage = 0;
  bool _hasMoreTrendingData = true;

  /* Future<void> checkForUpdate(BuildContext contex) async {
    packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    lastversion=version.substring(version.lastIndexOf(".")+1);
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        valcgeck=int.parse(lastversion);
        _updateInfo = info;
        if(_updateInfo?.updateAvailable){
          Showpop();
        }
        _updateInfo?.updateAvailable == true;
        print(_updateInfo);
        print(version);
        print(_updateInfo.availableVersionCode-valcgeck);
        print(lastversion);
        print("_updateInfo.......");

//        showDilogue(contex);
        print(_updateInfo);
      });
    }).catchError((e) => _showError(e));
  }*/

  getPackageInfo() async {
    NewVersion newVersion = NewVersion();
    await newVersion.getVersionStatus();
    // status.canUpdate; // (true)
    // status.localVersion ;// (1.2.1)
    // status.storeVersion; // (1.2.3)
    // status.appStoreLink;
    newVersion.showAlertIfNecessary(context: context);
    // print(status.canUpdate);
    // print(status.localVersion);
    // print(status.storeVersion);
    // print(status.appStoreLink);
  }

  @override
  void initState() {
    super.initState();

    // Initialize infinite scrolling for trending products
    _trendingScrollController.addListener(_onTrendingScroll);

    if (GroceryAppConstant.Checkupdate) {
      getPackageInfo();
      GroceryAppConstant.Checkupdate = false;
    }
    // Load product categories (p_category)
    DatabaseHelper.getData("0").then((productCategories) {
      if (this.mounted) {
        setState(() {
          list = productCategories!;
        });
      }
    });

    // Load vendor categories (mv_cats)
    get_Category("0").then((vendorCategories) {
      if (this.mounted) {
        setState(() {
          list1 = vendorCategories!;
        });
      }
    });

    DatabaseHelper.getSlider().then((usersFromServe1) {
      if (this.mounted) {
        setState(() {
          sliderlist = usersFromServe1!;
        });
      }
    });

    DatabaseHelper.getTopProduct("day", "0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          topProducts1 = usersFromServe!;
        });
      }
    });
    DatabaseHelper.getTopProduct("top", "50").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          products1 =
              usersFromServe!; // Changed: Now trending products go to featured section
          // Filter out any duplicates in initial load
          Set<String> seenIds = <String>{};
          products1 = products1.where((product) {
            String productId = product.productIs ?? "";
            if (productId.isEmpty || seenIds.contains(productId)) {
              return false;
            }
            seenIds.add(productId);
            return true;
          }).toList();
          print("Loaded ${products1.length} initial trending products");
//          ScreenState.topProducts.add(topProducts[0]);
        });
      }
    });
    DatabaseHelper.getTopProduct1("new", "1000").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          dilofdayProducts =
              usersFromServe!; // Increased limit to show all new arrival products
        });
      }
    });
    DatabaseHelper.getfeature("yes", "10").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          topProducts =
              usersFromServe!; // Changed: Now featured products go to trending section
//          ScreenState.topProducts.add(topProducts[0]);
        });
      }
    });
    DatabaseHelper.getTopProduct("best", "0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          bestProducts = usersFromServe!;
        });
      }
    });

    getBanner().then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          bannerSlider = usersFromServe!;
        });
      }
    });
    DatabaseHelper.getPromotionBanner(GroceryAppConstant.Shop_id).then((value) {
      if (this.mounted && value != null) {
        print("valueee--> ${value.path}");
        promotionBanner = value;
        imageUrl = value.path ?? '';
        setState(() {});

        print("my url--------->");
        if (promotionBanner.path != null && promotionBanner.images != null) {
          print(GroceryAppConstant.mainurl +
              promotionBanner.path! +
              promotionBanner.images!);
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _trendingScrollController.dispose(); // Dispose scroll controller
    super.dispose();
  }

  // Infinite scrolling methods for trending products
  void _onTrendingScroll() {
    if (_trendingScrollController.position.pixels ==
            _trendingScrollController.position.maxScrollExtent &&
        !_isLoadingMoreTrending &&
        _hasMoreTrendingData) {
      _loadMoreTrendingProducts();
    }
  }

  Future<void> _loadMoreTrendingProducts() async {
    if (_isLoadingMoreTrending) return;

    setState(() {
      _isLoadingMoreTrending = true;
    });

    try {
      _trendingPage++;
      // Calculate start position for pagination (50 for initial + 20 per additional page)
      int startPosition = 50 + (_trendingPage - 1) * 20;

      // Use a custom method to get products with start parameter
      String link = GroceryAppConstant.base_url +
          "manage/api/products/all/?X-Api-Key=" +
          GroceryAppConstant.API_KEY +
          "&start=" +
          startPosition.toString() +
          "&limit=20" +
          "&deals=top" +
          "&field=shop_id&filter=" +
          GroceryAppConstant.Shop_id +
          "&loc_id=" +
          GroceryAppConstant.cityid;
      print("Loading more trending products: $link");

      final response = await http.get(Uri.parse(link));

      if (response.statusCode == 200 && mounted) {
        var responseData = json.decode(response.body);
        List<dynamic> galleryArray = responseData["data"]["products"];
        List<Products> newProducts = Products.getListFromJson(galleryArray);

        if (newProducts.isNotEmpty) {
          // Create a set of existing product IDs to check for duplicates
          Set<String> existingProductIds =
              products1.map((p) => p.productIs ?? "").toSet();

          // Filter out products that already exist
          List<Products> uniqueNewProducts = newProducts.where((product) {
            String productId = product.productIs ?? "";
            return productId.isNotEmpty &&
                !existingProductIds.contains(productId);
          }).toList();

          if (uniqueNewProducts.isNotEmpty) {
            setState(() {
              products1.addAll(uniqueNewProducts);
              _isLoadingMoreTrending = false;
            });
            print(
                "Added ${uniqueNewProducts.length} new unique trending products. Total: ${products1.length}");
          } else {
            // No new unique products found, stop loading more
            setState(() {
              _hasMoreTrendingData = false;
              _isLoadingMoreTrending = false;
            });
            print(
                "No new unique trending products found. Stopping infinite scroll.");
          }
        } else {
          setState(() {
            _hasMoreTrendingData = false;
            _isLoadingMoreTrending = false;
          });
          print("No more trending products available from API");
        }
      } else {
        setState(() {
          _hasMoreTrendingData = false;
          _isLoadingMoreTrending = false;
        });
      }
    } catch (e) {
      print("Error loading more trending products: $e");
      setState(() {
        _isLoadingMoreTrending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    reversedilofdayProducts = dilofdayProducts.reversed.toList();
    revesreProducts3 = products3.reversed.toList();
    reversedtopProducts = topProducts.reversed.toList();
//    showDilogue(context);
    return Material(
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF5F8),
                Colors.white,
                Color(0xFFFFF5F8).withOpacity(0.3),
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                // Fixed Search Bar Section with reduced margins
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE91E63),
                        Color(0xFFD81B60),
                        Color(0xFFAD1457),
                        Color(0xFF880E4F),
                      ],
                      stops: [0.0, 0.3, 0.7, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE91E63).withOpacity(0.4),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Enhanced search bar with more attractive design
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserFilterDemo()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white,
                                  Color(0xFFFFF5F8),
                                  Color(0xFFFCE4EC),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 15,
                                  offset: Offset(0, 6),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFE91E63).withOpacity(0.15),
                                        Color(0xFFE91E63).withOpacity(0.08),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: Color(0xFFE91E63),
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "🛍️ Search for fashion & lifestyle",
                                        style: TextStyle(
                                          color: Color(0xFF2D3748),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      Text(
                                        "Clothes, accessories, beauty & more...",
                                        style: TextStyle(
                                          color: Color(0xFF9E9E9E),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE91E63).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.tune_rounded,
                                    color: Color(0xFFE91E63),
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: _trendingScrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Container(
                        //   margin: EdgeInsets.only(left: 10, top: 10),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       Icon(
                        //         Icons.location_on,
                        //         size: 20,
                        //         color:
                        //             Theme.of(context).textTheme.bodyText1.color,
                        //       ),
                        //       SizedBox(
                        //           width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        //       Container(
                        //         width: MediaQuery.of(context).size.width / 1.7,
                        //         child: Text(
                        //           addController.text.isEmpty
                        //               ? "Click here to get your location"
                        //               : addController.text,
                        //           style: robotoRegular.copyWith(
                        //             color: Theme.of(context)
                        //                 .textTheme
                        //                 .bodyText1
                        //                 .color,
                        //             fontSize: Dimensions.fontSizeSmall,
                        //           ),
                        //           maxLines: 1,
                        //           overflow: TextOverflow.ellipsis,
                        //         ),
                        //       ),
                        //       Icon(Icons.arrow_drop_down, color: Colors.black),
                        //       InkWell(
                        //         onTap: () {
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) => UserFilterDemo()),
                        //           );
                        //         },
                        //         child: Container(
                        //           height: 40,
                        //           width: 40,
                        //           child: Card(
                        //             elevation: 3,
                        //             shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(10),
                        //             ),
                        //             color: GroceryAppColors.tela,
                        //             child: Icon(
                        //               Icons.search,
                        //               color: GroceryAppColors.white,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       InkWell(
                        //         onTap: () {
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) => WishList(),
                        //             ),
                        //           );
                        //         },
                        //         child: Container(
                        //           height: 40,
                        //           width: 40,
                        //           child: Card(
                        //             elevation: 3,
                        //             shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(10),
                        //             ),
                        //             color: GroceryAppColors.tela,
                        //             child: Icon(
                        //               Icons.shopping_cart,
                        //               color: GroceryAppColors.white,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         width: 5,
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        list.length > 0
                            ? Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white,
                                      Color(0xFFFFF5F8),
                                      Color(0xFFFCE4EC).withOpacity(0.3),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFE91E63).withOpacity(0.1),
                                      blurRadius: 15,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFFE91E63),
                                            Color(0xFFD81B60),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFFE91E63)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.grid_view_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "🛍️ SHOP BY CATEGORY",
                                            style: TextStyle(
                                              color: Color(0xFF2D3748),
                                              fontSize: 18,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "Explore fashion collections",
                                            style: TextStyle(
                                              color: Color(0xFF9E9E9E),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Container(
                                    //   padding: EdgeInsets.all(8),
                                    //   decoration: BoxDecoration(
                                    //     color:
                                    //         Color(0xFFE91E63).withOpacity(0.1),
                                    //     borderRadius: BorderRadius.circular(12),
                                    //   ),
                                    //   child: Icon(
                                    //     Icons.arrow_forward_ios_rounded,
                                    //     color: Color(0xFFE91E63),
                                    //     size: 16,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )
                            : Container(),

                        // get data (product categories) start
                        list.length > 0
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 7),
                                child: GridView.count(
                                    physics: ClampingScrollPhysics(),
                                    controller: new ScrollController(
                                        keepScrollOffset: false),
                                    shrinkWrap: true,
                                    crossAxisCount: 4,
                                    childAspectRatio: 0.9,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 12,
                                    children: List.generate(
                                        list.length > 8 ? 8 : list.length,
                                        (index) {
                                      return InkWell(
                                        onTap: () {
                                          print(
                                              "Category tapped: ID=${list[index].pcatId}, Name=${list[index].pCats}");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProductList(
                                                  list[index].pcatId ?? "",
                                                  list[index].pCats ??
                                                      "Product List"),
                                            ),
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                const Color.fromARGB(255, 243, 165, 188),
                                               
                                                const Color.fromARGB(255, 200, 136, 150),
                                                const Color.fromARGB(255, 200, 136, 150)
                                                    .withOpacity(0.05),
                                                const Color.fromARGB(255, 244, 163, 193)
                                                    .withOpacity(0.1),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFFE91E63)
                                                    .withOpacity(0.15),
                                                spreadRadius: 2,
                                                blurRadius: 8,
                                                offset: Offset(0, 4),
                                              ),
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                spreadRadius: 1,
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(2),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color(0xFFE91E63),
                                                      Color(0xFFD81B60),
                                                      Color(0xFFAD1457),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFFE91E63)
                                                          .withOpacity(0.3),
                                                      spreadRadius: 2,
                                                      blurRadius: 6,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                width: 50,
                                                height: 50,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  child: list[index]
                                                          .img!
                                                          .isEmpty
                                                      ? Container(
                                                          color:
                                                              Colors.grey[200],
                                                          child: Icon(
                                                            Icons.category,
                                                            color: Colors
                                                                .grey[400],
                                                            size: 24,
                                                          ),
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              GroceryAppConstant
                                                                      .logo_Image_pcat +
                                                                  list[index]
                                                                      .img!,
                                                          fit: BoxFit.cover,
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            color: Colors
                                                                .grey[200],
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color:
                                                                    GroceryAppColors
                                                                        .tela,
                                                                strokeWidth:
                                                                    2.0,
                                                              ),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Container(
                                                            color: Colors
                                                                .grey[200],
                                                            child: Icon(
                                                              Icons.category,
                                                              color: const Color.fromARGB(255, 182, 168, 168),
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Flexible(
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 4),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Colors.white,
                                                        Color.fromARGB(255, 233, 180, 198),
                                                      ],
                                                    ),
                                                    border: Border.all(
                                                      color: Color(0xFFE91E63)
                                                          .withOpacity(0.3),
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0xFFE91E63)
                                                            .withOpacity(0.15),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    list[index].pCats ?? "",
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 11,
                                                      color: Color(0xFF2D2D2D),
                                                      letterSpacing: 0.3,
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })),
                              )
                            : Row(),
                        // Slider section with responsive height
                        sliderlist.length > 0
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFE91E63).withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.18,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: PageView.builder(
                                      itemCount: sliderlist.length,
                                      itemBuilder: (ctx, index) {
                                        return Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (!sliderlist[index]
                                                      .title!
                                                      .isEmpty) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Screen2(
                                                                  sliderlist[index]
                                                                          .title ??
                                                                      "",
                                                                  "")),
                                                    );
                                                  } else if (!sliderlist[index]
                                                      .description!
                                                      .isEmpty) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetails1(
                                                                  sliderlist[index]
                                                                          .description ??
                                                                      "")),
                                                    );
                                                  }
                                                },
                                                child: CachedNetworkImage(
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  imageUrl: GroceryAppConstant
                                                          .Base_Imageurl +
                                                      sliderlist[index].img!,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                    color: Color(0xFFE91E63),
                                                  )),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                            ));
                                      }),
                                ),
                              )
                            : Container(),

                        // Vendor section with compact design
                        list1.length > 0
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFE91E63).withOpacity(0.1),
                                            Color(0xFFE91E63).withOpacity(0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.store_outlined,
                                        color: Color(0xFFE91E63),
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "SHOP BY VENDOR",
                                      style: TextStyle(
                                        color: Color(0xFF2D3748),
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),

                        // Vendor categories with compact grid
                        list1.length > 0
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: GridView.count(
                                    physics: ClampingScrollPhysics(),
                                    controller: new ScrollController(
                                        keepScrollOffset: false),
                                    shrinkWrap: true,
                                    crossAxisCount: 4,
                                    childAspectRatio: 1.0,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    children: List.generate(
                                        list1.length > 4 ? 4 : list1.length,
                                        (index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => VendorList(
                                                  list1[index].pcatId ?? "",
                                                  "Vendor List"),
                                            ),
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Color(0xFFE91E63)
                                                    .withOpacity(0.05),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFFE91E63)
                                                    .withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFFE91E63),
                                                      Color(0xFFD81B60),
                                                    ],
                                                  ),
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFFE91E63)
                                                          .withOpacity(0.3),
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                width: 45,
                                                height: 45,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          22.5),
                                                  child: list1[index]
                                                          .img!
                                                          .isEmpty
                                                      ? Container(
                                                          color:
                                                              Colors.grey[200],
                                                          child: Icon(
                                                            Icons.store,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              GroceryAppConstant
                                                                      .logo_Image_cat +
                                                                  list1[index]
                                                                      .img!,
                                                          fit: BoxFit.cover,
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            color: Colors
                                                                .grey[200],
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                                strokeWidth:
                                                                    2.0,
                                                              ),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Container(
                                                            color: Colors
                                                                .grey[200],
                                                            child: Icon(
                                                              Icons.store,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              SizedBox(height: 6),
                                              Flexible(
                                                child: Text(
                                                  list1[index].pCats ?? "",
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 9,
                                                    color: Color(0xFF2D2D2D),
                                                    height: 1.1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })),
                              )
                            : Container(),

                        // Featured Products section with compact header
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          margin: EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFE91E63).withOpacity(0.1),
                                          Color(0xFFE91E63).withOpacity(0.05),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.star_outlined,
                                      color: Color(0xFFE91E63),
                                      size: 18,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Featured Products",
                                    style: TextStyle(
                                      color: Color(0xFF2D3748),
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFE91E63).withOpacity(0.1),
                                      Color(0xFFE91E63).withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Color(0xFFE91E63).withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductList(
                                              "yes", "Featured Products")),
                                    );
                                  },
                                  child: Text(
                                    'View All',
                                    style: TextStyle(
                                      color: Color(0xFFE91E63),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        topProducts.length > 0
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: GridView.count(
                                  physics: ClampingScrollPhysics(),
                                  controller: new ScrollController(
                                      keepScrollOffset: false),
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  children: List.generate(topProducts.length,
                                      (index) {
                                    return Container(
                                        margin: EdgeInsets.all(4),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          elevation: 4,
                                          shadowColor: Color(0xFFE91E63)
                                              .withOpacity(0.2),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.white,
                                                  Color(0xFFFFF5F8)
                                                      .withOpacity(0.7),
                                                ],
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetails(
                                                                  topProducts[
                                                                      index],
                                                                  key: ValueKey(
                                                                      'product_${topProducts[index].productIs}'))),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 120,
                                                    width: double.infinity,
                                                    child: Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    12),
                                                            topRight:
                                                                Radius.circular(
                                                                    12),
                                                          ),
                                                          child:
                                                              CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                            imageUrl: GroceryAppConstant
                                                                    .Product_Imageurl +
                                                                topProducts[
                                                                        index]
                                                                    .img!,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    Color(0xFFE91E63)
                                                                        .withOpacity(
                                                                            0.1),
                                                                    Color(0xFFE91E63)
                                                                        .withOpacity(
                                                                            0.05),
                                                                  ],
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Color(
                                                                          0xFFE91E63)),
                                                                  strokeWidth:
                                                                      2,
                                                                ),
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    Color(0xFFE91E63)
                                                                        .withOpacity(
                                                                            0.1),
                                                                    Color(0xFFE91E63)
                                                                        .withOpacity(
                                                                            0.05),
                                                                  ],
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .image_not_supported_outlined,
                                                                color: Color(
                                                                    0xFFE91E63),
                                                                size: 30,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // Featured badge
                                                        Positioned(
                                                          top: 6,
                                                          right: 6,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        6,
                                                                    vertical:
                                                                        3),
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                      0xFFE91E63),
                                                                  Color(
                                                                      0xFFD81B60),
                                                                ],
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 10,
                                                                ),
                                                                SizedBox(
                                                                    width: 2),
                                                                Text(
                                                                  'Featured',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 7,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          topProducts[index]
                                                                  .productName ??
                                                              "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  GroceryAppColors
                                                                      .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    '\u{20B9} ${topProducts[index].buyPrice}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: GroceryAppColors
                                                                            .black,
                                                                        decoration:
                                                                            TextDecoration.lineThrough),
                                                                  ),
                                                                  Text(
                                                                      '\u{20B9} ${calDiscount(topProducts[index].buyPrice ?? "", topProducts[index].discount ?? "")}',
                                                                      style: TextStyle(
                                                                          color: GroceryAppColors
                                                                              .green,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize:
                                                                              12)),
                                                                ],
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                // Add to cart functionality
                                                                if (GroceryAppConstant
                                                                    .isLogin) {
                                                                  SharedPreferences
                                                                      pref =
                                                                      await SharedPreferences
                                                                          .getInstance();
                                                                  String mrp_price = calDiscount(
                                                                      topProducts[index]
                                                                              .buyPrice ??
                                                                          "",
                                                                      topProducts[index]
                                                                              .discount ??
                                                                          "");
                                                                  totalmrp =
                                                                      double.parse(
                                                                          mrp_price);

                                                                  double
                                                                      dicountValue =
                                                                      double.parse(topProducts[index].buyPrice ??
                                                                              "") -
                                                                          totalmrp!;
                                                                  String gst_sgst = calGst(
                                                                      mrp_price,
                                                                      topProducts[index]
                                                                              .sgst ??
                                                                          "");
                                                                  String gst_cgst = calGst(
                                                                      mrp_price,
                                                                      topProducts[index]
                                                                              .cgst ??
                                                                          "");

                                                                  String adiscount = calDiscount(
                                                                      topProducts[index]
                                                                              .buyPrice ??
                                                                          "",
                                                                      topProducts[index].msrp !=
                                                                              null
                                                                          ? topProducts[index].msrp ??
                                                                              ""
                                                                          : "0");

                                                                  admindiscountprice = (double.parse(
                                                                          topProducts[index].buyPrice ??
                                                                              "") -
                                                                      double.parse(
                                                                          adiscount));

                                                                  String color =
                                                                      "";
                                                                  String size =
                                                                      "";
                                                                  _addToproducts(
                                                                      topProducts[index].productIs ??
                                                                          "",
                                                                      topProducts[index].productName ??
                                                                          "",
                                                                      topProducts[index]
                                                                          .img!,
                                                                      int.parse(
                                                                          mrp_price),
                                                                      int.parse(
                                                                          topProducts[index].count ??
                                                                              ""),
                                                                      color,
                                                                      size,
                                                                      topProducts[index]
                                                                              .productDescription ??
                                                                          "",
                                                                      gst_sgst,
                                                                      gst_cgst,
                                                                      topProducts[index]
                                                                              .discount ??
                                                                          "",
                                                                      dicountValue
                                                                          .toString(),
                                                                      topProducts[index]
                                                                              .APMC ??
                                                                          "",
                                                                      admindiscountprice
                                                                          .toString(),
                                                                      topProducts[index]
                                                                              .buyPrice ??
                                                                          "",
                                                                      topProducts[index]
                                                                              .shipping ??
                                                                          "",
                                                                      topProducts[index]
                                                                              .quantityInStock ??
                                                                          "");

                                                                  setState(() {
                                                                    GroceryAppConstant
                                                                        .carditemCount++;
                                                                    groceryCartItemCount(
                                                                        GroceryAppConstant
                                                                            .carditemCount);
                                                                    AppConstent
                                                                        .cc++;
                                                                    pref.setInt(
                                                                        "cc",
                                                                        AppConstent
                                                                            .cc);
                                                                  });
                                                                } else {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                SignInPage()),
                                                                  );
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 32,
                                                                width: 32,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          0xFFE91E63),
                                                                      Color(
                                                                          0xFFD81B60),
                                                                    ],
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Color(
                                                                              0xFFE91E63)
                                                                          .withOpacity(
                                                                              0.3),
                                                                      blurRadius:
                                                                          4,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              2),
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 18,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                                  }),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: Text(
                                    'No featured products available',
                                    style: TextStyle(
                                      color: GroceryAppColors.lightGray,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                        //  gettopproduct("top","0") trending products ends

                        //  bannerSlider starts with responsive height
                        bannerSlider.length > 0
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFE91E63).withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.18,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: PageView.builder(
                                      itemCount: bannerSlider.length,
                                      itemBuilder: (ctx, index) {
                                        return Container(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (!bannerSlider[index]
                                                  .title!
                                                  .isEmpty) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Screen2(
                                                              sliderlist[index]
                                                                      .title ??
                                                                  "",
                                                              "")),
                                                );
                                              } else if (!bannerSlider[index]
                                                  .description!
                                                  .isEmpty) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetails1(
                                                              bannerSlider[
                                                                          index]
                                                                      .description ??
                                                                  "")),
                                                );
                                              }
                                            },
                                            child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 4),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    child: CachedNetworkImage(
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      imageUrl: GroceryAppConstant
                                                              .Base_Imageurl +
                                                          bannerSlider[index]
                                                              .img!,
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                        color:
                                                            Color(0xFFE91E63),
                                                      )),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ))),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            : Container(),
                        //  bannerSlider ends

                        // Best Deals section with compact header
                        bestProducts.length > 0
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFE91E63),
                                            Color(0xFFD81B60),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.local_fire_department_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "BEST DEALS",
                                        style: TextStyle(
                                          color: Color(0xFF2D2D2D),
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFE91E63).withOpacity(0.1),
                                            Color(0xFFD81B60).withOpacity(0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Color(0xFFE91E63)
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProductList(
                                                  "best", "Best Deals"),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'View All',
                                          style: TextStyle(
                                            color: Color(0xFFE91E63),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),

                        bestProducts.length > 0
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: GridView.count(
                                    physics: ClampingScrollPhysics(),
                                    controller: new ScrollController(
                                        keepScrollOffset: false),
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    children: List.generate(bestProducts.length,
                                        (index) {
                                      return Container(
                                        margin: EdgeInsets.all(4),
                                        child: Card(
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetails(
                                                                bestProducts[
                                                                    index])),
                                                  );
                                                },
                                                child: Container(
                                                  height: 130,
                                                  width: double.infinity,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(12),
                                                      topRight:
                                                          Radius.circular(12),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: GroceryAppConstant
                                                              .Product_Imageurl +
                                                          bestProducts[index]
                                                              .img!,
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                        color:
                                                            Color(0xFFE91E63),
                                                      )),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.all(8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        bestProducts[index]
                                                                .productName ??
                                                            "",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color:
                                                              GroceryAppColors
                                                                  .black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '\u{20B9} ${bestProducts[index].buyPrice}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: GroceryAppColors
                                                                          .black,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough),
                                                                ),
                                                                Text(
                                                                    '\u{20B9} ${calDiscount(bestProducts[index].buyPrice ?? "", bestProducts[index].discount ?? "")}',
                                                                    style: TextStyle(
                                                                        color: GroceryAppColors
                                                                            .green,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            12)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })),
                              )
                            : Container(),
                        // Trending Products section starts with compact header
                        products1.length > 0
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                margin: EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFE91E63)
                                                    .withOpacity(0.1),
                                                Color(0xFFE91E63)
                                                    .withOpacity(0.05),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            Icons.trending_up,
                                            color: Color(0xFFE91E63),
                                            size: 16,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "TRENDING PRODUCTS",
                                          style: TextStyle(
                                              color: Color(0xFF2D2D2D),
                                              fontSize: 14,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFE91E63).withOpacity(0.1),
                                            Color(0xFFE91E63).withOpacity(0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Color(0xFFE91E63)
                                              .withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductList("top",
                                                        "Trending Products")),
                                          );
                                        },
                                        child: Text('View All',
                                            style: TextStyle(
                                                color: Color(0xFFE91E63),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),

                        products1.length > 0
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: GridView.count(
                                    physics: ClampingScrollPhysics(),
                                    controller: new ScrollController(
                                        keepScrollOffset: false),
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    children: List.generate(products1.length,
                                        (index) {
                                      return Container(
                                        margin: EdgeInsets.all(4),
                                        child: Card(
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetails(
                                                                products1[
                                                                    index])),
                                                  );
                                                },
                                                child: Container(
                                                  height: 130,
                                                  width: double.infinity,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(12),
                                                      topRight:
                                                          Radius.circular(12),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: GroceryAppConstant
                                                              .Product_Imageurl +
                                                          products1[index].img!,
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                        color:
                                                            Color(0xFFE91E63),
                                                      )),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.all(8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        products1[index]
                                                                .productName ??
                                                            "",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color:
                                                              GroceryAppColors
                                                                  .black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '\u{20B9} ${products1[index].buyPrice}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: GroceryAppColors
                                                                          .black,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough),
                                                                ),
                                                                Text(
                                                                    '\u{20B9} ${calDiscount(products1[index].buyPrice ?? "", products1[index].discount ?? "")}',
                                                                    style: TextStyle(
                                                                        color: GroceryAppColors
                                                                            .green,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            12)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })),
                              )
                            : Container(),
                        // Promotional banner with responsive height
                        imageUrl.length > 0
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.18,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: PageView.builder(
                                    itemCount: imageUrl.length,
                                    itemBuilder: (ctx, index) {
                                      return Container(
                                        child: GestureDetector(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xFFE91E63)
                                                      .withOpacity(0.1),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Image.network(
                                                "${GroceryAppConstant.mainurl + promotionBanner.path! + promotionBanner.images!}",
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    color: Colors.grey[200],
                                                    child: Icon(Icons
                                                        .image_not_supported),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ))
                            : Container(),

                        // New Arrival section with compact header
                        dilofdayProducts.length > 0
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFE91E63),
                                            Color(0xFFD81B60),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.new_releases_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "🆕 NEW ARRIVAL",
                                        style: TextStyle(
                                          color: Color(0xFF2D2D2D),
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFE91E63).withOpacity(0.1),
                                            Color(0xFFD81B60).withOpacity(0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Color(0xFFE91E63)
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductList(
                                                        "new", "New Arrival")),
                                          );
                                        },
                                        child: Text(
                                          'View All',
                                          style: TextStyle(
                                            color: Color(0xFFE91E63),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),

                        dilofdayProducts.length > 0
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: GridView.count(
                                    physics: ClampingScrollPhysics(),
                                    controller: new ScrollController(
                                        keepScrollOffset: false),
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    children: List.generate(
                                        dilofdayProducts.length, (index) {
                                      return Container(
                                          margin: EdgeInsets.all(4),
                                          child: Card(
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Colors.white,
                                                        Color(0xFFFFF5F8),
                                                        Color(0xFFFCE4EC)
                                                            .withOpacity(0.2),
                                                      ],
                                                    ),
                                                    border: Border.all(
                                                      color: Color(0xFFE91E63)
                                                          .withOpacity(0.1),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Column(children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProductDetails(
                                                                      dilofdayProducts[
                                                                          index])),
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 130,
                                                        width: double.infinity,
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        12),
                                                                topRight: Radius
                                                                    .circular(
                                                                        12),
                                                              ),
                                                              child:
                                                                  CachedNetworkImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: double
                                                                    .infinity,
                                                                height: double
                                                                    .infinity,
                                                                imageUrl: GroceryAppConstant
                                                                        .Product_Imageurl +
                                                                    dilofdayProducts[
                                                                            index]
                                                                        .img!,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Color(
                                                                          0xFFE91E63)),
                                                                )),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Container(
                                                                  color: Color(
                                                                      0xFFFCE4EC),
                                                                  child: Icon(
                                                                    Icons
                                                                        .shopping_bag_rounded,
                                                                    color: Color(
                                                                        0xFFE91E63),
                                                                    size: 30,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            // New Badge
                                                            Positioned(
                                                              top: 8,
                                                              left: 8,
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            4),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          0xFFE91E63),
                                                                      Color(
                                                                          0xFFD81B60),
                                                                    ],
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .new_releases_rounded,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 10,
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            2),
                                                                    Text(
                                                                      "NEW",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            8,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.all(8),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              dilofdayProducts[
                                                                          index]
                                                                      .productName ??
                                                                  "",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                color:
                                                                    GroceryAppColors
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            SizedBox(height: 4),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        '\u{20B9} ${dilofdayProducts[index].buyPrice}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                GroceryAppColors.black,
                                                                            decoration: TextDecoration.lineThrough),
                                                                      ),
                                                                      Text(
                                                                          '\u{20B9} ${calDiscount(dilofdayProducts[index].buyPrice ?? "", dilofdayProducts[index].discount ?? "")}',
                                                                          style: TextStyle(
                                                                              color: GroceryAppColors.green,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 12)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ]))));
                                    })),
                              )
                            : Container(),
                        // Bottom padding for better spacing
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*Showpop(){
    showDialog(
      barrierDismissible: false, // JUST MENTION THIS LINE
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
              content: Padding(
                padding: const EdgeInsets.all(5.0),
                child:  Container(
                  height: 110.0,
                  width: 320.0,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding:  EdgeInsets.all(5.0),
                          child: Text("New Version is avaliable on Playstore",style: TextStyle(fontSize: 18,color: Colors.black),)
                      ),
//          Padding(
//              padding:  EdgeInsets.all(10.0),
//              child: Text('${_updateInfo.availableVersionCode}',style: TextStyle(fontSize: 18,color: Colors.black),)
//          ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          (_updateInfo.availableVersionCode-valcgeck)<3? FlatButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel !', style: TextStyle(color:GroceryAppColors.black, fontSize: 18.0),)):Row(),

                          FlatButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                                // _launchURL();
                              },
                              child: Text('Update ', style: TextStyle(color:GroceryAppColors.green, fontSize: 18.0),)),

                        ],
                      )
                    ],
                  ),
                ),
              )
          ),
        );
      },
    );
  }*/

//  showDilogue(BuildContext context) {
//    Dialog errorDialog = Dialog(
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//      //this right here
//      child: Container(
//        height: 160.0,
//        width: 300.0,
//
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Padding(
//                padding: EdgeInsets.all(10.0),
//                child: Text("New Version is avaliable on Playstore",
//                  style: TextStyle(fontSize: 18, color: Colors.black),)
//            ),
////          Padding(
////              padding:  EdgeInsets.all(10.0),
////              child: Text('${_updateInfo.availableVersionCode}',style: TextStyle(fontSize: 18,color: Colors.black),)
////          ),
//
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                FlatButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                    child: Text('Cancel !', style: TextStyle(
//                        color:GroceryAppColors.black, fontSize: 18.0),)),
//
//                FlatButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                      _launchURL();
//                    },
//                    child: Text('Update Now ', style: TextStyle(
//                        color:GroceryAppColors.green, fontSize: 18.0),)),
//
//              ],
//            )
//          ],
//        ),
//      ),
//    );
//    showDialog(
//        context: context, builder: (BuildContext context) => errorDialog);
//  }

  String calDiscount(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = (byprice1 - (byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(GroceryAppConstant.val);
    print(returnStr);
    return returnStr;
  }

  final DbProductManager dbmanager = new DbProductManager();

  ProductsCart? products2;

  void _addToproducts(
      String pID,
      String p_name,
      String image,
      int price,
      int quantity,
      String c_val,
      String p_size,
      String p_disc,
      String sgst,
      String cgst,
      String discount,
      String dis_val,
      String adminper,
      String adminper_val,
      String cost_price,
      String shippingcharge,
      String totalQun) {
    if (products2 == null) {
//      print(pID+"......");
//      print(p_name);
//      print(image);
//      print(price);
//      print(quantity);
//      print(c_val);
//      print(p_size);
//      print(p_disc);
//      print(sgst);
//      print(cgst);
//      print(discount);
//      print(dis_val);
//      print(adminper);
//      print(adminper_val);
//      print(cost_price);
      ProductsCart st = new ProductsCart(
          pid: pID,
          pname: p_name,
          pimage: image,
          pprice: (price * quantity).toString(),
          pQuantity: quantity,
          pcolor: c_val,
          psize: p_size,
          pdiscription: p_disc,
          sgst: sgst,
          cgst: cgst,
          discount: discount,
          discountValue: dis_val,
          adminper: adminper,
          adminpricevalue: adminper_val,
          costPrice: cost_price,
          shipping: shippingcharge,
          totalQuantity: totalQun);
      dbmanager.insertStudent(st).then((id) => {
            showLongToast(" Products  is added to cart "),
            print(' Added to Db ${id}')
          });
    }
  }

  String calGst(String byprice, String sgst) {
    String returnStr;
    double discount = 0.0;
    if (sgst.length > 1) {
      returnStr = discount.toString();
      double byprice1 = double.parse(byprice);
      print(sgst);

      double discount1 = double.parse(sgst);

      discount = ((byprice1 * discount1) / (100.0 + discount1));

      returnStr = discount.toStringAsFixed(2);
      print(returnStr);
      return returnStr;
    } else {
      return '0';
    }
  }

  void showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future cartItemcount(int val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setInt("itemCount", val);
    print(val.toString() + "shair....");
  }
}
