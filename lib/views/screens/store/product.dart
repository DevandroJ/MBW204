import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import "package:lottie/lottie.dart";
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/views/basewidget/search.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/data/models/warung/card_add_model.dart';
import 'package:mbw204_club_ina/data/models/warung/category_product_model.dart';
import 'package:mbw204_club_ina/data/models/warung/product_warung_model.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/views/screens/store/cart_product.dart';
import 'package:mbw204_club_ina/views/screens/store/detail_product.dart';

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
  String idCategory;
  CartModel cartModel;
  CategoryProductModel categoryProductModel;

  @override
  void initState() {
    super.initState();
    idCategory = widget.idCategory;
    Future.delayed(Duration.zero, () {
      Provider.of<WarungProvider>(context, listen: false).getDataCategoryProductByParent(context, widget.typeProduct, widget.idCategory);
      Provider.of<WarungProvider>(context, listen: false).getDataProductByCategoryConsumen(context, "", idCategory);
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        getMoreData();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void getMoreData() async {
    Provider.of<WarungProvider>(context, listen: false).getDataProductByCategoryConsumenLoad(context, "", idCategory);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: scrollController,
           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
  
              SliverAppBar(
                iconTheme: IconThemeData(
                  color: ColorResources.BTN_PRIMARY
                ),
                title: Text("Produk - ${widget.nameCategory}",
                  style: poppinsRegular.copyWith(
                    color: ColorResources.BTN_PRIMARY,
                    fontWeight: FontWeight.bold
                  ),
                ),
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
                        hintText: "Cari Produk",
                        type: "commerce",
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
                          position: BadgePosition.topEnd(top: 3.0, end: 6.0),
                          animationDuration: Duration(milliseconds: 300),
                          animationType: BadgeAnimationType.slide,
                          badgeContent: Text(
                            warungProvider.cartBody.numOfItems.toString(),
                            style: poppinsRegular.copyWith(
                              color: Colors.white, 
                              fontSize: 12.0
                            ),
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
                  ]
                )
              ))),

              SliverToBoxAdapter(
                child: getCategoryParent(),
              ),
            
            ];
          },
          body: getDataProductByCategory(),
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
                itemBuilder: (BuildContext context, int i) {
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
            itemCount: warungProvider.categoryProductByParentList.length + 1,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int i) {
              if(i == 0) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      idCategory = widget.idCategory;
                    });
                    Provider.of<WarungProvider>(context, listen: false).getDataProductByCategoryConsumen(context, "", idCategory);
                  },
                child: Container(
                  height: 50.0,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: idCategory == widget.idCategory ? ColorResources.PRIMARY : ColorResources.WHITE,
                    border: Border.all(
                      color: ColorResources.BTN_PRIMARY,
                      width: 1.0
                    )
                  ),
                  child: Center(
                    child: Text(widget.nameCategory,
                  style: poppinsRegular.copyWith(
                    color: idCategory == widget.idCategory ? ColorResources.WHITE : ColorResources.PRIMARY,
                    fontSize: 14.0,
                  )))),
                );
              }
              return InkWell(
                onTap: () {
                  setState(() {
                    idCategory = warungProvider.categoryProductByParentList[i-1].id;
                  });
                  Provider.of<WarungProvider>(context, listen: false).getDataProductByCategoryConsumen(context, "", idCategory);
                },
                child: Container(
                  height: 50.0,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: idCategory == warungProvider.categoryProductByParentList[i-1].id ? ColorResources.PRIMARY : ColorResources.WHITE,
                    border: Border.all(
                      color: ColorResources.BTN_PRIMARY,
                      width: 1.0
                    )
                  ),
                  child: Center(
                    child: Text(warungProvider.categoryProductByParentList[i-1].name,
                  style: poppinsRegular.copyWith(
                    color: idCategory == warungProvider.categoryProductByParentList[i-1].id ? ColorResources.WHITE : ColorResources.PRIMARY,
                    fontSize: 14.0,
                  )
                ))),
              );
            },
          ),
        );
      },
    );
  }

  Widget getDataProductByCategory() {
    return Consumer<WarungProvider>(  
      builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
        if(warungProvider.categoryProductByCategoryConsumenStatus == CategoryProductByCategoryConsumenStatus.loading) {
          return loadingList();
        }
        return RefreshIndicator(
          onRefresh: () {
            return Provider.of<WarungProvider>(context, listen: false).getDataProductByCategoryConsumen(context, "", idCategory);
          },
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
            physics: AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1 / 1.7
            ),
            itemCount: warungProvider.productWarungConsumenList.length,
            itemBuilder: (BuildContext context, int i) {
              if (i == warungProvider.productWarungConsumenList.length) {
                return Container();
              } else {
                return itemsData(context, warungProvider.productWarungConsumenList[i]);
              }
            },
          ),
        );
      },
    );
  }

  Widget itemsData(BuildContext context, ProductWarungList productWarungList) {
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
                idProduct: productWarungList.id,
                typeProduct: "commerce",
                path: "",
              );
            }));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              border: Border.all(
                color: Colors.grey,
                width: 0.5
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 5 / 5,
                  child: Stack(
                    children: [
                    ClipRRect(
                     borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)
                      ),
                      child: CachedNetworkImage(
                        imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${productWarungList.pictures.first.path}",
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: imageProvider
                              )
                            ),
                          );
                        },
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
                                topLeft: Radius.circular(12)
                              ),
                              color: Colors.red[900]
                            ),
                            child: Center(
                              child: Text(productWarungList.discount.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
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
                          productWarungList.name,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular.copyWith(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      Text(ConnexistHelper.formatCurrency(productWarungList.price),
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
                                Text(productWarungList.store.name,
                                maxLines: 1,
                                style: poppinsRegular.copyWith(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                Text(productWarungList.store.city,
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
                            margin: EdgeInsets.only(left: 4.0),
                            child: Text("${productWarungList.stats.ratingAvg.toString().substring(0, 3)}",
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
  }

  Widget loadingList() {
    return Container(
      child: GridView.builder(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
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
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0),
                      ),
                      color: Colors.white
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    width: 150.0,
                    height: 15.0,
                    margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 15.0,
                    margin: EdgeInsets.only(left: 8.0, right: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white
                    ),
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
            height: 200.0,
            width: 200.0,
          ),
          SizedBox(height: 20.0),
          Container(
            child: Text("Saat ini produk belum tersedia",
              textAlign: TextAlign.center,
              style: poppinsRegular,
            ),
          ),
        ]
      )
    ));
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