import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/data/models/warung/address_model.dart';
import 'package:mbw204_club_ina/data/models/warung/card_add_model.dart';
import 'package:mbw204_club_ina/providers/region.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/warung/pilih_alamat.dart';
import 'package:mbw204_club_ina/views/screens/warung/pilih_pembayaran_warung.dart';
import 'package:mbw204_club_ina/views/screens/warung/pilih_pengiriman.dart';

class PengirimanPage extends StatefulWidget {
  @override
  _PengirimanPageState createState() => _PengirimanPageState();
}

class _PengirimanPageState extends State<PengirimanPage> {
  AddressModel addressModel;
  CartModel cartModel;
  bool isLoading = true;
  bool isLoadingCart = true;

  @override
  void initState() {
    super.initState();
    _getRequestsCart();
  }

  _getRequests() async {
    await Provider.of<RegionProvider>(context, listen: false).getDataAddress(context).then((value) {
      setState(() {
        addressModel = value;
        isLoading = false;
      });
    });
  }

  _getRequestsCart() async {
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    await warungVM.getCartInfo(context).then((val) {
      setState(() {
        isLoadingCart = false;
        cartModel = val;
        _getRequests();
      });
    });
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
          onPressed: () => Navigator.of(context).pop()
        ),
        centerTitle: true,
        elevation: 0,
        title: Text( "Pengiriman"),
      ),
      body: isLoadingCart
          ? Loader(
            color: ColorResources.PRIMARY
          )
          : Stack(children: [
              ListView(physics: BouncingScrollPhysics(), children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text( "Alamat Pengiriman",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return PilihAlamatPage(
                                  title: "Pilih Alamat Pengiriman",
                                );
                              })).then((val) => val ? _getRequestsCart() : null);
                            },
                            child: Text("Pilih Alamat Lain",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: ColorResources.PRIMARY,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Divider(
                        thickness: 2,
                        color: Colors.grey[100],
                      ),
                      SizedBox(height: 4),
                      isLoading
                          ? loadingList(1)
                          : addressModel.body.length == 0
                              ? Text("Silahkan pilih alamat pengiriman Anda.",
                                  style: TextStyle(
                                    color: ColorResources.PRIMARY,
                                    fontSize: 12,
                                  ))
                              : ListView(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    ...addressModel.body
                                        .where((element) =>
                                            element.defaultLocation == true)
                                        .map((alamatList) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(alamatList.name,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 5),
                                          Text(alamatList.phoneNumber,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              )),
                                          SizedBox(height: 3),
                                          Text(alamatList.address,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              )),
                                          // SizedBox(height: 4),
                                        ],
                                      );
                                    }).toList()
                                  ],
                                ),
                    ],
                  ),
                ),
                // SizedBox(height: 5),
                Divider(
                  thickness: 12,
                  color: Colors.grey[100],
                ),
                ...cartModel.body.stores
                    .asMap()
                    .map((index, data) => MapEntry(
                        index,
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Pesanan  " + (index + 1).toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                          height: 30,
                                          width: 30,
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              color: ColorResources.PRIMARY),
                                          child: Center(
                                              child: Icon(Icons.store,
                                                  color: Colors.white))),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(data.store.name,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                          Text(data.store.city,
                                              style: TextStyle(
                                                color: ColorResources.PRIMARY,
                                                fontSize: 12,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  ...data.items.map((dataProduct) {
                                    return Container(
                                      margin: EdgeInsets.only(top: 8),
                                      child: Row(
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
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: CachedNetworkImage(
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
                                                          baseColor:
                                                              Colors.grey[300],
                                                          highlightColor:
                                                              Colors.grey[100],
                                                          child: Container(
                                                            color: Colors.white,
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                          ),
                                                        )),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Center(
                                                                child:
                                                                    Image.asset(
                                                          "assets/default_image.png",
                                                          fit: BoxFit.cover,
                                                        )),
                                                      ),
                                                    )),
                                                dataProduct.product.discount !=
                                                        null
                                                    ? Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Container(
                                                          height: 20,
                                                          width: 25,
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomRight: Radius
                                                                      .circular(
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
                                                                          RegExp(
                                                                              r"([.]*0)(?!.*\d)"),
                                                                          "") +
                                                                  "%",
                                                              style: TextStyle(
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
                                                        dataProduct.product.name
                                                                .substring(
                                                                    0, 80) +
                                                            "...",
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                        ),
                                                      )
                                                    : Text(
                                                        dataProduct
                                                            .product.name,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: 15.0,
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
                                                      color: ColorResources.PRIMARY,
                                                    )),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    ConnexistHelper
                                                        .formatCurrency(
                                                            dataProduct
                                                                .product.price),
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                    onTap: () {
                                      if (cartModel.body.shippingAddress != null) {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return PilihPengirimanPage(idStore: data.storeId);
                                        })).then((val) => val ? _getRequestsCart() : null);
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Anda belum memilih alamat",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.white,
                                      ),
                                      child: data.deliveryCost == null
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                            Icon(
                                              Icons.local_shipping,
                                              color: ColorResources.PRIMARY
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                            Text("Pilih Pengiriman",
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight:
                                                    FontWeight.bold,
                                              )
                                            )
                                          ],
                                        )),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey
                                        )
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(data.deliveryCost.serviceName,
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                )
                                              )
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.grey
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Divider(
                                          thickness: 1.0,
                                          color: Colors.grey[100],
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(data.deliveryCost.courierName,
                                                    style: TextStyle(
                                                      fontSize:  15.0,
                                                      fontWeight: FontWeight.bold,
                                                    )
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    ConnexistHelper.formatCurrency(data.deliveryCost.price),
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: ColorResources.PRIMARY
                                                    )
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Text( "Estimasi tiba " + data.deliveryCost.estimateDays.replaceAll(RegExp(r"HARI"), "") + " Hari",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: ColorResources.PRIMARY
                                                    )
                                                  ),
                                                ]
                                              )
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
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
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 88),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text("Ringakasan Belanja",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total Harga",
                                      style: TextStyle(color: Colors.black)),
                                  Container(
                                    child: Text(
                                        ConnexistHelper.formatCurrency(
                                            cartModel.body.totalProductPrice +
                                                cartModel.body.serviceCharge),
                                        style: TextStyle(color: Colors.black)),
                                  )
                                ]),
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(top: 8),
                          //   child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Text("Service",
                          //             style: TextStyle(color: Colors.black)),
                          //         Container(
                          //           child: Text(
                          //               ConnexistHelper.formatCurrency(
                          //                   cartModel.body.serviceCharge),
                          //               style: TextStyle(color: Colors.black)),
                          //         )
                          //       ]),
                          // ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Ongkos Kirim",
                                      style: TextStyle(color: Colors.black)),
                                  Container(
                                    child: Text(
                                        ConnexistHelper.formatCurrency(
                                            cartModel.body.totalDeliveryCost),
                                        style: TextStyle(color: Colors.black)),
                                  )
                                ]),
                          ),
                        ])),
              ]),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: 70,
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 50,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Total Tagihan",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorResources.PRIMARY),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                        ConnexistHelper.formatCurrency(cartModel
                                                .body.totalProductPrice +
                                            cartModel.body.totalDeliveryCost +
                                            cartModel.body.serviceCharge),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              bool active = false;
                              for (int i = 0;
                                  i < cartModel.body.stores.length;
                                  i++) {
                                if (cartModel.body.stores[i].deliveryCost !=
                                    null) {
                                  active = true;
                                } else {
                                  active = false;

                                  break;
                                }
                              }
                              active 
                              ? Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                  return PilihPembayaranWarungPage();
                                }))
                              : Fluttertoast.showToast(
                                msg: "Anda belum memilih metode pengiriman",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white
                              );
                            },
                            child: Container(
                              width: 170,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: ColorResources.PRIMARY),
                              child: Center(
                                child: Text(
                                  "Pilih Pembayaran",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )))
            ]),
    );
  }

  Widget loadingList(int index) {
    return Container(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: index,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 12.0,
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white),
                ),
                Container(
                  width: 120,
                  height: 12.0,
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white),
                ),
                Container(
                  width: 180,
                  height: 12.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
