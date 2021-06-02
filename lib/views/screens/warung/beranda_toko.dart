import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/models/warung/seller_store_model.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/warung/barang_jualan.dart';
import 'package:mbw204_club_ina/views/screens/warung/edit_toko.dart';
import 'package:mbw204_club_ina/views/screens/warung/tambah_jualan.dart';


class BerandaTokoPage extends StatefulWidget {
  @override
  _BerandaTokoPageState createState() => _BerandaTokoPageState();
}

class _BerandaTokoPageState extends State<BerandaTokoPage> with TickerProviderStateMixin {
  SellerStoreModel sellerStoreModel;
  bool isLoading = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    warungVM.getDataStore(context, 'self').then((value) {
      if (value != null) {
        setState(() {
          sellerStoreModel = value;
          isLoading = false;
        });
      }
    });
  }

  Future<bool> onWillPop() {
    Navigator.of(context).pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        title: Text( "Warung Saya"),
      ),
      body: isLoading
      ? Container(
          color: Colors.white,
          child: Center(
            child: Loader(
              color: ColorResources.PRIMARY
            ),
          ),
        )
      : Column(
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
                        imageUrl: sellerStoreModel.body?.picture == null ? "" : AppConstants.BASE_URL_FEED_IMG + sellerStoreModel.body.picture.path,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Loader(
                          color: ColorResources.PRIMARY,
                        ),
                        errorWidget: (context, url, error) => Image.asset("assets/default_toko.jpg"),
                      ),
                    )
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(sellerStoreModel.body.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        SizedBox(height: 4.0),
                        Text(sellerStoreModel.body.address +", " +sellerStoreModel.body.city,
                          style: TextStyle(
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
                          idStore: sellerStoreModel.body.id,
                          nameStore: sellerStoreModel.body.name,
                          description: sellerStoreModel.body.description,
                          province: sellerStoreModel.body.province,
                          city: sellerStoreModel.body.city,
                          postalCode: sellerStoreModel.body.postalCode,
                          address: sellerStoreModel.body.address,
                          location: sellerStoreModel.body.location,
                          supportedCouriers: sellerStoreModel.body.supportedCouriers,
                          picture: sellerStoreModel.body.picture,
                          status: sellerStoreModel.body.open,
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
              padding: const EdgeInsets.only(
                left: 16.0, 
                right: 16.0, 
                top: 20.0, 
                bottom: 10.0
              ),
              child: Text("Barang Jualan Saya",
                style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold)
              )
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TambahJualanPage(
                    idStore: sellerStoreModel.body.id,
                  );
                }));
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
                            style: TextStyle(
                              fontSize: 16.0
                            ),
                          ),
                          Text( "U xload foto barang jualanmu lalu lengkapi detailnya",
                            style: TextStyle(
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
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                  return BarangJualanPage(
                    idStore: sellerStoreModel.body.id,
                  );
                }));
              },
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
                            style: TextStyle(
                              fontSize: 16.0
                            ),
                          ),
                          Text("Lihat semua barang yang dijual di warungmu",
                            style: TextStyle(
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
        )
      ),
    );
  }
}
