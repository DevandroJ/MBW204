import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/screens/warung/detail_pesanan_transaction_warung.dart';
import 'package:mbw204_club_ina/data/models/warung/review_product_model.dart';
import 'package:mbw204_club_ina/data/models/warung/transaction_warung_paid_model.dart';
import 'package:mbw204_club_ina/data/models/warung/transaction_warung_unpaid_model.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/warung/review_product.dart';


class PesananTransactionWarungPage extends StatefulWidget {
  final int index;

  PesananTransactionWarungPage({
    Key key,
    @required this.index,
  }) : super(key: key);
  @override
  _PesananTransactionWarungPageState createState() =>
      _PesananTransactionWarungPageState();
}

class _PesananTransactionWarungPageState
    extends State<PesananTransactionWarungPage> with TickerProviderStateMixin {
  TabController tabController;
  ReviewProductModel reviewPM;
  bool isLoading = true;

  _getRequests() async {
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    await warungVM.getReviewProductList(context).then((value) {
      setState(() {
        isLoading = false;
        reviewPM = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getRequests();
    tabController = TabController(length: 6, vsync: this, initialIndex: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20.0,
            color: ColorResources.GREY,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        elevation: 0,
        title: Text("Pesanan Saya"),
      ),
      body: Column(
        children: [
          TabBar(
            isScrollable: true,
            indicatorColor: ColorResources.PRIMARY,
            labelColor: Colors.black,
            tabs: [
              Tab(text: "Belum Bayar"),
              Tab(text: "Menunggu Konfirmasi"),
              Tab(text: "Diproses"),
              Tab(text: "Dikirim"),
              Tab(text: "Tiba di Tujuan"),
              Tab(text: "Belum Diulas")
            ],
            controller: tabController,
          ),
          Expanded(
            flex: 40,
            child: TabBarView(controller: tabController, children: <Widget>[
              getUnpaidData(),
              getTransactionBuyerByStatus("RECEIVED"),
              getTransactionBuyerByStatus("PACKING"),
              getTransactionBuyerByStatus("SHIPPING"),
              getTransactionBuyerByStatus("DELIVERED"),
              getDataReviewProduct()
            ]),
          ),
          // getToken()
        ],
      ),
    );
  }

  Widget getUnpaidData() {
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    return FutureBuilder<TransactionWarungUnpaidModel>(
      future: warungVM.getTransactionUnpaid(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final TransactionWarungUnpaidModel transactionUnpaid = snapshot.data;
          if (transactionUnpaid.body == null) {
            return emptyTransaction();
          } else if (transactionUnpaid.body.length == 0) {
            return emptyTransaction();
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            physics: BouncingScrollPhysics(),
            itemCount: transactionUnpaid.body.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 16, bottom: 8),
                      child: Text(
                          transactionUnpaid.body[index].paymentRef.paymentGuide,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          )),
                    ),
                    SizedBox(height: 5),
                    Divider(
                      thickness: 8,
                      color: Colors.grey[100],
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              transactionUnpaid.body[index].paymentChannel.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              )),
                          ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl: transactionUnpaid.body[index].paymentChannel.logo,
                              height: 20,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Loader(
                                color: ColorResources.PRIMARY,
                              ),
                              errorWidget: (context, url, error) => Center(
                                  child: Image.asset(
                                "assets/default_image.png",
                                height: 20,
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(
                      thickness: 2,
                      color: Colors.grey[100],
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nomor Virtual Account",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              )),
                          SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  transactionUnpaid
                                      .body[index].paymentRef.paymentCode,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                          text: transactionUnpaid.body[index]
                                              .paymentRef.paymentCode))
                                      .then((result) {
                                    showFloatingFlushbar(context);
                                  });
                                },
                                child: Text("Salin",
                                    style: TextStyle(
                                      color: ColorResources.PRIMARY,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text("Total Pembayaran",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              )),
                          SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  ConnexistHelper.formatCurrency(
                                      transactionUnpaid
                                              .body[index].paymentRef.amount +
                                          transactionUnpaid.body[index]
                                              .paymentChannel.paymentFee),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                              GestureDetector(
                                onTap: () {
                                  _modalDetail(
                                      transactionUnpaid.body[index].stores,
                                      transactionUnpaid
                                          .body[index].totalProductPrice,
                                      transactionUnpaid
                                          .body[index].totalDeliveryCost,
                                      transactionUnpaid.body[index]
                                          .paymentChannel.paymentFee);
                                },
                                child: Text("Lihat Detail",
                                  style: TextStyle(
                                    color: ColorResources.PRIMARY,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.grey[100],
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        _modalGuide(
                            transactionUnpaid.body[index].paymentChannel.guide);
                      },
                      child: Center(
                        child: Text("Lihat Cara Pembayaran",
                            style: TextStyle(
                              color: ColorResources.PRIMARY,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            )),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              );
            },
          );
        }
        return loadingListUnPaid();
      },
    );
  }

  Widget getTransactionBuyerByStatus(String status) {
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    return FutureBuilder<TransactionWarungPaidModel>(
      future: warungVM.getTransactionBuyerPaid(context, status),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final TransactionWarungPaidModel transactionPaid = snapshot.data;
          if (transactionPaid.body == null) {
            return emptyTransaction();
          } else if (transactionPaid.body.length == 0) {
            return emptyTransaction();
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            physics: BouncingScrollPhysics(),
            itemCount: transactionPaid.body.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DetailPesananTransactionWarungPage(
                        idTrx: transactionPaid.body[index].id,
                        typeUser: "buyer",
                        status: status,
                      );
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_bag,
                                    color: ColorResources.PRIMARY),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Belanja",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        )),
                                    SizedBox(height: 2),
                                    Text(
                                        ConnexistHelper.formatDate(
                                            DateTime.parse(transactionPaid
                                                .body[index].created)),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        )),
                                  ],
                                )
                              ],
                            )),
                            Text(transactionPaid.body[index].orderStatus,
                                style: TextStyle(
                                  color: ColorResources.PRIMARY,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ))
                          ],
                        ),
                        SizedBox(height: 5),
                        Divider(
                          thickness: 2,
                          color: Colors.grey[100],
                        ),
                        SizedBox(height: 5),
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 45,
                                height: 45,
                                child: Stack(
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl: transactionPaid
                                                        .body[index]
                                                        .products
                                                        .first
                                                        .product
                                                        .pictures
                                                        .length ==
                                                    0
                                                ? ""
                                                : AppConstants.BASE_URL_FEED_IMG +
                                                    transactionPaid
                                                        .body[index]
                                                        .products
                                                        .first
                                                        .product
                                                        .pictures
                                                        .first
                                                        .path,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Center(
                                                    child: Shimmer.fromColors(
                                              baseColor: Colors.grey[300],
                                              highlightColor: Colors.grey[100],
                                              child: Container(
                                                color: Colors.white,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            )),
                                            errorWidget:
                                                (context, url, error) => Center(
                                                    child: Image.asset(
                                              "assets/default_image.png",
                                              fit: BoxFit.cover,
                                            )),
                                          ),
                                        )),
                                    transactionPaid.body[index].products.first
                                                .product.discount !=
                                            null
                                        ? Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              height: 20,
                                              width: 25,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  12),
                                                          topLeft:
                                                              Radius.circular(
                                                                  12)),
                                                  color: Colors.red[900]),
                                              child: Center(
                                                child: Text(
                                                  transactionPaid
                                                          .body[index]
                                                          .products
                                                          .first
                                                          .product
                                                          .discount
                                                          .discount
                                                          .toString()
                                                          .replaceAll(
                                                              RegExp(
                                                                  r"([.]*0)(?!.*\d)"),
                                                              "") +
                                                      "%",
                                                  style: TextStyle(
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
                                width: 8,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    transactionPaid.body[index].products.first
                                                .product.name.length >
                                            75
                                        ? Text(
                                            transactionPaid.body[index].products
                                                    .first.product.name
                                                    .substring(0, 80) +
                                                "...",
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Text(
                                            transactionPaid.body[index].products
                                                .first.product.name,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        transactionPaid.body[index].products
                                                .first.quantity
                                                .toString() +
                                            " barang",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: ColorResources.PRIMARY,
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        transactionPaid.body[index].products.length > 1
                            ? Text(
                                "+" +
                                    (transactionPaid
                                                .body[index].products.length -
                                            1)
                                        .toString() +
                                    " produk lainnya",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: ColorResources.PRIMARY,
                                ))
                            : Container(),
                        SizedBox(height: 20),
                        Text("Total Belanja",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            )),
                        SizedBox(height: 5),
                        Text(
                            ConnexistHelper.formatCurrency(
                                transactionPaid.body[index].totalPrice),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return loadingList();
      },
    );
  }

  Widget getDataReviewProduct() {
    return isLoading
        ? loadingListReview()
        : reviewPM.body == null
            ? emptyTransaction()
            : reviewPM.body.length == 0
                ? emptyTransaction()
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    physics: BouncingScrollPhysics(),
                    itemCount: reviewPM.body.length,
                    itemBuilder: (context, index) {
                      return Card(
                          elevation: 2,
                          margin: EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ReviewProductPage(
                                    idProduct: reviewPM.body[index].id,
                                    nameProduct: reviewPM.body[index].name,
                                    imgUrl: reviewPM
                                        .body[index].pictures.first.path);
                              })).then((val) => val ? _getRequests() : null);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  BorderRadius.circular(12),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: CachedNetworkImage(
                                                imageUrl: reviewPM.body[index]
                                                            .pictures.length ==
                                                        0
                                                    ? ""
                                                    : AppConstants.BASE_URL_FEED_IMG +
                                                        reviewPM
                                                            .body[index]
                                                            .pictures
                                                            .first
                                                            .path,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            Shimmer.fromColors(
                                                  baseColor: Colors.grey[300],
                                                  highlightColor:
                                                      Colors.grey[100],
                                                  child: Container(
                                                    color: Colors.white,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                )),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Center(
                                                            child: Image.asset(
                                                  "assets/default_image.png",
                                                  fit: BoxFit.cover,
                                                )),
                                              ),
                                            )),
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
                                        Text(
                                            ConnexistHelper.formatDate(
                                                DateTime.parse(
                                                    reviewPM.body[index].date)),
                                            style: TextStyle(
                                              color: ColorResources.PRIMARY,
                                              fontSize: 14,
                                            )),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        reviewPM.body[index].name.length > 30
                                            ? Text(
                                                reviewPM.body[index].name
                                                        .substring(0, 30) +
                                                    "...",
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                reviewPM.body[index].name,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        RatingBarIndicator(
                                          rating: 0,
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 30.0,
                                          direction: Axis.horizontal,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  );
  }

  Widget emptyTransaction() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            LottieBuilder.asset(
              "assets/lottie/empty_transaction.json",
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20),
            Container(
              child: Text(
                "Belum ada transaksi saat ini",
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

  void showFloatingFlushbar(BuildContext context) {
    Flushbar(
      // aroundPadding: EdgeInsets.all(10),
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

  _modalGuide(String guidePayment) {
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
                                  child: Text("Cara Pembayaran",
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
                          child: ListView(
                            padding: EdgeInsets.all(16),
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: [Html(data: guidePayment)],
                          ),
                        )
                      ],
                    ),
                  ],
                )));
      },
    );
  }

  _modalDetail(List<TransactionUnpaidStoreElement> stores,
      double totalProductPrice, double totalDeliveryCost, double adminfee) {
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
                                  child: Text("Detail Tagihan",
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
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: [
                              ...stores
                                  .asMap()
                                  .map((index, data) => MapEntry(
                                      index,
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Pesanan  " +
                                                        (index + 1).toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Container(
                                                        height: 30,
                                                        width: 30,
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                            color: ColorResources.PRIMARY),
                                                        child: Center(
                                                            child: Icon(
                                                                Icons.store,
                                                                color: Colors
                                                                    .white))),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(data.store.name,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(data.store.city,
                                                            style: TextStyle(
                                                              color: ColorResources.PRIMARY,
                                                              fontSize: 12,
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("No Invoice",
                                                        style: TextStyle(
                                                          color: ColorResources.PRIMARY,
                                                          fontSize: 12,
                                                        )),
                                                    SizedBox(height: 4),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(data.invoiceNo,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                ...data.items
                                                    .map((dataProduct) {
                                                  return Container(
                                                    margin:
                                                        EdgeInsets.only(top: 8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 60,
                                                          height: 60,
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: double
                                                                      .infinity,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl: dataProduct.product.pictures.length ==
                                                                              0
                                                                          ? ""
                                                                          : AppConstants.BASE_URL_FEED_IMG +
                                                                              dataProduct.product.pictures.first.path,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      placeholder: (context,
                                                                              url) =>
                                                                          Center(
                                                                              child: Shimmer.fromColors(
                                                                        baseColor:
                                                                            Colors.grey[300],
                                                                        highlightColor:
                                                                            Colors.grey[100],
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              Colors.white,
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              double.infinity,
                                                                        ),
                                                                      )),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Center(
                                                                              child: Image.asset(
                                                                        "assets/default_image.png",
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )),
                                                                    ),
                                                                  )),
                                                              dataProduct.product
                                                                          .discount !=
                                                                      null
                                                                  ? Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            25,
                                                                        padding:
                                                                            EdgeInsets.all(5),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.only(bottomRight: Radius.circular(12), topLeft: Radius.circular(12)),
                                                                            color: Colors.red[900]),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            dataProduct.product.discount.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") +
                                                                                "%",
                                                                            style:
                                                                                TextStyle(
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
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              dataProduct
                                                                          .product
                                                                          .name
                                                                          .length >
                                                                      75
                                                                  ? Text(
                                                                      dataProduct
                                                                              .product
                                                                              .name
                                                                              .substring(0, 80) +
                                                                          "...",
                                                                      maxLines:
                                                                          2,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      dataProduct
                                                                          .product
                                                                          .name,
                                                                      maxLines:
                                                                          2,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                      ),
                                                                    ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                  dataProduct
                                                                          .quantity
                                                                          .toString() +
                                                                      " barang " +
                                                                      "(" +
                                                                      (dataProduct.product.weight *
                                                                              dataProduct
                                                                                  .quantity)
                                                                          .toString() +
                                                                      " gr)",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                    color: ColorResources.PRIMARY,
                                                                  )),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                  ConnexistHelper.formatCurrency(
                                                                      dataProduct
                                                                          .product
                                                                          .price),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                                SizedBox(
                                                  height: 25,
                                                ),
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                      width: double.infinity,
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        color: Colors.white,
                                                      ),
                                                      child:
                                                          data.deliveryCost ==
                                                                  null
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Icon(
                                                                            Icons
                                                                                .local_shipping,
                                                                            color:
                                                                                ColorResources.PRIMARY),
                                                                        SizedBox(
                                                                          width:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                            "Pilih Pengiriman",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight.bold,
                                                                            ))
                                                                      ],
                                                                    )),
                                                                    SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Icon(
                                                                        Icons
                                                                            .arrow_forward_ios,
                                                                        color: Colors
                                                                            .grey)
                                                                  ],
                                                                )
                                                              : Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Expanded(
                                                                            child: Text(data.deliveryCost.serviceName,
                                                                                style: TextStyle(
                                                                                  fontSize: 15.0,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ))),
                                                                        // SizedBox(
                                                                        //   width:
                                                                        //       8,
                                                                        // ),
                                                                        // Icon(
                                                                        //     Icons.arrow_forward_ios,
                                                                        //     color: Colors.grey)
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1,
                                                                      color: Colors
                                                                              .grey[
                                                                          100],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Expanded(
                                                                            child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                              Text(data.deliveryCost.courierName,
                                                                                  style: TextStyle(
                                                                                    fontSize: 15.0,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  )),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              Text(ConnexistHelper.formatCurrency(data.deliveryCost.price), style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: ColorResources.PRIMARY)),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              Text("Estimasi tiba " + data.deliveryCost.estimateDays.replaceAll(RegExp(r"HARI"), "") + " Hari", style: TextStyle(fontSize: 14.0, color: ColorResources.PRIMARY)),
                                                                            ])),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            thickness: 12,
                                            color: Colors.grey[100],
                                          ),
                                        ],
                                      )))
                                  .values
                                  .toList(),
                              Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 88),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Text("Ringakasan Belanja",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Total Harga Barang",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                Container(
                                                  child: Text(
                                                      ConnexistHelper
                                                          .formatCurrency(
                                                              totalProductPrice),
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                )
                                              ]),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Ongkos Kirim",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                Container(
                                                  child: Text(
                                                      ConnexistHelper
                                                          .formatCurrency(
                                                              totalDeliveryCost),
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                )
                                              ]),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Biaya Admin",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                Container(
                                                  child: Text(
                                                      ConnexistHelper
                                                          .formatCurrency(
                                                              adminfee),
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                )
                                              ]),
                                        ),
                                        SizedBox(height: 8),
                                        Divider(
                                          thickness: 2,
                                          color: Colors.grey[100],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Total Pembayaran",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                Container(
                                                  child: Text(
                                                      ConnexistHelper.formatCurrency(
                                                          totalProductPrice +
                                                              totalDeliveryCost +
                                                              adminfee),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                )
                                              ]),
                                        ),
                                      ])),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                )));
      },
    );
  }

  Widget loadingListUnPaid() {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 8, top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 10,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white)),
                              SizedBox(height: 5),
                              Container(
                                  height: 10,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white)),
                              SizedBox(height: 5),
                              Container(
                                  height: 10,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(right: 32),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white)),
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Divider(
                  thickness: 8,
                  color: Colors.grey[100],
                ),
                SizedBox(height: 5),
                Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 10,
                                width: 120,
                                margin: EdgeInsets.only(right: 16, left: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white)),
                            Container(
                                height: 10,
                                width: 80,
                                margin: EdgeInsets.only(right: 16, left: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white)),
                          ],
                        ),
                      ],
                    )),
                SizedBox(height: 5),
                Divider(thickness: 2, color: Colors.grey[100]),
                SizedBox(height: 5),
                Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 10.0,
                          margin: EdgeInsets.only(right: 16, left: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 10,
                                width: 120,
                                margin: EdgeInsets.only(right: 16, left: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white)),
                            Container(
                                height: 10,
                                width: 40,
                                margin: EdgeInsets.only(right: 16, left: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white)),
                          ],
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: 80,
                          height: 10.0,
                          margin: EdgeInsets.only(right: 16, left: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 10,
                                width: 100,
                                margin: EdgeInsets.only(right: 16, left: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white)),
                            Container(
                                height: 10,
                                width: 60,
                                margin: EdgeInsets.only(right: 16, left: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white)),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    )),
                SizedBox(height: 5),
                Divider(thickness: 2, color: Colors.grey[100]),
                SizedBox(height: 5),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Center(
                    child: Container(
                        height: 10,
                        width: 120,
                        margin: EdgeInsets.only(right: 16, left: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white)),
                  ),
                ),
                SizedBox(height: 14),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget loadingList() {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.white)),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 10,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.white)),
                                  SizedBox(height: 2),
                                  Container(
                                      height: 10,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.white)),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                            height: 10,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(
                      thickness: 2,
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white)),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                height: 10,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white)),
                            SizedBox(height: 5),
                            Container(
                                height: 10,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 80,
                      height: 10.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 60,
                      height: 10.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget loadingListReview() {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white)),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                height: 10,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white)),
                            SizedBox(height: 5),
                            Container(
                                height: 10,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
