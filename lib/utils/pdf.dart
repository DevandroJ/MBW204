import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/loader.dart';

class PDFScreen extends StatefulWidget {
  final String path;
  final String title;

  PDFScreen({
    Key key, 
    this.path,
    this.title  
  }) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int page = 0;
  int total = 0;
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.BTN_PRIMARY,
        title: Text(widget.title,
          style: poppinsRegular,
        ),
      ),
      body: Stack(
        children: [
        PDFView(
          filePath: widget.path,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          fitEachPage: true,
          pageFling: true,
          pageSnap: true,
          defaultPage: currentPage,
          fitPolicy: FitPolicy.BOTH,
          preventLinkNavigation: false, // if set to true the link is handled in flutter
          onRender: (_pages) {
            setState(() {
              pages = _pages;
              isReady = true;
            });
          },
          onError: (error) {
            setState(() {
              errorMessage = error.toString();
            });
          },
          onPageError: (page, error) {
            setState(() {
              errorMessage = '$page: ${error.toString()}';
            });
            print('$page: ${error.toString()}');
          },
          onViewCreated: (PDFViewController pdfViewController) {
            _controller.complete(pdfViewController);
          },
          onLinkHandler: (String uri) {
            print('goto uri: $uri');
          },
          onPageChanged: (int _page, int _total) {
            setState(() {
              page = _page + 1; 
              total = _total;
              currentPage = _page;
            });
          },
        ),
        errorMessage.isEmpty
        ? !isReady
          ? Center(
              child: Loader(
                color: ColorResources.BTN_PRIMARY,
              ),
            )
          : Container()
        : Center(
            child: Text(errorMessage),
          ),
          // Container(
          //   margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
          //   child: Align(
          //     alignment: Alignment.topCenter,
          //     child: Text("$page / $total",
          //       style: poppinsRegular.copyWith(
          //         fontSize: 16.0
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
      // floatingActionButton: FutureBuilder<PDFViewController>(
      //   future: _controller.future,
      //   builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
      //     if (snapshot.hasData) {
      //       return FloatingActionButton.extended(
      //         label: Text("Go to ${pages ~/ 2}"),
      //         onPressed: () async {
      //           await snapshot.data.setPage(pages ~/ 2);
      //         },
      //       );
      //     }
      //     return Container();
      //   },
      // ),
    );
  }
}