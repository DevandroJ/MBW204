import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/views/screens/dashboard/dashboard.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/views/screens/store/seller_transaction_order.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/store/stuff_sell.dart';
import 'package:mbw204_club_ina/views/screens/store/edit_store.dart';
import 'package:mbw204_club_ina/views/screens/store/seller_add_product.dart';

class SellerStoreScreen extends StatefulWidget {
  @override
  _SellerStoreScreenState createState() => _SellerStoreScreenState();
}

class _SellerStoreScreenState extends State<SellerStoreScreen> with TickerProviderStateMixin {

  Future<bool> onWillPop() {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DashBoardScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorResources.PRIMARY,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20.0,
            color: ColorResources.GREY,
          ),
          onPressed: onWillPop,
        ),
        centerTitle: true,
        elevation: 0,
        title: Text(getTranslated("MY_STORE", context),
          style: poppinsRegular.copyWith(
            fontSize: 16.0
          ),
        ),
      ),
      body: Consumer<WarungProvider>(
        builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
          if(warungProvider.sellerStoreStatus == SellerStoreStatus.loading) {
            return Loader(
              color: ColorResources.PRIMARY
            );
          }
          return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 65.0,
                    height: 65.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: CachedNetworkImage(
                        imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${warungProvider?.sellerStoreModel?.body?.picture?.path}",
                        fit: BoxFit.cover,
                        placeholder: (BuildContext context, String url) => Loader(
                          color: ColorResources.PRIMARY,
                        ),
                        errorWidget: (BuildContext context, String url, dynamic error) => ClipOval(
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorResources.PRIMARY
                            ),
                            child: Icon(
                              Icons.store,
                              size: 30.0,
                              color: ColorResources.WHITE,
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(warungProvider.sellerStoreModel.body.name,
                          style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        SizedBox(height: 4.0),
                        Text(warungProvider.sellerStoreModel.body.address +", " + warungProvider.sellerStoreModel.body.city,
                          style: poppinsRegular.copyWith(
                            color: Colors.black, 
                            fontSize: 14.0
                          )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return EditTokoPage(
                          idStore: warungProvider.sellerStoreModel?.body?.id,
                          nameStore: warungProvider.sellerStoreModel?.body?.name,
                          description: warungProvider.sellerStoreModel?.body?.description,
                          province: warungProvider.sellerStoreModel?.body?.province,
                          city: warungProvider.sellerStoreModel?.body?.city,
                          subDistrict: warungProvider.sellerStoreModel?.body?.subDistrict,
                          village: warungProvider.sellerStoreModel?.body?.village,
                          postalCode: warungProvider.sellerStoreModel?.body?.postalCode,
                          address: warungProvider.sellerStoreModel?.body?.address,
                          email: warungProvider.sellerStoreModel?.body?.email,
                          phone: warungProvider.sellerStoreModel?.body?.phone,
                          location: warungProvider.sellerStoreModel?.body?.location,
                          supportedCouriers: warungProvider.sellerStoreModel?.body?.supportedCouriers,
                          picture: warungProvider.sellerStoreModel?.body?.picture,
                          status: warungProvider.sellerStoreModel?.body?.open,
                        );
                      }));
                    },
                    child: Icon(
                      Icons.edit_outlined,
                      color: Colors.black
                    )
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16.0, 
                right: 16.0, 
                top: 20.0, 
                bottom: 10.0
              ),
              child: Text("Barang Jualan Saya",
                style: poppinsRegular.copyWith(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                )
                )
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TambahJualanPage(
                  idStore: warungProvider?.sellerStoreModel?.body?.id,
                )));
              },
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: Icon(
                        Icons.add_circle_outline,
                        color: Colors.black
                      )
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tambah Produk",
                            style: poppinsRegular.copyWith(
                              fontSize: 16.0
                            ),
                          ),
                          Text( "Upload foto barang jualanmu lalu lengkapi detailnya",
                            style: poppinsRegular.copyWith(
                              fontSize: 12.0, 
                              color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.arrow_forward_ios),
                      ],
                    )
                  ],
                )
              ),
            ),
            Divider(),
            InkWell(
              onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                StuffSellerScreen(
                idStore: warungProvider.sellerStoreModel.body.id,
              ))),
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: Icon(
                        Icons.list_alt,
                        color: Colors.black
                      )
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Daftar Produk",
                            style: poppinsRegular.copyWith(
                              fontSize: 16.0
                            ),
                          ),
                          Text("Lihat semua barang yang dijual di warungmu",
                            style: poppinsRegular.copyWith(
                              fontSize: 12.0, 
                              color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.arrow_forward_ios),
                      ],
                    )
                  ],
                )
              ),
            ),
            Divider(),
            InkWell(
              onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                SellerTransactionOrderScreen(
                index: 0,
              ))),
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: Icon(
                        Icons.list,
                        color: Colors.black
                      )
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pesanan",
                            style: poppinsRegular.copyWith(
                              fontSize: 16.0
                            ),
                          ),
                          Text("Barang pesanan yang masuk",
                            style: poppinsRegular.copyWith(
                              fontSize: 12.0, 
                              color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.arrow_forward_ios),
                      ],
                    )
                  ],
                )
              ),
            ),
            Divider(),
          ],
        );         
          },
        )
      ),
    );
  }
}
