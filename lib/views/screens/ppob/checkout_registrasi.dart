import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:mbw204_club_ina/views/screens/auth/sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

class CheckoutRegistrasiScreen extends StatefulWidget {
  final double productPrice;
  final double adminFee;
  final String transactionId;
  final String nameBank;
  final String paymentChannel;
  final String noVa;
  final String guide;

  CheckoutRegistrasiScreen({
    this.productPrice,
    this.adminFee,
    this.transactionId,
    this.nameBank,
    this.paymentChannel,
    this.noVa,
    this.guide
  });

  @override
  _CheckoutRegistrasiScreenState createState() => _CheckoutRegistrasiScreenState();
}

class _CheckoutRegistrasiScreenState extends State<CheckoutRegistrasiScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int beginCount = 30;
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

  Future<bool> onWillPop() {
    Navigator.pop(context);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    nominal = double.parse(widget.productPrice.toString());
    biayaAdmin = double.parse(widget.adminFee.toString());
    
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Container(
            decoration: BoxDecoration(
              color: ColorResources.BLACK
            ),
            child: ListView(
              children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      width: 180.0,
                      height: 120.0,
                      margin: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Image.asset("assets/images/logo.png"),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: SelectableText("Checkout Registrasi",
                        style: titilliumRegular.copyWith(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: ColorResources.WHITE,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
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
                                      left: 16.0,
                                      right: 16.0,
                                      top: 16.0,
                                    ),
                                    child: Row(
                                      children: [
                                        SelectableText("Transaksi",
                                          style: titilliumRegular.copyWith(
                                            fontSize: 16.0
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SelectableText("# ${widget.transactionId}",
                                              style: titilliumRegular.copyWith(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold
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
                                      right: 16.0,
                                      top: 10.0,
                                      bottom: 10.0
                                    ),
                                    child: Row(
                                      children: [
                                        SelectableText("Pembayaran Registrasi",
                                          style: titilliumRegular.copyWith(
                                            fontSize: 16.0
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SelectableText(ConnexistHelper.formatCurrency(nominal),
                                              style: titilliumRegular.copyWith(
                                                fontSize: 16.0
                                              )
                                            )
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
                                    child: Row(
                                      children: [
                                        SelectableText("Biaya Admin",
                                          style: titilliumRegular.copyWith(
                                            fontSize: 16.0
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SelectableText(ConnexistHelper.formatCurrency(biayaAdmin),
                                              style: titilliumRegular.copyWith(
                                                fontSize: 16.0
                                              )
                                            )
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                                    child: Divider(
                                      thickness: 2.0,
                                    )
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      bottom: 16.0,
                                      top: 16.0
                                    ),
                                    child: Row(
                                      children: [
                                        SelectableText("Total Pembayaran",
                                          style: titilliumRegular.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SelectableText(ConnexistHelper.formatCurrency(nominal + biayaAdmin),
                                                style: titilliumRegular.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0
                                                )
                                              )
                                            ],
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                  viewAutomate()
                                ],
                              )
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 25.0, left: 16.0, right: 16.0, top: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 5.0),
                                height: 50.0,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    elevation: 0.0,
                                    backgroundColor: ColorResources.BTN_PRIMARY_SECOND
                                  ),
                                  onPressed: () {
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => SignInScreen()),
                                    );
                                  },
                                  child: Text("Kembali",
                                    style: titilliumRegular.copyWith(
                                      color: ColorResources.WHITE,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 5.0),
                                height: 50.0,
                                child: TextButton(
                                style: TextButton.styleFrom(
                                  elevation: 0.0,
                                  backgroundColor: ColorResources.BTN_PRIMARY_SECOND,
                                ),
                                onPressed: () { 
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                                },
                                child: Text("OK",
                                  style: titilliumRegular.copyWith(
                                    color: ColorResources.WHITE,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
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
          child: SelectableText(
            "Transfer ke Nomor " + widget.nameBank + " berikut ini :",
            textAlign: TextAlign.center,
            style: titilliumRegular.copyWith(
              fontSize: 18.0,
              color: ColorResources.BLACK,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5.0),
          child: SelectableText("${widget.noVa}",
            style: titilliumRegular.copyWith(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          children: [
            Flexible(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                height: 50.0,
                child: TextButton(
                  style: TextButton.styleFrom(
                    elevation: 0.0,
                    side: BorderSide(
                      color: Colors.black,
                      width: 1.0
                    ),
                    backgroundColor: Colors.transparent
                  ),
                  onPressed: () async { 
                    try {
                      await launch("${AppConstants.BASE_URL_HELP_PAYMENT}/${widget.paymentChannel}");
                    } catch(e) {
                      print(e);
                    }
                  },
                  child: Text("Cara Pembayaran",
                    style: titilliumRegular.copyWith(
                      color: ColorResources.BLACK
                    )
                  ),
                ), 
              ),
            ),            
            Flexible(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                height: 50.0,
                child: TextButton(
                  style: TextButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    side: BorderSide(
                      color: Colors.black,
                      width: 1.0
                    )
                  ),
                  onPressed: () async { 
                    try {
                      await launch("${AppConstants.BASE_URL_PAYMENT_BILLING}/${widget.transactionId}");
                    } catch(e) {
                      print(e);
                    }
                  },
                  child: Text("Lihat Tagihan",
                    style: titilliumRegular.copyWith(
                      color: ColorResources.BLACK
                    )
                  ),
                ), 
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: Column(
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
          ) 
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
