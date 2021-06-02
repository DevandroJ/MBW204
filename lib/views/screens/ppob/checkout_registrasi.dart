import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_expansion_tile.dart' as custom;
import 'package:mbw204_club_ina/views/screens/auth/auth.dart';

class CheckoutRegistrasiScreen extends StatefulWidget {
  final double productPrice;
  final double adminFee;
  final String transactionId;
  final String nameBank;
  final String noVa;
  final String guide;

  CheckoutRegistrasiScreen({
    this.productPrice,
    this.adminFee,
    this.transactionId,
    this.nameBank,
    this.noVa,
    this.guide
  });

  @override
  _CheckoutRegistrasiScreenState createState() => _CheckoutRegistrasiScreenState();
}

class _CheckoutRegistrasiScreenState extends State<CheckoutRegistrasiScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;

  final formKey = GlobalKey<FormState>();
  final int beginCount = 30;
  bool isAwaiting = false;
  bool isHidePassword = true;
  double nominal;
  double biayaAdmin;

  @override 
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(hours: 12));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    nominal = double.parse(widget.productPrice.toString());
    biayaAdmin = double.parse(widget.adminFee.toString());
    
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Container(
            decoration: BoxDecoration(
              color: ColorResources.PRIMARY
            ),
            child: ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        width: 208.0,
                        height: 238.0,
                        margin: EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
                        child: Image.asset(
                          "assets/images/logo.png",
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          "Checkout Registrasi",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.WHITE,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 10),
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(4.0)
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        right: 45.0,
                                        top: 16.0,
                                        bottom: 16.0
                                      ),
                                      child: Row(
                                        children: [
                                          Text("Nomor Transaksi",
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          SizedBox(width: 15.0),
                                          Expanded(
                                            child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(widget.transactionId,
                                                style: TextStyle(
                                                  fontSize: 16.0
                                                )
                                              )
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        right: 45.0,
                                        top: 16.0,
                                        bottom: 16.0
                                      ),
                                      child: Row(
                                        children: [
                                          Text("Pembayaran Registrasi",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Expanded(
                                            child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(ConnexistHelper.formatCurrency(nominal),
                                                style: TextStyle(
                                                  fontSize: 16.0
                                                )
                                              )
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 16.0,
                                          right: 45.0,
                                          bottom: 16.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "Biaya Admin",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                  ConnexistHelper
                                                      .formatCurrency(
                                                          biayaAdmin),
                                                  style:
                                                      TextStyle(fontSize: 16))
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 16.0, right: 16.0),
                                        child: Divider(
                                          thickness: 2.0,
                                        )),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 16.0,
                                          right: 16.0,
                                          bottom: 16.0,
                                          top: 16.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "Total Pembayaran",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                  ConnexistHelper
                                                      .formatCurrency(nominal +
                                                          biayaAdmin),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16))
                                            ],
                                          )),
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(
                                                ClipboardData(text: (nominal + biayaAdmin).toString())).then((result) {
                                                showFloatingFlushbar(context);
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(left: 8.0),
                                              child: Image.asset(
                                                "assets/icons/ic-copy.png",
                                                width: 20,
                                                height: 20,
                                                color: ColorResources.GREY,
                                              )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    viewAutomate()
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 25.0, left: 16, right: 16, top: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 5),
                                height: 50.0,
                                child: RaisedButton(
                                  elevation: 3.0,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AuthScreen()),
                                    );
                                  },
                                  color: ColorResources.WHITE,
                                  textColor: ColorResources.PRIMARY,
                                  child: Text("Kembali"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 5.0),
                                height: 50.0,
                                child: RaisedButton(
                                elevation: 3.0,
                                onPressed: () { 
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen(initialPage: 0)));
                                  Provider.of<AuthProvider>(context, listen: false).updateSelectedIndex(0);
                                },
                                color: ColorResources.WHITE,
                                textColor: ColorResources.PRIMARY,
                                child: Text("OK"),
                              ),
                                
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget viewAutomate() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Text(
            "Transfer ke Nomor " + widget.nameBank + " berikut ini :",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Proppins",
              fontSize: 16.0,
              color: ColorResources.BLACK,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5.0),
          child: Text("${widget.noVa}",
            style: TextStyle(
              fontFamily: "Proppins",
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10.0),
          width: 90,
          height: 40,
          child: Card(
            color: ColorResources.PRIMARY,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
              side: BorderSide(
                width: 1.0, 
                color: ColorResources.PRIMARY
              )
            ),
            child: InkWell(
              child: Center(
                child: Text(
                  'SALIN',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: ColorResources.WHITE,
                  ),
                ),
              ),
              onTap: () {
                Clipboard.setData(ClipboardData(text: "${widget.noVa}")).then((result) {
                  showFloatingFlushbar(context);
                });
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5.0, left: 16, right: 16),
          child: Text(
            "Silahkan lakukan pembayaran untuk menyelesaikan proses registrasi anda,password akan dikirim setelah pembayaran diselesaikan.",
            style: TextStyle(
              fontFamily: "Proppins",
              fontSize: 15.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
          Container(
            margin: EdgeInsets.only(bottom: 5.0, top: 5.0),
            child: Text("Batas Pembayaran",
            style: TextStyle(
              fontFamily: "Proppins",
              fontSize: 16.0,
              color: ColorResources.BLACK,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10.0),
          child: Countdown(
            animation: StepTween(
              begin: 7200,
              end: 0,
            ).animate(controller),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 16, left: 10.0, right: 10.0),
          child: custom.ExpansionTile(
            headerBackgroundColor: ColorResources.PRIMARY,
            iconColor: ColorResources.WHITE,
            initiallyExpanded: true,
            title: Text("Petunjuk Pembayaran",
              style: TextStyle(
                color: ColorResources.WHITE
              ),
            ),
            children: [
              ListTile(
                dense: true,
                title: Html(
                  data: "${widget.guide}",
                  style: {
                    "b": Style(fontSize: FontSize.large),
                    "li": Style(fontSize: FontSize.large)
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void showFloatingFlushbar(BuildContext context) {
    Flushbar(
      margin: EdgeInsets.all(10.0),
      borderRadius: 8.0,
      backgroundColor: ColorResources.DIM_GRAY,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      message: 'Copied to Clipboard',
      duration: Duration(seconds: 2),
    )..show(context);
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);
    String timerText = '${clockTimer.inHours.remainder(24).toString()} jam ${clockTimer.inMinutes.remainder(60).toString()} menit ${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')} detik';
    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 25.0,
        color: ColorResources.PRIMARY,
      ),
    );
  }
}
