import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/views/screens/dashboard/dashboard.dart';
import 'package:mbw204_club_ina/views/screens/store/buyer_transaction_order.dart';
import 'package:mbw204_club_ina/data/models/warung/product_warung_model.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/store/detail_product.dart';
import 'package:mbw204_club_ina/data/models/warung/card_add_model.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/views/screens/store/cart_product.dart';
import 'package:mbw204_club_ina/views/screens/store/product.dart';
import 'package:mbw204_club_ina/views/basewidget/search.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/basewidget/error_component.dart';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with SingleTickerProviderStateMixin { 

  ScrollController scrollController = ScrollController();
  CartModel cartModel;
  bool sliverPersistentHeader = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  
  bool loading = false;

  shrinkNavListener() {
    if (isShrink != sliverPersistentHeader) {    
      setState(() => sliverPersistentHeader = isShrink);
    }
  }

  bool get isShrink {
    return scrollController.hasClients && scrollController.offset > kToolbarHeight;
  }
  
  Future<bool> onWillPop() {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DashBoardScreen();
    }));
  }

  @override 
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<WarungProvider>(context, listen: false).getDataCategoryProduct(context, "commerce");
      Provider.of<WarungProvider>(context, listen: false).getDataStore(context);
      Provider.of<WarungProvider>(context, listen: false).getCartInfo(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: ColorResources.WHITE,
        body: Stack(
          children: [

            SafeArea(
              child: RefreshIndicator(
                backgroundColor: ColorResources.WHITE,
                color: ColorResources.PRIMARY,
                onRefresh: () {
                  return Future.delayed(Duration(seconds: 2), () {
                    Provider.of<WarungProvider>(context, listen: false).getDataCategoryProduct(context, "commerce");
                    Provider.of<WarungProvider>(context, listen: false).getDataStore(context);
                    Provider.of<WarungProvider>(context, listen: false).getCartInfo(context);
                  });         
                },
                child: CustomScrollView(
                  controller: scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                    slivers: [

                      SliverToBoxAdapter(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                              child: Image.asset(
                                Images.toolbar_background, 
                                fit: BoxFit.fill,
                                height: 30 + MediaQuery.of(context).padding.top, 
                                width: MediaQuery.of(context).size.width,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              height: 55.0,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 15.0),
                                    child: CupertinoNavigationBarBackButton(
                                    onPressed: onWillPop,
                                    color: ColorResources.BTN_PRIMARY_SECOND,
                                  )),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                  Expanded(
                                    child: Text("W204 Mart",
                                      style: poppinsRegular.copyWith(
                                        fontSize: 20.0, 
                                        color: ColorResources.PRIMARY
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox.shrink()
                                ]
                              ),
                            ),
                          ]
                        ),
                      ),

                      SliverPersistentHeader(
                        pinned: true,               
                        delegate: SliverDelegate(
                          child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_SMALL, 
                            vertical: isShrink ? 2.0 : 0.0 
                          ),
                          color: ColorResources.BG_GREY,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: SearchWidget(
                                  hintText: "Cari Produk",
                                  type: "commerce"
                                )
                              ),
                              InkWell(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionOrderScreen(
                                  index: 0,
                                ))),
                                child: Container(
                                  margin: EdgeInsets.only(left: 20.0),
                                  child: Icon(
                                    Icons.list,
                                    color: ColorResources.PRIMARY,
                                  )
                                ),
                              ),
                              Consumer<WarungProvider>(
                                builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
                                  return warungProvider.cartBody == null 
                                  ? 
                                    InkWell(
                                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartProdukPage())),
                                      child: Container(
                                        margin: EdgeInsets.only(left: 15.0, right: 15.0),
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
                                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                                      ),
                                      child: IconButton(
                                      icon: Icon(
                                        Icons.shopping_cart,
                                        color: isShrink ? Colors.white : ColorResources.PRIMARY
                                      ),
                                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartProdukPage())),
                                    )
                                  );
                                },
                              ),
                            ]
                          )
                        )
                      )
                    ),
                      
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                        child: getDataCategory(context),
                      ),
                    ), 
                    
                  ],
                ),
              ),
            ),
          ]
        ),
      )    
    );
  }

  Widget getDataCategory(BuildContext context) {
    return Consumer<WarungProvider>(
      builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
        
        if(warungProvider.categoryProductStatus == CategoryProductStatus.loading) {            
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Loader(
              color: ColorResources.BTN_PRIMARY,
            ),
          );
        }

        if(warungProvider.categoryProductStatus == CategoryProductStatus.error) {
          return Center(
            child: ErrorComponent(
              width: 120.0,
              height: 120.0,
            )
          );
        }
      
        if(warungProvider.categoryProductStatus == CategoryProductStatus.empty) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset("assets/lottie/product_not_available.json",
                    height: 120.0,
                    width: 120.0,
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Text("Belum ada Produk",
                      textAlign: TextAlign.center
                    ),
                  ),
                ]
              )
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: warungProvider.categoryHasManyProduct.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int i) {
            List<ProductWarungList> categoryHasManyProduct = warungProvider.categoryHasManyProduct[i]["items"];
            return Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(warungProvider.categoryHasManyProduct[i]["category"],
                    style: poppinsRegular.copyWith(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Container(
                    width: double.infinity,
                    height: 250.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: warungProvider.categoryHasManyProduct[i]["items"].length == 0 
                    ? Center(
                        child: Text("Belum ada Produk",
                        style: poppinsRegular,
                      )
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: categoryHasManyProduct.take(6).length,
                      itemBuilder: (BuildContext context, int z) {
                        if(z == 5) {
                          return Container(
                            width: 130.0,
                            child: Card(
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                              child: InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(
                                    idCategory: warungProvider.categoryHasManyProduct[i]['id'],
                                    nameCategory: warungProvider.categoryHasManyProduct[i]['category'],
                                    typeProduct: "commerce",
                                    path: ""
                                  )));                           
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.5
                                    )
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Lihat semua",
                                        style: poppinsRegular.copyWith(
                                          color: ColorResources.PRIMARY
                                        ),
                                      ),
                                      Text("...",
                                        style: poppinsRegular.copyWith(
                                          color: ColorResources.PRIMARY
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ), 
                            ),
                          );      
                        }

                        return Container(
                          width: 130.0,
                          child: Card(
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                            child: InkWell(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return DetailProductPage(
                                    idProduct: categoryHasManyProduct[z].id,
                                    typeProduct: "commerce",
                                    path: "",
                                  );
                                }));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0.5
                                  )
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 5 / 4.8,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                              child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15.0),
                                              child: CachedNetworkImage(
                                                imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${categoryHasManyProduct[z].pictures.first.path}",
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
                                                )),
                                                errorWidget: (BuildContext context, String url, dynamic error) => Center(
                                                child: Image.asset("assets/images/default_image.png",
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                )),
                                              ),
                                            ),
                                          ),
                                          categoryHasManyProduct[z].discount != null
                                          ? Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                height: 25,
                                                width: 30,
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    bottomRight: Radius.circular(12),
                                                    topLeft: Radius.circular(12)
                                                  ),
                                                  color: Colors.red[900]
                                                ),
                                                child: Center(
                                                  child: Text(categoryHasManyProduct[z].discount.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
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
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 100.0,
                                            child: Text(
                                              categoryHasManyProduct[z].name,
                                              overflow: TextOverflow.ellipsis,
                                              style: poppinsRegular.copyWith(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ),
                                          Text(ConnexistHelper.formatCurrency(categoryHasManyProduct[z].price),
                                            style: poppinsRegular.copyWith(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                            )
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                padding: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(40),
                                                  color: ColorResources.PRIMARY
                                                ),
                                                child: Center(
                                                  child: Icon(Icons.store,
                                                    color: Colors.white, size: 15
                                                  )
                                                )
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(categoryHasManyProduct[z].store.name,
                                                    maxLines: 1,
                                                    style: poppinsRegular.copyWith(
                                                        color: Colors.black,
                                                        fontSize: 12.0,
                                                        fontWeight: FontWeight.bold
                                                      )
                                                    ),
                                                    Text(categoryHasManyProduct[z].store.city,
                                                      maxLines: 1,
                                                      style: poppinsRegular.copyWith(
                                                        color: ColorResources.PRIMARY,
                                                        fontSize: 12.0,
                                                      )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              RatingBarIndicator(
                                                rating: categoryHasManyProduct[z].stats.ratingAvg,
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
                                                margin: EdgeInsets.only(left: 4.0),
                                                child: Text("${categoryHasManyProduct[z].stats.ratingAvg.toString().substring(0, 3)}",
                                                style: poppinsRegular.copyWith(
                                                  fontSize: 12.0,
                                                  color: ColorResources.PRIMARY,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ), 
                          ),
                        );         
                        
                        // Card(
                        //   elevation: 2,
                        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        //   child: InkWell(
                        //     borderRadius: BorderRadius.circular(15.0),
                        //     onTap: () {
                        //       // Navigator.push(context, MaterialPageRoute(builder: (context) {
                        //       //   return DetailProductPage(
                        //       //     idProduct: categoryHasManyProduct[z].id,
                        //       //     typeProduct: "",
                        //       //     path: "",
                        //       //   );
                        //       // }));
                        //     },
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         AspectRatio(
                        //           aspectRatio: 5 / 4.8,
                        //           child: Stack(
                        //             children: [
                        //               Container(
                        //                   width: double.infinity,
                        //                   height: double.infinity,
                        //                   decoration: BoxDecoration(
                        //                     borderRadius: BorderRadius.only(
                        //                         topLeft: Radius.circular(12),
                        //                         topRight: Radius.circular(12)),
                        //                   ),
                        //                   child: ClipRRect(
                        //                     borderRadius: BorderRadius.only(
                        //                         topLeft: Radius.circular(12),
                        //                         topRight: Radius.circular(12)),
                        //                     child: CachedNetworkImage(
                        //                       imageUrl: categoryHasManyProduct[z].pictures.length == 0
                        //                         ? ""
                        //                         : AppConstants.BASE_URL_FEED_IMG + categoryHasManyProduct[z].pictures.first.path,
                        //                       fit: BoxFit.cover,
                        //                       placeholder: (context, url) => Center(
                        //                           child: Shimmer.fromColors(
                        //                         baseColor: Colors.grey[300],
                        //                         highlightColor: Colors.grey[100],
                        //                         child: Container(
                        //                           color: Colors.white,
                        //                           width: double.infinity,
                        //                           height: double.infinity,
                        //                         ),
                        //                       )),
                        //                       errorWidget: (context, url, error) => Center(
                        //                           child: Image.asset(
                        //                         "assets/default_image.png",
                        //                         fit: BoxFit.cover,
                        //                         width: double.infinity,
                        //                         height: double.infinity,
                        //                       )),
                        //                     ),
                        //                   )),
                        //                   categoryHasManyProduct[z].discount != null
                        //                   ? Align(
                        //                       alignment: Alignment.topLeft,
                        //                       child: Container(
                        //                         height: 25,
                        //                         width: 30,
                        //                         padding: EdgeInsets.all(8),
                        //                         decoration: BoxDecoration(
                        //                           borderRadius: BorderRadius.only(
                        //                             bottomRight: Radius.circular(12),
                        //                             topLeft: Radius.circular(12)
                        //                           ),
                        //                           color: Colors.red[900]
                        //                         ),
                        //                         child: Center(
                        //                           child: Text(categoryHasManyProduct[z].discount.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
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
                        //         Padding(
                        //           padding: const EdgeInsets.all(8),
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: <Widget>[
                        //               categoryHasManyProduct[z].name.length > 45
                        //                   ? Text(
                        //                       categoryHasManyProduct[z].name.substring(0, 45) + "...",
                        //                       maxLines: 2,
                        //                       style: TextStyle(
                        //                         fontSize: 15.0,
                        //                       ),
                        //                     )
                        //                   : Text(
                        //                       categoryHasManyProduct[z].name,
                        //                       maxLines: 2,
                        //                       style: TextStyle(
                        //                         fontSize: 15.0,
                        //                       ),
                        //                     ),
                        //               SizedBox(
                        //                 height: 5,
                        //               ),
                        //               Text(ConnexistHelper.formatCurrency(categoryHasManyProduct[z].price),
                        //                   style: TextStyle(
                        //                     fontSize: 16.0,
                        //                     fontWeight: FontWeight.bold,
                        //                   )),
                        //               SizedBox(
                        //                 height: 8,
                        //               ),
                        //               Row(
                        //                 crossAxisAlignment: CrossAxisAlignment.center,
                        //                 children: [
                        //                   Container(
                        //                     height: 20,
                        //                     width: 20,
                        //                     padding: EdgeInsets.all(2),
                        //                     decoration: BoxDecoration(
                        //                       borderRadius: BorderRadius.circular(40),
                        //                       color: ColorResources.PRIMARY
                        //                     ),
                        //                     child: Center(
                        //                       child: Icon(Icons.store,
                        //                         color: Colors.white, size: 15
                        //                       )
                        //                     )
                        //                   ),
                        //                   SizedBox(
                        //                     width: 5,
                        //                   ),
                        //                   Expanded(
                        //                     child: Column(
                        //                       crossAxisAlignment: CrossAxisAlignment.start,
                        //                       children: [
                        //                         Text(categoryHasManyProduct[z].store.name,
                        //                             maxLines: 1,
                        //                             style: TextStyle(
                        //                                 color: Colors.black,
                        //                                 fontSize: 12,
                        //                                 fontWeight: FontWeight.bold)),
                        //                         Text(categoryHasManyProduct[z].store.city,
                        //                             maxLines: 1,
                        //                             style: TextStyle(
                        //                               color: ColorResources.PRIMARY,
                        //                               fontSize: 12,
                        //                             )),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               SizedBox(
                        //                 height: 8,
                        //               ),
                        //               Row(
                        //                 children: [
                        //                   RatingBarIndicator(
                        //                     rating: categoryHasManyProduct[z].stats.ratingAvg,
                        //                     itemBuilder: (context, index) => Icon(
                        //                       Icons.star,
                        //                       color: Colors.amber,
                        //                     ),
                        //                     itemCount: 5,
                        //                     itemSize: 15.0,
                        //                     direction: Axis.horizontal,
                        //                   ),
                        //                   Container(),
                        //                   Container(
                        //                     margin: EdgeInsets.only(left: 8, right: 15),
                        //                     child: Text(
                        //                         "(" +
                        //                             categoryHasManyProduct[z].stats.ratingAvg
                        //                                 .toString()
                        //                                 .substring(0, 3) +
                        //                             ")",
                        //                         style: TextStyle(
                        //                           fontSize: 12.0,
                        //                           color: ColorResources.PRIMARY,
                        //                           fontWeight: FontWeight.bold,
                        //                         )),
                        //                   ),
                        //                 ],
                        //               )
                        //             ],
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // );



                      },
                    ),
                  )
                ],
              ),
            );
          }
        );
        // return Container(
        //   width: double.infinity,
        //   padding: EdgeInsets.all(10.0),
        //   decoration: BoxDecoration(
        //     color: ColorResources.PRIMARY,
        //     borderRadius: BorderRadius.circular(10.0)
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text("Kategori Pilihan",
        //         style: TextStyle(
        //           fontSize: 17.0 * MediaQuery.of(context).textScaleFactor,
        //           color: ColorResources.WHITE,
        //           fontWeight: FontWeight.bold
        //         ),
        //       ),
        //       SizedBox(height: 15.0),
        //       Container(
        //         width: double.infinity,
        //         height: 150.0,
        //         child: ListView.builder(
        //           scrollDirection: Axis.horizontal,
        //           shrinkWrap: true,
        //           physics: BouncingScrollPhysics(),
        //           itemCount: warungProvider.categoryProductList.length,
        //           itemBuilder: (BuildContext context, int i) {
        //             return Container(
        //               width: 130.0,
        //               child: Card(
        //                 elevation: 0.8,
        //                 shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(10.0)
        //                 ),
        //                 child: InkWell(
        //                   borderRadius: BorderRadius.circular(10.0),
        //                   onTap: () {
        //                     Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(
        //                       idCategory: warungProvider.categoryProductList[i].id,
        //                       nameCategory: warungProvider.categoryProductList[i].name,
        //                       typeProduct: "commerce",
        //                       path: ""
        //                     ))); 
        //                   },
        //                   child: Container(
        //                     padding: EdgeInsets.all(10.0),
        //                     child: Stack(
        //                       // mainAxisAlignment: MainAxisAlignment.center,
        //                       children: [
        //                         Align(
        //                           alignment: Alignment.center,
        //                           child: Container(
        //                             height: 30.0,
        //                             width: 30.0,
        //                             child: ClipRRect(
        //                               borderRadius: BorderRadius.circular(60.0),
        //                               child: CachedNetworkImage(
        //                                 imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${warungProvider.categoryProductList[i].picture.path}",
        //                                 fit: BoxFit.cover,
        //                                 placeholder: (context, url) => Center(
        //                                 child: Shimmer.fromColors(
        //                                   baseColor: Colors.grey[200],
        //                                   highlightColor: Colors.grey[100],
        //                                   child: Container(
        //                                     color: Colors.white,
        //                                     width: double.infinity,
        //                                     height: double.infinity,
        //                                   ),
        //                                 )),
        //                                 errorWidget: (context, url, error) => Center(child: Image.asset("assets/default_image.png", fit: BoxFit.cover)),
        //                               ),
        //                             )
        //                           ),
        //                         ),
        //                         SizedBox(height: 8.0),
        //                         Align(
        //                           alignment: Alignment.center,
        //                           child: Container(
        //                             margin: EdgeInsets.only(top: 80.0),
        //                             child: Text(
        //                               warungProvider.categoryProductList[i].name,
        //                               style: poppinsRegular.copyWith(
        //                                 height: 1.6
        //                               )
        //                             ),
        //                           ),
        //                         )
        //                       ],
        //                     )
        //                   ),
        //                 ),
        //               ),
        //             );
        //           },
        //         ),
        //       )
        //     ],
        //   ));


    //     return GridView.builder(
    //       shrinkWrap: true,
    //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //         crossAxisCount: 4,
    //         childAspectRatio: 3 / 4,
    //       ),
    //       physics: BouncingScrollPhysics(),
    //       itemCount: warungProvider.categoryProductList.length,
    //       itemBuilder: (BuildContext context, int i) {
    //         return Card(
    //           elevation: 0.0,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(15.0)
    //           ),
    //           child: InkWell(
    //             customBorder: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(15.0),
    //             ),
    //             onTap: () { 
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(
    //                 idCategory: warungProvider.categoryProductList[i].id,
    //                 nameCategory: warungProvider.categoryProductList[i].name,
    //                 typeProduct: "commerce",
    //                 path: ""
    //               ))); 
    //             },
    //             child: Container(
    //               margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Container(
    //                     height: 30.0,
    //                     width: 30.0,
    //                     child: ClipRRect(
    //                       borderRadius: BorderRadius.circular(60.0),
    //                       child: CachedNetworkImage(
    //                         imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${warungProvider.categoryProductList[i].picture.path}",
    //                         fit: BoxFit.cover,
    //                         placeholder: (context, url) => Center(
    //                         child: Shimmer.fromColors(
    //                           baseColor: Colors.grey[200],
    //                           highlightColor: Colors.grey[100],
    //                           child: Container(
    //                             color: Colors.white,
    //                             width: double.infinity,
    //                             height: double.infinity,
    //                           ),
    //                         )),
    //                         errorWidget: (context, url, error) => Center(child: Image.asset("assets/default_image.png", fit: BoxFit.cover)),
    //                       ),
    //                     )
    //                   ),
    //                   SizedBox(height: 10.0),
    //                   Container(
    //                     child: warungProvider.categoryProductList.length > 16
    //                     ? Text(
    //                       warungProvider.categoryProductList[i].name.substring(0, 15) + "...",
    //                       style: TextStyle(
    //                         color: Colors.black,
    //                         fontSize: 11.0,
    //                       ),
    //                       textAlign: TextAlign.center,
    //                     )
    //                     : Text(warungProvider.categoryProductList[i].name,
    //                       style: TextStyle(
    //                         color: Colors.black,
    //                         fontSize: 11.0,
    //                         height: 1.4
    //                       ),
    //                       textAlign: TextAlign.center,
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //         );
    //       },
    //     );          
      },
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
