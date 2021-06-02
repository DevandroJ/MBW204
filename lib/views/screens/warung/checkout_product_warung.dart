import 'package:flushbar/flushbar.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_expansion_tile.dart' as custom;
import 'package:mbw204_club_ina/views/screens/warung/warung_index.dart';

class CheckoutProductWarungPage extends StatefulWidget {
  final String paymentChannel;
  final String paymentCode;
  final String paymentRefId;
  final String paymentGuide;
  final String paymentAdminFee;
  final String paymentStatus;
  final String refNo;
  final String billingUid;
  final double amount;

  CheckoutProductWarungPage({
    Key key,
    @required this.paymentChannel,
    @required this.paymentCode,
    @required this.paymentRefId,
    @required this.paymentGuide,
    @required this.paymentAdminFee,
    @required this.paymentStatus,
    @required this.refNo,
    @required this.billingUid,
    @required this.amount,
  }) : super(key: key);
  @override
  _CheckoutProductWarungPageState createState() => _CheckoutProductWarungPageState();
}

class _CheckoutProductWarungPageState extends State<CheckoutProductWarungPage> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(hours: 12));
    controller.forward();
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return JualBeliPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
      
    return WillPopScope(
      onWillPop: () {
        return _onWillPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.WHITE,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 20.0,
              color: ColorResources.GREY,
            ),
            onPressed: () => Navigator.of(context).pop()
          ),
          centerTitle: true,
          elevation: 0,
          title: Text( "Pilih Pembayaran"),
        ),
        body: Stack(
          children: [
          ListView(
            physics: BouncingScrollPhysics(), 
            children: [
            Column(
              children: [
              Container(
                padding: EdgeInsets.only(left: 16.0, right: 45.0, top: 16.0, bottom: 16.0),
                child: Row(
                  children: [
                    Text("Total Tagihan",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(ConnexistHelper.formatCurrency(widget.amount),
                            style: TextStyle(fontSize: 16.0)
                          )
                        ],
                      )
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16.0, right: 45.0, bottom: 16.0),
                child: Row(
                  children: [
                    Text("Biaya Admin",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text(ConnexistHelper.formatCurrency(double.parse(widget.paymentAdminFee)),
                          style: TextStyle(fontSize: 16.0)
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
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                child: Row(
                  children: [
                    Text("Total Pembayaran",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(ConnexistHelper.formatCurrency(widget.amount + double.parse(widget.paymentAdminFee)),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)
                          )
                        ],
                      )
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: (widget.amount + double.parse(widget.paymentAdminFee)).toString())).then((result) {
                          showFloatingFlushbar(context);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        child: Image.asset(
                          "assets/copy.png",
                          width: 20,
                          height: 20,
                          color: Colors.grey,
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            Container(
              child: _viewOtomatis()
            ),
          ]),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70.0,
              width: double.infinity,
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SizedBox(
                height: 55.0,
                width: double.infinity,
                child: RaisedButton(
                  color: ColorResources.PRIMARY,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text("Selesaikan Pembayaran",
                      style: TextStyle(
                        fontSize: 16.0, 
                        color: Colors.white
                      )
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/");
                  }
                ),
              )
            )
          )
        ]
      ),
    ),
  );
}

  void showFloatingFlushbar(BuildContext context) {
    Flushbar(
      margin: EdgeInsets.all(10.0),
      borderRadius: 8,
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      message: 'Tersalin',
      duration: Duration(seconds: 2),
    )..show(context);
  }

  Widget _viewOtomatis() {
    Map<String, dynamic> _basket = Provider.of<Map<String, dynamic>>(context, listen: false);
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 80.0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5.0, top: 25.0, left: 10.0, right: 10.0),
            child: Text("Transfer ke Nomor " + _basket["nama_bank"] + " berikut ini :",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Proppins",
                fontSize: 16.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              )
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: Text(
              widget.paymentCode,
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
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
                side: BorderSide(width: 1, color: ColorResources.PRIMARY)
              ),
              child: InkWell(
                child: Center(
                  child: Text('SALIN',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: ColorResources.PRIMARY,
                    ),
                  ),
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.paymentCode)).then((result) {
                    showFloatingFlushbar(context);
                  });
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5.0, left: 16.0, right: 16.0),
            child: Text(widget.paymentGuide,
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
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              )
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: Countdown(
              animation: StepTween(
                begin: 7200,
                end: 0,
              ).animate(controller),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: custom.ExpansionTile(
              headerBackgroundColor: ColorResources.PRIMARY,
              iconColor: Colors.white,
              initiallyExpanded: true,
              title: Text("Petunjuk Pembayaran",
                style: TextStyle(color: Colors.white),
              ),
              children: <Widget>[
                ListTile(
                  title: Html(data: "${_basket["guide"]}"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText = '${clockTimer.inHours.remainder(24).toString()} jam ${clockTimer.inMinutes.remainder(60).toString()} menit ${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')} detik';

    return Text("$timerText",
      style: TextStyle(
        fontSize: 25.0,
        color: ColorResources.PRIMARY
      ),
    );
  }
}
