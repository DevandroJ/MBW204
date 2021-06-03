import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/data/models/warung/card_add_model.dart';
import 'package:mbw204_club_ina/data/models/warung/product_warung_model.dart';
import 'package:mbw204_club_ina/views/screens/feed/notification.dart';
import 'package:mbw204_club_ina/views/screens/warung/cart_product.dart';
import 'package:mbw204_club_ina/views/screens/warung/detail_product.dart';

class SearchProductPage extends StatefulWidget {
  final String typeProduct;

  SearchProductPage({
    Key key,
    @required this.typeProduct,
  }) : super(key: key);
  @override
  _SearchProductPageState createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  ScrollController scrollController = ScrollController();
  bool isDataNull = false;
  int page = 0;
  CartModel cartModel;
  bool isLoading = true;
  List<ProductWarungList> _data = [];

  void getData(text) {
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: ' Mohon Tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Loader(
        color: ColorResources.PRIMARY,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    pr.show();
     Provider.of<WarungProvider>(context, listen: false).getDataSearchProduct(context, text, 0).then((product) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide().whenComplete(() {
          setState(() {
            _data = [];
          });
          if (product.body != null) {
            setState(() {
              _data.addAll(product.body);
              return null;
            });
          } else {
            Fluttertoast.showToast(
              msg: "Produk tidak ada",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red[400],
              textColor: Colors.white,
              fontSize: 14.0
            );
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<WarungProvider>(context, listen: false).getCartInfo(context);

  
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return Future.value(true);
      },
      child: Scaffold(
        body: CustomScrollView(
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          slivers: [

            // App Bar
            SliverAppBar(
              floating: true,
              elevation: 0,
              centerTitle: false,
              toolbarHeight: 10,
              automaticallyImplyLeading: false,
              backgroundColor: ColorResources.getPrimaryToBlack(context),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: SliverDelegate(
                child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL, 
                  vertical: 2.0
                ),
                color: ColorResources.WHITE,
                alignment: Alignment.center,
                child: Row(
                  children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 20.0,
                      color: ColorResources.PRIMARY,
                    ),
                    onPressed: () => Navigator.of(context).pop()
                  ),
                  Expanded(
                    child: Container(
                      height: 55.0,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        color: ColorResources.LAVENDER,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.text,
                              style: poppinsRegular.copyWith(
                                color: ColorResources.BLACK
                              ),
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[200]
                                  )
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[200]
                                  )
                                )
                              ),
                              autofocus: true,
                              onSubmitted: (val) {
                                getData(val);
                              },
                            ),
                          ),
                          Icon(
                            Icons.search,
                            color: ColorResources.PRIMARY,
                          ),
                        ], 
                      ),
                    ),
                  ),
                  Consumer<WarungProvider>(
                    builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
                      return warungProvider.cartBody == null 
                      ? 
                        GestureDetector(
                          onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => CartProdukPage())),
                          child: Container(
                            margin: EdgeInsets.only(left: 20.0, right: 14.0),
                            child: Icon(
                              Icons.shopping_cart,
                              color: ColorResources.PRIMARY,
                            )
                          ),
                        ) 
                      : Badge(
                        position: BadgePosition.topEnd(top: 3.0, end: 6.0),
                        animationDuration: Duration(milliseconds: 300),
                        animationType: BadgeAnimationType.slide,
                        badgeContent: Text(
                          warungProvider.cartBody.numOfItems.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.shopping_cart,
                            color: ColorResources.PRIMARY 
                          ),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartProdukPage())),
                        )
                      );
                    },
                  ),
                ]
              )
            ))),

            // Get Data Search
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: getDataSearch()
              )
            )

          ],
        ) 
      ),
    );
  }

  Widget _searchCard() => Container(
    height: 45.0,
    width: double.infinity,
    child: CupertinoTextField(
      keyboardType: TextInputType.text,
      placeholder: 'Cari Produk di Toko Indomini Mart',
      placeholderStyle: TextStyle(
        color: Color(0xffC4C6CC),
        fontSize: 14.0,
        fontFamily: 'Proppins',
      ),
      autofocus: true,
      style: TextStyle(fontFamily: 'Proppins'),
      onSubmitted: (value) {
        getData(value);
      },
      prefix: Padding(
        padding: const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
        child: Icon(
          Icons.search,
          color: Color(0xffC4C6CC),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Color(0xffF0F1F5),
      ),
    ),
  );

  Widget getDataSearch() {
    return isDataNull
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Sedang memuat data ...",
                  style: TextStyle(
                    fontSize: 18.0
                  ),
                ),
              ),
              Loader(
                color: ColorResources.PRIMARY,
              ),
            ],
          ),
        )
      : _data.length == 0 ? emptyTransaction() : getDataProductByCategory();
  }

  Widget getDataProductByCategory() {
    return GridView.builder(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 3 / 5,
      ),
      itemCount: _data.length,
      itemBuilder: (context, index) {
        if (index == _data.length) {
          return Container();
        } else {
          return _itemsData(context, _data[index]);
        }
      },
      // children: productWarungModel.body.map((resultProduct) {
      //   return _itemsData(context, resultProduct);
      // }).toList(),
    );
    // return FutureBuilder<ProductWarungModel>(
    //   future: warungVM.getDataProductByCategory(
    //       widget.idCategory, widget.typeProduct),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       final ProductWarungModel productWarungModel = snapshot.data;
    //       if (productWarungModel.body.length == 0) {
    //         return Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Center(
    //                 child: Container(
    //                   // width: 900.0,
    //                   margin: EdgeInsets.only(bottom: 30.0),
    //                   child: lottie.LottieBuilder.asset(
    //                     "assets/product_belum_tersedia.json",
    //                     height: 190.0,
    //                     width: 326.0,
    //                     alignment: Alignment.center,
    //                     fit: BoxFit.cover,
    //                   ),
    //                 ),
    //               ),
    //               Container(
    //                 child: Center(
    //                     child: Text(
    //                   "Product Belum Tersedia",
    //                   style: TextStyle(fontSize: 16.0),
    //                 )),
    //               )
    //             ],
    //           ),
    //         );
    //       } else if (productWarungModel.body == null) {
    //         return Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Center(
    //                 child: Container(
    //                   // width: 900.0,
    //                   margin: EdgeInsets.only(bottom: 30.0),
    //                   child: lottie.LottieBuilder.asset(
    //                     "assets/product_belum_tersedia.json",
    //                     height: 190.0,
    //                     width: 326.0,
    //                     alignment: Alignment.center,
    //                     fit: BoxFit.cover,
    //                   ),
    //                 ),
    //               ),
    //               Container(
    //                 child: Center(
    //                     child: Text(
    //                   "Product Belum Tersedia",
    //                   style: TextStyle(fontSize: 16.0),
    //                 )),
    //               )
    //             ],
    //           ),
    //         );
    //       }
    //       return GridView(
    //         padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
    //         physics: BouncingScrollPhysics(),
    //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //           crossAxisCount: 2,
    //           mainAxisSpacing: 8.0,
    //           crossAxisSpacing: 8.0,
    //           childAspectRatio: 3 / 5,
    //         ),
    //         children: productWarungModel.body.map((resultProduct) {
    //           return _itemsData(context, resultProduct);
    //         }).toList(),
    //       );
    //     }
    //     return loadingList();
    //   },
    // );
  }

  Widget _itemsData(BuildContext context, ProductWarungList productWarungList) {
    // Map<String, dynamic> _basket =
    //     Provider.of<Map<String, dynamic>>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailProductPage(
            idProduct: productWarungList.id,
            typeProduct: widget.typeProduct,
            path: "",
          );
        }));
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 5 / 4.8,
              child: Stack(
                children: [
                  Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                        child: CachedNetworkImage(
                          imageUrl: productWarungList.pictures.length == 0
                              ? ""
                              : AppConstants.BASE_URL_FEED_IMG +
                                  productWarungList.pictures.first.path,
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
                            "assets/default_image.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )),
                        ),
                      )),
                  productWarungList.discount != null
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 25,
                            width: 30,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(12),
                                    topLeft: Radius.circular(12)),
                                color: Colors.red[900]),
                            child: Center(
                              child: Text(
                                productWarungList.discount.discount
                                        .toString()
                                        .replaceAll(
                                            RegExp(r"([.]*0)(?!.*\d)"), "") +
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  productWarungList.name.length > 45
                  ? Text(
                    productWarungList.name.substring(0, 45) + "...",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  )
                  : Text(
                    productWarungList.name,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(ConnexistHelper.formatCurrency(productWarungList.price),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on,
                          size: 15, color: Colors.orange[700]),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        productWarungList.store.city,
                        style: TextStyle(
                            fontSize: 12.0, color: Colors.orange[700]),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: productWarungList.stats.ratingAvg,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 15.0,
                        direction: Axis.horizontal,
                      ),
                      Container(),
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 15),
                        child: Text(
                            "(" +
                                productWarungList.stats.ratingAvg
                                    .toString()
                                    .substring(0, 3) +
                                ")",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  )
                  // : Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget emptyTransaction() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  "assets/lottie/product_not_available.json",
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 20),
                Container(
                  child: Text(
                    "Saat ini produk belum tersedia",
                    style: poppinsRegular,
                    textAlign: TextAlign.center
                  ),
                ),
              ]
            )
          ),
        ],
      ),
    );
  }
}



class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 75;

  @override
  double get minExtent => 55;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}