import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';

class WebViewClass extends StatefulWidget {
  final String title;
  String url;

  WebViewClass(this.title, this.url);
  @override
  _WebViewClassState createState() => _WebViewClassState();
}

class _WebViewClassState extends State<WebViewClass> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  late ContextMenu contextMenu;
  double progress = 0;
  final urlController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    
    // Initialize pull to refresh controller
    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (webViewController != null) {
          await webViewController!.reload();
        }
      },
    );

    // Initialize context menu
    contextMenu = ContextMenu(
      menuItems: [
        ContextMenuItem(
          id: 1,
          title: "Reload",
          action: () async {
            await webViewController?.reload();
          },
        ),
        ContextMenuItem(
          id: 2,
          title: "Go Back",
          action: () async {
            if (await webViewController?.canGoBack() ?? false) {
              await webViewController?.goBack();
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GroceryAppColors.tela,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: InkWell(
            onTap: () async {
              // Check if WebView can go back
              if (webViewController != null && await webViewController!.canGoBack()) {
                await webViewController!.goBack();
              } else {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              }
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              switch (value) {
                case 'refresh':
                  await webViewController?.reload();
                  break;
                case 'back':
                  if (await webViewController?.canGoBack() ?? false) {
                    await webViewController?.goBack();
                  }
                  break;
                case 'forward':
                  if (await webViewController?.canGoForward() ?? false) {
                    await webViewController?.goForward();
                  }
                  break;
                case 'home':
                  await webViewController?.loadUrl(
                    urlRequest: URLRequest(
                      url: WebUri(widget.url.isNotEmpty ? widget.url : GroceryAppConstant.base_url + 'term-condition.php')
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: GroceryAppColors.tela),
                    SizedBox(width: 8),
                    Text('Refresh'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'back',
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: GroceryAppColors.tela),
                    SizedBox(width: 8),
                    Text('Back'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'forward',
                child: Row(
                  children: [
                    Icon(Icons.arrow_forward, color: GroceryAppColors.tela),
                    SizedBox(width: 8),
                    Text('Forward'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'home',
                child: Row(
                  children: [
                    Icon(Icons.home, color: GroceryAppColors.tela),
                    SizedBox(width: 8),
                    Text('Home'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (webViewController != null && await webViewController!.canGoBack()) {
            await webViewController!.goBack();
            return false;
          }
          return true;
        },
        child: Column(
          children: [
            // Progress indicator
            if (progress < 1.0)
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(GroceryAppColors.tela),
              ),
            // Main WebView content
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(
                      url: WebUri(widget.url.isNotEmpty ? widget.url : GroceryAppConstant.base_url + 'term-condition.php')
                    ),
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      domStorageEnabled: true,
                      databaseEnabled: true,
                      clearCache: false,
                      cacheEnabled: true,
                      supportZoom: true,
                      builtInZoomControls: false,
                      displayZoomControls: false,
                      useWideViewPort: true,
                      loadWithOverviewMode: true,
                      allowFileAccess: true,
                      allowContentAccess: true,
                      allowFileAccessFromFileURLs: true,
                      allowUniversalAccessFromFileURLs: true,
                      verticalScrollBarEnabled: true,
                      horizontalScrollBarEnabled: true,
                      useShouldOverrideUrlLoading: true,
                      useOnLoadResource: true,
                      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                    ),
                    contextMenu: contextMenu,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) async {
                      webViewController = controller;
                      print('WebView created successfully');
                    },
                    onLoadStart: (controller, url) async {
                      setState(() {
                        isLoading = true;
                        if (url != null) {
                          widget.url = url.toString();
                          urlController.text = widget.url;
                        }
                      });
                      print('Started loading: $url');
                    },
                    onLoadStop: (controller, url) async {
                      setState(() {
                        isLoading = false;
                        if (url != null) {
                          widget.url = url.toString();
                          urlController.text = widget.url;
                        }
                      });
                      print('Finished loading: $url');
                    },
                    onLoadError: (controller, url, code, message) {
                      setState(() {
                        isLoading = false;
                      });
                      print('Load error: $code - $message');
                      
                      // Show error snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to load content: $message'),
                          backgroundColor: Colors.red,
                          action: SnackBarAction(
                            label: 'Retry',
                            textColor: Colors.white,
                            onPressed: () async {
                              await controller.reload();
                            },
                          ),
                        ),
                      );
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, isReload) {
                      setState(() {
                        if (url != null) {
                          widget.url = url.toString();
                          urlController.text = widget.url;
                        }
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print('Console: ${consoleMessage.message}');
                    },
                    onReceivedServerTrustAuthRequest: (controller, challenge) async {
                      // Handle SSL certificate issues
                      return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                    },
                  ),
                  // Loading overlay
                  if (isLoading)
                    Container(
                      color: Colors.white.withOpacity(0.8),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(GroceryAppColors.tela),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Loading...',
                              style: TextStyle(
                                fontSize: 16,
                                color: GroceryAppColors.darkGray,
                                fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
