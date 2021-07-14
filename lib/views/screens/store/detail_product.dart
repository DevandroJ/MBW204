import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import "package:flutter/material.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:mbw204_club_ina/views/basewidget/search.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/basewidget/error_component.dart';
import 'package:mbw204_club_ina/data/models/warung/card_add_model.dart';
import 'package:mbw204_club_ina/data/models/warung/product_single_warung_model.dart';
import 'package:mbw204_club_ina/data/models/warung/product_warung_model.dart';
import 'package:mbw204_club_ina/data/models/warung/seller_store_model.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/store/cart_product.dart';
import 'package:mbw204_club_ina/views/screens/store/seller_edit_product.dart';
import 'package:mbw204_club_ina/views/screens/store/product.dart';
import 'package:mbw204_club_ina/views/screens/store/search_product.dart';

class DetailProductPage extends StatefulWidget {
  final String idProduct;
  final String typeProduct;
  final String path;

  DetailProductPage({
    Key key,
    @required this.idProduct,
    @required this.typeProduct,
    @required this.path,
  }) : super(key: key);
  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();

  bool lastStatus = true;

  bool start = false;
  int current = 0;
  CartModel cartModel;
  bool isLoading = true;
  bool isLoadingBottom = true;
  bool isLoadingProduct = true;
  bool isLoadingCategory = true;
  SellerStoreModel sellerStoreModel;
  ProgressDialog pr;

  ProductSingleWarungModel productSingleWarungModel;
  ProductWarungModel productWarungModel;

  scrollListener() {
    if (isShrink != lastStatus) {
      setState(() => lastStatus = isShrink);
    }
  }

  bool get isShrink {
    return scrollController.hasClients && scrollController.offset > (280 - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(() => scrollListener());

    _getDataProduct();
    _getDataSeller();
  }

  _getDataProduct() async {
    await Provider.of<WarungProvider>(context, listen: false).getDataSingleProduct(context, widget.idProduct, widget.typeProduct, widget.path).then((val) {
      if (val.code == 0) {
        setState(() {
          isLoadingProduct = false;
          productSingleWarungModel = val;
        });
        _getProductByCategory();
      }
    });
  }

  _getDataSeller() async {
    await Provider.of<WarungProvider>(context, listen: false).getDataStore(context).then((value) {
      setState(() {
        isLoadingBottom = false;
        sellerStoreModel = value;
      });
    });
  }

  _getProductByCategory() async {
    await Provider.of<WarungProvider>(context, listen: false).getDataProductByCategoryConsumen(context, productSingleWarungModel.body.name, productSingleWarungModel.body.category.id, 0).then((valueCategory) {
      if (valueCategory.code == 0) {
        setState(() {
          isLoadingCategory = false;
          productWarungModel = valueCategory;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() {
    Navigator.pop(context, true);
    return Future.value(true);
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
      progressTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 13.0, 
        fontWeight: FontWeight.w400
      ),
      messageTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 19.0, 
        fontWeight: FontWeight.w600
      )
    );

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: isLoadingBottom 
        ? loadingDetailPage() 
        : isLoadingProduct ? loadingDetailPage() 
        : detailProduct(),
      ),
    );
  }

  Widget detailProduct() {
    return Consumer<WarungProvider>(
      builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
        if(warungProvider.sellerStoreStatus == SellerStoreStatus.error) {
          return Center(
            child: ErrorComponent(
              height: 120.0,
              width: 120.0,
            ),
          );
        }
        return Stack(
          children: [
          CustomScrollView(
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: isShrink ? Colors.black : Colors.white,
              ),
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Center(
                  child: Platform.isIOS
                  ? Container(
                      margin: EdgeInsets.only(left: 8),
                      child: isShrink
                  ? Icon(Icons.arrow_back_ios)
                  : IconShadowWidget(
                      Icon(
                        Icons.arrow_back_ios, 
                        color: Colors.white
                      ),
                      shadowColor: Colors.black,
                    )
                  )
                  : isShrink
                  ? Icon(
                      Icons.arrow_back, 
                      color: Colors.black
                    )
                  : IconShadowWidget(
                      Icon(Icons.arrow_back, color: Colors.white),
                      shadowColor: Colors.black,
                    ),
                ),
              ),
              pinned: true,
              expandedHeight: 280.0,
              floating: true,
              title: isShrink ? searchCard() : Container(),
              titleSpacing: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Center(child: getImages(productSingleWarungModel)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Consumer<WarungProvider>(
                  builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
                    return warungProvider.cartBody == null 
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                              return CartProdukPage();
                            }));
                          },
                          child: Center(
                            child: isShrink
                            ? Icon(
                              Icons.shopping_cart,
                              color: ColorResources.PRIMARY,
                            )
                            : IconShadowWidget(
                              Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              shadowColor: Colors.black,
                            )
                          ),
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
                        icon: IconShadowWidget(
                          Icon(
                            Icons.shopping_cart,
                            color: isShrink ? ColorResources.PRIMARY : Colors.white,
                          ),
                          shadowColor: isShrink ? Colors.white : Colors.black,
                        ),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartProdukPage())),
                      )
                    );
                  },
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0, top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ConnexistHelper.formatCurrency(productSingleWarungModel.body.price),
                            textAlign: TextAlign.start,
                            style: poppinsRegular.copyWith(
                              fontSize: 20.0, 
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 8.0),
                      child: Text(productSingleWarungModel.body.name,
                        textAlign: TextAlign.start,
                        style: poppinsRegular.copyWith(
                          fontSize: 16.0
                        )
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 8.0),
                      child: Text(productSingleWarungModel.body.stock < 1 ? "Stok Habis" : "Stok  " + productSingleWarungModel.body.stock.toString(),
                        textAlign: TextAlign.start,
                        style: poppinsRegular.copyWith(
                          fontSize: 15.0
                        )
                      ),
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: productSingleWarungModel.body.stats.ratingAvg,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8, right: 15),
                          child: Text(productSingleWarungModel.body.stats.ratingAvg.toString().substring(0, 3),
                            style: poppinsRegular.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 15.0,
                color: Colors.grey[100],
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(55.0)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(55.0),
                        child: CachedNetworkImage(
                          imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${productSingleWarungModel.body.store.picture.path}",
                          fit: BoxFit.cover,
                          placeholder: (BuildContext context, String url) => Loader(
                            color: ColorResources.PRIMARY,
                          ),
                          errorWidget: (BuildContext context, String url, dynamic error) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/default_image.png'),
                                fit: BoxFit.cover
                              )
                            ),
                          ),
                        ),
                      )
                    ),
                    SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(productSingleWarungModel.body.store.name,
                          style: poppinsRegular.copyWith(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        SizedBox(height: 5.0),
                        Text(productSingleWarungModel.body.store.city,
                          style: poppinsRegular.copyWith(
                            color: Colors.grey[600], 
                            fontSize: 14.0
                          )
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 15.0,
                color: Colors.grey[100],
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    showKurirAvailable(productSingleWarungModel.body.store.supportedCouriers);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Dukungan Kurir",
                              style: poppinsRegular.copyWith(                                
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 15.0,
                color: Colors.grey[100],
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Text("Informasi Produk",
                  style: poppinsRegular.copyWith(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Berat",
                          style: poppinsRegular.copyWith(
                            color: Colors.black, 
                            fontSize: 16.0
                          )
                        ),
                        Container(
                          child: Text(
                            productSingleWarungModel.body.weight.toString() + " Gram",
                            style: poppinsRegular.copyWith(
                                color: ColorResources.PRIMARY,
                                fontSize: 16.0
                              )
                            ),
                        )
                      ]
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Kondisi",
                          style: poppinsRegular.copyWith(
                            color: Colors.black, 
                            fontSize: 16.0
                          )
                        ),
                        Container(
                          child: Text(
                            productSingleWarungModel.body.condition == "NEW"
                            ? "Baru"
                            : "Bekas",
                            style: poppinsRegular.copyWith(
                              color: ColorResources.PRIMARY,
                              fontSize: 16
                            )
                          ),
                        )
                      ]
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Pemesanan Min",
                          style: poppinsRegular.copyWith(
                            color: Colors.black, 
                            fontSize: 16.0
                          )
                        ),
                        Container(
                          child: Text(productSingleWarungModel.body.minOrder.toString() + " Buah",
                            style: poppinsRegular.copyWith(
                              color: ColorResources.PRIMARY,
                              fontSize: 16.0
                            )
                          ),
                        )
                      ]
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Kategori",
                          style: poppinsRegular.copyWith(
                            color: Colors.black, 
                            fontSize: 16.0
                          )
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ProductPage(
                                idCategory: productSingleWarungModel.body.category.id,
                                nameCategory: productSingleWarungModel.body.category.name,
                                typeProduct: widget.typeProduct,
                                path: widget.path
                              );
                            }));
                          },
                          child: Text(
                            productSingleWarungModel.body.category.name,
                            style: poppinsRegular.copyWith(                                  fontSize: 16.0,
                              color: ColorResources.PRIMARY
                            )
                          ),
                        )
                      ]
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
              Divider(
                thickness: 15.0,
                color: Colors.grey[100],
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Text("Deskripsi",
                  style: poppinsRegular.copyWith(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: productSingleWarungModel.body.description.length > 200
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(productSingleWarungModel.body.description.substring(0, 200) + "...",
                          style: poppinsRegular.copyWith(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8.0),
                        GestureDetector(
                          onTap: () {
                            modalDeskripsi(productSingleWarungModel);
                          },
                          child: Text("Baca Selengkapnya",
                            style: poppinsRegular.copyWith(
                              fontSize: 16.0, 
                              color: ColorResources.PRIMARY
                            ),
                          ),
                        )
                      ],
                    )
                  : Text(
                    productSingleWarungModel.body.description,
                    style: poppinsRegular.copyWith(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
              ),
              Divider(
                thickness: 15.0,
                color: Colors.grey[100],
              ),
            ]
          )
        ),
          getAdapter(),
            SliverToBoxAdapter(
            child: SizedBox(
              height: 80.0,
            )
          ),
         ],
        ),
        isLoadingBottom
        ? Container()
        : Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60.0,
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5.0,
                    blurRadius: 7.0,
                    offset: Offset(0, 4.0),
                  ),
                ],
              ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (sellerStoreModel?.body != null) {
                            if (productSingleWarungModel.body.store.id != sellerStoreModel?.body?.id) {
                              if (productSingleWarungModel.body.stock < 1) {
                                Fluttertoast.showToast(
                                  backgroundColor: ColorResources.ERROR,
                                  textColor: Colors.white,
                                  msg: "Stok Barang Habis",
                                  fontSize: 14.0
                                );
                              } else {
                                await Provider.of<WarungProvider>(context, listen: false).postAddCart(context, productSingleWarungModel.body.id, productSingleWarungModel.body.minOrder);   
                              }
                          } else {
                            if (productSingleWarungModel.body.stock < 1) {
                              Fluttertoast.showToast(
                                backgroundColor: ColorResources.ERROR,
                                textColor: Colors.white,
                                msg: "Stok Barang Habis",
                                fontSize: 14.0
                              );
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return EditProductWarungPage(
                                  idProduct: productSingleWarungModel.body.id,
                                  typeProduct: widget.typeProduct,
                                  path: widget.path
                                );
                              }));
                            }
                          }
                          } else {
                            if (productSingleWarungModel.body.stock < 1) {
                              Fluttertoast.showToast( 
                                backgroundColor: ColorResources.ERROR,
                                textColor: Colors.white,
                                fontSize: 14.0,
                                msg: "Stok Barang Habis",
                              );
                            } else {
                              await Provider.of<WarungProvider>(context, listen: false).postAddCart(context, productSingleWarungModel.body.id, productSingleWarungModel.body.minOrder);
                            }
                          }
                        },
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: ColorResources.PRIMARY
                          ),
                          child: Center(
                            child: getStatusText(),
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
      },
    );
  }

  Widget getAdapter() {
    if (sellerStoreModel?.body != null) {
      if (productSingleWarungModel.body.store.id != sellerStoreModel?.body?.id) {
        return isLoadingCategory ? loadingWarungId() : getDataProductByCategory();
      } else {
        return SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: Text("Pembeli akan melihat barangmu tampil seperti ini",
            style: poppinsRegular.copyWith(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          )
        );
      }
    } else {
      return isLoadingCategory ? loadingWarungId() : getDataProductByCategory();
    }
  }

  Color getStatusColor() {
    if (sellerStoreModel?.body != null) {
      if (productSingleWarungModel.body.store.id != sellerStoreModel?.body?.id) {
        if (productSingleWarungModel.body.stock < 1) {
          return Colors.grey[200];
        } else {
          return ColorResources.PRIMARY;
        }
      } else {
        if (productSingleWarungModel.body.stock < 1) {
          return Colors.grey[200];
        } else {
          return Colors.grey[200];
        }
      }
    } else {
      if (productSingleWarungModel.body.stock < 1) {
        return Colors.grey[200];
      } else {
        return ColorResources.PRIMARY;
      }
    }
  }

  Text getStatusText() {
    if (sellerStoreModel?.body != null) {
      if (productSingleWarungModel.body.store.id != sellerStoreModel?.body?.id) {
        if (productSingleWarungModel.body.stock < 1) {
          return Text("Stok Habis",
            style: poppinsRegular.copyWith(color: Colors.black, fontSize: 16));
        } else {
          return Text("Tambah Keranjang",
            style: poppinsRegular.copyWith(color: Colors.white, fontSize: 16));
        }
      } else {
        if (productSingleWarungModel.body.stock < 1) {
          return Text("Stok Habis",
            style: poppinsRegular.copyWith(color: Colors.black, fontSize: 16));
        } else {
          return Text("Ubah Produk",
            style: poppinsRegular.copyWith(color: Colors.white, fontSize: 16));
        }
      }
    } else {
      if (productSingleWarungModel.body.stock < 1) {
        return Text("Stok Habis",
          style: poppinsRegular.copyWith(color: Colors.black, fontSize: 16));
      } else {
        return Text("Tambah Keranjang",
          style: poppinsRegular.copyWith(color: Colors.white, fontSize: 16));
      }
    }
  }

  Widget searchCard() => InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SearchProductPage(
          typeProduct: widget.typeProduct,
        );
      }));
    },
    child: Container(
      height: 45.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Color(0xffF0F1F5),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
            child: Icon(
              Icons.search,
              color: Color(0xffC4C6CC),
            ),
          ),
          Text("Cari Produk di Indomini Mart",
            style: poppinsRegular.copyWith(
              color: Color(0xffC4C6CC),
              fontSize: 14.0,
            ),
          )
        ],
      ),
    ),
  );

  Widget getImages(ProductSingleWarungModel imageUrl) {
    return Container(
      child: Stack(
        children: [
          CarouselSlider(
            items: imageUrl.body.pictures.map((fileImage) {
              return GestureDetector(
                onTap: () => modalBottomimages(context, current, imageUrl),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                      child: CachedNetworkImage(
                    imageUrl: AppConstants.BASE_URL_FEED_IMG + fileImage.path,
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
                    errorWidget: (context, url, error) => Center(
                        child: Image.asset(
                      "assets/default_image.png",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )),
                  )),
                ),
              );
            }).toList(),
            options: CarouselOptions(
                height: double.infinity,
                enableInfiniteScroll: false,
                aspectRatio: 16 / 9,
                autoPlay: false,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() => current = index);
                }),
          ),
          imageUrl.body.pictures.length != 1
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imageUrl.body.pictures.map((url) {
                  int index = imageUrl.body.pictures.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current == index ? Colors.red[600] : Colors.grey[200]
                    ),
                  );
                }).toList(),
              ),
            )
          : Container()
        ],
      ),
    );
  }

  void modalBottomimages(BuildContext context, int number, ProductSingleWarungModel imageUrl) {
    PageController pageController = PageController(initialPage: number);

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        context: context,
        builder: (BuildContext cn) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0
              )
            )
          ),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: PhotoViewGallery.builder(
                    pageController: pageController,
                    itemCount: imageUrl.body.pictures.length,
                    loadingBuilder: (context, event) => Center(
                      child: Container(
                        child: Loader(
                          color: ColorResources.PRIMARY
                        ),
                      ),
                    ),
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(AppConstants.BASE_URL_FEED_IMG + imageUrl.body.pictures[index].path),
                        initialScale: PhotoViewComputedScale.contained * 1,
                        heroAttributes: PhotoViewHeroAttributes(
                          tag: AppConstants.BASE_URL_FEED_IMG +
                          imageUrl.body.pictures[index].path
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    )
                  ),
                ),
              ],
            )
          ),
        );
      }
    );
  }

  Widget getDataProductByCategory() {
    var delivered = productWarungModel.body.where((element) => element.id != widget.idProduct).toList();
    return SliverToBoxAdapter(
      child: Container(
        height: delivered.length == 0 || delivered == null ? 0.0 : 420.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            delivered.length == 0 || delivered == null
            ? Container()
            : Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Produk yang serupa",
                    style: poppinsRegular.copyWith(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ProductPage(
                          idCategory: productSingleWarungModel.body.category.id,
                          nameCategory: productSingleWarungModel.body.category.name,
                          typeProduct: widget.typeProduct,
                          path: widget.path
                        );
                      }));
                    },
                    child: Text("Lihat Semua",
                      style: poppinsRegular.copyWith(
                        fontSize: 16.0,
                        color: ColorResources.PRIMARY,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
              child: SearchWidget(
                hintText: "Cari Produk di Toko Benz Mart",
              ),
            ),
            delivered.length == 0 || delivered == null
            ? Container()
            : Container(
              height: 300.0,
              child: ListView(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: productWarungModel.body.where((element) => element.id != widget.idProduct).map((resultProduct) {
                  return itemsData(context, resultProduct);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingWarungId() {
    return SliverToBoxAdapter(
      child: Container(
        height: 320.0,
        margin: EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[200],
              highlightColor: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 180.0,
                    height: 15.0,
                    margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white
                    ),
                  ),
                  Container(
                    height: 280.0,
                    padding: EdgeInsets.only(left: 16.0, right: 7.0, bottom: 16.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 150.0,
                          margin: EdgeInsets.only(right: 7.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0)
                          ),
                        );
                      },
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemsData(BuildContext context, ProductWarungList productWarungList) {
    return Container(
      width: 170.0,
      margin: EdgeInsets.only(right: 5.0),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: InkWell(
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
                aspectRatio: 5 / 4,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0)
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0)
                        ),
                        child: CachedNetworkImage(
                          imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${productWarungList.pictures.first.path}",
                          fit: BoxFit.cover,
                          placeholder: (BuildContext context, String url) => Center(
                            child: Shimmer.fromColors(
                            baseColor: Colors.grey[200],
                            highlightColor: Colors.grey[100],
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        ),
                          errorWidget: (BuildContext context, String url, dynamic error) => Center(
                            child: Image.asset(
                            "assets/default_image.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        ),
                      ),
                    )
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
                              topLeft: Radius.circular(12)),
                              color: Colors.red[900]
                            ),
                          child: Center(
                            child: Text(productWarungList.discount.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
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
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    productWarungList.name.length > 35
                    ? Text(
                        productWarungList.name.substring(0, 35) + "...",
                        maxLines: 2,
                        style: poppinsRegular.copyWith(
                          fontSize: 15.0,
                        ),
                      )
                    : Text(
                        productWarungList.name,
                        maxLines: 2,
                        style: poppinsRegular.copyWith(
                          fontSize: 15.0,
                        ),
                      ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(ConnexistHelper.formatCurrency(productWarungList.price),
                      style: poppinsRegular.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 20.0,
                          width: 20.0,
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                            color: ColorResources.PRIMARY
                          ),
                          child: Center(
                            child: Icon(Icons.store,
                              color: Colors.white, 
                              size: 15.0
                            )
                          )
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productWarungList.store.name,
                                style: poppinsRegular.copyWith(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(productWarungList.store.city,
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
                      height: 8.0,
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
                          margin: EdgeInsets.only(left: 8.0, right: 15.0),
                          child: Text(
                            "(" + productWarungList.stats.ratingAvg.toString().substring(0, 3) + ")",
                            style: poppinsRegular.copyWith(
                              fontSize: 12.0,
                              color: ColorResources.PRIMARY,
                              fontWeight: FontWeight.bold,
                            )
                          ),
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
      ),
    );
  }

  void showKurirAvailable(List<SupportedCourierProductWarungSingle> kurir) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close)),
                      Container(
                        margin: EdgeInsets.only(left: 16),
                        child: Text("Kurir yang tersedia",
                          style: poppinsRegular.copyWith(
                            fontSize: 16.0, 
                            color: Colors.black
                          )
                        )
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 3,
                ),
                Expanded(
                  flex: 40,
                  child: Container(
                    padding: EdgeInsets.only(top: 8, bottom: 16),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: kurir.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 16,
                            right: 16,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60.0,
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl: AppConstants.BASE_URL_FEED_IMG +
                                        kurir[index].image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    // height: double.infinity,
                                    placeholder: (context, url) => Center(
                                        child: Shimmer.fromColors(
                                      baseColor: Colors.grey[200],
                                      highlightColor: Colors.grey[100],
                                      child: Container(
                                        color: Colors.white,
                                        width: double.infinity,
                                        // height: double.infinity,
                                      ),
                                    )),
                                    errorWidget: (BuildContext context, String url,  dynamic error) =>
                                      Center(child: Image.asset(
                                      "assets/default_image.png",
                                      fit: BoxFit.cover,
                                    )
                                  ),
                                ),
                              )
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              child: Text(kurir[index].name,
                                style: poppinsRegular.copyWith(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                              )
                            ),
                          ],
                        )
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        thickness: 1.0,
                      );
                    },
                  )
                ),
              )
            ],
          )
        );
      },
    );
  }

  modalDeskripsi(ProductSingleWarungModel productSingleWarungModel) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.96,
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
                        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(Icons.close)
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16.0),
                              child: Text("Deskripsi Produk",
                                style: poppinsRegular.copyWith(
                                  fontSize: 16.0,
                                  color: Colors.black
                                )
                              )
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 3.0,
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(16.0),
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: [
                          Row(
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
                                          imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${productSingleWarungModel.body.pictures.first.path}",
                                          fit: BoxFit.cover,
                                          placeholder: (BuildContext context, String url) =>
                                            Center(
                                              child: Shimmer.fromColors(
                                              baseColor: Colors.grey[200],
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
                                    productSingleWarungModel.body.discount != null
                                      ? Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            height: 20.0,
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(12.0),
                                                topLeft: Radius.circular(12.0)
                                              ),
                                              color: Colors.red[900]
                                            ),
                                            child: Text(productSingleWarungModel.body.discount.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
                                            style: poppinsRegular.copyWith(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ),
                                    )
                                    : Container()
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    productSingleWarungModel.body.name.length > 90
                                      ? Text(
                                          productSingleWarungModel.body.name.substring(0, 90) + "...",
                                          maxLines: 2,
                                          style: poppinsRegular.copyWith(
                                            fontSize: 15.0,
                                          ),
                                        )
                                      : Text(productSingleWarungModel.body.name,
                                        maxLines: 2,
                                        style: poppinsRegular.copyWith(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(ConnexistHelper.formatCurrency(productSingleWarungModel.body.price),
                                      style: poppinsRegular.copyWith(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("STOK: ",
                                          style: poppinsRegular.copyWith(
                                            fontSize: 14.0,
                                            color: ColorResources.PRIMARY
                                          )
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(productSingleWarungModel.body.stock.toString(),
                                          style: poppinsRegular.copyWith(
                                            fontSize: 14.0,
                                            color: ColorResources.PRIMARY
                                          )
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ]
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Divider(
                              thickness: 2.0,
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              productSingleWarungModel.body.description,
                              style: poppinsRegular.copyWith(
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
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

  Widget loadingDetailPage() {
    return ListView(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity, 
                height: 280.0, 
                color: Colors.white
              ),
              Container(
                width: double.infinity,
                height: 20.0,
                margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white
                ),
              ),
              Container(
                width: double.infinity,
                height: 20.0,
                margin: EdgeInsets.only(left: 16.0, right: 100.0, top: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white
                ),
              ),
              Container(
                width: 120.0,
                height: 20.0,
                margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 15.0,
          color: Colors.grey[100],
        ),
        SizedBox(height: 16.0),
        Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[100],
          child: Row(
            children: [
              Container(
                width: 50.0,
                height: 50.0,
                margin: EdgeInsets.only(left: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.white
                )
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140.0,
                    height: 15.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: 80.0,
                    height: 15.0,
                    margin: EdgeInsets.only(top: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 16.0),
        Divider(
          thickness: 15.0,
          color: Colors.grey[100],
        ),
        SizedBox(height: 16.0),
        Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 150.0,
                height: 15.0,
                margin: EdgeInsets.only(
                  left: 16.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white
                ),
              ),
              Container(
                width: 20.0,
                height: 20.0,
                margin: EdgeInsets.only(right: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.0),
        Divider(
          thickness: 15.0,
          color: Colors.grey[100],
        ),
        SizedBox(height: 16.0),
        Container(
          height: 320.0,
          child: Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 180.0,
                      height: 15.0,
                      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white
                      ),
                    ),
                    Container(
                      height: 280.0,
                      padding: EdgeInsets.only(left: 16.0, right: 7.0, bottom: 16.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 150.0,
                            margin: EdgeInsets.only(right: 7.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0)
                            ),
                          );
                        },
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
