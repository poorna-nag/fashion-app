import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:royalmart/grocery/BottomNavigation/wishlist.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/grocery/model/InvoiceModel.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';  // Temporarily disabled
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../screen/finalScreen.dart';
import '../../service_app/dbhelper/database_helper.dart';

class InstaMojoPaymentWebViewFood extends StatefulWidget {
  final String url;
  final String amount;
  final String email;
  final String name;
  final String mobile;
  final String invoice;
  final String username;
  final String finalamt;
  final String usedWalletamt;

  final String address;
  final String pincode;
  final String city;
  final String deliveryfee;
  final String coupancode;
  final String difference;
  final String onedayprice;
  final bool checkbox;
  final List<ProductsCart> prodctlist1;
  InstaMojoPaymentWebViewFood(
      {Key? key,
      required this.url,
      required this.amount,
      required this.email,
      required this.name,
      required this.mobile,
      required this.invoice,
      required this.address,
      required this.pincode,
      required this.city,
      required this.deliveryfee,
      required this.coupancode,
      required this.difference,
      required this.onedayprice,
      required this.prodctlist1,
      required this.username,
      required this.finalamt,
      required this.usedWalletamt,
      required this.checkbox})
      : super(key: key);

  @override
  State<InstaMojoPaymentWebViewFood> createState() =>
      _InstaMojoPaymentWebViewFoodState();
}

class _InstaMojoPaymentWebViewFoodState
    extends State<InstaMojoPaymentWebViewFood> {
  final GlobalKey webViewKey = GlobalKey();
  final DbProductManager dbmanager = new DbProductManager();
  // Simplified for compatibility - complex options removed
  WebViewController? webViewController;
  late bool result;
  String url = '';
  double progress = 0;
  final urlController = TextEditingController();
  bool isShowWebView = false;
  String userId = '';
  String shareLink = '';
  String? initiaUrl;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // Initialize WebViewController
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress / 100;
              isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            if (url.contains('payment-redirect') ||
                url.contains('redirect-url')) {
              _uploadProductsInstamojo();
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('success') ||
                request.url.contains('payment-redirect') ||
                request.url.contains('redirect-url')) {
              _uploadProductsInstamojo();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  // Connectivity connectivity = Connectivity();
  // ConnectivityResult connectivityResult = ConnectivityResult.none;

  @override
  Widget build(BuildContext context) {
    initiaUrl = widget.url +
        "?price=${widget.amount}&name=${widget.name}&phone=${widget.mobile}&invoice=${widget.invoice}&email=${widget.email}";
    log('initiaUrl   ' + initiaUrl.toString());

    // Load the URL when controller is ready
    if (webViewController != null) {
      webViewController!.loadRequest(Uri.parse(initiaUrl!));
    }

    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFF8F9FA),
          appBar: AppBar(
            automaticallyImplyLeading: false,
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
            elevation: 0,
            title: Text(
              "Payment",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Stack(children: [
            // WebView with modern implementation
            WebViewWidget(controller: webViewController!),
            // Progress indicator
            isLoading
                ? LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Color(0xFFFFE8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFE91E63),
                    ),
                  )
                : Container(),
          ]),
        ),

        /*floatingActionButton: isShowWebView
                ? FloatingActionButton(
                    onPressed: () => _launchUrl(whatsappUrl),
                    backgroundColor: AppColors.whatsappColor,
                    child: const Icon(
                      Icons.whatsapp,
                      size: 30,
                    ),
                  )
                : null,*/
      ),
    );
  }

  cancleandRefund(String val, BuildContext context) async {
    String link = GroceryAppConstant.base_url + "api/order_status.php";
    var map = new Map<String, dynamic>();
    map['user_id'] = widget.mobile;
    map['order_id'] = widget.invoice;
    map['status'] = val;
    map['note'] = 'Payment faild';
    map['api_id'] = GroceryAppConstant.Shop_id;
    final response = await http.post(Uri.parse(link), body: map);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(responseData.toString());
    }
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await webViewController?.canGoBack() ?? false) {
      webViewController?.goBack();
      return Future.value(false);
    } else {
      Navigator.pop(context);

      return Future.value(false);
    }
  }

  //-------------------------------------------------------------------------------///

//   Future _getInvoiceinstamojo(
//     String paymode,
//   ) async {
//     print('called data oredr first');
//     var map = Map<String, dynamic>();
//     map['name'] = widget.name;
//     map['mobile'] = widget.mobile;
//     map['email'] = widget.email;
//     map['address'] = widget.address;
//     map['pincode'] = widget.pincode;
//     map['city'] = widget.city;
//     map['invoice_total'] = widget.amount.toString();
//     map['notes'] = 'ghy';
//     map['shop_id'] = GroceryAppConstant.Shop_id.toString();
//     map['PayMode'] = paymode;
//     map['user_id'] = "user_id";
//     map['shipping'] = widget.deliveryfee;
//     map['mv'] = widget.prodctlist1[0].mv.toString();
//     map['lat'] = GroceryAppConstant.latitude.toString();
//     map['lng'] = GroceryAppConstant.longitude.toString();
//     map['coupon'] = widget.coupancode != null ? widget.coupancode : "";
//     map['couponAmount'] = widget.difference.toString();
//     map['fast_price'] =
//         widget.onedayprice != null ? widget.onedayprice.toString() : "0.0";
//     print('map-------->${map}');
//     final response = await http
//         .post(Uri.parse(GroceryAppConstant.base_url + 'api/order.php'), body: map);
//     print('called data oredr' + response.body);
//     if (response.statusCode == 200) {
// //      final jsonBody = json.decode(response.body);
//       Invoice1 user = Invoice1.fromJson(jsonDecode(response.body));
//       // print("123"+user.Invoice);
//       if (user.success.toString() == "true") {
//         print("12345" + user.Invoice.toString());
//         print('called data oredr' + user.Invoice.toString());

//         // _uploadProductsInstamojo(
//         //   user.Invoice ?? "",
//         //   paymode,
//         // );
//         setState(() {
//           invoiceid = user.Invoice;
//         });
//       } else {
//         showLongToast('Invoice is not generated');
//       }
//     } else
//       throw Exception("Unable to generate Employee Invoice");
// //    print("123  Unable to generate Employee Invoice");
//   }

  Future _uploadProductsInstamojo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    print('called data oredr secnd');
    print('called data oredr secnd      ' + GroceryAppConstant.email);

    final email = GroceryAppConstant.email.contains("@gmai.com") ||
            GroceryAppConstant.email.contains("@")
        ? GroceryAppConstant.email
        : 'shahiexpressofficial@gmail.com';

    print('called data email      ' + email);

    for (int i = 0; i < widget.prodctlist1.length; i++) {
      var map = Map<String, dynamic>();

      map['invoice_id'] = widget.invoice;
      map['product_id'] = widget.prodctlist1[i].pid;
      map['product_name'] = widget.prodctlist1[i].pname;
      map['quantity'] = widget.prodctlist1[i].pQuantity.toString();
      map['price'] = (double.parse(widget.prodctlist1[i].costPrice ?? "") *
              widget.prodctlist1[i].pQuantity!)
          .toString();
      map['user_per'] = widget.prodctlist1[i].discount;
      map['user_dis'] =
          (double.parse(widget.prodctlist1[i].discountValue ?? "") *
                  widget.prodctlist1[i].pQuantity!)
              .toStringAsFixed(2)
              .toString();
      map['admin_per'] = widget.prodctlist1[i].adminper;
      map['admin_dis'] = widget.prodctlist1[i].adminpricevalue;
      map['shop_id'] = GroceryAppConstant.Shop_id;
      map['cgst'] = widget.prodctlist1[i].cgst;
      map['sgst'] = widget.prodctlist1[i].sgst;
      map['variant'] = widget.prodctlist1[i].varient == null
          ? " "
          : WishlistState.prodctlist1![i].varient;
      map['color'] = widget.prodctlist1[i].pcolor == null ||
              widget.prodctlist1[i].pcolor!.isEmpty
          ? 'defaultcolor'
          : widget.prodctlist1[i].pcolor;
      map['size'] = widget.prodctlist1[i].psize == null ||
              widget.prodctlist1[i].psize!.isEmpty
          ? 'defaultSize'
          : widget.prodctlist1[i].psize;
      map['refid'] = "0";
      map['image'] = widget.prodctlist1[i].pimage;
      map['prime'] = "0";
      map['mv'] = widget.prodctlist1[i].mv.toString();
      final response = await http.post(
          Uri.parse(GroceryAppConstant.base_url + 'api/order.php'),
          body: map);
      print('called data oredr snd  ' + response.body);
      try {
        // print(response);
        if (response.statusCode == 200) {
//        final jsonBody = json.decode(response.body);
          ProductAdded1 user =
              ProductAdded1.fromJson(jsonDecode(response.body));

          setState(() {
            if (user.success.toString() == "true" &&
                i == (widget.prodctlist1.length - 1)) {
              dbmanager.deleteallProducts();
              GroceryAppConstant.itemcount = 0;
              GroceryAppConstant.carditemCount = 0;
              groceryCartItemCount(GroceryAppConstant.carditemCount);
              pre.setString("mvid", "");
              setState(() {
                webViewController?.goBack();
              });

              if (widget.checkbox) {
                // if (double.parse(widget.finalamt ?? "")! <=
                //     double.parse(widget.usedWalletamt ?? "")) {
                //   walletPurchase2(widget.finalamt.toString());
                // } else {
                walletPurchase2(widget.usedWalletamt.toString());
                //  }
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowInVoiceId(widget.invoice)),
              );
            } else {
              showLongToast(' Somting went wrong');
            }
          });
        }
      } catch (Exception) {
        // throw Exception("Unable to uplod product detail");
      }
      // }

      /*  else{
        setState(() {

          pmv=prodctlist1[i].mv;

          // print(' set state after if ${pmv}'+i.toString());
        });
          int p;
        for( p=0;p<i;p++){
          setState(() {
            prodctlist1.removeAt(0);
            print("list length"+prodctlist1.length.toString());

          });

        }

        if(p==i){

          _getInvoice1(paytype);
          break;


        }

      }*/
    }
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future walletPurchase2(String amount) async {
    String md5 = generateMd5(
      widget.username.toString() +
          widget.invoice.toString() +
          amount.toString(),
    );
    String link = GroceryAppConstant.base_url + "api/payFromWallet.php";
    var body = {
      "username": widget.username,
      "key": md5,
      "price": amount.toString(),
      "purpose": widget.invoice,
      "name": GroceryAppConstant.name,
      "phone": widget.username,
      "email": GroceryAppConstant.email,
    };
    print("walletPurchaseBody------->$body");
    final response = await http.post(Uri.parse(link), body: body);

    try {
      if (response.statusCode == 200) {
        print("response------->${response.body}");
        print("res---->${response.body}");
        showLongToast('Your order is successfull');
        // Navigator.of(context, rootNavigator: true).pop('dialog');

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => ShowInVoiceId(widget ?? "")),
        // );
      }
    } catch (Exception) {}
  }
}
