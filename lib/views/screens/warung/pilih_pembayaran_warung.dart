import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/data/models/warung/bank_warung_model.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/warung/checkout_product_warung.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_expansion_tile.dart' as custom;

class PilihPembayaranWarungPage extends StatefulWidget {
  @override
  _PilihPembayaranWarungPageState createState() => _PilihPembayaranWarungPageState();
}

class _PilihPembayaranWarungPageState extends State<PilihPembayaranWarungPage> {
  ProgressDialog pr;

  String idx;
  var _bankController;
  bool load = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  @override
  void initState() {
    super.initState();
    initializing();
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    iosInitializationSettings = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        onSelectNotification(payload);
      },
    );
  }

  void _showNotificationsAfterSecond(String noVA, String idTrx) async {
    await notificationAfterSec(noVA, idTrx);
  }

  Future<void> notificationAfterSec(String noVA, String idTrx) async {
    Map<String, dynamic> basket =
        Provider.of<Map<String, dynamic>>(context, listen: false);
    var timeDelayed = DateTime.now().add(Duration(seconds: 2));
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('second channel ID', 'General', 'General',
            priority: Priority.high,
            importance: Importance.max,
            styleInformation: BigTextStyleInformation(
              'Segera selesaikan pembayaran Anda melalui ' +
                  basket["nama_bank"] +
                  ' dengan Transfer ke Nomor ' +
                  noVA,
              htmlFormatBigText: true,
              contentTitle: '<b>Transaksi Berhasil</b>',
              htmlFormatContentTitle: true,
            ),
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(
        1,
        'Transaksi Berhasil',
        'Segera selesaikan pembayaran Anda melalui ' +
            basket["nama_bank"] +
            ' dengan Transfer ke Nomor ' +
            noVA,
        timeDelayed,
        notificationDetails,
        payload: idTrx,
    );
    load = true;
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true, onPressed: () {}, child: Text("Okay")),
      ],
    );
  }

  Future onSelectNotification(String payload) async {
    if (load == true) {
      Map<String, dynamic> basket = Provider.of<Map<String, dynamic>>(context, listen: false);
      debugPrint('notification payload: ' + payload);
      load = false;
      basket.addAll({"information": payload});
      print(payload);
      Navigator.pushNamed(context, "/transaction-warung");
    }
  }

  @override
  Widget build(BuildContext context) {
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: ' Mohon Tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Loader(
        color: ColorResources.PRIMARY,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return Scaffold(
      backgroundColor: Colors.white,
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
            shrinkWrap: true,
            children: [
              Card(
                margin: EdgeInsets.only(
                  left: 12.0, 
                  right: 12.0, 
                  bottom: 70.0, 
                  top: 12.0
                ),
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
                        margin: EdgeInsets.only(left: 10),
                        child: Text("Pilih Cara Pembayaran",
                          style: TextStyle(color: Colors.white),
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
                        children: <Widget>[
                          Image.asset(
                            "assets/atm.png",
                            width: 25,
                            height: 25,
                            color: ColorResources.PRIMARY,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                "TRANSFER",
                                style: TextStyle(color: Colors.grey),
                              ))
                        ],
                      ),
                      children: <Widget>[_getDataBank()],
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
              child: RaisedButton(
                color: _bankController == null
                    ? Colors.grey[200]
                    : ColorResources.PRIMARY,
                onPressed: _bankController == null
                    ? () {
                        Fluttertoast.showToast(
                          msg: "Anda belum memilih metode pembayaran",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white
                        );
                      }
                    : () async {
                      pr.show();
                      await warungVM.postCartCheckout(context, idx).then((value) {
                        if (value.code == 0) {
                          pr.hide();
                          _showNotificationsAfterSecond(value.body.paymentCode, value.body.refNo);
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return CheckoutProductWarungPage(
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
                            msg:"Terjadi kesalahan mohon ulangi transaksi",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white
                          );
                        }
                      });
                    },
                  child: Text("Bayar",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: _bankController == null
                          ? Colors.grey
                          : Colors.white),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget _getDataBank() {
    // Map<String, dynamic> _basket = Provider.of<Map<String, dynamic>>(context, listen: false);

    // return FutureBuilder<BankWarungModel>(
    //   future: Provider.of<BankProvider>(context, listen: false).getBankWarung(context),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     if (snapshot.hasData) {
    //       final BankWarungModel bankWarungModel = snapshot.data;
    //       return ListView.builder(
    //         physics: ScrollPhysics(),
    //         scrollDirection: Axis.vertical,
    //         shrinkWrap: true,
    //         itemCount: bankWarungModel.body.length,
    //         itemBuilder: (BuildContext context, int index) {
    //           return Row(
    //             children: [
    //               Expanded(
    //                 child: Container(
    //                   height: 70.0,
    //                   margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
    //                   child: Card(
    //                     elevation: 2.0,
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(8.0),
    //                     ),
    //                     color: idx == bankWarungModel.body[index].channel ? ColorResources.PRIMARY : Colors.white,
    //                     child: GestureDetector(
    //                       onTap: () {
    //                         setState(() {
    //                           idx = bankWarungModel.body[index].channel;
    //                           _bankController = TextEditingController(text: bankWarungModel.body[index].name);
    //                           _basket.addAll({
    //                             "nama_bank": bankWarungModel.body[index].name,
    //                             "guide": bankWarungModel.body[index].guide
    //                           });
    //                         });
    //                       },
    //                       child: Container(
    //                         padding: EdgeInsets.all(10),
    //                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
    //                         child: Column(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Row(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               children: [
    //                                 ClipRRect(
    //                                   child: CachedNetworkImage(
    //                                     imageUrl: bankWarungModel.body[index].logo,
    //                                     height: 30.0,
    //                                     fit: BoxFit.cover,
    //                                     placeholder: (context, url) => Loader(
    //                                       color: ColorResources.PRIMARY,
    //                                     ),
    //                                     errorWidget: (context, url, error) => Center(child: Image.asset("assets/default_image.png",
    //                                       height: 20.0,
    //                                       fit: BoxFit.cover,
    //                                     )),
    //                                   ),
    //                                 ),
    //                                 Container(
    //                                   margin: EdgeInsets.only(left: 10.0),
    //                                   child: Text(
    //                                     bankWarungModel.body[index].name,
    //                                     style: TextStyle(
    //                                       fontWeight: FontWeight.bold,
    //                                       color: idx == bankWarungModel.body[index].channel ? Colors.white : Colors.black
    //                                     ),
    //                                   ),
    //                                 )
    //                               ],
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   )
    //                 ),
    //               ),
    //             ],
    //           );
    //         }
    //       );
    //     }
    //     return Container(
    //       padding: EdgeInsets.all(20.0),
    //       child: Loader(
    //         color: ColorResources.PRIMARY,
    //       ),
    //     );
    //   },
    // );
  }
}
