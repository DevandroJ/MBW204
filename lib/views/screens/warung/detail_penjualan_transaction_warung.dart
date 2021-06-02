import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:flushbar/flushbar.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/models/warung/shipping_tracking_model.dart';
import 'package:mbw204_club_ina/data/models/warung/transaction_warung_paid_single_model.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/warung/penjualan_transaction_warung.dart';


class DetailPenjualanTransactionWarungPage extends StatefulWidget {
  final String idTrx;
  final String typeUser;
  final String status;

  DetailPenjualanTransactionWarungPage(
      {Key key,
      @required this.idTrx,
      @required this.typeUser,
      @required this.status})
      : super(key: key);
  @override
  _DetailPenjualanTransactionWarungPageState createState() =>
      _DetailPenjualanTransactionWarungPageState();
}

class _DetailPenjualanTransactionWarungPageState
    extends State<DetailPenjualanTransactionWarungPage> {
  TransactionWarungPaidSingleModel transactionPaidSingle;
  bool isLoading = true;
  ProgressDialog pr;
  final formKey = new GlobalKey<FormState>();
  final _noResi = TextEditingController();
  @override
  void initState() {
    _noResi.addListener(() {
      setState(() {});
    });
    _getRequests();
    super.initState();
  }

  _getRequests() async {
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    await warungVM
        .getTransactionPaidSingle(context, widget.idTrx, widget.typeUser)
        .then((value) {
      setState(() {
        isLoading = false;
        transactionPaidSingle = value;
      });
    });
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
      progressTextStyle: TextStyle(
        color: Colors.black, 
        fontSize: 13.0, 
        fontWeight: FontWeight.w400
      ),
      messageTextStyle: TextStyle(
        color: Colors.black, 
        fontSize: 19.0, 
        fontWeight: FontWeight.w600
      )
    );
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Detail Transaksi",
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: ColorResources.PRIMARY,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: isLoading
            ? Center(
                child: Loader(
                  color: ColorResources.PRIMARY,
                ),
              )
            : Stack(
                children: [
                  ListView(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Status",
                                  style: TextStyle(
                                    color: ColorResources.PRIMARY,
                                    fontSize: 12,
                                  )),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(transactionPaidSingle.body.orderStatus,
                                      style: TextStyle(
                                        color: ColorResources.PRIMARY,
                                        fontSize: 14,
                                      )),
                                  GestureDetector(
                                    onTap: () {
                                      if (transactionPaidSingle.body.wayBill ==
                                          null) {
                                        Fluttertoast.showToast(
                                            msg: "No Resi belum ada",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white);
                                      } else {
                                        _modalTrackingKurir(
                                            transactionPaidSingle.body.id);
                                      }
                                    },
                                    child: Text("Lihat",
                                        style: TextStyle(
                                          color: ColorResources.PRIMARY,
                                          fontSize: 14,
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Divider(
                                thickness: 2,
                                color: Colors.grey[100],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Tanggal Pembelian",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      )),
                                  Text(
                                      ConnexistHelper.formatDate(DateTime.parse(
                                          transactionPaidSingle.body.created)),
                                      style: TextStyle(
                                        color: ColorResources.PRIMARY,
                                        fontSize: 14,
                                      )),
                                ],
                              ),
                              SizedBox(height: 8),
                              Divider(
                                thickness: 2,
                                color: Colors.grey[100],
                              ),
                              SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("No Invoice",
                                      style: TextStyle(
                                        color: ColorResources.PRIMARY,
                                        fontSize: 12,
                                      )),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(transactionPaidSingle.body.invoiceNo,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          )),
                                      // GestureDetector(
                                      //   onTap: () {},
                                      //   child: Text("Lihat",
                                      //       style: TextStyle(
                                      //         color: ColorPalette.btnLogin,
                                      //         fontSize: 14,
                                      //       )),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Divider(
                        thickness: 12,
                        color: Colors.grey[100],
                      ),
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Warung: ",
                                      style: TextStyle(
                                        color: ColorResources.PRIMARY,
                                        fontSize: 14,
                                      )),
                                  SizedBox(width: 2),
                                  Text(transactionPaidSingle.body.store.name,
                                      style: TextStyle(
                                        color: ColorResources.PRIMARY,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      )),
                                ],
                              ),
                              SizedBox(height: 8),
                              ...transactionPaidSingle.body.products
                                  .map((dataProduct) {
                                return Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 60,
                                              height: 60,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: dataProduct
                                                                      .product
                                                                      .pictures
                                                                      .length ==
                                                                  0
                                                              ? ""
                                                              : AppConstants.BASE_URL_FEED_IMG +
                                                                  dataProduct
                                                                      .product
                                                                      .pictures
                                                                      .first
                                                                      .path,
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  url) =>
                                                              Center(
                                                                  child: Shimmer
                                                                      .fromColors(
                                                            baseColor: Colors
                                                                .grey[300],
                                                            highlightColor:
                                                                Colors
                                                                    .grey[100],
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                            ),
                                                          )),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Center(
                                                                  child: Image
                                                                      .asset(
                                                            "assets/default_image.png",
                                                            fit: BoxFit.cover,
                                                          )),
                                                        ),
                                                      )),
                                                  dataProduct.product
                                                              .discount !=
                                                          null
                                                      ? Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Container(
                                                            height: 20,
                                                            width: 25,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            12),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            12)),
                                                                color: Colors
                                                                    .red[900]),
                                                            child: Center(
                                                              child: Text(
                                                                dataProduct
                                                                        .product
                                                                        .discount
                                                                        .discount
                                                                        .toString()
                                                                        .replaceAll(
                                                                            RegExp(r"([.]*0)(?!.*\d)"),
                                                                            "") +
                                                                    "%",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  dataProduct.product.name
                                                              .length >
                                                          75
                                                      ? Text(
                                                          dataProduct
                                                                  .product.name
                                                                  .substring(
                                                                      0, 80) +
                                                              "...",
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                          ),
                                                        )
                                                      : Text(
                                                          dataProduct
                                                              .product.name,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                          ),
                                                        ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                      dataProduct.quantity
                                                              .toString() +
                                                          " barang " +
                                                          "(" +
                                                          (dataProduct.product
                                                                      .weight *
                                                                  dataProduct
                                                                      .quantity)
                                                              .toString() +
                                                          " gr)",
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: ColorResources.PRIMARY)),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                      ConnexistHelper
                                                          .formatCurrency(
                                                              dataProduct
                                                                  .product
                                                                  .price),
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Divider(
                                          thickness: 2,
                                          color: Colors.grey[100],
                                        ),
                                        SizedBox(height: 8),
                                        Text("Total Belanja",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            )),
                                        SizedBox(height: 8),
                                        Text(
                                            ConnexistHelper.formatCurrency(
                                                dataProduct.product.price *
                                                    dataProduct.quantity),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList()
                            ],
                          )),
                      Divider(
                        thickness: 12,
                        color: Colors.grey[100],
                      ),
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Detail Pengiriman",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )),
                              SizedBox(height: 15),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text("Kurir Pengiriman",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(
                                        transactionPaidSingle
                                                .body.deliveryCost.courierId
                                                .toUpperCase() +
                                            " - " +
                                            transactionPaidSingle
                                                .body.deliveryCost.serviceName,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text("No. Resi",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        )),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            transactionPaidSingle
                                                        .body.wayBill ==
                                                    null
                                                ? "Belum ada No. Resi"
                                                : transactionPaidSingle
                                                    .body.wayBill,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            )),
                                        SizedBox(height: 15),
                                        transactionPaidSingle.body.wayBill ==
                                                null
                                            ? Container()
                                            : GestureDetector(
                                                onTap: () {
                                                  Clipboard.setData(ClipboardData(
                                                          text:
                                                              transactionPaidSingle
                                                                  .body
                                                                  .wayBill))
                                                      .then((result) {
                                                    showFloatingFlushbar(
                                                        context);
                                                  });
                                                },
                                                child: Text("Salin No. Resi",
                                                    style: TextStyle(
                                                      color: ColorResources.PRIMARY,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    )),
                                              )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text("Alamat Pengiriman",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        )),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            transactionPaidSingle
                                                .body.user.fullname,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            )),
                                        SizedBox(height: 4),
                                        Text(
                                            transactionPaidSingle
                                                .body
                                                .destShippingAddress
                                                .phoneNumber,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            )),
                                        SizedBox(height: 4),
                                        Text(
                                            transactionPaidSingle.body
                                                .destShippingAddress.address,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            )),
                                        SizedBox(height: 4),
                                        Text(
                                            transactionPaidSingle
                                                .body.destShippingAddress.city,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            )),
                                        SizedBox(height: 4),
                                        Text(
                                            transactionPaidSingle.body
                                                .destShippingAddress.postalCode,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Divider(
                        thickness: 12,
                        color: Colors.grey[100],
                      ),
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Informasi Pembayaran",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )),
                              SizedBox(height: 8),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total Harga Barang",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          )),
                                      Container(
                                        child: Text(
                                            ConnexistHelper.formatCurrency(
                                                transactionPaidSingle
                                                    .body.totalProductPrice),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            )),
                                      )
                                    ]),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Ongkos Kirim",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          )),
                                      Container(
                                        child: Text(
                                            ConnexistHelper.formatCurrency(
                                                transactionPaidSingle
                                                    .body.deliveryCost.price),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            )),
                                      )
                                    ]),
                              ),
                            ],
                          )),
                      Divider(
                        thickness: 2,
                        color: Colors.grey[100],
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total bayar",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    )),
                                Container(
                                  child: Text(
                                      ConnexistHelper.formatCurrency(
                                          transactionPaidSingle
                                              .body.totalPrice),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                )
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: widget.status == "RECEIVED"
                            ? 60
                            : widget.status == "PACKING"
                                ? 140
                                : 10,
                      )
                    ],
                  ),
                  widget.status == "RECEIVED"
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              height: 60,
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        pr.show();
                                        await warungVM
                                            .postOrderPacking(context, widget.idTrx)
                                            .then((value) {
                                          if (value.code == 0) {
                                            pr.hide();
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Konfirmasi pesanan berhasil",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white);
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return PenjualanTransactionWarungPage(
                                                  index: 1);
                                            }));
                                          } else {
                                            pr.hide();
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Konfirmasi pesanan gagal, coba ulangi kembali",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white);
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: ColorResources.PRIMARY),
                                        child: Center(
                                          child: Text(
                                            "Konfirmasi Pesanan",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )))
                      : widget.status == "PACKING"
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  height: 140,
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 4), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: new TextFormField(
                                            controller: _noResi,
                                            decoration: new InputDecoration(
                                              // labelText: "No Ponsel",
                                              hintText:
                                                  "Masukan No Resi Pengiriman",
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            ),
                                            validator: (val) {
                                              if (val.isEmpty) {
                                                return "No Resi pengiriman tidak boleh kosong";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType: TextInputType.text,
                                            style: new TextStyle(
                                              fontFamily: 'Proppins',
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () async {
                                            print(_noResi.text);
                                            if (_noResi.text == '') {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "No Resi, tidak boleh kosong",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white);
                                            } else {
                                              pr.show();
                                              await warungVM
                                                  .postInputResi(context, widget.idTrx,
                                                      _noResi.text)
                                                  .then((value) {
                                                if (value.code == 0) {
                                                  pr.hide();
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Input No Resi Berhasil",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.green,
                                                      textColor: Colors.white);
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return PenjualanTransactionWarungPage(
                                                        index: 2);
                                                  }));
                                                } else {
                                                  pr.hide();
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Input No Resi, coba ulangi kembali",
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
                                            }
                                          },
                                          child: Container(
                                            height: 50,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: _noResi.text == ''
                                                    ? Colors.grey[350]
                                                    : ColorResources.PRIMARY),
                                            child: Center(
                                              child: Text(
                                                "Submit",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )))
                          : Container()
                ],
              ));
  }

  void showFloatingFlushbar(BuildContext context) {
    Flushbar(
      margin: EdgeInsets.all(10.0),
      borderRadius: 8,
      backgroundGradient: LinearGradient(
        colors: [Colors.blue, Colors.orange[700]],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      // All of the previous Flushbars could be dismissed by swiping down
      // now we want to swipe to the sides
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      // The default curve is Curves.easeOut
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      // title: 'This is a floating Flushbar',
      message: 'Copied to Clipboard',
      duration: Duration(seconds: 2),
    )..show(context);
  }

  _modalTrackingKurir(String idOrder) {
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (context) {
        return new Container(
            height: MediaQuery.of(context).size.height * 0.96,
            // margin: MediaQuery.of(context).padding,
            color: Colors.transparent,
            child: Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 8),
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close)),
                              Container(
                                  margin: EdgeInsets.only(left: 16),
                                  child: Text("Detail Status Pengiriman",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black))),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 3,
                        ),
                        Expanded(
                          flex: 40,
                          child: FutureBuilder<ShippingTrackingModel>(
                            future: warungVM.getShippingTracking(context, idOrder),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final ShippingTrackingModel
                                    shippingTrackingModel = snapshot.data;
                                if (shippingTrackingModel.body == null) {
                                  return Center(
                                    child: Text(
                                        "Terjadi kesalahan dalam pengambilan data"),
                                  );
                                }
                                return ListView(
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  children: [
                                    Timeline.builder(
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return TimelineModel(
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 8, bottom: 8),
                                                child: Card(
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0)),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        // Image.network(doodle.doodle),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        Text(
                                                            shippingTrackingModel
                                                                .body
                                                                .manifest[index]
                                                                .cityName),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        Text(shippingTrackingModel
                                                            .body
                                                            .manifest[index]
                                                            .manifestDescription),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        Row(children: [
                                                          Text(DateFormat(
                                                                  'dd MMMM yyyy')
                                                              .format(shippingTrackingModel
                                                                  .body
                                                                  .manifest[
                                                                      index]
                                                                  .manifestDate)),
                                                          Text(shippingTrackingModel
                                                              .body
                                                              .manifest[index]
                                                              .manifestTime),
                                                        ]),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              iconBackground:
                                                  ColorResources.PRIMARY,
                                              position:
                                                  TimelineItemPosition.right,
                                              isFirst: index == 0,
                                              isLast: index ==
                                                  shippingTrackingModel
                                                      .body.manifest.length,
                                              icon: Icon(
                                                Icons.local_shipping,
                                                color: Colors.white,
                                              ));
                                        },
                                        itemCount: shippingTrackingModel
                                            .body.manifest.length,
                                        physics: BouncingScrollPhysics(),
                                        position: TimelinePosition.Left)
                                  ],
                                );
                              }
                              return Loader(
                                color: ColorResources.PRIMARY,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )));
      },
    );
  }
}
