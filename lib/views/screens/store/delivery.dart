import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mbw204_club_ina/data/models/warung/address_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/models/warung/card_add_model.dart';
import 'package:mbw204_club_ina/providers/region.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/store/select_address.dart';
import 'package:mbw204_club_ina/views/screens/store/select_payment.dart';
import 'package:mbw204_club_ina/views/screens/store/select_delivery.dart';

class PengirimanPage extends StatefulWidget {
  @override
  _PengirimanPageState createState() => _PengirimanPageState();
}

class _PengirimanPageState extends State<PengirimanPage> {
  
  @override
  Widget build(BuildContext context) {

    Provider.of<WarungProvider>(context, listen: false).getCartInfo(context);
    Provider.of<RegionProvider>(context, listen: false).getDataAddress(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20.0,
            color: ColorResources.PRIMARY,
          ),
          onPressed: () => Navigator.of(context).pop()
        ),
        centerTitle: true,
        elevation: 0,
        title: Text("Pengiriman",
          style: poppinsRegular.copyWith(
            color: ColorResources.PRIMARY
          ),
        ),
      ),
      body: Consumer<WarungProvider>(
        builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
          if(warungProvider.cartStatus == CartStatus.loading) {
            return Loader(
              color: ColorResources.PRIMARY,
            );
          }
          return Stack(
            children: [
            ListView(
              physics: BouncingScrollPhysics(),
              children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Alamat Pengiriman",
                          style: poppinsRegular.copyWith(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return PilihAlamatPage(
                                title:"Pilih Alamat Pengiriman",
                              );
                            }));
                          },
                          child: Text("Pilih Alamat Lain",
                            style: poppinsRegular.copyWith(
                              fontSize: 14.0,
                              color: ColorResources.PRIMARY,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Divider(
                      thickness: 2.0,
                      color: Colors.grey[100],
                    ),
                    SizedBox(height: 4.0),
                    Consumer<RegionProvider>(
                      builder: (BuildContext context, RegionProvider regionProvider, Widget child) {
                        if(regionProvider.getAddressStatus == GetAddressStatus.loading) {
                          return Loader(
                            color: ColorResources.PRIMARY,
                          );
                        }
                        List<AddressList> addresses =  regionProvider.addresList.where((el) => el.defaultLocation == true).toList();
                        return regionProvider.addresList.length == 0
                          ? Text("Silahkan pilih alamat pengiriman Anda.",
                              style: poppinsRegular.copyWith(
                                color: ColorResources.PRIMARY,
                                fontSize: 12.0,
                              )
                            )
                          : ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: addresses.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(addresses[i].name,
                                    style: poppinsRegular.copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  SizedBox(height: 5),
                                  Text(addresses[i].phoneNumber,
                                    style: poppinsRegular.copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                    )
                                  ),
                                  SizedBox(height: 3),
                                  Text(addresses [i].address,
                                    style: poppinsRegular.copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                    )
                                  ),
                                ],
                              );
                            },
                          );
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 12.0,
                color: Colors.grey[100],
              ),
              ...warungProvider.cartBody.stores
                  .asMap()
                  .map((int i, StoreElement data) => MapEntry(
                      i,
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Pesanan  " + (i + 1).toString(),
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
                                      padding: EdgeInsets.all(2.0),
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
                                SizedBox(
                                  height: 8.0,
                                ),
                                ...data.items.map((dataProduct) {
                                  return Container(
                                    margin: EdgeInsets.only(top: 8.0),
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
                                                    borderRadius: BorderRadius.circular(12.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: "${AppConstants.BASE_URL_FEED_IMG + dataProduct.product.pictures.first.path}",
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
                                          width: 8,
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
                                                    fontSize: 15.0,
                                                  ),
                                                )
                                              : Text(dataProduct.product.name,
                                                  maxLines: 2,
                                                  style: poppinsRegular.copyWith(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(dataProduct.quantity.toString() + " barang " + "(" + (dataProduct.product.weight * dataProduct.quantity) .toString() + " gr)",
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
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                  fontWeight:FontWeight.bold,
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
                                GestureDetector(
                                  onTap: () {
                                    if (warungProvider.cartBody?.shippingAddress != null) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return PilihPengirimanPage(idStore: data.storeId);
                                      }));
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Anda belum memilih alamat",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: ColorResources.ERROR,
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
                                    child: data.shippingRate == null
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
                                            style: poppinsRegular.copyWith(
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
                                            child: Text(data.shippingRate.serviceType,
                                              style: poppinsRegular.copyWith(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              )
                                            )
                                          ),
                                          SizedBox(
                                            width: 8.0,
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
                                      Column(
                                        children: [
                                          Text(data.shippingRate.courierName,
                                            style: poppinsRegular.copyWith(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            )
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(data.shippingRate.serviceName,
                                                  style: poppinsRegular.copyWith(
                                                    fontSize:  15.0,
                                                    fontWeight: FontWeight.bold,
                                                  )
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  ConnexistHelper.formatCurrency(data.shippingRate.price),
                                                  style: poppinsRegular.copyWith(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorResources.PRIMARY
                                                  )
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text( "Estimasi tiba " + data.shippingRate.estimateDays.replaceAll(RegExp(r"HARI"), "") + " Hari",
                                                style: poppinsRegular.copyWith(
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
                              Text("Total Harga", style: poppinsRegular.copyWith(color: Colors.black)),
                              Container(
                                child: Text(
                                  ConnexistHelper.formatCurrency(warungProvider.cartBody.totalProductPrice + warungProvider.cartBody.serviceCharge),
                                  style: poppinsRegular.copyWith(
                                    color: Colors.black
                                  )
                                ),
                              )
                            ]
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Ongkos Kirim",
                              style: poppinsRegular.copyWith(color: Colors.black)),
                            Container(
                              child: Text(
                              ConnexistHelper.formatCurrency(warungProvider.cartBody.totalDeliveryCost),
                                style: poppinsRegular.copyWith(
                                  color: Colors.black
                                )
                              ),
                            )
                          ]
                        ),
                      ),
                    ]
                  )
                ),
              ]
            ),
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
                          child: Container(
                            height: 50.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Total Tagihan",
                                  style: poppinsRegular.copyWith(
                                    fontSize: 14.0,
                                    color: ColorResources.PRIMARY
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(ConnexistHelper.formatCurrency(warungProvider.cartBody.totalProductPrice + warungProvider.cartBody.totalDeliveryCost + warungProvider.cartBody.serviceCharge),
                                  style: poppinsRegular.copyWith(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            bool active = false;
                            for (int i = 0; i < warungProvider.cartBody.stores.length; i++) {
                              if (warungProvider.cartBody.stores[i].shippingRate != null) {
                                active = true;
                              } else {
                                active = false;
                                break;
                              }
                            }
                            active 
                            ? Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                return SelectPaymentScreen();
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
                          width: 170.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: ColorResources.PRIMARY
                          ),
                          child: Center(
                            child: Text("Pilih Pembayaran",
                              style: poppinsRegular.copyWith(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                )
              )
            ]
          );      
        },
      )
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
