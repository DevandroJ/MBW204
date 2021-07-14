import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/data/models/warung/bank_payment_store.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/store/checkout_product.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_expansion_tile.dart' as custom;

class SelectPaymentScreen extends StatefulWidget {
  @override
  _SelectPaymentScreenState createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen> {
  ProgressDialog pr;

  String id;
  var bankController;
  // bool load = false;

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // AndroidInitializationSettings androidInitializationSettings;
  // IOSInitializationSettings iosInitializationSettings;
  // InitializationSettings initializationSettings;

  @override
  void initState() {
    super.initState();
    // initializing();
  }

  // void initializing() async {
  //   androidInitializationSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
  //   iosInitializationSettings = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  //   initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
  //   await flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     onSelectNotification: (payload) async {
  //       onSelectNotification(payload);
  //     },
  //   );
  // }

  // void showNotificationsAfterSecond(String noVA, String idTrx) async {
  //   await notificationAfterSec(noVA, idTrx);
  // }

  // Future<void> notificationAfterSec(String noVA, String idTrx) async {
  //   Map<String, dynamic> basket =
  //       Provider.of<Map<String, dynamic>>(context, listen: false);
  //   var timeDelayed = DateTime.now().add(Duration(seconds: 2));
  //   AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails('second channel ID', 'General', 'General',
  //           priority: Priority.high,
  //           importance: Importance.max,
  //           styleInformation: BigTextStyleInformation(
  //             'Segera selesaikan pembayaran Anda melalui ' +
  //                 basket["nama_bank"] +
  //                 ' dengan Transfer ke Nomor ' +
  //                 noVA,
  //             htmlFormatBigText: true,
  //             contentTitle: '<b>Transaksi Berhasil</b>',
  //             htmlFormatContentTitle: true,
  //           ),
  //           ticker: 'test');

  //   IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   );

  //   NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
  //   await flutterLocalNotificationsPlugin.schedule(
  //       1,
  //       'Transaksi Berhasil',
  //       'Segera selesaikan pembayaran Anda melalui ' +
  //           basket["nama_bank"] +
  //           ' dengan Transfer ke Nomor ' +
  //           noVA,
  //       timeDelayed,
  //       notificationDetails,
  //       payload: idTrx,
  //   );
  //   load = true;
  // }

  // Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
  //   return CupertinoAlertDialog(
  //     title: Text(title),
  //     content: Text(body),
  //     actions: [
  //       CupertinoDialogAction(
  //         isDefaultAction: true,
  //         onPressed: () {}, 
  //         child: Text("Okay")
  //       ),
  //     ],
  //   );
  // }

  // Future onSelectNotification(String payload) async {
  //   if (load == true) {
  //     Map<String, dynamic> basket = Provider.of<Map<String, dynamic>>(context, listen: false);
  //     load = false;
  //     basket.addAll({"information": payload});
  //     Navigator.pushNamed(context, "/transaction-warung");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: 'Mohon Tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Loader(
        color: ColorResources.PRIMARY,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 13.0, 
        fontWeight: FontWeight.w400
      ),
      messageTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 19.0, 
        fontWeight: FontWeight.w600
      )
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorResources.WHITE,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20.0,
            color: ColorResources.PRIMARY,
          ),
          onPressed: () => Navigator.of(context).pop()
        ),
        centerTitle: true,
        elevation: 0,
        title: Text("Pilih Pembayaran",
          style: poppinsRegular.copyWith(
            color: ColorResources.PRIMARY
          )
        ),
      ),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Card(
                margin: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 70.0, top: 12.0),
                child: custom.ExpansionTile(
                  initiallyExpanded: true,
                  headerBackgroundColor: ColorResources.PRIMARY,
                  iconColor: Colors.white,
                  title: Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text("Pilih Cara Pembayaran",
                          style: poppinsRegular.copyWith(
                            color: Colors.white
                          ),
                        )
                      )
                    ],
                  ),
                  children: [
                    custom.ExpansionTile(
                      initiallyExpanded: true,
                      headerBackgroundColor: Colors.white,
                      iconColor: ColorResources.PRIMARY,
                      title: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5.0),
                            child: Text("TRANSFER",
                              style: poppinsRegular.copyWith(
                                color: Colors.grey
                              ),
                            )
                          )
                        ],
                      ),
                      children: [getDataBank()],
                    ),
                  ],
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60.0,
              color: Colors.white,
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: bankController == null ? Colors.grey[200] : ColorResources.PRIMARY
                ),
                onPressed: bankController == null
                  ? () {
                      Fluttertoast.showToast(
                        backgroundColor: ColorResources.PRIMARY,
                        textColor: ColorResources.WHITE,
                        fontSize: 14.0,
                        msg: "Anda belum memilih metode pembayaran",
                      );
                    }
                  : () async {
                    pr.show();
                    await Provider.of<WarungProvider>(context, listen: false).postCartCheckout(context, id).then((value) {
                      if (value.code == 0) {
                        pr.hide();
                        // showNotificationsAfterSecond(value.body.paymentCode, value.body.refNo);
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return CheckoutProductScreen(
                            paymentChannel: value.body.paymentChannel,
                            paymentCode: value.body.paymentCode,
                            paymentRefId: value.body.paymentRefId,
                            paymentGuide: value.body.paymentGuide,
                            paymentAdminFee: value.body.paymentAdminFee,
                            paymentStatus: value.body.paymentStatus,
                            refNo: value.body.refNo,
                            billingUid: value.body.billingUid,
                            amount: value.body.amount);
                          }
                        ));
                      } else {
                        pr.hide();
                        Fluttertoast.showToast(
                          backgroundColor: ColorResources.ERROR,
                          textColor: ColorResources.WHITE,
                          fontSize: 14.0,
                          msg:"Failed: Internal Server Problem",
                        );
                      }
                    });
                  },
                  child: Text("Bayar",
                  style: poppinsRegular.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: bankController == null
                    ? Colors.grey
                    : Colors.white
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget getDataBank() {
    Map<String, dynamic> basket = Provider.of<Map<String, dynamic>>(context, listen: false);
    return FutureBuilder<BankPaymentStore>(
      future: Provider.of<WarungProvider>(context, listen: false).getDataBank(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final BankPaymentStore bankWarungModel = snapshot.data;
          return ListView.builder(
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: bankWarungModel.body.length,
            itemBuilder: (BuildContext context, int i) {
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 70.0,
                      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 5.0, top: 5.0),
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: id == bankWarungModel.body[i].channel ? ColorResources.PURPLE_LIGHT : Colors.white,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              id = bankWarungModel.body[i].channel;
                              bankController = TextEditingController(text: bankWarungModel.body[i].name);
                              basket.addAll({
                                "nama_bank": bankWarungModel.body[i].name,
                                "guide": bankWarungModel.body[i].guide
                              });
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      child: CachedNetworkImage(
                                        imageUrl: bankWarungModel.body[i].logo,
                                        height: 30.0,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Loader(
                                          color: ColorResources.PRIMARY,
                                        ),
                                        errorWidget: (context, url, error) => Center(child: Image.asset("assets/default_image.png",
                                          height: 20.0,
                                          fit: BoxFit.cover,
                                        )),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        bankWarungModel.body[i].name,
                                        style: poppinsRegular.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: id == bankWarungModel.body[i].channel ? Colors.white : Colors.black
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              );
            }
          );
        }
        return Container(
          padding: EdgeInsets.all(20.0),
          child: Loader(
            color: ColorResources.PRIMARY,
          ),
        );
      },
    );
  }
}
