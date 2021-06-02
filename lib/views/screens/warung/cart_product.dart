import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/views/basewidget/error_component.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/warung/detail_product.dart';
import 'package:mbw204_club_ina/views/screens/warung/edit_note.dart';
import 'package:mbw204_club_ina/views/screens/warung/pengiriman.dart';

class CartProdukPage extends StatefulWidget {
  @override
  _CartProdukPageState createState() => _CartProdukPageState();
}

class _CartProdukPageState extends State<CartProdukPage> with WidgetsBindingObserver {
  TextEditingController catatan;
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    catatan = TextEditingController();

    catatan.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void increment(String storeId, String productId, int count) async {
    await Provider.of<WarungProvider>(context, listen: false).postEditQuantityCart(context, storeId, productId, count, "increment");
  }

  void decrement(String storeId, String productId, int count) async {
    if (count >= 1) {
      await Provider.of<WarungProvider>(context, listen: false).postEditQuantityCart(context, storeId, productId, count, "decrement");
    }
  }

  void deleteProduct(String idProduct) async {
    pr.show();
    try {
      await Provider.of<WarungProvider>(context, listen: false).postDeleteProductCart(context, idProduct);
      pr.hide();  
      Fluttertoast.showToast(
        msg: "Barang telah dihapus",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorResources.PRIMARY,
        textColor: Colors.white
      );
    } catch(_) {
      pr.hide();  
      Fluttertoast.showToast(
        msg: "Terjadi kesalahan, coba ulangi kembali",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white
      );
    }   
    
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<WarungProvider>(context, listen: false).getCartInfo(context);
       
    pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: ' Mohon Tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Loader(
        color: ColorResources.PRIMARY,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
        color: Colors.black, 
        fontSize: 13.0, 
        fontWeight: FontWeight.w400
      ),
      messageTextStyle: TextStyle(
        color: Colors.black, 
        fontSize: 19.0, 
        fontWeight: FontWeight.w600
      )
    );
    return Scaffold(
      backgroundColor: ColorResources.BG_GREY,
      appBar: AppBar(
        backgroundColor: ColorResources.WHITE,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20.0,
            color: ColorResources.PRIMARY
          ),
          onPressed: () => Navigator.of(context).pop()
        ),
        centerTitle: true,
        elevation: 0,
        title: Text( "Keranjang"),
      ),
      body: getCart(),
    );
  }

  Widget emptyCart() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            LottieBuilder.asset(
              "assets/lottie/shopping.json",
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20),
            Container(
              child: Text(
                "Wah, Keranjang belanjaanmu kosong",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 5),
            Container(
              child: Text(
                "Yuk, isi keranjangmu dengan barang impianmu",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            SizedBox(
              height: 50.0,
              width: double.infinity,
              child: RaisedButton(
              color: ColorResources.PRIMARY,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text("Mulai Belanja",
                  style: TextStyle(
                    fontSize: 16.0 * MediaQuery.of(context).textScaleFactor, 
                    color: Colors.white
                  )
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              }),
            )
          ]
        )
      ),
    );
  }

  Widget getCart() {
    return Consumer<WarungProvider>(
      builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
        if(warungProvider.cartStatus == CartStatus.loading) {
          return Loader(
            color: ColorResources.PRIMARY,
          );
        }
        if(warungProvider.cartStatus == CartStatus.empty) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset("assets/lottie/shopping.json",
                    height: 200.0,
                    width: 200.0,
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    child: Text("Wah, Keranjang belanjaanmu kosong",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    child: Text("Yuk, isi keranjangmu dengan barang impianmu",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0, 
                        color: Colors.black
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    height: 50.0,
                    width: double.infinity,
                    child: RaisedButton(
                    color: ColorResources.PRIMARY,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text("Mulai Belanja",
                        style: TextStyle(
                          fontSize: 16.0 * MediaQuery.of(context).textScaleFactor, 
                          color: Colors.white
                        )
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, true)),
                  )
                ]
              )
            ),
          );
        }
        if(warungProvider.cartStatus == CartStatus.error) {
          return Center(
            child: ErrorComponent(
              width: 120.0,
              height: 120.0,
            )
          );
        }
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 70.0),
              child: ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: warungProvider.cartBody.stores.length,
                itemBuilder: (BuildContext context, int i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  child: Icon(Icons.store, color: Colors.white))),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(warungProvider.cartBody.stores[i].store.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(warungProvider.cartBody.stores[i].store.city,
                                style: TextStyle(
                                  color: ColorResources.PRIMARY,
                                  fontSize: 12.0,
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ...warungProvider.cartStores[i].items.map((item) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                  return DetailProductPage(
                                    idProduct: item.product.id,
                                    typeProduct: "commerce",
                                    path: "",
                                  );
                                }));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 70.0,
                                    height: 70.0,
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
                                                imageUrl: item.product.pictures.length == 0 ? "" : AppConstants.BASE_URL_FEED_IMG + item.product.pictures.first.path,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                Center(
                                                  child: Shimmer.fromColors(
                                                  baseColor: Colors.grey[200],
                                                  highlightColor: Colors.grey[100],
                                                  child: Container(
                                                    color: Colors.white,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                )),
                                                errorWidget: (context, url, error) => Center(child: Image.asset( "assets/default_image.png",fit: BoxFit.cover,
                                                )),
                                              ),
                                            )),
                                          item.product.discount != null
                                            ? Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  height: 20,
                                                  width: 25,
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    bottomRight: Radius.circular(12.0),
                                                    topLeft: Radius.circular(12.0)
                                                  ),
                                                  color: Colors.red[900]),
                                                  child: Center(
                                                    child: Text(item.product.discount.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          item.product.name.length > 75
                                              ? Text(
                                                  item.product.name
                                                          .substring(0, 80) +
                                                      "...",
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                )
                                              : Text(
                                                  item.product.name,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                              ConnexistHelper.formatCurrency(
                                                  item.product.price),
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                    return EditNoteProductPage(
                                      idProduct: item.productId,
                                      note: item.note,
                                    );
                                  }));
                                },
                                child: Text(
                                  item.note == "" ? "Tulis catatan untuk barang ini" : item.note,
                                  style: TextStyle(
                                    color: ColorResources.PRIMARY,
                                    fontSize: 14.0,
                                  )
                                ),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Container(
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () => deleteProduct(item.productId),
                                      child: Icon(Icons.delete,
                                      color: Colors.red[300])
                                      ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (item.quantity > item.product.minOrder) {
                                          decrement(item.storeId, item.productId, (item.quantity - 1));
                                        }
                                      },
                                      child: Icon(Icons.do_not_disturb_on,
                                        color: item.quantity <= item.product.minOrder
                                        ? Colors.grey[350]
                                        : ColorResources.PRIMARY,
                                        size: 28.0
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    Container(
                                      width: 30.0,
                                      height: 25.0,
                                      child: Center(
                                        child: Text(item.quantity.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          )
                                        )
                                      )
                                    ),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        increment(item.storeId, item.productId, (item.quantity + 1));
                                      },
                                      child: Icon(Icons.add_circle,
                                        color: ColorResources.PRIMARY,
                                        size: 28.0
                                      ),
                                    ),
                                  ],
                                )
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                            ]
                          );
                      }).toList()
                    ],
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                width: double.infinity,
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
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
                                "Total Harga",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorResources.PRIMARY,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _modalInputan();
                                },
                                child: Row(
                                  children: [
                                    Text(
                                    ConnexistHelper.formatCurrency(
                                      warungProvider.cartBody.totalProductPrice + warungProvider.cartBody.serviceCharge),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Icon(
                                      Icons.expand_less,
                                      color: Colors.black
                                    )
                                  ],
                                ),
                              ),
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
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                          return PengirimanPage();
                        }));
                      },
                      child: Container(
                        width: 150.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: ColorResources.PRIMARY),
                        child: Center(
                          child: Text("Beli (" + warungProvider.cartBody.numOfItems.toString() + ")",
                            style: TextStyle(
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
          ],
        );
      }
    );
  }

  void _alert() async {
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext cn) => new AlertDialog(
        contentTextStyle: TextStyle(
          fontFamily: 'Proppins',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Apakah anda ingin menghapus semua produk yang ada dikeranjang?",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(cn).pop(true);
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey[400])),
                              child: Center(
                                child: Text(
                                  "Tidak",
                                  style:
                                      TextStyle(color: ColorResources.PRIMARY),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              pr.show();
                              await warungVM
                                  .postEmptyProductCart(context)
                                  .then((value) {
                                pr.hide();

                              
                                Navigator.of(cn).pop(true);
                                Fluttertoast.showToast(
                                    msg: "Barang telah dihapus semua",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: ColorResources.PRIMARY,
                                    textColor: Colors.white);
                              });
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorResources.PRIMARY),
                              child: Center(
                                child: Text(
                                  "Ya",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 10.0,
              right: 10.0,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 8.0,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    child: Image.asset("assets/default_toko.jpg")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _modalInputan() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.25,
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
                      padding: EdgeInsets.only(
                        left: 16.0, 
                        right: 16.0, 
                        top: 16.0, 
                        bottom: 8.0
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.close)
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 16),
                                child: Text("Ringkasan Belanja",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                  )
                                )
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    Consumer<WarungProvider>(
                      builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
                        if(warungProvider.cartStatus == CartStatus.loading) {
                          return Container();
                        } 
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Harga (" + warungProvider.cartBody.numOfItems.toString() + " barang)",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0
                                      )
                                    ),
                                    Container(
                                      child: Text( ConnexistHelper.formatCurrency(warungProvider.cartBody.totalProductPrice + warungProvider.cartBody.serviceCharge),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                    )
                                  ]
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Divider(
                                thickness: 1,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Bayar",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0
                                      )
                                    ),
                                    Container(
                                      child: Text(
                                        ConnexistHelper.formatCurrency(warungProvider.cartBody.totalProductPrice + warungProvider.cartBody.serviceCharge),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                    )
                                  ]
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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

  Widget loadingList(int index) {
    return Container(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200],
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
                // Container(
                //   width: 180,
                //   height: 12.0,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(12),
                //       color: Colors.white),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
