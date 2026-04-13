import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebViewClassTeam extends StatefulWidget {
  final String title;
  final String url;

  WebViewClassTeam(this.title, this.url);
  @override
  _WebViewClassTeamState createState() => _WebViewClassTeamState();
}

class _WebViewClassTeamState extends State<WebViewClassTeam>
    with TickerProviderStateMixin {
  bool isLoading = true;
  bool isLoading2 = true;
  final GlobalKey webViewKey = GlobalKey();
  final GlobalKey webViewKey1 = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewController? webViewController2;

  TabController? _tabController;
  String? mobile;
  String? levelUser;
  bool _dataLoaded = false;
  String? _teamUrl;
  String? _prospectsUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    print("=== STARTING TO LOAD USER DATA ===");
    SharedPreferences pref = await SharedPreferences.getInstance();

    // Get all stored keys for debugging
    Set<String> keys = pref.getKeys();
    print("All SharedPreferences keys: $keys");

    String? userId = pref.getString("user_id");
    String? userMobile = pref.getString("mobile");
    String? userLevel = pref.getString("level");

    print("Raw userId from SharedPreferences: '$userId'");
    print("Raw mobile from SharedPreferences: '$userMobile'");
    print("Raw level from SharedPreferences: '$userLevel'");
    print(
        "Current GroceryAppConstant.user_id BEFORE: '${GroceryAppConstant.user_id}'");

    if (userId != null && userId.isNotEmpty && userId.trim().isNotEmpty) {
      setState(() {
        GroceryAppConstant.user_id = userId.trim();
      });
      print("✓ User ID set to: '${GroceryAppConstant.user_id}'");
    } else {
      print("❌ User ID is null, empty, or contains only whitespace: '$userId'");
      // Try to get from different key if main one fails
      String? altUserId =
          pref.getString("user_mobile") ?? pref.getString("mobile");
      if (altUserId != null && altUserId.isNotEmpty) {
        setState(() {
          GroceryAppConstant.user_id = altUserId;
        });
        print(
            "✓ Using mobile as fallback user ID: '${GroceryAppConstant.user_id}'");
      }
    }

    if (userMobile != null && userMobile.isNotEmpty) {
      setState(() {
        mobile = userMobile;
      });
    }

    if (userLevel != null && userLevel.isNotEmpty) {
      setState(() {
        levelUser = userLevel;
      });
    }

    print("Final User ID: '${GroceryAppConstant.user_id}'");
    print("Final Mobile: '$mobile'");
    print("Final Level: '$levelUser'");
    print("Is Login: ${GroceryAppConstant.isLogin}");

    // Only construct URLs if we have a valid user_id
    if (GroceryAppConstant.user_id.isNotEmpty) {
      _teamUrl =
          "${GroceryAppConstant.base_url}api/myTeam.php?ref=yes&user_id=${GroceryAppConstant.user_id}&level=${levelUser ?? '1'}";
      _prospectsUrl =
          "${GroceryAppConstant.base_url}api/myProspects.php?ref=${GroceryAppConstant.user_id}";

      print("✅ Team URL: $_teamUrl");
      print("✅ Prospects URL: $_prospectsUrl");

      setState(() {
        _dataLoaded = true;
      });
    } else {
      print("❌ Cannot construct URLs - user_id is still empty!");
      // Show error or redirect to login
    }

    print("=== USER DATA LOADING COMPLETED ===");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GroceryAppColors.tela,
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
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: "My Team",
              // icon: Icon(Icons.cloud_outlined),
            ),
            Tab(
              text: "My Prospects",
              // icon: Icon(Icons.beach_access_sharp),
            ),
          ],
        ),
      ),
      body: _dataLoaded
          ? TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: <Widget>[
                Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(
                        url: WebUri(_teamUrl!),
                      ),
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStop: (controller, url) {
                        print("🌐 Team page loaded: $_teamUrl");
                        print("🌐 Actual loaded URL: $url");
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Stack(),
                  ],
                ),
                Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey1,
                      initialUrlRequest: URLRequest(
                        url: WebUri(
                            "${GroceryAppConstant.base_url}api/myProspects?user_id=${GroceryAppConstant.user_id}"),
                      ),
                      onWebViewCreated: (controller) {
                        webViewController2 = controller;
                      },
                      onLoadStop: (controller, url) {
                        setState(() {
                          isLoading2 = false;
                        });
                      },
                    ),
                    isLoading2
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Stack(),
                  ],
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

/*
class WebViewState extends State<WebViewScreen>{

  String title,url;
  bool isLoading=true;
  final _key = UniqueKey();

  WebViewState(String title,String url){
    this.title=title;
    this.url=url;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: Text(this.title,style: TextStyle(fontWeight: FontWeight.w700)),centerTitle: true
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: this.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? Center( child: CircularProgressIndicator(),)
              : Stack(),
        ],
      ),
    );
  }

}*/
