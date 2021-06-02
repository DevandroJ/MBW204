import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/data/models/warung/transaction_warung_paid_model.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/screens/warung/detail_penjualan_transaction_warung.dart';

class PenjualanTransactionWarungPage extends StatefulWidget {
  final int index;

  PenjualanTransactionWarungPage({
    Key key,
    @required this.index,
  }) : super(key: key);
  @override
  _PenjualanTransactionWarungPageState createState() =>
      _PenjualanTransactionWarungPageState();
}

class _PenjualanTransactionWarungPageState
    extends State<PenjualanTransactionWarungPage>
    with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: 4, vsync: this, initialIndex: widget.index);
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
        centerTitle: true,
        elevation: 0,
        title: Text( "Penjualan Saya"),
      ),
      body: Column(
        children: [
          TabBar(
            isScrollable: true,
            indicatorColor: ColorResources.PRIMARY,
            labelColor: Colors.black,
            tabs: [
              Tab(text: "Pesanan Baru"),
              Tab(text: "Siap Dikirim"),
              Tab(text: "Sedang Dikirim"),
              Tab(text: "Sampai Tujuan"),
              // Tab(text: "Selesai"),
            ],
            controller: tabController,
          ),
          Expanded(
            flex: 40,
            child: TabBarView(controller: tabController, children: [
              getTransactionSellerByStatus("RECEIVED"),
              getTransactionSellerByStatus("PACKING"),
              getTransactionSellerByStatus("SHIPPING"),
              getTransactionSellerByStatus("DELIVERED"),
              // Container(),
            ]),
          ),
          // getToken()
        ],
      ),
    );   
  }

  Widget getTransactionSellerByStatus(String status) {
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    return FutureBuilder<TransactionWarungPaidModel>(
      future: warungVM.getTransactionSellerPaid(context, status),
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
                      return DetailPenjualanTransactionWarungPage(
                          idTrx: transactionPaid.body[index].id,
                          typeUser: "seller",
                          status: status);
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
                        // ...transactionPaid.body[index].products
                        //     .map((dataProduct) {
                        //   return Container(
                        //     margin: EdgeInsets.only(bottom: 8),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: <Widget>[
                        //         Container(
                        //           width: 45,
                        //           height: 45,
                        //           child: Stack(
                        //             children: [
                        //               Container(
                        //                   width: double.infinity,
                        //                   height: double.infinity,
                        //                   decoration: BoxDecoration(
                        //                     borderRadius:
                        //                         BorderRadius.circular(8),
                        //                   ),
                        //                   child: ClipRRect(
                        //                     borderRadius:
                        //                         BorderRadius.circular(8),
                        //                     child: CachedNetworkImage(
                        //                       imageUrl: dataProduct.product
                        //                                   .pictures.length ==
                        //                               0
                        //                           ? ""
                        //                           : AppConstants.BASE_URL_FEED_IMG +
                        //                               dataProduct.product
                        //                                   .pictures.first.path,
                        //                       fit: BoxFit.cover,
                        //                       placeholder: (context, url) =>
                        //                           Center(
                        //                               child: Shimmer.fromColors(
                        //                         baseColor: Colors.grey[300],
                        //                         highlightColor:
                        //                             Colors.grey[100],
                        //                         child: Container(
                        //                           color: Colors.white,
                        //                           width: double.infinity,
                        //                           height: double.infinity,
                        //                         ),
                        //                       )),
                        //                       errorWidget:
                        //                           (context, url, error) =>
                        //                               Center(
                        //                                   child: Image.asset(
                        //                         "assets/default_image.png",
                        //                         fit: BoxFit.cover,
                        //                       )),
                        //                     ),
                        //                   )),
                        //               dataProduct.product.discount != null
                        //                   ? Align(
                        //                       alignment: Alignment.topLeft,
                        //                       child: Container(
                        //                         height: 20,
                        //                         width: 25,
                        //                         padding: EdgeInsets.all(5),
                        //                         decoration: BoxDecoration(
                        //                             borderRadius:
                        //                                 BorderRadius.only(
                        //                                     bottomRight: Radius
                        //                                         .circular(12),
                        //                                     topLeft:
                        //                                         Radius.circular(
                        //                                             12)),
                        //                             color: Colors.red[900]),
                        //                         child: Center(
                        //                           child: Text(
                        //                             dataProduct.product.discount
                        //                                     .discount
                        //                                     .toString()
                        //                                     .replaceAll(
                        //                                         RegExp(
                        //                                             r"([.]*0)(?!.*\d)"),
                        //                                         "") +
                        //                                 "%",
                        //                             style: TextStyle(
                        //                               color: Colors.white,
                        //                               fontSize: 10,
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     )
                        //                   : Container()
                        //             ],
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           width: 8,
                        //         ),
                        //         Expanded(
                        //           child: Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             children: <Widget>[
                        //               dataProduct.product.name.length > 75
                        //                   ? Text(
                        //                       dataProduct.product.name
                        //                               .substring(0, 80) +
                        //                           "...",
                        //                       maxLines: 2,
                        //                       style: TextStyle(
                        //                         fontSize: 15.0,
                        //                         fontWeight: FontWeight.bold,
                        //                       ),
                        //                     )
                        //                   : Text(
                        //                       dataProduct.product.name,
                        //                       maxLines: 2,
                        //                       style: TextStyle(
                        //                         fontSize: 15.0,
                        //                         fontWeight: FontWeight.bold,
                        //                       ),
                        //                     ),
                        //               SizedBox(
                        //                 height: 5,
                        //               ),
                        //               Text(
                        //                   dataProduct.quantity.toString() +
                        //                       " barang",
                        //                   style: TextStyle(
                        //                     fontSize: 12.0,
                        //                     color: ColorPalette.fontColor,
                        //                   )),
                        //               SizedBox(
                        //                 height: 5,
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   );
                        // }).toList(),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                            )),
                          ],
                        ),
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
                "Wah, Belum ada transaksi saat ini",
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
