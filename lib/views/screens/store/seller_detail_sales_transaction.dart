import 'dart:developer';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:timelines/timelines.dart' as t;
import 'package:flushbar/flushbar.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/views/basewidget/custom_dropdown.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/models/warung/shipping_tracking_model.dart';
import 'package:mbw204_club_ina/data/models/warung/transaction_warung_paid_single_model.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';

class DetailSellerTransactionScreen extends StatefulWidget {
  final String typeUser;
  final String status;

  DetailSellerTransactionScreen({Key key,
    @required this.typeUser,
    @required this.status})
    : super(key: key);
  @override
  _DetailSellerTransactionScreenState createState() => _DetailSellerTransactionScreenState();
}

class _DetailSellerTransactionScreenState extends State<DetailSellerTransactionScreen> {
  TransactionWarungPaidSingleModel transactionPaidSingle;
  bool isLoading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Color completeColor = Color(0xff5e6172);
  Color inProgressColor = Color(0xff5ec792);
  Color todoColor = Color(0xffd1d2d7);

  final _processes = [
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
    (() async {
      Map<String, dynamic> basket = Provider.of(context, listen: false);
      await Provider.of<WarungProvider>(context, listen: false).getTransactionPaidSingle(context, basket['idTrx'], widget.typeUser).then((value) {
        setState(() {
          isLoading = false;
          transactionPaidSingle = value;
        });
      });
    })();
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<WarungProvider>(context, listen: false).getPickupTimeslots(context);
    Provider.of<WarungProvider>(context, listen: false).getDimenstionSize(context);
    Provider.of<WarungProvider>(context, listen: false).getApproximatelyVolumes(context);

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
        elevation: 0.0,
      ),
      body: isLoading
      ? Center(
          child: Loader(
            color: ColorResources.PRIMARY,
          ),
        )
      : Stack(
        children: [
          RefreshIndicator(
            backgroundColor: ColorResources.PRIMARY,
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
                          fontSize: 14.0
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
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...transactionPaidSingle.body.products.map((dataProduct) {
                        return Container(    
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.grey,
                            )
                          ),
                          padding: EdgeInsets.all(16.0),
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
                                              placeholder: (BuildContext context, String url) => Center(
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.grey[300],
                                                  highlightColor: Colors.grey[100],
                                                  child: Container(
                                                    color: Colors.white,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                )
                                              ),
                                              errorWidget: (BuildContext context, String url, dynamic error) =>
                                                Center(
                                                  child: Image.asset("assets/images/default_image.png",
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
                                                  bottomRight:Radius.circular(12.0),
                                                  topLeft: Radius.circular(12.0)
                                                ),
                                                  color: Colors.red[900]
                                                ),
                                              child: Center(
                                                child: Text(dataProduct.product.discount.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
                                                  style: poppinsRegular.copyWith(
                                                    color: ColorResources.WHITE,
                                                    fontSize: 10.0,
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
                                        ? Text(dataProduct.product.name.substring(0, 80) + "...",
                                            maxLines: 2,
                                            style: poppinsRegular.copyWith(
                                              fontSize: 14.0,
                                            ),
                                          )
                                        : Text(dataProduct.product.name,
                                            maxLines: 2,
                                            style: poppinsRegular.copyWith(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(dataProduct.quantity.toString() + " barang " +  "(" + (dataProduct.product.weight * dataProduct.quantity).toString() + " gr)",
                                          style: poppinsRegular.copyWith(
                                            fontSize: 12.0,
                                            color: ColorResources.PRIMARY
                                          )
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(ConnexistHelper.formatCurrency(dataProduct.sellerPrice),
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
                              Divider(
                                thickness: 2.0,
                                color: Colors.grey[100],
                              ),
                              SizedBox(height: 8.0),
                              Text("Total Belanja",
                                style: poppinsRegular.copyWith(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                )
                              ),
                              SizedBox(height: 8.0),
                              Text(ConnexistHelper.formatCurrency(dataProduct.sellerPrice *  dataProduct.quantity),
                                style: poppinsRegular.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                )
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
                        // Container(
                        //   alignment: Alignment.topRight,
                        //   margin: EdgeInsets.only(top: 0.0, right: 0.0),
                        //   child: InkWell(
                        //     onTap: () {
                        //       Clipboard.setData(ClipboardData(
                        //         text: transactionPaidSingle.body.wayBill))
                        //         .then((result) {
                        //           showFloatingFlushbar(context);
                        //         });
                        //     },
                        //     child: Text("Salin No. Resi",
                        //       style: poppinsRegular.copyWith(
                        //         color: ColorResources.PRIMARY,
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 10.0,
                        //       )
                        //     ),
                        //   ),
                        // ),
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
                        SizedBox(height: 8.0),
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
                                child: Text(ConnexistHelper.formatCurrency(transactionPaidSingle.body.sellerProductPrice),
                                  style: poppinsRegular.copyWith(
                                    color: Colors.black,
                                    fontSize: 14.0
                                  )
                                ),
                              )
                            ]
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8.0),
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
                                child: Text(ConnexistHelper.formatCurrency(transactionPaidSingle.body.deliveryCost.price),
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
                // Divider(
                //   thickness: 2.0,
                //   color: Colors.grey[100],
                // ),
                // Padding(
                //   padding: EdgeInsets.all(16),
                //   child: Container(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text("Total bayar",
                //           style: poppinsRegular.copyWith(
                //             color: Colors.black,
                //             fontSize: 14.0,
                //           )
                //         ),
                //         Container(
                //           child: Text(ConnexistHelper.formatCurrency(transactionPaidSingle.body.totalProductPrice + transactionPaidSingle.body.deliveryCost.price),
                //             style: poppinsRegular.copyWith(
                //               color: Colors.black,
                //               fontSize: 14.0,
                //               fontWeight: FontWeight.bold
                //             )
                //           ),
                //         )
                //       ]
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: widget.status == "RECEIVED"
                  ? 60.0
                  : widget.status == "PACKING"
                  ? 110.0
                  : 10.0,
                )
              ],
            ),
          ),
          widget.status == "RECEIVED"
          ? Align(
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
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 4), 
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> basket = Provider.of(context, listen: false);
                          await Provider.of<WarungProvider>(context, listen: false).postOrderPacking(context, basket['idTrx']);
                        },
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: ColorResources.PRIMARY
                          ),
                          child: Center(
                            child: Text("Konfirmasi Pesanan",
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
                )
              )
            )
          : widget.status == "PACKING"
          ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80.0,
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
                    offset: Offset(0, 4.0), 
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: () async {
                        if(transactionPaidSingle.body.deliveryCost.courierId == "jne") {
                          Map<String, dynamic> basket = Provider.of(context, listen: false);
                          await Provider.of<WarungProvider>(context, listen: false).bookingCourier(context, basket['idTrx'], transactionPaidSingle.body.deliveryCost.courierId);
                        } else if(transactionPaidSingle.body.deliveryCost.courierId == "ninja") {
                          showAnimatedDialog(
                            context: context, 
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    height: 690.0,
                                    decoration: BoxDecoration(
                                      color: ColorResources.WHITE,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 300.0,
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 0.5,
                                            )
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 10.0, top: 5.0),
                                                child: Text("Pickup",
                                                  style: poppinsRegular.copyWith(
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      flex: 2,
                                                      child: Text("Date :",
                                                        style: poppinsRegular,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 3,
                                                      child: Consumer<WarungProvider>(
                                                        builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
                                                          return Container(
                                                            child: DateTimePicker(
                                                              initialValue: warungProvider.dataDatePickup,
                                                              expands: false,
                                                              firstDate: DateTime(2000),
                                                              lastDate: DateTime(2100),
                                                              style: poppinsRegular,
                                                              decoration: InputDecoration(
                                                                labelStyle: poppinsRegular,
                                                                hintStyle: poppinsRegular,
                                                                isDense: true,
                                                                contentPadding: EdgeInsets.only(bottom: 0.0, top: 0.0, left: 0.0, right: 0.0),
                                                                floatingLabelBehavior: FloatingLabelBehavior.never
                                                              ),
                                                              onChanged: (val) { 
                                                                warungProvider.changeDatePickup(val);
                                                              },
                                                              onSaved: (val) {
                                                                warungProvider.changeDatePickup(val);
                                                              },  
                                                            ),
                                                          );                                          
                                                        },
                                                      ) 
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 12.0, right: 12.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text("Timeslots :",
                                                        style: poppinsRegular,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Consumer<WarungProvider>(
                                                        builder:(BuildContext context, WarungProvider warungProvider, Widget child) {
                                                          if(warungProvider.pickupTimeslotsStatus == PickupTimeslotsStatus.loading) {
                                                            return Shimmer.fromColors(
                                                              baseColor: Colors.grey[200], 
                                                              highlightColor: Colors.grey[300],
                                                              child: Container(
                                                                margin: EdgeInsets.only(top: 5.0),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(10.0)
                                                                ),
                                                                width: 300.0,
                                                                height: 40.0,
                                                                child: Container(),
                                                              ),
                                                            );
                                                          }                    
                                                          return Container(
                                                            width: 120.0,
                                                            margin: EdgeInsets.only(bottom: 18.0),
                                                            child: CustomDropDownFormField(
                                                              titleText: 'Timeslots',
                                                              hintText: 'Timeslots',
                                                              contentPadding: EdgeInsets.only(bottom: 0.0, top: 0.0, left: 0.0, right: 0.0),
                                                              value: warungProvider.dataPickupTimeslots,
                                                              filled: false,
                                                              onSaved: (val) {
                                                                warungProvider.changePickupTimeSlots(val);
                                                              },
                                                              onChanged: (val) {  
                                                                warungProvider.changePickupTimeSlots(val);
                                                              },
                                                              dataSource: warungProvider.pickupTimeslots,
                                                              textField: 'name',
                                                              valueField: 'name',
                                                            ),
                                                          );                          
                                                        },
                                                      )
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ),
                                        Container(
                                          width: 300.0,
                                          margin: EdgeInsets.only(top: 8.0),
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 0.5,
                                            )
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 10.0, top: 5.0),
                                                child: Text("Delivery",
                                                  style: poppinsRegular.copyWith(
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 12.0, right: 12.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text("Timeslots :",
                                                        style: poppinsRegular,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Consumer<WarungProvider>(
                                                        builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
                                                          if(warungProvider.pickupTimeslotsStatus == PickupTimeslotsStatus.loading) {
                                                            return Shimmer.fromColors(
                                                              baseColor: Colors.grey[200], 
                                                              highlightColor: Colors.grey[300],
                                                              child: Container(
                                                                margin: EdgeInsets.only(top: 5.0),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(10.0)
                                                                ),
                                                                width: 300.0,
                                                                height: 40.0,
                                                                child: Container(),
                                                              ),
                                                            );
                                                          }       
                                                          return Container(
                                                            width: 140.0,
                                                            margin: EdgeInsets.only(bottom: 18.0),
                                                            child: CustomDropDownFormField(
                                                              titleText: 'Delivery Timeslots',
                                                              hintText: 'Delivery Timeslots',
                                                              contentPadding: EdgeInsets.zero,
                                                              value: warungProvider.dataDeliveryTimeslots,
                                                              filled: false,
                                                              onSaved: (val) {
                                                                warungProvider.changeDeliveryTimeSlots(val);
                                                              },
                                                              onChanged: (val) {  
                                                                warungProvider.changeDeliveryTimeSlots(val);
                                                              },
                                                              dataSource: warungProvider.pickupTimeslots,
                                                              textField: 'name',
                                                              valueField: 'name',
                                                            ),
                                                          );                          
                                                        },
                                                      )
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 12.0, right: 12.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text("Approx Volumes :",
                                                        style: poppinsRegular,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Consumer<WarungProvider>(
                                                        builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
                                                          if(warungProvider.pickupTimeslotsStatus == PickupTimeslotsStatus.loading) {
                                                            return Shimmer.fromColors(
                                                              baseColor: Colors.grey[200], 
                                                              highlightColor: Colors.grey[300],
                                                              child: Container(
                                                                margin: EdgeInsets.only(top: 5.0),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(10.0)
                                                                ),
                                                                width: 300.0,
                                                                height: 40.0,
                                                                child: Container(),
                                                              ),
                                                            );
                                                          }                    
                                                          return Container(
                                                            
                                                            margin: EdgeInsets.only(bottom: 18.0),
                                                            child: CustomDropDownFormField(
                                                              titleText: 'Approx Volumes',
                                                              hintText: 'Approx Volumes',
                                                              contentPadding: EdgeInsets.only(bottom: 0.0, top: 0.0, left: 0.0, right: 0.0),
                                                              value: warungProvider.dataApproximatelyVolumes,
                                                              filled: false,
                                                              onSaved: (val) {
                                                                warungProvider.changeApproximatelyVolumes(val);
                                                              },
                                                              onChanged: (val) {  
                                                                warungProvider.changeApproximatelyVolumes(val);
                                                              },
                                                              dataSource: warungProvider.approximatelyVolumes,
                                                              textField: 'name',
                                                              valueField: 'name',
                                                            ),
                                                          );                          
                                                        },
                                                      )
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ),  
                                        Container(
                                          width: 300.0,
                                          margin: EdgeInsets.only(top: 8.0),
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 0.5,
                                            )
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 10.0, top: 5.0),
                                                child: Text("Dimensions",
                                                  style: poppinsRegular.copyWith(
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 14.0, right: 14.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text("Size",
                                                        style: poppinsRegular,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Consumer<WarungProvider>(
                                                        builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
                                                          if(warungProvider.pickupTimeslotsStatus == PickupTimeslotsStatus.loading) {
                                                            return Shimmer.fromColors(
                                                              baseColor: Colors.grey[200], 
                                                              highlightColor: Colors.grey[300],
                                                              child: Container(
                                                                margin: EdgeInsets.only(top: 5.0),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(10.0)
                                                                ),
                                                                width: 300.0,
                                                                height: 40.0,
                                                                child: Container(),
                                                              ),
                                                            );
                                                          }                    
                                                          return Container(
                                                            margin: EdgeInsets.only(bottom: 18.0),
                                                            child: CustomDropDownFormField(
                                                              titleText: 'Size',
                                                              hintText: 'Size',
                                                              // contentPadding: EdgeInsets.only(bottom: 9.0),
                                                              value: warungProvider.dataDimensionsSize,
                                                              filled: false,
                                                              onSaved: (val) {
                                                                warungProvider.changeDimensionsSize(val);
                                                              },
                                                              onChanged: (val) {  
                                                                warungProvider.changeDimensionsSize(val);
                                                              },
                                                              dataSource: warungProvider.dimensionsSize,
                                                              textField: 'name',
                                                              valueField: 'name',
                                                            ),
                                                          );                          
                                                        },
                                                      )
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 4.0, left: 14.0, right: 14.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text("Height",
                                                        style: poppinsRegular,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(context).accentColor,
                                                          borderRadius: BorderRadius.circular(6.0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.1), 
                                                              spreadRadius: 1.0, 
                                                              blurRadius: 3.0, 
                                                              offset: Offset(0.0, 1.0)
                                                            )
                                                          ],
                                                        ),
                                                        child: Consumer<WarungProvider>(
                                                          builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
                                                            return TextFormField(
                                                              onChanged: (val) {
                                                                if(val != "") {
                                                                  warungProvider.changeDimensionsHeight(int.parse(val));
                                                                }
                                                              },
                                                              cursorColor: ColorResources.BLACK,
                                                              maxLines: 1,
                                                              keyboardType: TextInputType.number,
                                                              initialValue: null,
                                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                              decoration: InputDecoration(
                                                                hintText: '',
                                                                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                                                                isDense: true,
                                                                hintStyle: poppinsRegular.copyWith(
                                                                  color: Theme.of(context).hintColor
                                                                ),
                                                                suffix: Text("CM"),
                                                                errorStyle: TextStyle(height: 1.5),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: Colors.grey,
                                                                    width: 0.5
                                                                  ),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: Colors.grey,
                                                                    width: 0.5
                                                                  ),
                                                                ),
                                                              ),
                                                            );                                                  
                                                          },
                                                        )                                                    
                                                      )
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 8.0, left: 14.0, right: 14.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text("Length :",
                                                        style: poppinsRegular,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(context).accentColor,
                                                          borderRadius: BorderRadius.circular(6.0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.1), 
                                                              spreadRadius: 1.0, 
                                                              blurRadius: 3.0, 
                                                              offset: Offset(0.0, 1.0)
                                                            )
                                                          ],
                                                        ),
                                                        child: Consumer<WarungProvider>(
                                                          builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
                                                            return TextFormField(
                                                              onChanged: (val) {
                                                                if(val != "") {
                                                                  warungProvider.changeDimensionsLength(int.parse(val));
                                                                }
                                                              },
                                                              cursorColor: ColorResources.BLACK,
                                                              maxLines: 1,
                                                              keyboardType: TextInputType.number,
                                                              initialValue: null,
                                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                              decoration: InputDecoration(
                                                                hintText: '',
                                                                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                                                                isDense: true,
                                                                hintStyle: poppinsRegular.copyWith(
                                                                  color: Theme.of(context).hintColor
                                                                ),
                                                                suffix: Text("CM"),
                                                                errorStyle: TextStyle(height: 1.5),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: Colors.grey,
                                                                    width: 0.5
                                                                  ),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: Colors.grey,
                                                                    width: 0.5
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      )
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 8.0, left: 14.0, right: 14.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text("Width",
                                                        style: poppinsRegular,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Consumer<WarungProvider>(
                                                        builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
                                                          return TextFormField(
                                                            onChanged: (val) {
                                                              if(val != "") {
                                                                warungProvider.changeDimensionsWidth(int.parse(val));
                                                              }
                                                            },
                                                            cursorColor: ColorResources.BLACK,
                                                            maxLines: 1,
                                                            keyboardType: TextInputType.number,
                                                            initialValue: null,
                                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                            decoration: InputDecoration(
                                                              hintText: '',
                                                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                                                              isDense: true,
                                                              hintStyle: poppinsRegular.copyWith(
                                                                color: Theme.of(context).hintColor
                                                              ),
                                                              suffix: Text("CM"),
                                                              errorStyle: TextStyle(height: 1.5),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Colors.grey,
                                                                  width: 0.5
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Colors.grey,
                                                                  width: 0.5
                                                                ),
                                                              ),
                                                            ),
                                                          );                                                   
                                                        },
                                                      )
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(top: 8.0, left: 13.0, right: 13.0),
                                          child: TextButton(
                                            onPressed: () async{
                                              Map<String, dynamic> basket = Provider.of(context, listen: false);
                                              try {
                                                if(Provider.of<WarungProvider>(context,listen: false).dataPickupTimeslots.isEmpty || Provider.of<WarungProvider>(context,listen: false).dataPickupTimeslots == null) {
                                                  Fluttertoast.showToast(
                                                    backgroundColor: ColorResources.ERROR,
                                                    textColor: ColorResources.WHITE,
                                                    fontSize: 14.0,
                                                    msg: "Pickup Timeslots is Required",
                                                  );
                                                  return;
                                                }
                                                if(Provider.of<WarungProvider>(context,listen: false).dataDeliveryTimeslots.isEmpty || Provider.of<WarungProvider>(context,listen: false).dataDeliveryTimeslots == null) {
                                                  Fluttertoast.showToast(
                                                    backgroundColor: ColorResources.ERROR,
                                                    textColor: ColorResources.WHITE,
                                                    fontSize: 14.0,
                                                    msg: "Delivery Timeslots is Required",
                                                  );
                                                  return;
                                                }
                                                if(Provider.of<WarungProvider>(context,listen: false).dataDimensionsSize.isEmpty || Provider.of<WarungProvider>(context,listen: false).dataDimensionsSize == null) {
                                                  Fluttertoast.showToast(
                                                    backgroundColor: ColorResources.ERROR,
                                                    textColor: ColorResources.WHITE,
                                                    fontSize: 14.0,
                                                    msg: "Dimensions Size is Required",
                                                  );
                                                  return;
                                                }
                                                if(Provider.of<WarungProvider>(context,listen: false).dataDimensionsHeight == 0 || Provider.of<WarungProvider>(context,listen: false).dataDimensionsHeight == null) {
                                                  Fluttertoast.showToast(
                                                    backgroundColor: ColorResources.ERROR,
                                                    textColor: ColorResources.WHITE,
                                                    fontSize: 14.0,
                                                    msg: "Dimensions Height is Required",
                                                  );
                                                  return;
                                                }
                                                 if(Provider.of<WarungProvider>(context,listen: false).dataDimensionsLength == 0 || Provider.of<WarungProvider>(context,listen: false).dataDimensionsLength == null) {
                                                  Fluttertoast.showToast(
                                                    backgroundColor: ColorResources.ERROR,
                                                    textColor: ColorResources.WHITE,
                                                    fontSize: 14.0,
                                                    msg: "Dimensions Length is Required",
                                                  );
                                                  return;
                                                }
                                                 if(Provider.of<WarungProvider>(context,listen: false).dataDimensionsWidth == 0 || Provider.of<WarungProvider>(context,listen: false).dataDimensionsWidth == null) {
                                                  Fluttertoast.showToast(
                                                    backgroundColor: ColorResources.ERROR,
                                                    textColor: ColorResources.WHITE,
                                                    fontSize: 14.0,
                                                    msg: "Dimensions Width is Required",
                                                  );
                                                  return;
                                                }
                                                if(Provider.of<WarungProvider>(context,listen: false).dataApproximatelyVolumes.isEmpty || Provider.of<WarungProvider>(context,listen: false).dataApproximatelyVolumes == null) {
                                                  Fluttertoast.showToast(
                                                    backgroundColor: ColorResources.ERROR,
                                                    textColor: ColorResources.WHITE,
                                                    fontSize: 14.0,
                                                    msg: "Approximately Volumes is Required",
                                                  );
                                                  return;
                                                }
                                                await Provider.of<WarungProvider>(context, listen: false).bookingCourier(context, basket['idTrx'], transactionPaidSingle.body.deliveryCost.courierId);
                                              } catch(e) {

                                              }
                                            }, 
                                            style: TextButton.styleFrom(
                                              backgroundColor: ColorResources.PRIMARY
                                            ),
                                            child: Text("Submit", 
                                              style: poppinsRegular.copyWith(
                                                color: ColorResources.WHITE
                                              )
                                            )
                                          ),
                                        )
                                      ],
                                    )
                                  ),
                                ),
                              );
                            }
                          );
                        }
                      },
                      child: Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:  BorderRadius.circular(10.0),
                          color: ColorResources.PRIMARY),
                        child: Center(
                          child: Text("Booking Courier",
                            style: poppinsRegular.copyWith(
                              color: Colors.white,
                              fontSize: 16.0
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            )
          )
          : Container()
        ],
      )
    );
  }

  void showFloatingFlushbar(BuildContext context) {
    Flushbar(
      margin: EdgeInsets.all(10.0),
      borderRadius: 8.0,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      message: 'Copied to Clipboard',
      duration: Duration(seconds: 1),
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
                            final ShippingTrackingModel shippingTrackingModel = snapshot.data;
                            return ListView(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: [
                                Timeline.builder(
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
                                                Text(DateFormat('dd MMMM yyyy').format(shippingTrackingModel.body.wayBillDelivery.manifests[i].date)),
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
                                )
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