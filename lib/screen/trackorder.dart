import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyOrdertrack extends StatefulWidget {
  String idvalue;
  MyOrdertrack(this.idvalue);

  @override
  State<MyOrdertrack> createState() => _MyOrdertrackState();
}

class _MyOrdertrackState extends State<MyOrdertrack> {
  WebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();
  double progress = 0;
  final urlController = TextEditingController();
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  String? trackingUrl;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    // Construct dynamic tracking URL
    trackingUrl = widget.idvalue.isNotEmpty 
        ? 'https://shiprocket.co/tracking/${widget.idvalue}'
        : 'https://shiprocket.co/tracking/';
    
    print('Tracking URL: $trackingUrl');
    
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress / 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              hasError = false;
            });
            print('Started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            print('Finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
              hasError = true;
              errorMessage = error.description;
            });
            print('WebView error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            print('Navigation to: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      );
    
    // Load the dynamic URL
    if (trackingUrl != null) {
      webViewController!.loadRequest(Uri.parse(trackingUrl!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[50],
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        title: Text(
          "Track Order: ${widget.idvalue}",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          if (webViewController != null)
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.black),
              onPressed: () {
                webViewController!.reload();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          if (isLoading)
            LinearProgressIndicator(
              value: progress > 0 ? progress : null,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
          // Main content
          Expanded(
            child: Stack(
              children: [
                if (hasError)
                  _buildErrorWidget()
                else if (webViewController != null)
                  WebViewWidget(controller: webViewController!)
                else
                  _buildLoadingWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
          SizedBox(height: 16),
          Text(
            'Loading tracking information...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Order ID: ${widget.idvalue}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            SizedBox(height: 20),
            Text(
              'Unable to load tracking information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              errorMessage.isNotEmpty ? errorMessage : 'Please check your internet connection',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Order ID: ${widget.idvalue}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  hasError = false;
                  isLoading = true;
                });
                _initializeWebView();
              },
              icon: Icon(Icons.refresh, color: Colors.white),
              label: Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    webViewController = null;
    super.dispose();
  }
}