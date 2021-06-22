import 'package:badges/badges.dart';
import 'package:flutter/services.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/data/models/warung/card_add_model.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/views/screens/warung/cart_product.dart';
import 'package:mbw204_club_ina/views/screens/warung/product.dart';
import 'package:mbw204_club_ina/views/basewidget/search.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/basewidget/error_component.dart';

class JualBeliPage extends StatefulWidget {
  @override
  _JualBeliPageState createState() => _JualBeliPageState();
}

class _JualBeliPageState extends State<JualBeliPage> with SingleTickerProviderStateMixin { 

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
  
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<WarungProvider>(context, listen: false).getDataCategoryProduct(context, "commerce");
      Provider.of<WarungProvider>(context, listen: false).getDataStore(context, "seller");
      Provider.of<WarungProvider>(context, listen: false).getCartInfo(context);
    });
  }

  Future<bool> onWillPop() {
    return SystemNavigator.pop();
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
              child: CustomScrollView(
                controller: scrollController,
                  slivers: [

                    // Custom App Bar
                    SliverToBoxAdapter(
                      child: CustomAppBar(title: "Benz Mart", isBackButtonExist: true),
                    ),

                    // Search Button
                    SliverPersistentHeader(
                      pinned: true,               
                      delegate: SliverDelegate(
                        child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_SMALL, 
                          vertical: isShrink ? 2.0 : 0.0 
                        ),
                        color: isShrink ? Colors.white : Colors.transparent,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Expanded(
                              child: SearchWidget(
                                hintText: "Cari Produk di Benz Mart",
                              )
                            ),
                            Consumer<WarungProvider>(
                              builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
                                return warungProvider.cartBody == null 
                                ? 
                                  GestureDetector(
                                    onTap: () { 
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => CartProdukPage()));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20.0, right: 14.0),
                                      child: Icon(
                                        Icons.shopping_cart,
                                        color: isShrink ? Colors.white : ColorResources.PRIMARY,
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
                                    onPressed: () { 
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => CartProdukPage()));
                                    }
                                  )
                                );
                              },
                            ),
                          ]
                        )
                      )
                    )),
                    
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                      child: getDataCategory(context),
                    ),
                  ), 
                  
                ],
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
          return Shimmer.fromColors(
            baseColor: Colors.grey[200],
            highlightColor: Colors.grey[300],
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: 4 / 5,
              ),
              physics: BouncingScrollPhysics(),
              itemCount: 6,
              itemBuilder: (BuildContext context, int i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white
                      ),
                    ),
                  ],
                );
              },
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
          return Padding(
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kategori Pilihan",
              style: TextStyle(
                fontSize: 17.0 * MediaQuery.of(context).textScaleFactor,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 15.0),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 3 / 4,
              ),
              physics: BouncingScrollPhysics(),
              itemCount: warungProvider.categoryProductList.length,
              itemBuilder: (BuildContext context, int i) {
                return Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    onTap: () { 
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(
                        idCategory: warungProvider.categoryProductList[i].id,
                        nameCategory: warungProvider.categoryProductList[i].name,
                        typeProduct: "commerce",
                        path: ""
                      ))); 
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 30.0,
                            width: 30.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60.0),
                              child: CachedNetworkImage(
                                imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${warungProvider.categoryProductList[i].picture.path}",
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[200],
                                  highlightColor: Colors.grey[100],
                                  child: Container(
                                    color: Colors.white,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                )),
                                errorWidget: (context, url, error) => Center(child: Image.asset("assets/default_image.png", fit: BoxFit.cover)),
                              ),
                            )
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            child: warungProvider.categoryProductList.length > 16
                            ? Text(
                              warungProvider.categoryProductList[i].name.substring(0, 15) + "...",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11.0,
                              ),
                              textAlign: TextAlign.center,
                            )
                            : Text(warungProvider.categoryProductList[i].name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11.0,
                                height: 1.4
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
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
