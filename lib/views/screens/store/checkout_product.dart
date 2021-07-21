import "package:flutter/material.dart";
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mbw204_club_ina/views/screens/dashboard/dashboard.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

class CheckoutProductScreen extends StatefulWidget {
  final String paymentChannel;
  final String paymentCode;
  final String paymentRefId;
  final String paymentGuide;
  final String paymentAdminFee;
  final String paymentStatus;
  final String refNo;
  final String billingUid;
  final double amount;

  CheckoutProductScreen({
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
  _CheckoutProductScreenState createState() => _CheckoutProductScreenState();
}

class _CheckoutProductScreenState extends State<CheckoutProductScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(hours: 12));
    controller.forward();
  }

  Future<bool> onWillPop(BuildContext context) async {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DashBoardScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
      
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.PRIMARY,
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          title: Text( "Checkout Pembayaran",
            style: poppinsRegular,
          ),
        ),
        body: Stack(
          children: [
          ListView(
            physics: BouncingScrollPhysics(), 
            children: [
            Column(
              children: [
              Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 5.0),
                child: Row(
                  children: [
                    SelectableText("ID Transaksi #",
                      style: poppinsRegular.copyWith(
                        fontSize: 16.0
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SelectableText(widget.refNo,
                            style: poppinsRegular.copyWith(
                              fontSize: 16.0,
                              color: Colors.green[900]
                            )
                          )
                        ],
                      )
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 5.0),
                child: Row(
                  children: [
                    SelectableText("Total Tagihan",
                      style: poppinsRegular.copyWith(
                        fontSize: 16.0
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SelectableText(ConnexistHelper.formatCurrency(widget.amount),
                            style: poppinsRegular.copyWith(
                              fontSize: 16.0
                            )
                          )
                        ],
                      )
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 5.0),
                child: Row(
                  children: [
                    SelectableText("Biaya Admin",
                      style: poppinsRegular.copyWith(fontSize: 16.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        SelectableText(ConnexistHelper.formatCurrency(double.parse(widget.paymentAdminFee)),
                          style: poppinsRegular.copyWith(fontSize: 16.0)
                        )
                      ],
                    )),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                child: Row(
                  children: [
                    SelectableText("Total Pembayaran",
                      style: poppinsRegular.copyWith(
                        fontWeight: FontWeight.bold, 
                        fontSize: 16.0
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SelectableText(ConnexistHelper.formatCurrency(widget.amount + double.parse(widget.paymentAdminFee)),
                            style: poppinsRegular.copyWith(
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
            ]),
            Container(
              child: viewOtomatis()
            ),
          ]),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70.0,
              width: double.infinity,
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SizedBox(
                height: 55.0,
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: ColorResources.PRIMARY,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )
                  ),
                  child: Center(
                    child: SelectableText("Selesaikan Pembayaran",
                      style: poppinsRegular.copyWith(
                        fontSize: 16.0, 
                        color: Colors.white
                      )
                    ),
                  ),
                  onPressed: () =>  Navigator.pushNamed(context, "/")
                ),
              )
            )
          )
        ]
      ),
    ),
  );
}

  Widget viewOtomatis() {
    Map<String, dynamic> basket = Provider.of<Map<String, dynamic>>(context, listen: false);
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 80.0),
      child: Column(
        children: [
          // FutureBuilder<TransactionWarungPaidSingleModel>(
          //   future: Provider.of<WarungProvider>(context, listen: false).getTransactionPaidSingle(context, widget.refNo, 'buyer'),
          //   builder: (BuildContext context, AsyncSnapshot<TransactionWarungPaidSingleModel> snapshot) {
          //     if(snapshot.connectionState == ConnectionState.waiting) {
          //       return Text('...',
          //         style: poppinsRegular,
          //       );
          //     }
          //     TransactionWarungPaidSingleModel transactionUnpaid = snapshot.data;
          //     return InkWell(
          //       onTap: () {
                  
          //       },
          //       child: Text("Lihat Detail",
          //         style: poppinsRegular.copyWith(
          //           color: ColorResources.PRIMARY,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 15.0,
          //         )
          //       ),
          //     );
          //   }
          // ),
          Container(
            margin: EdgeInsets.only(bottom: 5.0, top: 25.0, left: 10.0, right: 10.0),
            child: SelectableText("Transfer ke Nomor " + basket["nama_bank"],
              textAlign: TextAlign.center,
              style: poppinsRegular.copyWith(
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
              style: poppinsRegular.copyWith(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                  height: 50.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      elevation: 3.0,
                      backgroundColor: ColorResources.YELLOW,
                    ),
                    onPressed: () async { 
                      try {
                        await launch("${AppConstants.BASE_URL_HELP_PAYMENT}/${widget.paymentChannel}");
                      } catch(e) {
                        print(e);
                      }
                    },
                    child: Text("Cara Pembayaran",
                      style: poppinsRegular.copyWith(
                        color: ColorResources.BLACK
                      )
                    ),
                  ), 
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                  height: 50.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      elevation: 3.0,
                      backgroundColor: ColorResources.YELLOW,
                    ),
                    onPressed: () async { 
                      try {
                        await launch("${AppConstants.BASE_URL_PAYMENT_BILLING}/${widget.refNo}");
                      } catch(e) {
                        print(e);
                      }
                    },
                    child: Text("Lihat Tagihan",
                      style: poppinsRegular.copyWith(
                        color: ColorResources.BLACK
                      )
                    ),
                  ), 
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 12.0, bottom: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Petunjuk Pembayaran",
                  style: poppinsRegular.copyWith(
                    color: ColorResources.BLACK
                  ),
                ),
                ListTile(
                  title: Html(data: "${widget.paymentGuide}"),
                ),
              ],
            )    
          )
        ],
      ),
    );
  }
}