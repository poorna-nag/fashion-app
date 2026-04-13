import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/BottomNavigation/wishlist.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/General/Home.dart';
import 'package:royalmart/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/model/CategaryModal.dart';
import 'package:royalmart/model/Gallerymodel.dart';
import 'package:royalmart/model/ListModel.dart';
import 'package:royalmart/model/TrackInvoiceModel.dart';
import 'package:royalmart/model/productmodel.dart';
import 'package:royalmart/model/promotion_banner_model.dart';
import 'package:royalmart/model/slidermodal.dart';
import 'package:royalmart/screen/SearchScreen.dart';
import 'package:royalmart/screen/detailpage1.dart';
import 'package:royalmart/screen/productlist.dart';
import 'package:royalmart/screen/secondtabview.dart';
import 'package:new_version/new_version.dart';
import 'package:royalmart/screen/vendor_list.dart';
import 'package:royalmart/utils/dimensions.dart';
import 'package:royalmart/utils/styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:royalmart/map/newMapScreen.dart';

import 'categories.dart';

class FoodAppHomeScreen extends StatefulWidget {
  @override
  FoodAppHomeScreenState createState() => FoodAppHomeScreenState();
}

// com.willyoudateme
class FoodAppHomeScreenState extends State<FoodAppHomeScreen> {
  static int cartvalue = 0;

  ValueNotifier isLoading = ValueNotifier(false);

  bool progressbar = true;

  getPackageInfo() async {
    NewVersion newVersion = NewVersion();
    final status = await newVersion.getVersionStatus();
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

  static List<String> imgList5 = [
    'https://www.liveabout.com/thmb/y4jjlx2A6PVw_QYG4un_xJSFGBQ=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/asos-plus-size-maxi-dress-56e73ba73df78c5ba05773ab.jpg',
  ];

  final List<String> imgList1 = [
    'https://assets.myntassets.com/h_1440,q_90,w_1080/v1/assets/images/9329399/2019/4/24/8df4ed41-1e43-4a0d-97fe-eb47edbdbacd1556086871124-Libas-Women-Kurtas-6161556086869769-1.jpg',
  ];
  int _current = 0;
  var _start = 0;
  static List<Categary> list = <Categary>[];
  static List<Categary> list1 = <Categary>[];
  static List<Categary> list2 = <Categary>[];
  static List<Slider1> sliderlist = <Slider1>[];
  static List<Slider1> bannerSlider = <Slider1>[];
  static List<ListModel> shoplist = <ListModel>[];
  static List<ListModel> items = <ListModel>[];
  static List<ListModel> shopList = <ListModel>[];
  static List<Products> topProducts = [];
  static List<Products> featuredProducts = [];
  static List<Products> dilofdayProducts = [];
  static List<Products> bestDealsProducts = [];
  static List<Products> dealsOfTheDayProducts = [];
  static List<Products> newArrivalProducts = [];
  List<Gallery> galiryImage = [];
  final List<String> imgL = [];
  SharedPreferences? pref;

  String lastversion = "0";
  int? valcgeck;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _flexibleUpdateAvailable = false;
  final addController = TextEditingController();
  PromotionBanner promotionBanner = PromotionBanner();
  String imageUrl = '';
  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      FoodAppConstant.latitude = position!.latitude;
      FoodAppConstant.longitude = position!.longitude;
      print(' lat ${FoodAppConstant.latitude},${FoodAppConstant.longitude}');
      getAddress(FoodAppConstant.latitude, FoodAppConstant.longitude);
    });
  }

  Position? position;

  getAddress(double lat, double long) async {
    var addresses = await placemarkFromCoordinates(lat, long);
    var first = addresses.first;

    setState(() {
      var address = first.subLocality.toString() +
          " " +
          first.subAdministrativeArea.toString() +
          " " +
          first.subThoroughfare.toString() +
          " " +
          first.thoroughfare.toString();

      addController.text = address.replaceAll("null", "");
      // print('Rahul ${address}');
      // pref.setString("lat", lat.toString());
      // pref.setString("lat", lat.toString());
      // pref.setString("add", address.toString().replaceAll("null", ""));
    });
  }

  List<ListModel> mvdetails = [];
  List<TrackInvoice> invoice = [];

  String? mobile;
  String? status;
  String? message = "";

  Future<void> getUserInfo() async {
    pref = await SharedPreferences.getInstance();
    SharedPreferences pre = await SharedPreferences.getInstance();
    String mob = pre.getString("mobile").toString();
    this.setState(() {
      mobile = mob;
      getInvoice();
    });
  }

  double? lat_val = 0.0;
  double? lang_val = 0.0;
  String? invoice_id;
  String? mv_lat;
  String? mv_lang;

  getInvoice() {
    trackInvoice(mobile ?? "0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          invoice = usersFromServe!;
          if (invoice.length > 0) {
            status = invoice[0].states;

            invoice_id = invoice[0].id;
            lat_val = double.parse(invoice[0].lat!);
            lang_val = double.parse(invoice[0].lng!);
            getmvdetails(invoice[0].mv ?? "");
            status == "Pending"
                ? message = "Your order is not yet accepted by Restaurants"
                : message = "Your food is being prepared";
          }

          // list = usersFromServe;
        });
      }
    });
  }

  getmvdetails(String mv) {
    getShopList1ByMV(mv).then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          mvdetails = usersFromServe!;
          if (mvdetails.length > 0) {
            mv_lat = mvdetails[0].lat;
            mv_lang = mvdetails[0].lng;
          }
        });
      }
    });
  }

  @override
  void initState() {
    isLoading.value = true;
    super.initState();
    /*
    DatabaseHelper.getTopProduct("top", "0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          topProducts = usersFromServe;
          print("top------->${topProducts.length}");
        });
      }
    });*/
    /*DatabaseHelper.getTopProduct("day", "0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          dealsOfTheDayProducts = usersFromServe;
        });
      }
    });*/
    DatabaseHelper.getTopProduct("best", "0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          bestDealsProducts = usersFromServe!;
          print("topb------->${bestDealsProducts.length}");
        });
      }
    });
    /*
    DatabaseHelper.getfeature("&featured=yes", "0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          featuredProducts = usersFromServe;
          print("fet------->${featuredProducts.length}");
          print(featuredProducts.last.name);
        });
      }
    });
    DatabaseHelper.getfeature("&featured=yes", "0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          featuredProducts = usersFromServe;
          print("fet------->${featuredProducts.length}");
          print(featuredProducts.last.name);
        });
      }
    });
    DatabaseHelper.getNewArrivals().then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          newArrivalProducts = usersFromServe;
          print("fet------->${newArrivalProducts.length}");
          print(newArrivalProducts.last.name);
        });
      }
    });*/

    getUserInfo();

    _getCurrentLocation();

    if (FoodAppConstant.Checkupdate) {
      getPackageInfo();
      FoodAppConstant.Checkupdate = false;
    }
    _getCurrentLocation();

    get_Category("1111").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          list = usersFromServe!;
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

    DatabaseHelper.getSlider().then((usersFromServe1) {
      if (this.mounted) {
        setState(() {
          FoodAppHomeScreenState.sliderlist = usersFromServe1!;

          FoodAppHomeScreenState.imgList5.clear();
          if (FoodAppHomeScreenState.sliderlist.length > 0) {
            for (var i = 0; i < FoodAppHomeScreenState.sliderlist.length; i++) {
              FoodAppHomeScreenState.imgList5
                  .add(FoodAppHomeScreenState.sliderlist[i].img!);
            }
          }
        });
      }
    });
    /*DatabaseHelper.getPromotionBanner(Constant.Shop_id).then((value) {
      if (this.mounted) {
        promotionBanner = value;
        imageUrl = value.path;
        setState(() {});
      }
      var url = Constant.base_url + promotionBanner.path + promotionBanner.images;
    });*/

    setState(() {
      isLoading.value = false;
    });
  }

  bool check = false;
  static const int PAGE_SIZE = 10;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 10) / 3;
    final double itemWidth = size.width / 2;
//    showDilogue(context);
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: isLoading.value
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                child: CustomScrollView(slivers: <Widget>[
                SliverList(
                  // Use a delegate to build items as they're scrolled on screen.
                  delegate: SliverChildBuilderDelegate(
                    // The builder function returns a ListTile with a title that
                    // displays the index of the current item.
                    (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            _getCurrentLocation();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10, top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                                SizedBox(
                                    width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.7,
                                  child: Text(
                                    addController.text.isEmpty
                                        ? "Click here to get your location"
                                        : addController.text,
                                    style: robotoRegular.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                      fontSize: Dimensions.fontSizeSmall,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down,
                                    color: Colors.black),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserFilterDemo()));
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: FoodAppColors.tela,
                                      child: Icon(
                                        Icons.search,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WishList(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: FoodAppColors.tela,
                                      child: Icon(
                                        Icons.shopping_cart,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        /*  Container(
                          margin: EdgeInsets.only(right: 5, left: 5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserFilterDemo("")),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: .5,
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                padding: EdgeInsets.only(top: 0, bottom: 0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.search,
                                      color: AppColors.tela,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Search your desired food",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),*/

                        ///TODO:- HomeScreen Slider
                        sliderlist != null
                            ? sliderlist.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 10),
                                    child: Container(
                                        // margin:  EdgeInsets.only(top:50),
                                        height: 155.0,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: sliderlist != null
                                            ? sliderlist.length > 0
                                                ? Container(
                                                    height: 180,
                                                    child: Center(
                                                      child: Text(
                                                          'Carousel temporarily disabled'),
                                                    ),
                                                  )
                                                : Container()
                                            : Container()),
                                  )
                                : Container()
                            : Container(),
                        SizedBox(
                          height: 13,
                        ),

                        list != null
                            ? list.length > 0
                                ? Container(
                                    color: FoodAppColors.white,
                                    padding:
                                        EdgeInsets.only(bottom: 10, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 8.0,
                                              left: 18.0,
                                              right: 8.0,
                                              bottom: 10),
                                          child: Text(
                                            "Shop by Category",
                                            style: TextStyle(
                                                color: FoodAppColors
                                                    .product_title_name,
                                                fontSize: 18,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container()
                            : Container(),
                        /*list != null
                        ? list.length > 0
                            ? Container(
                                child: GridView.count(
                                    physics: ClampingScrollPhysics(),
                                    controller: new ScrollController(keepScrollOffset: false),
                                    shrinkWrap: true,
                                    crossAxisCount: 4,
                                    childAspectRatio: 0.7,
                                    padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 0),
                                    children: List.generate(list.length, (index) {
                                      return InkWell(
                                        onTap: () {
                                          var i = list[index].pcatId;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Sbcategory(list[index].pCats, list[index].pcatId)),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(5.0, 25.0, 5.0, 0.0),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: AppColors.tela, width: 4),
                                                  borderRadius: BorderRadius.circular(35),
                                                ),
                                                width: 70,
                                                height: 70,
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(0.0),
                                                      child: list[index].img.isEmpty
                                                          ? Image.asset("assets/images/logo.png", fit: BoxFit.fill)
                                                          : Image.network(Constant.base_url + "manage/uploads/p_category/" + list[index].img,
                                                              fit: BoxFit.fill),
                                                    )),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  // SizedBox(height: 10.0),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      list[index].pCats,
                                                      maxLines: 2,
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                            ],
                                          ),
                                        ),
                                      );
                                    })),
                              )
                            : Row()
                        : Row(),*/

                        list != null
                            ? list.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                mainAxisSpacing: 10,
                                                crossAxisSpacing: 10,
                                                childAspectRatio:
                                                    (itemWidth / itemHeight)),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              // var i = list[index].pcatId;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductList(
                                                            list[index]
                                                                    .pcatId ??
                                                                "",
                                                            "Vendor List")),
                                              );
                                            },
                                            child: Card(
                                              margin: EdgeInsets.zero,
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Container(
                                                // elevation: 7,

                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  // border: Border.all(
                                                  //     color: AppColors.tela,
                                                  //     width: 2),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                margin: EdgeInsets.zero,
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        // border: Border.all(
                                                        //     color: AppColors.tela,
                                                        //     width: 2),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10)),
                                                      ),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 110,
                                                      child: ClipRRect(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight:
                                                                  Radius.circular(
                                                                      10)),
                                                          child: list[index]
                                                                  .img!
                                                                  .isEmpty
                                                              ? Image.asset(
                                                                  "assets/images/logo.png",
                                                                  fit: BoxFit
                                                                      .fill)
                                                              : Image.network(
                                                                  FoodAppConstant.logo_Image_cat +
                                                                      list[index].img!,
                                                                  fit: BoxFit.fill)),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      list[index]
                                                          .pCats
                                                          .toString(),
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: list.length),
                                  )

                                //     Container(
                                //         child: ListView.builder(
                                //           itemCount: 3,
                                //           shrinkWrap: true,
                                //           primary: false,
                                //           itemBuilder: (context, index) {
                                //             return InkWell(
                                //               onTap: () {
                                //                 Navigator.push(
                                //                   context,
                                //                   MaterialPageRoute(
                                //                       builder: (context) =>
                                //                           ProductList(
                                //                               list[index].pcatId,
                                //                               "Vendor List")),
                                //                 );
                                //               },
                                //               child: Padding(
                                //                 padding: const EdgeInsets.symmetric(
                                //                     horizontal: 8.0),
                                //                 child: Container(
                                //                   // margin: EdgeInsets.only(
                                //                   //   left: 12,
                                //                   //   right: 12,
                                //                   //   bottom: 12,
                                //                   // ),
                                //                   // height: 120,
                                //                   // width:
                                //                   //     MediaQuery.of(context).size.width,
                                //                   child: Card(
                                //                     elevation: 10,
                                //                     color: FoodAppColors.red,
                                //                     shape: RoundedRectangleBorder(
                                //                       borderRadius:
                                //                           BorderRadius.circular(10),
                                //                     ),
                                //                     child: Row(
                                //                       mainAxisAlignment:
                                //                           MainAxisAlignment
                                //                               .spaceBetween,
                                //                       // crossAxisAlignment:
                                //                       // CrossAxisAlignment.start,
                                //                       children: [
                                //                         Padding(
                                //                           padding:
                                //                               const EdgeInsets.only(
                                //                             left: 10,
                                //                             // top: 5,
                                //                           ),
                                //                           child: Text(
                                //                             list[index].pCats,
                                //                             style: TextStyle(
                                //                                 color: FoodAppColors
                                //                                     .black,
                                //                                 fontWeight:
                                //                                     FontWeight.bold,
                                //                                 fontSize: 18),
                                //                           ),
                                //                         ),
                                //                         Container(
                                //                           height: 80,
                                //                           width: 110,
                                //                           decoration: BoxDecoration(
                                //                             borderRadius:
                                //                                 BorderRadius.only(
                                //                               bottomLeft:
                                //                                   Radius.circular(
                                //                                       50),
                                //                               topRight:
                                //                                   Radius.circular(
                                //                                       10),
                                //                             ),
                                //                           ),
                                //                           child: ClipRRect(
                                //                             borderRadius:
                                //                                 BorderRadius.only(
                                //                               bottomLeft:
                                //                                   Radius.circular(
                                //                                       50),
                                //                               topRight:
                                //                                   Radius.circular(
                                //                                       10),
                                //                             ),
                                //                             child:
                                //                                 CachedNetworkImage(
                                //                               width: MediaQuery.of(
                                //                                           context)
                                //                                       .size
                                //                                       .width -
                                //                                   30,
                                //                               fit: BoxFit.fill,
                                //                               imageUrl: FoodAppConstant
                                //                                       .logo_Image_cat +
                                //                                   list[index].img,
                                //                               placeholder: (context,
                                //                                       url) =>
                                //                                   Center(
                                //                                       child:
                                //                                           CircularProgressIndicator()),
                                //                               errorWidget: (context,
                                //                                       url, error) =>
                                //                                   new Icon(
                                //                                       Icons.error),
                                //                             ),
                                //                           ),
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ),
                                //             );
                                //           },
                                //         ),
                                //       )
                                : Row()
                            : Row(),
                        SizedBox(
                          height: 20,
                        ),
                        // list != null
                        //     ? list.length > 0
                        //         ? Container(
                        //             color: FoodAppColors.white,
                        //             padding: EdgeInsets.only(bottom: 10),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: <Widget>[
                        //                 Padding(
                        //                   padding: EdgeInsets.only(
                        //                       top: 8.0, left: 8.0, right: 8.0),
                        //                   child: Text(
                        //                     "Categories",
                        //                     style: TextStyle(
                        //                         color: FoodAppColors
                        //                             .product_title_name,
                        //                         fontSize: 15,
                        //                         fontFamily: 'Roboto',
                        //                         fontWeight: FontWeight.bold),
                        //                   ),
                        //                 ),
                        //                 InkWell(
                        //                   onTap: () {
                        //                     Navigator.push(
                        //                       context,
                        //                       MaterialPageRoute(
                        //                         builder: (context) =>
                        //                             Cgategorywise(),
                        //                       ),
                        //                     );
                        //                   },
                        //                   child: Padding(
                        //                     padding: EdgeInsets.only(
                        //                         top: 8.0,
                        //                         left: 8.0,
                        //                         right: 8.0),
                        //                     child: Text(
                        //                       "View All",
                        //                       style: TextStyle(
                        //                           color: FoodAppColors.tela1,
                        //                           fontSize: 12,
                        //                           fontFamily: 'Roboto',
                        //                           fontWeight: FontWeight.bold),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           )
                        //         : Container()
                        //     : Container(),

                        // list.isNotEmpty
                        //     ? Container(
                        //         height: list.length > 8
                        //             ? 350
                        //             : list.length > 4
                        //                 ? 230
                        //                 : 130,
                        //         width: MediaQuery.of(context).size.width,
                        //         child: GridView.builder(
                        //             physics: NeverScrollableScrollPhysics(),
                        //             itemCount:
                        //                 list.length > 12 ? 12 : list.length,
                        //             gridDelegate:
                        //                 SliverGridDelegateWithFixedCrossAxisCount(
                        //                     crossAxisCount: 4,
                        //                     childAspectRatio: .9),
                        //             itemBuilder: (context, index) {
                        //               return Container(
                        //                 margin: index == 0 ||
                        //                         index == 4 ||
                        //                         index == 8
                        //                     ? EdgeInsets.only(left: 5)
                        //                     : index == 3 ||
                        //                             index == 7 ||
                        //                             index == 11
                        //                         ? EdgeInsets.only(right: 5)
                        //                         : EdgeInsets.only(left: 5),
                        //                 height: 120,
                        //                 width: 120,
                        //                 child: InkWell(
                        //                   onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           ProductList(
                        //               list[index].pcatId,
                        //               "Vendor List")),
                        // );
                        //                   },
                        //                   child: Column(
                        //                     children: [
                        //                       Container(
                        //                         height: 80,
                        //                         width: 80,
                        //                         child: Card(
                        //                           elevation: 3,
                        //                           shape: RoundedRectangleBorder(
                        //                             borderRadius:
                        //                                 BorderRadius.circular(
                        //                                     40),
                        //                           ),
                        //                           child: ClipRRect(
                        //                             borderRadius:
                        //                                 BorderRadius.circular(
                        //                                     40),
                        //                             child: CachedNetworkImage(
                        //                               width:
                        //                                   MediaQuery.of(context)
                        //                                           .size
                        //                                           .width -
                        //                                       30,
                        //                               fit: BoxFit.fill,
                        //                               imageUrl: FoodAppConstant
                        //                                       .logo_Image_cat +
                        //                                   list[index].img,
                        //                               placeholder: (context,
                        //                                       url) =>
                        //                                   Center(
                        //                                       child:
                        //                                           CircularProgressIndicator()),
                        //                               errorWidget: (context,
                        //                                       url, error) =>
                        //                                   new Icon(Icons.error),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       SizedBox(
                        //                           height: Dimensions
                        //                               .PADDING_SIZE_EXTRA_SMALL),
                        //                       Padding(
                        //                         padding: EdgeInsets.only(
                        //                             right: index == 0
                        //                                 ? Dimensions
                        //                                     .PADDING_SIZE_EXTRA_SMALL
                        //                                 : 0),
                        //                         child: Text(
                        //                           list[index].pCats,
                        //                           style: TextStyle(
                        //                               fontWeight:
                        //                                   FontWeight.bold,
                        //                               fontSize: 10),
                        //                           maxLines: 2,
                        //                           overflow:
                        //                               TextOverflow.ellipsis,
                        //                           textAlign: TextAlign.center,
                        //                         ),
                        //                       ),
                        //                       SizedBox(
                        //                           height: Dimensions
                        //                               .PADDING_SIZE_EXTRA_SMALL),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               );
                        //             }),
                        //       )
                        //     : Container(),
                        bestDealsProducts == null
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : bestDealsProducts.isNotEmpty
                                ? Container(
                                    color: FoodAppColors.white,
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 8.0, left: 15.0, right: 8.0),
                                          child: Text(
                                            "Recent Products",
                                            style: TextStyle(
                                              color: FoodAppColors
                                                  .product_title_name,
                                              fontSize: 15,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),

                        bestDealsProducts.length > 0
                            ? Container(
                                child: ListView.builder(
                                    itemCount: bestDealsProducts.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            left: 15, bottom: 10, right: 15),
                                        height: 90,
                                        width: 270,
                                        padding: EdgeInsets.all(Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            )
                                          ],
                                        ),
                                        child: Row(children: [
                                          Stack(children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL),
                                              child: bestDealsProducts[index]
                                                      .img!
                                                      .isEmpty
                                                  ? Image.asset(
                                                      "assets/images/logo.png",
                                                      height: 80,
                                                      width: 80,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : CachedNetworkImage(
                                                      fit: BoxFit.contain,
                                                      imageUrl: FoodAppConstant
                                                              .Base_Imageurl +
                                                          bestDealsProducts[
                                                                  index]
                                                              .img!,
                                                      height: 80,
                                                      width: 80,
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child: CircularProgressIndicator(
                                                                  //color:
                                                                  //FoodAppColors.tela,
                                                                  )),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(Icons.error),
                                                    ),
                                            ),
                                            double.parse(
                                                        bestDealsProducts[index]
                                                            .discount
                                                            .toString()) >
                                                    0
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        top: 15),
                                                    height: 25,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FoodAppColors.sellp,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(7),
                                                        bottomRight:
                                                            Radius.circular(7),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        bestDealsProducts[index]
                                                                .discount! +
                                                            "\n% OFF",
                                                        style: TextStyle(
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: FoodAppColors
                                                                .white),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ]),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      bestDealsProducts[index]
                                                          .productName
                                                          .toString(),
                                                      style: robotoMedium.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                        height: Dimensions
                                                            .PADDING_SIZE_EXTRA_SMALL),
                                                    // Text(
                                                    //   bestDealsProducts[index]
                                                    //       .name,
                                                    //   style: robotoMedium.copyWith(
                                                    //       fontSize: Dimensions
                                                    //           .fontSizeExtraSmall,
                                                    //       color: Theme.of(
                                                    //               context)
                                                    //           .disabledColor),
                                                    //   maxLines: 1,
                                                    //   overflow:
                                                    //       TextOverflow.ellipsis,
                                                    // ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "\u{20B9}" +
                                                              calDiscount(
                                                                  bestDealsProducts[
                                                                          index]
                                                                      .buyPrice
                                                                      .toString(),
                                                                  bestDealsProducts[
                                                                              index]
                                                                          .discount ??
                                                                      ""),
                                                          style: robotoBold.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeExtraSmall),
                                                        ),
                                                        SizedBox(
                                                            width: double.parse(
                                                                        bestDealsProducts[index].discount ??
                                                                            "") >
                                                                    0
                                                                ? Dimensions
                                                                    .PADDING_SIZE_EXTRA_SMALL
                                                                : 0),
                                                        double.parse(bestDealsProducts[
                                                                            index]
                                                                        .discount ??
                                                                    "") >
                                                                0
                                                            ? Expanded(
                                                                child: Text(
                                                                "\u{20B9}" +
                                                                    bestDealsProducts[
                                                                            index]
                                                                        .buyPrice
                                                                        .toString(),
                                                                style:
                                                                    robotoRegular
                                                                        .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeExtraSmall,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                ),
                                                              ))
                                                            : Expanded(
                                                                child:
                                                                    SizedBox()),
                                                        InkWell(
                                                            onTap: () {
                                                              print(
                                                                  "helllllllo");
                                                              if (FoodAppConstant
                                                                  .isLogin) {
                                                                String? mv = pref!
                                                                    .getString(
                                                                  "mvid",
                                                                );
                                                                if (mv ==
                                                                        null ||
                                                                    mv
                                                                        .isEmpty ||
                                                                    bestDealsProducts[index]
                                                                            .mv ==
                                                                        pref!.getString(
                                                                            "mvid")) {
                                                                  pref!.setString(
                                                                      "mvid",
                                                                      bestDealsProducts[index]
                                                                              .mv ??
                                                                          "");
                                                                  print(pref!
                                                                      .getString(
                                                                          "mvid"));

                                                                  String mrp_price = calDiscount(
                                                                      bestDealsProducts[
                                                                              index]
                                                                          .buyPrice
                                                                          .toString(),
                                                                      bestDealsProducts[
                                                                              index]
                                                                          .discount
                                                                          .toString());
                                                                  totalmrp =
                                                                      double.parse(
                                                                          mrp_price);

                                                                  double
                                                                      dicountValue =
                                                                      double.parse(bestDealsProducts[index]
                                                                              .buyPrice
                                                                              .toString()) -
                                                                          totalmrp!;
                                                                  String? gst_sgst = calGst(
                                                                      mrp_price,
                                                                      bestDealsProducts[index]
                                                                              .sgst ??
                                                                          "");
                                                                  String gst_cgst = calGst(
                                                                      mrp_price,
                                                                      bestDealsProducts[index]
                                                                              .cgst ??
                                                                          "");

                                                                  String adiscount = calDiscount(
                                                                      bestDealsProducts[index]
                                                                              .buyPrice ??
                                                                          "",
                                                                      bestDealsProducts[index].msrp !=
                                                                              null
                                                                          ? bestDealsProducts[index]
                                                                              .msrp
                                                                              .toString()
                                                                          : "0");

                                                                  admindiscountprice = (double.parse(
                                                                          bestDealsProducts[index].buyPrice ??
                                                                              "") -
                                                                      double.parse(
                                                                          adiscount));

                                                                  String color =
                                                                      "";
                                                                  String size =
                                                                      "";

                                                                  // String mv=  pref.getString("mvid",);

                                                                  _addToproducts(
                                                                      bestDealsProducts[index].productIs ??
                                                                          "",
                                                                      bestDealsProducts[index].productName ??
                                                                          "",
                                                                      bestDealsProducts[index]
                                                                          .img!,
                                                                      int.parse(
                                                                          mrp_price),
                                                                      int.parse(
                                                                          bestDealsProducts[index].count ??
                                                                              ""),
                                                                      color,
                                                                      size,
                                                                      bestDealsProducts[index]
                                                                              .productDescription ??
                                                                          "",
                                                                      gst_sgst,
                                                                      gst_cgst,
                                                                      bestDealsProducts[index]
                                                                              .discount ??
                                                                          "",
                                                                      dicountValue
                                                                          .toString(),
                                                                      bestDealsProducts[index]
                                                                              .APMC ??
                                                                          "",
                                                                      bestDealsProducts
                                                                          .toString(),
                                                                      bestDealsProducts[index]
                                                                              .buyPrice ??
                                                                          "",
                                                                      bestDealsProducts[index]
                                                                              .shipping ??
                                                                          "",
                                                                      bestDealsProducts[index]
                                                                              .quantityInStock ??
                                                                          "",
                                                                      bestDealsProducts[index]
                                                                              .youtube ??
                                                                          "",
                                                                      bestDealsProducts[index]
                                                                              .mv ??
                                                                          "");

//                                                                Navigator.push(context,
//                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);
                                                                } else {
                                                                  showAlertDialog(
                                                                      context,
                                                                      bestDealsProducts[
                                                                          index]);
                                                                }
                                                              } else {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              SignInPage()),
                                                                );
                                                              }
                                                            },
                                                            child: Icon(
                                                                Icons.add,
                                                                size: 25)),
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ]),
                                      );
                                    }),
                              )
                            : Container(),

                        bannerSlider != null
                            ? bannerSlider.length > 0
                                ? Container(
                                    height: 190.0,
                                    child: bannerSlider != null
                                        ? bannerSlider.length > 0
                                            ? PageView.builder(
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
                                                                        sliderlist[index].title ??
                                                                            "",
                                                                        "")),
                                                          );
                                                        } else if (!bannerSlider[
                                                                index]
                                                            .description!
                                                            .isEmpty) {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ProductDetails1(
                                                                        bannerSlider[index].description ??
                                                                            "")),
                                                          );
//
                                                        }
                                                      },
                                                      child: Container(
                                                        child: Card(
                                                          elevation: 3,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child:
                                                                CachedNetworkImage(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  30,
                                                              fit: BoxFit.fill,
                                                              imageUrl: FoodAppConstant
                                                                      .Base_Imageurl +
                                                                  bannerSlider[
                                                                          index]
                                                                      .img!,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  Center(
                                                                      child:
                                                                          CircularProgressIndicator()),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  new Icon(Icons
                                                                      .error),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor:
                                                      FoodAppColors.tela,
                                                ),
                                              )
                                        : Row())
                                : Container()
                            : Container(),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                )
              ])),
      ),
    );
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

  double? sgst1, cgst1, dicountValue, admindiscountprice;

  int? total = 000;
  int? actualprice = 200;
  double? mrp, totalmrp = 000;
  int? _count = 1;

  getAddrocatrvalue(Products pro) {
    String mrp_price = calDiscount(pro.buyPrice ?? "", pro.discount ?? "");
    totalmrp = double.parse(mrp_price);

    double? dicountValue = double.parse(pro.buyPrice ?? "") - totalmrp!;
    String gst_sgst = calGst(mrp_price, pro.sgst ?? "");
    String gst_cgst = calGst(mrp_price, pro.cgst ?? "");

    String adiscount = calDiscount(
        pro.buyPrice ?? "", pro.msrp != null ? pro.msrp ?? "" : "0");

    admindiscountprice =
        (double.parse(pro.buyPrice ?? "") - double.parse(adiscount));

    String color = "";
    String size = "";
    setState(() {
//                                                                              cartvalue++;
      FoodAppConstant.foodAppCartItemCount++;
      MyApp1State.countval = FoodAppConstant.foodAppCartItemCount;
      foodCartItemCount(FoodAppConstant.foodAppCartItemCount);
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp1()),
    );
  }

  showAlertDialog(BuildContext context, Products pro) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        dbmanager.deleteallProducts();

        FoodAppConstant.itemcount = 0;
        FoodAppConstant.foodAppCartItemCount = 0;
        foodCartItemCount(FoodAppConstant.foodAppCartItemCount);

        String mrp_price = calDiscount(pro.buyPrice ?? "", pro.discount ?? "");
        totalmrp = double.parse(mrp_price);
        String color = "";
        String size = "";
        double dicountValue = double.parse(pro.buyPrice ?? "") - totalmrp!;
        String gst_sgst = calGst(mrp_price, pro.sgst ?? "");
        String gst_cgst = calGst(mrp_price, pro.cgst ?? "");
        String adiscount = calDiscount(
            pro.buyPrice ?? "", pro.msrp != null ? pro.msrp ?? "" : "0");
        admindiscountprice =
            (double.parse(pro.buyPrice ?? "") - double.parse(adiscount));

        pref!.setString("mvid", pro.mv ?? "");
        _addToproducts(
            pro.productIs ?? "",
            pro.productName ?? "",
            pro.img!,
            int.parse(mrp_price),
            int.parse(pro.count ?? ""),
            color,
            size,
            pro.productDescription ?? "",
            gst_sgst,
            gst_cgst,
            pro.discount ?? "",
            dicountValue.toString(),
            pro.APMC ?? "",
            admindiscountprice.toString(),
            pro.buyPrice ?? "",
            pro.shipping ?? "",
            pro.quantityInStock ?? "",
            pro.youtube ?? "",
            pro.mv ?? "");

        setState(() {
//                                                                              cartvalue++;
//           Constant.carditemCount++;
//           cartItemcount(Constant.carditemCount);

          Navigator.of(context).pop();
          // _ProductList1Stateq.val=Constant.carditemCount++;
        });

        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductShow(widget.cat,widget.title)),);
      },
    );
    Widget continueButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Replace cart item?",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
          "Your cart contains dishes from different Restaurant. Do you want to discard the selection and add this" +
              pro.productName.toString()),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  final DbProductManager dbmanager = new DbProductManager();

  ProductsCart? products2;

//cost_price=buyprice
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
      String totalQun,
      String varient,
      String mv) {
    ProductsCart st = new ProductsCart(
        pid: pID,
        pname: p_name,
        pimage: image,
        pprice: (price * quantity).toString(),
        pQuantity: quantity,
        pcolor: c_val ?? "",
        psize: p_size ?? "",
        pdiscription: p_disc,
        sgst: sgst,
        cgst: cgst,
        discount: discount,
        discountValue: dis_val,
        adminper: adminper,
        adminpricevalue: adminper_val,
        costPrice: cost_price,
        shipping: shippingcharge,
        totalQuantity: totalQun,
        varient: varient,
        mv: int.parse(mv));
    dbmanager.getProductList1(pID).then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          if (usersFromServe.length > 0) {
            products2 = usersFromServe[0];
            st.quantity = (products2!.quantity! + st.quantity!);
            st.pprice =
                (double.parse(products2!.pprice!) + (totalmrp! * quantity))
                    .toString();

            // st.quantity++;
            if (st.quantity! <= int.parse(totalQun)) {
              dbmanager.updateStudent1(st).then((id) {
                showLongToast('Product added to your cart');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WishList(),
                  ),
                );
              });
            } else {
              showLongToast('Product added to your cart');
            }
          } else {
            dbmanager.insertStudent(st).then((id) => {
                  showLongToast("Product added to the cart"),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WishList(),
                    ),
                  ),
                  setState(() {
                    FoodAppConstant.foodAppCartItemCount++;
                    foodCartItemCount(FoodAppConstant.foodAppCartItemCount);
                  })
                });
          }
        });
      }
    });
  }

  String calDiscount(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = (byprice1 - (byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(FoodAppConstant.val);
    print(returnStr);
    return returnStr;
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _shairApp() {
    Share.share("Hi, Looking for best deals online? Download " +
        FoodAppConstant.appname +
        " app form click on this link  https://play.google.com/store/apps/details?id=com.huocart");
  }

  void _launchphone(String teli) async {
    final url = 'tel:' + teli;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
