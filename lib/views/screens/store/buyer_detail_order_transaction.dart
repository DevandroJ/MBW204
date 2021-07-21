import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flushbar/flushbar.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:timelines/timelines.dart' as t;

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/models/warung/shipping_tracking_model.dart';
import 'package:mbw204_club_ina/data/models/warung/transaction_warung_paid_single_model.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/store/cart_product.dart';

class DetailBuyerTransactionScreen extends StatefulWidget {
  final String typeUser;
  final String status;

  DetailBuyerTransactionScreen(
    {Key key,
    @required this.typeUser,
    @required this.status})
    : super(key: key);
  @override
  _DetailBuyerTransactionScreenState createState() => _DetailBuyerTransactionScreenState();
}

class _DetailBuyerTransactionScreenState extends State<DetailBuyerTransactionScreen> {
  TransactionWarungPaidSingleModel transactionPaidSingle;
  bool isLoading = true;
  ProgressDialog pr;

  Color completeColor = Color(0xff5e6172);
  Color inProgressColor = Color(0xff5ec792);
  Color todoColor = Color(0xffd1d2d7);

  List<String> _processes = [
    'Paid',
    'Packed',
    'Pickup',
    'Shipped',
    'Delivered',
    'Completed'
  ];

  Color getColor(int index, int processIndex) {
    if (index == processIndex) {
      return inProgressColor;
    } else if (index < processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  void initState() {
    super.initState();
    getRequests();
  }

  Future getRequests() async {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    await Provider.of<WarungProvider>(context, listen: false).getTransactionPaidSingle(context, basket['idTrx'], widget.typeUser).then((value) {
      setState(() {
        isLoading = false;
        transactionPaidSingle = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: ' Mohon Tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Loader(
        color: ColorResources.PRIMARY
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
        title: Text("Detail Transaksi",
          style: poppinsRegular.copyWith(
            color: Colors.white, 
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: ColorResources.PRIMARY,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: isLoading
        ? Loader(
          color: ColorResources.PRIMARY,
        )
        : Stack(
        children: [
          RefreshIndicator(
            backgroundColor: ColorResources.BTN_PRIMARY,
            color: ColorResources.WHITE,
            onRefresh: () {
              Map<String, dynamic> basket = Provider.of(context, listen: false);
              return Provider.of<WarungProvider>(context, listen: false).getTransactionPaidSingle(context, basket['idTrx'], widget.typeUser);
            },
            child: ListView(
              children: [
              Padding(
                padding: EdgeInsets.only(top: 12.0, bottom: 5.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Status Pesanan",
                      style: poppinsRegular.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ORDER #",
                          style: poppinsRegular.copyWith(
                            color: ColorResources.PRIMARY,
                            fontSize: 14.0,
                          )
                        ),
                        SizedBox(width: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SelectableText("${transactionPaidSingle.body.id}",
                              style: poppinsRegular.copyWith(
                                color: Colors.black,
                                fontSize: 14.0,
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 6.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("INVOICE #",
                          style: poppinsRegular.copyWith(
                            color: ColorResources.PRIMARY,
                            fontSize: 14.0,
                          )
                        ),
                        SizedBox(width: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SelectableText("${transactionPaidSingle.body.invoiceNo}",
                              style: poppinsRegular.copyWith(
                                color: Colors.black,
                                fontSize: 14.0,
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ),
            FutureBuilder<ShippingTrackingModel>(
              future: Provider.of<WarungProvider>(context, listen: false).getShippingTracking(context, transactionPaidSingle.body.id),
              builder: (BuildContext context, AsyncSnapshot<ShippingTrackingModel> snapshot) {
                if (snapshot.hasData) {
                  ShippingTrackingModel shippingTrackingModel = snapshot.data;
                  return Container(
                    margin: EdgeInsets.only(top: 15.0),
                    height: 120.0,
                    child: t.Timeline.tileBuilder(
                      theme: t.TimelineThemeData(
                        direction: Axis.horizontal,
                        connectorTheme: t.ConnectorThemeData(
                          space: 30.0,
                          thickness: 5.0,
                        ),
                      ),
                      builder: t.TimelineTileBuilder.connected(
                        connectionDirection: t.ConnectionDirection.before,
                        itemExtentBuilder: (_, __) => MediaQuery.of(context).size.width / _processes.length,
                        oppositeContentsBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 15.0),
                            child: Image.asset(
                              'assets/icons/ic-status-transaction-$index.png',
                              width: 30.0,
                              color: getColor(index, shippingTrackingModel.body.orderStatusInfos.length - 1),
                            ),
                          );
                        },
                        contentsBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text(_processes[index],
                              style: poppinsRegular.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: getColor(index, shippingTrackingModel.body.orderStatusInfos.length - 1
                              ),
                            )),
                          );
                        },
                        indicatorBuilder: (_, index) {
                          var color;
                          var child;
                          if (index == shippingTrackingModel.body.orderStatusInfos.length - 1) {
                            color = inProgressColor;
                            child = Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15.0,
                            );
                          } else if (index < shippingTrackingModel.body.orderStatusInfos.length - 1) {
                            color = completeColor;
                            child = Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15.0,
                            );
                          } else {
                            color = todoColor;
                          }
                          if (index <= shippingTrackingModel.body.orderStatusInfos.length - 1) {
                            return Stack(
                              children: [
                                CustomPaint(
                                  size: Size(30.0, 30.0),
                                  painter: _BezierPainter(
                                    color: color,
                                    drawStart: index > 0,
                                    drawEnd: index < shippingTrackingModel.body.orderStatusInfos.length - 1,
                                  ),
                                ),
                                t.DotIndicator(
                                  size: 30.0,
                                  color: color,
                                  child: child,
                                ),
                              ],
                            );
                          } else {
                            return Stack(
                              children: [
                                CustomPaint(
                                  size: Size(15.0, 15.0),
                                  painter: _BezierPainter(
                                    color: color,
                                    drawEnd: index < shippingTrackingModel.body.orderStatusInfos.length - 1,
                                  ),
                                ),
                                t.OutlinedDotIndicator(
                                  borderWidth: 4.0,
                                  color: color,
                                ),
                              ],
                            );
                          }
                        },
                        connectorBuilder: (_, index, type) {
                          if (index > 0) {
                            if (index == shippingTrackingModel.body.orderStatusInfos.length - 1) {
                              final prevColor = getColor(index - 1, shippingTrackingModel.body.orderStatusInfos.length - 1);
                              final color = getColor(index, shippingTrackingModel.body.orderStatusInfos.length - 1);
                              List<Color> gradientColors;
                              if (type == t.ConnectorType.start) {
                                gradientColors = [Color.lerp(prevColor, color, 0.5), color];
                              } else {
                                gradientColors = [
                                  prevColor,
                                  Color.lerp(prevColor, color, 0.5)
                                ];
                              }
                              return t.DecoratedLineConnector(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                  ),
                                ),
                              );
                            } else {
                              return t.SolidLineConnector(
                                color: getColor(index, shippingTrackingModel.body.orderStatusInfos.length - 1),
                              );
                            }
                          } else {
                            return null;
                          }
                        },
                        itemCount: _processes.length,
                      ),
                    ),
                  );
                }
                return Container(
                  height: 100.0,
                  child: Loader(
                    color: ColorResources.PRIMARY,
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Toko ",
                        style: poppinsRegular.copyWith(
                          color: ColorResources.PRIMARY,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        )
                      ),
                      Text(transactionPaidSingle.body.store.name,
                        style: poppinsRegular.copyWith(
                          color: ColorResources.PRIMARY,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  ...transactionPaidSingle.body.products.map((dataProduct) {
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 0.5,
                          color: Colors.grey,
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60.0,
                                height: 60.0,
                                child: Stack(
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12.0),
                                          child: CachedNetworkImage(
                                            imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${dataProduct.product.pictures.first.path}",
                                            fit: BoxFit.cover,
                                            placeholder: (BuildContext context, dynamic url) => Center(
                                              child: Shimmer.fromColors(
                                              baseColor: Colors.grey[300],
                                              highlightColor: Colors.grey[100],
                                              child: Container(
                                                color: Colors.white,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            )),
                                            errorWidget: (BuildContext context, String url, dynamic error) =>
                                              Center(
                                                child: Image.asset(
                                                "assets/images/default_image.png",
                                                fit: BoxFit.cover,
                                              )
                                            ),
                                          ),
                                        )
                                      ),
                                    dataProduct.product.discount != null
                                    ? Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          height: 20.0,
                                          width: 25.0,
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(12.0),
                                              topLeft: Radius.circular(12.0)
                                            ),
                                            color: Colors.red[900]
                                          ),
                                          child: Center(
                                            child: Text(dataProduct.product.discount.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
                                              style: poppinsRegular.copyWith(
                                                color: Colors.white,
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
                                width: 8.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    dataProduct.product.name.length > 75
                                    ? Text(
                                        dataProduct.product.name.substring(0, 80) + "...",
                                        maxLines: 2,
                                        style: poppinsRegular.copyWith(
                                          fontSize: 14.0,
                                        ),
                                      )
                                    : Text(
                                        dataProduct.product.name,
                                        maxLines: 2,
                                        style: poppinsRegular.copyWith(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(dataProduct.quantity.toString() + " barang " + "(" + (dataProduct.product.weight * dataProduct.quantity).toString() + " gr)",
                                      style: poppinsRegular.copyWith(
                                        fontSize: 12.0,
                                        color: ColorResources.PRIMARY,
                                      )
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(ConnexistHelper.formatCurrency(dataProduct.product.price),
                                      style: poppinsRegular.copyWith(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total Belanja",
                                    style: poppinsRegular.copyWith(
                                      color: Colors.black,
                                      fontSize: 12,
                                    )
                                  ),
                                  SizedBox(height: 8),
                                  Text(ConnexistHelper.formatCurrency(dataProduct.product.price * dataProduct.quantity),
                                    style: poppinsRegular.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    )
                                  ),
                                ],
                              ),
                              widget.status == "DELIVERED"
                              ? SizedBox(
                                  height: 40.0,
                                  width: 80.0,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0)
                                      ),
                                      backgroundColor: ColorResources.PRIMARY,
                                    ),
                                    child: Center(
                                      child: Text("Beli Lagi",
                                        style: poppinsRegular.copyWith(
                                          fontSize: 14.0,
                                          color: Colors.white
                                        )
                                      )
                                    ),
                                      onPressed: () async {
                                        if (dataProduct.product.stock < 1) {
                                          Fluttertoast.showToast(
                                            backgroundColor: ColorResources.SUCCESS,
                                            textColor: Colors.white,
                                            fontSize: 14.0,
                                            msg: "Stok Barang Habis",
                                          );
                                        } else {
                                          pr.show();
                                          Provider.of<WarungProvider>(context, listen: false).postAddCart(context, dataProduct.productId, dataProduct.product.minOrder).then((value) {
                                            if (value.code == 0) {
                                              pr.hide();
                                              Navigator.push(context,
                                                MaterialPageRoute(builder: (context) {
                                                return CartProdukPage();
                                              })).then((val) => val ? getRequests() : null);
                                            } else {
                                              pr.hide();
                                              Fluttertoast.showToast( 
                                                backgroundColor: ColorResources.ERROR,
                                                textColor: Colors.white,
                                                fontSize: 14.0,
                                                msg:"Terjadi kesalahan ketika tambah keranjang",
                                              );
                                            }
                                          });
                                        }
                                      }
                                    )
                                  )
                              : Container()
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList()
                ],
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Detail Pengiriman",
                    style: poppinsRegular.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    )
                  ),
                  if(transactionPaidSingle.body.wayBill != null)
                    SizedBox(height: 15.0),
                  if(transactionPaidSingle.body.wayBill != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text("No. Resi",
                            style: poppinsRegular.copyWith(
                              color: Colors.black,
                              fontSize: 14.0,
                            )
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                transactionPaidSingle.body.wayBill,
                                style: poppinsRegular.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text("Toko",
                          style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontSize: 14.0,
                          )
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(transactionPaidSingle.body.store.name,
                              style: poppinsRegular.copyWith(
                                color: Colors.black,
                                fontSize: 14.0,
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text("Asal",
                          style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontSize: 14.0,
                          )
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(transactionPaidSingle.body.store.city,
                              style: poppinsRegular.copyWith(
                                color: Colors.black,
                                fontSize: 14.0,
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text("Pembeli",
                          style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontSize: 14.0,
                          )
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(transactionPaidSingle.body.user.fullname,
                              style: poppinsRegular.copyWith(
                                color: Colors.black,
                                fontSize: 14.0,
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text("Tujuan",
                          style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                          )
                        ),
                      ),
                      Expanded(
                        child: Text(transactionPaidSingle.body.destShippingAddress.city,
                          style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontSize: 14.0,
                          )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text("Kurir",
                          style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                          )
                        ),
                      ),
                      Expanded(
                        child: Text(" ${transactionPaidSingle.body.deliveryCost.serviceName} - ${transactionPaidSingle.body.deliveryCost.courierName}",
                          style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontSize: 14.0,
                          )
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ),
              FutureBuilder<ShippingTrackingModel>(
                future: Provider.of<WarungProvider>(context, listen: false).getShippingTracking(context, transactionPaidSingle.body.id),
                builder: (BuildContext context, AsyncSnapshot<ShippingTrackingModel> snapshot) {
                  if (snapshot.hasData) {
                    final ShippingTrackingModel shippingTrackingModel = snapshot.data;
                    if(shippingTrackingModel?.body?.wayBillDelivery?.manifests == null || shippingTrackingModel?.body?.wayBillDelivery?.manifests?.length == 0) {
                      return Container();
                    }
                    return ListView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 6.0, right: 6.0),
                          child: Timeline.builder(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int i) {
                              return TimelineModel(
                                Container(
                                  margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 8.0),
                                          Text(shippingTrackingModel.body.wayBillDelivery.manifests[i].description),
                                          SizedBox(height: 8.0),
                                          Text(DateFormat('dd MMMM yyyy kk:mm').format(shippingTrackingModel.body.wayBillDelivery.manifests[i].date)),
                                          SizedBox(height: 8.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                iconBackground: ColorResources.PRIMARY,
                                position: TimelineItemPosition.right,
                                isFirst: i == 0,
                                isLast: i == shippingTrackingModel.body.wayBillDelivery.manifests.length,
                                icon: Icon(
                                  Icons.local_shipping,
                                  color: Colors.white,
                                )
                              );
                            },
                            itemCount: shippingTrackingModel.body.wayBillDelivery.manifests.length,
                            physics: BouncingScrollPhysics(),
                            position: TimelinePosition.Left
                          ),
                        ),
                      ],
                    );
                  } 
                  return Container(
                    height: 100.0,
                    child: Loader(
                      color: ColorResources.PRIMARY,
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Informasi Pembayaran",
                      style: poppinsRegular.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      )
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Harga Barang",
                            style: poppinsRegular.copyWith(
                              color: Colors.black,
                              fontSize: 14.0,
                            )
                          ),
                            Container(
                              child: Text(ConnexistHelper.formatCurrency(transactionPaidSingle.body.totalProductPrice),
                                style: poppinsRegular.copyWith(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                )
                              ),
                            )
                          ]
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Ongkos Kirim",
                            style: poppinsRegular.copyWith(
                              color: Colors.black,
                              fontSize: 14.0,
                            )
                          ),
                          Container(
                            child: Text(
                              ConnexistHelper.formatCurrency(transactionPaidSingle.body.deliveryCost.price),
                              style: poppinsRegular.copyWith(
                                color: Colors.black,
                                fontSize: 14.0,
                              )
                            ),
                          )
                        ]
                      ),
                    ),
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 16.0, right: 16.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total bayar",
                        style: poppinsRegular.copyWith(
                          color: Colors.black,
                          fontSize: 14.0,
                        )
                      ),
                      Container(
                        child: Text(ConnexistHelper.formatCurrency(transactionPaidSingle.body.totalProductPrice),
                          style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      )
                    ]
                  ),
                ),
              ),
              SizedBox(
                height: widget.status == "SHIPPING" ? 60 : 10,
              )
            ],
          ),
        ),
        widget.status == "DELIVERED" ? Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 60.0,
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5.0,
                  blurRadius: 7.0,
                  offset: Offset(0.0, 4.0), 
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> basket = Provider.of(context, listen: false);
                      await Provider.of<WarungProvider>(context, listen: false).postOrderDone(context, basket['idTrx']);
                    },
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                          color: ColorResources.PRIMARY
                        ),
                      child: Center(
                        child: Text("Barang Diterima",
                          style: poppinsRegular.copyWith(
                            color: Colors.white,
                            fontSize: 16.0
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ))
          ) : Container(),
        ],
      )
    );
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
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      message: 'Copied to Clipboard',
      duration: Duration(seconds: 2),
    )..show(context);
  }

  modalTrackingKurir(String idOrder) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.96,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)
                )
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.close)),
                            Container(
                              margin: EdgeInsets.only(left: 16.0),
                              child: Text("Detail Status Pengiriman",
                              style: poppinsRegular.copyWith(
                                  fontSize: 16.0,
                                  color: Colors.black
                                )
                              )
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 3.0,
                      ),
                      Expanded(
                        flex: 40,
                        child: FutureBuilder<ShippingTrackingModel>(
                          future: Provider.of<WarungProvider>(context, listen: false).getShippingTracking(context, idOrder),
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
                                      itemBuilder: (BuildContext context, int i) {
                                        return TimelineModel(
                                            Container(
                                              margin: EdgeInsets.only(
                                                top: 8.0, 
                                                bottom: 8.0
                                              ),
                                              child: Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0)
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: Padding(
                                                  padding: EdgeInsets.all(0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 8.0,
                                                      ),
                                                      Text(shippingTrackingModel.body.orderStatusInfos[i].progress),
                                                      SizedBox(
                                                        height: 8.0,
                                                      ),
                                                      Text(shippingTrackingModel.body.orderStatusInfos[i].handledBy),
                                                      SizedBox(
                                                        height: 8.0,
                                                      ),
                                                      Text(DateFormat('dd MMMM yyyy').format(DateTime.parse(shippingTrackingModel.body.orderStatusInfos[i].date))),
                                                      SizedBox(
                                                        height: 8.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            iconBackground: ColorResources.PRIMARY,
                                            position: TimelineItemPosition.right,
                                            isFirst: i == 0,
                                            isLast: i == shippingTrackingModel.body.orderStatusInfos.length,
                                            icon: Icon(
                                              Icons.local_shipping,
                                              color: Colors.white,
                                            )
                                          );
                                      },
                                      itemCount: shippingTrackingModel.body.orderStatusInfos.length,
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
              )
            )
          );
      },
    );
  }
}

class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius, radius)
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius, radius) 
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.drawStart != drawStart || oldDelegate.drawEnd != drawEnd;
  }
}