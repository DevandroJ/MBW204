
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/data/models/warung/shipping_couriers_model.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
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
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: ' Mohon Tunggu...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Loader(
          color: ColorResources.PRIMARY,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Pilih Jasa Pengiriman",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
          body: getDataCourier()),
    );
  }

  Widget getDataCourier() {
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    return FutureBuilder<ShippingCouriersModel>(
      future: warungVM.getCourierShipping(context, widget.idStore),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final ShippingCouriersModel shippingCM = snapshot.data;
          if (shippingCM.body == null) {
            return emptyKurir();
          }
          return ListView.builder(
            itemCount: shippingCM.body.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return shippingCM.body[index].services.length != 0
                  ? custom.ExpansionTile(
                      initiallyExpanded: true,
                      headerBackgroundColor: ColorResources.PRIMARY,
                      iconColor: Colors.white,
                      title: Text(shippingCM.body[index].name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      children: shippingCM.body[index].services
                          .asMap()
                          .map((key, kurir) => MapEntry(
                              key,
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: ListView(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    ...kurir.costs.map((cost) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.all(0),
                                            onTap: () async {
                                              pr.show();
                                              await warungVM
                                                  .postSetCouriers(
                                                    context, widget.idStore, cost.id)
                                                  .then((value) {
                                                if (value.code == 0) {
                                                  pr.hide();
                                                  Navigator.pop(context, true);
                                                } else {
                                                  pr.hide();
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Terjadi kesalahan mohon coba lagi",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.red,
                                                      textColor: Colors.white);
                                                }
                                              });
                                            },
                                            title: Container(
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 8),
                                                  Text(kurir.service,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 5),
                                                  Text(
                                                      "(" +
                                                          ConnexistHelper
                                                              .formatCurrency(
                                                                  cost.price) +
                                                          ")",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      )),
                                                  SizedBox(height: 5),
                                                  Text(
                                                      "Estimasi Tiba " +
                                                          cost.etd.replaceAll(
                                                              RegExp(r"HARI"),
                                                              "") +
                                                          " Hari",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      )),
                                                  SizedBox(height: 8),
                                                ],
                                              ),
                                            ),
                                          ),
                                          shippingCM.body[index].services
                                                      .length ==
                                                  key + 1
                                              ? Container()
                                              : Divider(
                                                  thickness: 1,
                                                )
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              )))
                          .values
                          .toList(),
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
      padding: const EdgeInsets.all(16.0),
      child: Container(
          width: double.infinity,
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  "assets/lottie/product_not_available.json",
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 20),
                Container(
                  child: Text(
                    "Ups, belum ada kurir \nSilahkan coba ganti/tambah alamat anda",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ])),
    );
  }
}
