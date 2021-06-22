import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import "package:lottie/lottie.dart";
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/data/models/warung/card_add_model.dart';
import 'package:mbw204_club_ina/data/models/warung/category_product_model.dart';
import 'package:mbw204_club_ina/data/models/warung/product_warung_model.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/views/screens/feed/notification.dart';
import 'package:mbw204_club_ina/views/screens/warung/cart_product.dart';
import 'package:mbw204_club_ina/views/screens/warung/detail_product.dart';
import 'package:mbw204_club_ina/views/basewidget/search.dart';

class ProductPage extends StatefulWidget {
  final String idCategory;
  final String nameCategory;
  final String typeProduct;
  final String path;

  ProductPage({
    Key key,
    @required this.idCategory,
    @required this.nameCategory,
    @required this.typeProduct,
    @required this.path,
  }) : super(key: key);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ScrollController scrollController = ScrollController();
  int page = 0;
  CartModel cartModel;
  CategoryProductModel categoryProductModel;
  bool isLoading = true;
  bool isLoadingProduct = true;
  bool isLoadingParent = true;
  List<ProductWarungList> product = [];

  circularProgress() {
    return Center(
      child: Container(
        child: LottieBuilder.asset(
          "assets/lottie/search_product.json",
          height: 200.0,
          width: 200.0,
          alignment: Alignment.center,
          fit: BoxFit.cover,
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    this.getMoreData(page);
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        getMoreData(page);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void getMoreData(int index) async {
    Provider.of<WarungProvider>(context, listen: false).getDataProductByCategoryConsumen(context, widget.idCategory, index).then((value) {
      if (value != null) {
        setState(() {
          isLoadingProduct = false;
          product.addAll(value.body);
          page++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    Provider.of<WarungProvider>(context, listen: false).getDataCategoryProductByParent(context, widget.typeProduct, widget.idCategory);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          slivers: [
            
            SliverToBoxAdapter(
              child: CustomAppBar(title: "Product", isBackButtonExist: true)
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
                  Expanded(
                    child: SearchWidget(
                      hintText: "Cari Produk di Toko MBW204 Club INA",
                    )
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
                          position: BadgePosition.topEnd(top: 3, end: 6),
                          animationDuration: Duration(milliseconds: 300),
                          animationType: BadgeAnimationType.slide,
                          badgeContent: Text(
                            warungProvider.cartBody.numOfItems.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.shopping_cart, 
                              color: ColorResources.PRIMARY,
                            ),
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartProdukPage())),
                          )
                        );
                    },
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen())),
                    child: Container(
                      child: Icon(
                        Icons.notifications,
                        color: ColorResources.PRIMARY,
                      ),
                    ),
                  ),
                ]
              )
            ))),

            SliverToBoxAdapter(
              child: getCategoryParent(),
            ),
            
            SliverToBoxAdapter(
              child: isLoadingProduct ? loadingList() : product.length == 0 ? emptyTransaction() : getDataProductByCategory()
            )

          ],
        )
      ) 
    );
  }

  Widget getCategoryParent() {
    return Consumer<WarungProvider>(
      builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
        if(warungProvider.categoryProductByParentStatus == CategoryProductByParentStatus.loading) {
          return Container(
            height: 45.0,
            margin: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200],
              highlightColor: Colors.grey[100],
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100.0,
                    height: 45.0,
                    margin: EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0), 
                      color: Colors.white
                    ),
                  );
                },
              ),
            ),
          );
        }
        if(warungProvider.categoryProductByParentStatus == CategoryProductByParentStatus.empty) {
          return Container();
        }
        return Container(
          height: 50.0,
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
          child: ListView.builder(
            itemCount: warungProvider.categoryProductByParentList.length,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int i) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                    return ProductPage(
                      idCategory: warungProvider.categoryProductByParentList[i].id,
                      nameCategory: warungProvider.categoryProductByParentList[i].name,
                      typeProduct: "commerce",
                      path: ""
                    );
                  }));
                },
              child: Container(
                height: 50.0,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: Colors.white,
                  border: Border.all(
                    color: ColorResources.PRIMARY,
                    width: 2.0
                  )
                ),
                child: Center(
                  child: Text(warungProvider.categoryProductByParentList[i].name,
                style: TextStyle(
                  color: ColorResources.PRIMARY,
                  fontSize: 14.0,
                )))),
              );
            },
          ),
        );
      },
    );
  }

  Widget loadingListCategory() {
    return Container(
      height: 45,
      margin: EdgeInsets.only(top: 8, left: 16, right: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: ListView.builder(
          itemCount: 5,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              width: 100,
              height: 45,
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.white),
            );
          },
        ),
      ),
    );
  }

  Widget getDataProductByCategory() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 3 / 5.6,
      ),
      itemCount: product.length,
      itemBuilder: (context, index) {
        if (index == product.length) {
          return Container();
        } else {
          return _itemsData(context, product[index]);
        }
      },
    );
  }

  Widget _itemsData(BuildContext context, ProductWarungList productWarungList) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailProductPage(
              idProduct: productWarungList.id,
              typeProduct: widget.typeProduct,
              path: "",
            );
          }));
        },
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
                children: <Widget>[
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
                            Text(productWarungList.store.name,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            Text(productWarungList.store.city,
                                maxLines: 1,
                                style: TextStyle(
                                  color: ColorResources.PRIMARY,
                                  fontSize: 12,
                                )),
                          ],
                        ),
                      ),
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
    );
  }

  Widget loadingList() {
    return Container(
      child: GridView.builder(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 3 / 5.4,
        ),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                        color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 150,
                    height: 15.0,
                    margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                  ),
                  Container(
                    width: 100,
                    height: 15.0,
                    margin: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                  ),
                ],
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
      child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: Column(children: [
            LottieBuilder.asset("assets/lottie/product_not_available.json",
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20.0),
            Container(
              child: Text(
                "Saat ini produk belum tersedia",
                textAlign: TextAlign.center,
                style: poppinsRegular,
              ),
            ),
          ]
        )
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