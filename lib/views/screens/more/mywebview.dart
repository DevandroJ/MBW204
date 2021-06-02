import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/basewidget/square_loader.dart';

class MyWebview extends StatefulWidget {
  MyWebview(
      {Key key, this.onUrlChanged, this.onStateChanged, this.url, this.title})
      : super(key: key);

  final ValueChanged<String> onUrlChanged;
  final String url;
  final String title;
  final ValueChanged<WebViewStateChanged> onStateChanged;
  final FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  _MyWebviewState createState() => _MyWebviewState();
}

class _MyWebviewState extends State<MyWebview> {
  
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

    widget.flutterWebviewPlugin.onUrlChanged.listen((String url) {
       if (url.contains("mailto:")) {
        widget.flutterWebviewPlugin.stopLoading();
        launchURL(url);
        return NavigationDecision.prevent;
      } else if (url.contains("tel:")) {
        widget.flutterWebviewPlugin.stopLoading();
        launchURL(url);
        return NavigationDecision.prevent;
      } else if (url.contains("whatsapp:")) {
        widget.flutterWebviewPlugin.stopLoading();
        launchURL(url);
        return NavigationDecision.prevent;
      }
      return NavigationDecision.navigate;
    });

    widget.flutterWebviewPlugin.onStateChanged.listen((event) {
      widget.onStateChanged(event);
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.flutterWebviewPlugin.close();
    widget.flutterWebviewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      invalidUrlRegex: '/((mailto:\w+)|(tel:\w+)|(whatsapp:\w+))/g',
      withZoom: true,
      hidden: true,
      primary: true,
      resizeToAvoidBottomInset: true,
      initialChild: Center(
        child: SquareLoader(
          color: ColorResources.PRIMARY
        ),
      ),
      withLocalStorage: true,
      appCacheEnabled: true,
      supportMultipleWindows: true,
      withJavascript: true,
      clearCache: true,
      clearCookies: true,
      userAgent: AppConstants.MOBILE_UA
    );
  }
}
