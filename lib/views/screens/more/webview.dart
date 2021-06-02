import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/views/basewidget/square_loader.dart';

class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;
  WebViewScreen({@required this.url, @required this.title});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final Completer<WebViewController> controller = Completer<WebViewController>();
  WebViewController controllerGlobal;
  bool isLoading = true;

  launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitApp,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [

              CustomAppBar(title: widget.title),

              Expanded(
                child: Stack(
                  children: [
                    WebView(
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: widget.url,
                      userAgent: AppConstants.MOBILE_UA,
                      gestureNavigationEnabled: true,
                      onWebViewCreated: (WebViewController webViewController) {
                        controller.future.then((value) => controllerGlobal = value);
                        controller.complete(webViewController);
                      },
                      navigationDelegate: (NavigationRequest request) {             
                        if (request.url.contains('tel:')) {
                          launchURL(request.url);
                          return NavigationDecision.prevent;
                        } else if(request.url.contains('whatsapp:')) {
                          launchURL(request.url);
                          return NavigationDecision.prevent; 
                        } else if(request.url.contains('mailto:')) {
                          launchURL(request.url);
                        }
                        return NavigationDecision.navigate;
                      },
                      onPageStarted: (String url) async {
                        setState(() => isLoading = true);
                      },
                      onPageFinished: (String url) {
                        setState(() => isLoading = false);
                      },
                    ),
                    isLoading ? Center(
                      child: SquareLoader(
                        color: ColorResources.getPrimaryToBlack(context)
                      ),
                    ) : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> exitApp() async {
    if(controllerGlobal != null) {
      if (await controllerGlobal.canGoBack()) {
        controllerGlobal.goBack();
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    } else {
      return Future.value(true);
    }
  }
}
