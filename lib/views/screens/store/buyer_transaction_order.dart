import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/views/screens/store/store_index.dart';
import 'package:mbw204_club_ina/views/screens/store/buyer_detail_order_transaction.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/models/warung/review_product_model.dart';
import 'package:mbw204_club_ina/data/models/warung/transaction_warung_paid_model.dart';
import 'package:mbw204_club_ina/data/models/warung/transaction_warung_unpaid_model.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/store/review_product.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionOrderScreen extends StatefulWidget {
  final int index;

  TransactionOrderScreen({
    Key key,
    @required this.index,
  }) : super(key: key);
  @override
  _TransactionOrderScreenState createState() => _TransactionOrderScreenState();
}

class _TransactionOrderScreenState extends State<TransactionOrderScreen> with TickerProviderStateMixin {
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
    tabController = TabController(length: 7, vsync: this, initialIndex: widget.index);
  }

  Future<bool> onWillPop() {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StoreScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 20.0,
              color: ColorResources.PRIMARY,
            ),
            onPressed: onWillPop,
          ),
          centerTitle: true,
          elevation: 0.0,
          title: Text("Pesanan Saya",
            style: poppinsRegular.copyWith(
              color: ColorResources.PRIMARY
            ),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              isScrollable: true,
              indicatorColor: ColorResources.PRIMARY,
              labelColor: Colors.black,
              labelStyle: poppinsRegular,
              tabs: [
                Tab(text: "Belum Bayar"),
                Tab(text: "Menunggu Konfirmasi"),
                Tab(text: "Diproses"),
                Tab(text: "Dikirim"),
                Tab(text: "Tiba di Tujuan"),
                Tab(text: "Selesai"),
                Tab(text: "Belum Diulas"),
              ],
              controller: tabController,
            ),
            Expanded(
              flex: 40,
              child: TabBarView(
                controller: tabController, 
                physics: NeverScrollableScrollPhysics(),
                children: [
                  getUnpaidData(),
                  getTransactionBuyerByStatus("RECEIVED"),
                  getTransactionBuyerByStatus("PACKING"),
                  getTransactionBuyerByStatus("SHIPPING"),
                  getTransactionBuyerByStatus("DELIVERED"),
                  getTransactionBuyerByStatus("DONE"),
                  getDataReviewProduct()
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getUnpaidData() {
    return FutureBuilder<TransactionWarungUnpaidModel>(
      future: Provider.of<WarungProvider>(context, listen: false).getTransactionUnpaid(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final TransactionWarungUnpaidModel transactionUnpaid = snapshot.data;
          if (transactionUnpaid.body == null) {
            return emptyTransaction();
          } else if (transactionUnpaid.body.length == 0) {
            return emptyTransaction();
          }
          return RefreshIndicator(
            backgroundColor: ColorResources.PRIMARY,
            color: ColorResources.WHITE,
            onRefresh: () {
              return Provider.of<WarungProvider>(context, listen: false).getTransactionUnpaid(context);
            },
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              physics: BouncingScrollPhysics(),
              itemCount: transactionUnpaid.body.length,
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: Colors.grey
                    ),
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Transaksi #",
                              style: poppinsRegular.copyWith(
                                color: Colors.grey[600],
                                fontSize: 14.0,
                              )
                            ),
                            SelectableText("${transactionUnpaid.body[i].paymentRef.refNo}",
                              style: poppinsRegular.copyWith(
                                color: Colors.green[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              )
                            ),
                          ],
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 2.0, bottom: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tanggal",
                              style: poppinsRegular.copyWith(
                                color: Colors.grey[600],
                                fontSize: 14.0,
                              )
                            ),
                            Text(DateFormat('dd MMMM yyyy kk:mm').format(DateTime.parse(transactionUnpaid.body[i].billCreated)),
                              style: poppinsRegular.copyWith(
                                color: Colors.grey[600],
                                fontSize: 14.0,
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(height: 2.0),
                      Divider(
                        thickness: 8.0,
                        color: Colors.grey[100],
                      ),
                      SizedBox(height: 6.0),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              transactionUnpaid.body[i].paymentChannel.name,
                              style: poppinsRegular.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              )
                            ),
                            ClipRRect(
                              child: CachedNetworkImage(
                                imageUrl: transactionUnpaid.body[i].paymentChannel.logo,
                                height: 20.0,
                                fit: BoxFit.cover,
                                placeholder: (BuildContext context, String url) => Loader(
                                  color: ColorResources.PRIMARY,
                                ),
                                errorWidget: (BuildContext context, String url, dynamic error) => Center(
                                  child: Image.asset("assets/images/default_image.png",
                                    height: 20.0,
                                    fit: BoxFit.cover,
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2.0,
                        color: Colors.grey[100],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nomor ${transactionUnpaid.body[i].paymentChannel.category}",
                              style: poppinsRegular.copyWith(
                                color: Colors.grey[600],
                                fontSize: 14.0,
                              )
                            ),
                            SizedBox(height: 2.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SelectableText(transactionUnpaid.body[i].paymentRef.paymentCode,
                                  style: poppinsRegular.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  )
                                ),
                              ],
                            ),
                            SizedBox(height: 6.0),
                            Text("Total Pembayaran",
                              style: poppinsRegular.copyWith(
                                color: Colors.grey[600],
                                fontSize: 14.0,
                              )
                            ),
                            SizedBox(height: 6.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ConnexistHelper.formatCurrency(transactionUnpaid.body[i].paymentRef.amount + transactionUnpaid.body[i].paymentChannel.paymentFee),
                                  style: poppinsRegular.copyWith(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
                                InkWell(
                                  onTap: () {
                                    modalDetail(
                                      transactionUnpaid.body[i].stores,
                                      transactionUnpaid.body[i].totalProductPrice,
                                      transactionUnpaid.body[i].totalDeliveryCost,
                                      transactionUnpaid.body[i].paymentChannel.paymentFee
                                    );
                                  },
                                  child: Text("Lihat Detail",
                                    style: poppinsRegular.copyWith(
                                      color: ColorResources.PRIMARY,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    )
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.0),
                            Text(transactionUnpaid.body[i].paymentRef.paymentGuide,
                              style: poppinsRegular.copyWith(
                                color: Colors.grey[600],
                                fontSize: 14.0,
                              )
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2.0,
                        color: Colors.grey[100],
                      ),
                      SizedBox(height: 5.0),
                      InkWell(
                        onTap: () async {
                          try {
                            await launch("${AppConstants.BASE_URL_PAYMENT_BILLING}/${transactionUnpaid.body[i].paymentRef.refNo}");
                          } catch(e) {
                            print(e);
                          }
                        },
                        child: Center(
                          child: Text("Lihat Cara Pembayaran",
                            style: poppinsRegular.copyWith(
                              color: ColorResources.PRIMARY,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            )
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return loadingListUnPaid();
      },
    );
  }

  Widget getTransactionBuyerByStatus(String status) {
    return FutureBuilder<TransactionWarungPaidModel>(
      future: Provider.of<WarungProvider>(context, listen: false).getTransactionBuyerPaid(context, status),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final TransactionWarungPaidModel transactionPaid = snapshot.data;
          if (transactionPaid.body == null) {
            return emptyTransaction();
          } else if (transactionPaid.body.length == 0) {
            return emptyTransaction();
          }
          return RefreshIndicator(
            backgroundColor: ColorResources.PRIMARY,
            color: ColorResources.WHITE,
            onRefresh: () {
              return Provider.of<WarungProvider>(context, listen: false).getTransactionBuyerPaid(context, status);
            },
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: transactionPaid.body.length,
              itemBuilder: (BuildContext context, int i) {
                return Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
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
                                Icon(
                                  Icons.shopping_bag,
                                  color: ColorResources.PRIMARY
                                ),
                                SizedBox(width: 8.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Belanja",
                                      style: poppinsRegular.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                      )
                                    ),
                                    SizedBox(height: 2.0),
                                    Text(DateFormat('dd MMMM yyyy kk:mm').format(DateTime.parse(transactionPaid.body[i].created)),
                                      style: poppinsRegular.copyWith(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                      )
                                    ),
                                    Text('ORDER ID #${transactionPaid.body[i].id}',
                                      style: poppinsRegular.copyWith(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                      )
                                    ),
                                  ],
                                )
                              ],
                            )),
                            Text(transactionPaid.body[i].orderStatus,
                              style: poppinsRegular.copyWith(
                                color: ColorResources.PRIMARY,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              )
                            )
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Divider(
                          thickness: 2.0,
                          color: Colors.grey[100],
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          margin: EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${transactionPaid.body[i].products.first.product.pictures.first.path}",
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
                                          errorWidget: (BuildContext context, String url, dynamic error) => Center(
                                            child: Image.asset("assets/images/default_image.png",
                                            fit: BoxFit.cover,
                                          )
                                        ),
                                      ),
                                    )),
                                    transactionPaid.body[i].products.first.product.discount != null
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
                                          color: Colors.red[900]),
                                          child: Center(
                                            child: Text(
                                              transactionPaid.body[i].products.first.product.discount.discount.toString().replaceAll(RegExp("([.]*0)(?!.*\d)"),"") + "%",
                                              style: poppinsRegular.copyWith(
                                                color: Colors.white,
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          transactionPaid.body[i].products.first.product.name,
                                          maxLines: 2,
                                          style: poppinsRegular.copyWith(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Map<String, dynamic> basket = Provider.of(context, listen: false);
                                            basket.addAll({
                                              "idTrx": transactionPaid.body[i].id
                                            });
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) {
                                              return DetailBuyerTransactionScreen(
                                                typeUser: "buyer",
                                                status: status
                                              );
                                            }));
                                          },
                                          child: Text("Lihat detail",
                                            style: poppinsRegular.copyWith(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(transactionPaid.body[i].products.first.quantity.toString() +" barang",
                                      style: poppinsRegular.copyWith(
                                        fontSize: 12.0,
                                        color: ColorResources.PRIMARY,
                                      )
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.0),
                        transactionPaid.body[i].products.length > 1
                        ? Text("+" + (transactionPaid.body[i].products.length - 1).toString() +" produk lainnya",
                          style: poppinsRegular.copyWith(
                            fontSize: 12.0,
                            color: ColorResources.PRIMARY,
                          ))
                        : Container(),
                        SizedBox(height: 20.0),
                        Text("Total Belanja",
                          style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontSize: 12.0,
                          )
                        ),
                        SizedBox(height: 5.0),
                        Text(ConnexistHelper.formatCurrency(transactionPaid.body[i].totalProductPrice),
                          style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          )
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
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
          elevation: 2.0,
          margin: EdgeInsets.only(bottom: 8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                return ReviewProductPage(
                  idProduct: reviewPM.body[index].id,
                  nameProduct: reviewPM.body[index].name,
                  imgUrl: reviewPM.body[index].pictures.first.path
                );
              })).then((val) => val ? _getRequests() : null);
            },
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
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
                            borderRadius:  BorderRadius.circular(12.0),
                            child: CachedNetworkImage(
                              imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${reviewPM.body[index].pictures.first.path}",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[100],
                                child: Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              )),
                              errorWidget: (context, url, error) => Center(
                                child: Image.asset(
                                  "assets/images/efault_image.png",
                                  fit: BoxFit.cover,
                                )
                              ),
                            ),
                          )
                        ),
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
                      children: [
                        Text(ConnexistHelper.formatDate(DateTime.parse(reviewPM.body[index].date)),
                          style: poppinsRegular.copyWith(
                            color: ColorResources.PRIMARY,
                            fontSize: 14.0,
                          )
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        reviewPM.body[index].name.length > 30
                        ? Text(reviewPM.body[index].name.substring(0, 30) + "...",
                            maxLines: 1,
                            style: poppinsRegular.copyWith(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        : Text(reviewPM.body[index].name,
                          maxLines: 1,
                          style: poppinsRegular.copyWith(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        RatingBarIndicator(
                          rating: 0.0,
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
          )
        );
      },
    );
  }

  Widget emptyTransaction() {
    return RefreshIndicator(
      backgroundColor: ColorResources.PRIMARY,
      color: ColorResources.WHITE,
      onRefresh: () {
        return Future.delayed(Duration(seconds: 2), () {
          Provider.of<WarungProvider>(context, listen: false).getTransactionBuyerPaid(context, "RECEIVED");
          Provider.of<WarungProvider>(context, listen: false).getTransactionBuyerPaid(context, "PACKING");
          Provider.of<WarungProvider>(context, listen: false).getTransactionBuyerPaid(context, "SHIPPING");
          Provider.of<WarungProvider>(context, listen: false).getTransactionBuyerPaid(context, "DELIVERED");
          Provider.of<WarungProvider>(context, listen: false).getTransactionBuyerPaid(context, "DONE");
        });
      },
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset("assets/lottie/no-transaction.json",
                    height: 200.0,
                    width: 200.0,
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    child: Text("Belum ada transaksi saat ini",
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
          )
        ],
      ),
    );
  }

  modalGuide(String guidePayment) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // enableDrag: true,
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
                          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 8),
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
                                      style: poppinsRegular.copyWith(
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
                )
              )
            );
      },
    );
  }

  modalDetail(List<TransactionUnpaidStoreElement> stores, double totalProductPrice, double totalDeliveryCost, double adminfee) {
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
                            child: Icon(
                              Icons.close
                            )
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 16),
                            child: Text("Detail Tagihan",
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
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          ...stores.asMap().map((index, data) => MapEntry(index,
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Pesanan  " + (index + 1).toString(),
                                              style: poppinsRegular.copyWith(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold
                                              )
                                            ),
                                            SizedBox(height: 10.0),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 30.0,
                                                  width: 30.0,
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(40.0),
                                                    color: ColorResources.PRIMARY
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.store,
                                                      color: Colors.white
                                                      )
                                                    )
                                                  ),
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(data.store.name,
                                                      style: poppinsRegular.copyWith(
                                                        color: Colors.black,
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.bold
                                                      )
                                                    ),
                                                    Text(data.store.city,
                                                      style: poppinsRegular.copyWith(
                                                        color: ColorResources.PRIMARY,
                                                        fontSize: 12.0,
                                                      )
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.0),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("No Invoice",
                                                  style: poppinsRegular.copyWith(
                                                    color: ColorResources.PRIMARY,
                                                    fontSize: 12.0,
                                                  )
                                                ),
                                                SizedBox(height: 4.0),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(data.invoiceNo,
                                                      style: poppinsRegular.copyWith(
                                                        color: Colors.black,
                                                        fontSize: 14.0,
                                                      )
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                            ...data.items.map((dataProduct) {
                                              return Container(
                                                margin: EdgeInsets.only(top: 8),
                                                child: Row(
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
                                                            child:
                                                              ClipRRect(
                                                              borderRadius:BorderRadius.circular(12.0),
                                                              child: CachedNetworkImage(
                                                                imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${dataProduct.product.pictures.first.path}",
                                                                fit: BoxFit.cover,
                                                                placeholder: (context, url) => Center(
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
                                                                errorWidget: (context, url, error) => Center(
                                                                  child: Image.asset(
                                                                    "assets/default_image.png",
                                                                    fit: BoxFit.cover,
                                                                  )
                                                                ),
                                                              ),
                                                            )
                                                          ),
                                                          dataProduct.product.discount !=  null
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
                                                                fontSize: 15.0,
                                                              ),
                                                            )
                                                          : Text(dataProduct.product .name,
                                                              maxLines:2,
                                                              style: poppinsRegular.copyWith(
                                                                fontSize: 15.0,
                                                              ),
                                                            ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Text(dataProduct.quantity.toString() + " barang " + "(" + (dataProduct.product.weight * dataProduct.quantity).toString() +" gr)",
                                                            style: poppinsRegular.copyWith(
                                                              fontSize: 12.0,
                                                              color: ColorResources.PRIMARY,
                                                            )
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Text(
                                                            ConnexistHelper.formatCurrency(dataProduct.product.price),
                                                            style: poppinsRegular.copyWith(
                                                              fontSize: 16.0,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold,
                                                            )
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                            SizedBox(
                                              height: 25.0,
                                            ),
                                            SizedBox(
                                              height: 4.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        thickness: 12.0,
                                        color: Colors.grey[100],
                                      ),
                                    ],
                                  )
                                )
                              ).values.toList(),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 88.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    child: Text("Ringakasan Belanja",
                                      style: poppinsRegular.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                      )
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total Harga Barang",
                                          style: poppinsRegular.copyWith(
                                            color: Colors.black
                                          )
                                        ),
                                        Container(
                                          child: Text(ConnexistHelper.formatCurrency(totalProductPrice),
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black
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
                                          color: Colors.black
                                        )),
                                        Container(
                                          child: Text(
                                            ConnexistHelper.formatCurrency(totalDeliveryCost),
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black
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
                                        Text("Biaya Admin",
                                          style: poppinsRegular.copyWith(
                                            color: Colors.black
                                          )
                                        ),
                                        Container(
                                          child: Text(
                                            ConnexistHelper .formatCurrency(adminfee),
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black
                                            )
                                          ),
                                        )
                                      ]
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Divider(
                                    thickness: 2,
                                    color: Colors.grey[100],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 8),
                                    child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total Pembayaran",
                                          style: poppinsRegular.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          )
                                        ),
                                        Container(
                                          child: Text(
                                            ConnexistHelper.formatCurrency(totalProductPrice + totalDeliveryCost + adminfee),
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            )
                                          ),
                                        )
                                      ]
                                    ),
                                  ),
                                ]
                              )
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )
          )
        );
      },
    );
  }

  Widget loadingListUnPaid() {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(16.0),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
                        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 10.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white
                              )
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              height: 10.0,
                              width: double.infinity,
                              margin: EdgeInsets.only(right: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white
                              )
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              height: 10.0,
                              width: double.infinity,
                              margin: EdgeInsets.only(right: 32),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white
                              )
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                Divider(
                  thickness: 8.0,
                  color: Colors.grey[100],
                ),
                SizedBox(height: 5.0),
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
                            height: 10.0,
                            width: 120.0,
                            margin: EdgeInsets.only(right: 16.0, left: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.white
                            )
                          ),
                          Container(
                            height: 10.0,
                            width: 80.0,
                            margin: EdgeInsets.only(right: 16.0, left: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                                color: Colors.white
                            )
                          ),
                        ],
                      ),
                    ],
                  )
                ),
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
                        width: 100.0,
                        height: 10.0,
                        margin: EdgeInsets.only(right: 16.0, left: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Container(
                          height: 10.0,
                          width: 120.0,
                          margin: EdgeInsets.only(right: 16.0, left: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.white
                            )
                          ),
                        Container(
                          height: 10.0,
                          width: 40.0,
                          margin: EdgeInsets.only(right: 16, left: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white
                            )
                          ),
                        ],
                      ),
                        SizedBox(height: 15.0),
                        Container(
                          width: 80.0,
                          height: 10.0,
                          margin: EdgeInsets.only(right: 16, left: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 10.0,
                              width: 100.0,
                              margin: EdgeInsets.only(right: 16.0, left: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.white
                                )
                              ),
                            Container(
                              height: 10.0,
                              width: 60.0,
                              margin: EdgeInsets.only(right: 16.0, left: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.white
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                      ],
                    )
                  ),
                SizedBox(height: 5.0),
                Divider(
                  thickness: 2.0, 
                  color: Colors.grey[100]
                ),
                SizedBox(height: 5.0),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Center(
                    child: Container(
                      height: 10.0,
                      width: 120.0,
                      margin: EdgeInsets.only(right: 16.0, left: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white
                      )
                    ),
                  ),
                ),
                SizedBox(height: 14.0),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            child: Padding(
              padding: EdgeInsets.all(16.0),
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
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white
                          )
                      ),
                        SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 10.0,
                              width: 120.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.white
                              )
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              height: 10.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.white
                              )
                            ),
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
