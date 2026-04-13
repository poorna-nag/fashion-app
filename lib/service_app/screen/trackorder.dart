import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyOrdertrack extends StatefulWidget {
  final String idvalue;
  MyOrdertrack(this.idvalue);

  @override
  _MyOrdertrackState createState() => _MyOrdertrackState();
}

class _MyOrdertrackState extends State<MyOrdertrack> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    
    // Initialize the controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading progress
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
          },
          onWebResourceError: (WebResourceError error) {
            // Handle error
          },
        ),
      )
      ..loadRequest(Uri.parse('https://shiprocket.co/tracking/${widget.idvalue}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[50],
        leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "My Order",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ],
      ),
    );
  }
}