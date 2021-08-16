
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/data/models/warung/shipping_couriers_model.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_expansion_tile.dart' as custom;

class PilihPengirimanPage extends StatefulWidget {
  final String idStore;

  PilihPengirimanPage({
    Key key,
    @required this.idStore,
  }) : super(key: key);
  @override
  _PilihPengirimanPageState createState() => _PilihPengirimanPageState();
}

class _PilihPengirimanPageState extends State<PilihPengirimanPage> {
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
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
      progressTextStyle: poppinsRegular.copyWith( color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: poppinsRegular.copyWith(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)       
    );
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Pilih Jasa Pengiriman",
            style: poppinsRegular.copyWith(
              color: Colors.black, 
              fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleSpacing: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Icon(Icons.close)),
          elevation: 0,
        ),
        body: getDataCourier()
      ),
    );
  }

  Widget getDataCourier() {
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    return FutureBuilder<ShippingCouriersModel>(
      future: warungVM.getCourierShipping(context, widget.idStore),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final ShippingCouriersModel shippingCM = snapshot.data;
          if(shippingCM.body == null) {
            return emptyKurir();
          }
          return ListView.builder(
            itemCount: shippingCM.body.categories.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int i) {
              return shippingCM.body.categories.length != 0
              ? custom.ExpansionTile(
                  initiallyExpanded: true,
                  headerBackgroundColor: ColorResources.PRIMARY,
                  iconColor: Colors.white,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shippingCM.body.categories[i].type.replaceAll('_', ''),
                        style: poppinsRegular.copyWith(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Text(shippingCM.body.categories[i].label.replaceAll('_', ''),
                        style: poppinsRegular.copyWith(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ],
                  ),
                  children: shippingCM.body.categories[i].rates.asMap().map((int key, Rate rate) => MapEntry(key,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    onTap: () async {
                                      pr.show();
                                      await warungVM.postSetCouriers(context, widget.idStore, rate.rateId).then((value) {
                                        if (value.code == 0) {
                                          pr.hide();
                                          Provider.of<WarungProvider>(context, listen: false).getCartInfo(context);
                                          Navigator.pop(context, true);
                                        } else {
                                          pr.hide();
                                          Fluttertoast.showToast(
                                            backgroundColor: ColorResources.ERROR,
                                            textColor: ColorResources.WHITE,
                                            fontSize: 14.0,
                                            msg: "Failed: Internal Server Problem",
                                          );
                                        }
                                      });
                                    },
                                    leading: CachedNetworkImage(
                                      imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${rate.courierLogo}",
                                      width: 75.0,
                                      height: 75.0,
                                    ),
                                    title: Container(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 8.0),
                                          Text(rate.serviceName,
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold
                                            )
                                          ),
                                          SizedBox(height: 5.0),
                                          Text(rate.courierName,
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold
                                            )
                                          ),
                                          SizedBox(height: 5.0),
                                          Text("("+ ConnexistHelper.formatCurrency(rate.price) + ")",
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                            )
                                          ),
                                          SizedBox(height: 5.0),
                                          Text("Estimasi Tiba " + rate.estimateDays.replaceAll(RegExp(r"HARI"), "") + " Hari",
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                            )
                                          ),
                                          SizedBox(height: 8.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  shippingCM.body.categories.length == key + 1
                                  ? Container()
                                  : Container()
                                ],
                              )
                            
                          ],
                        ),
                      )
                    )
                  ).values.toList(),
                )
              : Container();
            },
          );
        }
        return Loader(
          color: ColorResources.PRIMARY
        );
      },
    );
  }

  Widget emptyKurir() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              "assets/lottie/product_not_available.json",
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20.0),
            Container(
              child: Text(
                "Ups, belum ada kurir \nSilahkan coba ganti/tambah alamat anda",
                textAlign: TextAlign.center,
                style: poppinsRegular.copyWith(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ]
        )
      ),
    );
  }

}
