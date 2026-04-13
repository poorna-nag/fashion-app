import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebViewClass extends StatefulWidget {
  final String url;
  final String? title;
  
  const WebViewClass({Key? key, required this.url, this.title})
      : super(key: key);
      
  @override
  _WebViewClassState createState() => _WebViewClassState();
}

class _WebViewClassState extends State<WebViewClass> {
  late SharedPreferences pref;
  final GlobalKey webViewKey = GlobalKey();

  WebViewController? webViewController;
  String url = '';
  double progress = 0;
  final urlController = TextEditingController();
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    url = widget.url;
    
    // Initialize WebViewController for webview_flutter 4.x
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              this.url = url;
              urlController.text = widget.url;
            });
          },
          onPageFinished: (url) {
            setState(() {
              this.url = url;
              urlController.text = this.url;
              isLoading = false;
            });
          },
          onProgress: (progress) {
            setState(() {
              this.progress = progress / 100;
              urlController.text = this.url;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FoodAppColors.tela,
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
        title: Center(
            child: Text(
          widget.title.toString(),
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: WebViewWidget(
                    controller: webViewController!,
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
          
        ],
      ),
      
    );
  }


}
