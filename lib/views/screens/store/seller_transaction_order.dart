import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/views/screens/store/seller_store.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/data/models/warung/transaction_warung_paid_model.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/screens/store/seller_detail_sales_transaction.dart';

class SellerTransactionOrderScreen extends StatefulWidget {
  final int index;

  SellerTransactionOrderScreen({
    Key key,
    @required this.index,
  }) : super(key: key);
  @override
  _SellerTransactionOrderScreenState createState() => _SellerTransactionOrderScreenState();
}

class _SellerTransactionOrderScreenState extends State<SellerTransactionOrderScreen> with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this, initialIndex: widget.index);
  }

  var progress = ['ORDER_PAID','ORDER_PACKED','ORDER_PICKUP', 'ORDER_SHIPPED', 'ORDER_DELIVERED', 'ORDER_COMPLETED'];

  Future<bool> onWillPop() {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SellerStoreScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorResources.BTN_PRIMARY,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 20.0,
              color: ColorResources.WHITE,
            ),
            onPressed: onWillPop
          ),
          centerTitle: true,
          elevation: 0.0,
          title: Text("Penjualan Saya",
            style: poppinsRegular.copyWith(
              color: ColorResources.WHITE
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
                Tab(text: "Pesanan Baru"),
                Tab(text: "Siap Dikirim"),
                Tab(text: "Sedang Dikirim"),
                Tab(text: "Sampai Tujuan"),
                Tab(text: "Selesai"),
              ],
              controller: tabController,
            ),
            Expanded(
              flex: 40,
              child: TabBarView(
                controller: tabController, 
                physics: NeverScrollableScrollPhysics(),
                children: [
                  getTransactionSellerByStatus("RECEIVED"),
                  getTransactionSellerByStatus("PACKING"),
                  getTransactionSellerByStatus("PICKUP,SHIPPING"),
                  getTransactionSellerByStatus("DELIVERED"),
                  getTransactionSellerByStatus("DONE"),
                ]
              ),
            ),
            // getToken()
          ],
        ),
      ),
    );   
  }

  Widget getTransactionSellerByStatus(String status) {
    return FutureBuilder<TransactionWarungPaidModel>(
      future: Provider.of<WarungProvider>(context, listen: false).getTransactionSellerPaid(context, status),
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
              return Future.delayed(Duration(seconds: 2), () {
                Provider.of<WarungProvider>(context, listen: false).getTransactionSellerPaid(context, "RECEIVED");
                Provider.of<WarungProvider>(context, listen: false).getTransactionSellerPaid(context, "PACKING");
                Provider.of<WarungProvider>(context, listen: false).getTransactionSellerPaid(context, "PICKUP,SHIPPING");
                Provider.of<WarungProvider>(context, listen: false).getTransactionSellerPaid(context, "DELIVERED");
                Provider.of<WarungProvider>(context, listen: false).getTransactionSellerPaid(context, "DONE");
              });
            },
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: transactionPaid.body.length,
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
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
                                width: 45.0,
                                height: 45.0,
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
                                          placeholder: (BuildContext context, String url) =>
                                            Center(
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
                                          errorWidget:(BuildContext context, String url, dynamic error) => Center(
                                            child: Image.asset(
                                            "assets/images/default_image.png",
                                            fit: BoxFit.cover,
                                          )
                                        ),  
                                      ),
                                    )
                                  ),
                                  transactionPaid.body[i].products.first.product.discount != null
                                    ? Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          height: 20.0,
                                          width: 25.0,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(12.0),
                                            topLeft: Radius.circular(12.0)
                                          ),
                                          color: Colors.red[900]),
                                          child: Center(
                                            child: Text(transactionPaid.body[i].products.first.product.discount.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"),"") + "%",
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
                                              return DetailSellerTransactionScreen(
                                                typeUser: "seller",
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
                                    Text(transactionPaid.body[i].products.first.quantity.toString() + " barang",
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
                        ? Text("+" + (transactionPaid.body[i].products.length - 1).toString() + " produk lainnya",
                          style: poppinsRegular.copyWith(
                            fontSize: 12.0,
                            color: ColorResources.PRIMARY,
                          )
                        )
                        : Container(),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total Belanja",
                                    style: poppinsRegular.copyWith(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                    )
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(ConnexistHelper.formatCurrency(transactionPaid.body[i].sellerProductPrice),
                                    style: poppinsRegular.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    )
                                  ),
                                ],
                              )
                            ),
                          ],
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

  Widget loadingList() {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.only(bottom: 8.0),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                height: 25.0,
                                width: 25.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: Colors.white
                                )
                              ),
                              SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 10.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Colors.white
                                    )
                                  ),
                                  SizedBox(height: 2.0),
                                  Container(
                                    height: 10.0,
                                    width: 60.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white
                                    )
                                  ),
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
                            color: Colors.white
                          )
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Divider(
                      thickness: 2.0,
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 45.0,
                          width: 45.0,
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
                            SizedBox(height: 5),
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
                    SizedBox(height: 30.0),
                    Container(
                      width: 80.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      width: 60.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white
                      ),
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
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              "assets/lottie/no-transaction.json",
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20),
            Container(
              child: Text(
                "Wah, Belum ada transaksi saat ini",
                textAlign: TextAlign.center,
                style: poppinsRegular.copyWith(
                  fontSize: 18,
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
