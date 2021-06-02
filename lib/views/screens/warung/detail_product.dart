import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import "package:flutter/material.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/basewidget/error_component.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/data/models/warung/card_add_model.dart';
import 'package:mbw204_club_ina/data/models/warung/product_single_warung_model.dart';
import 'package:mbw204_club_ina/data/models/warung/product_warung_model.dart';
import 'package:mbw204_club_ina/data/models/warung/seller_store_model.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/warung/cart_product.dart';
import 'package:mbw204_club_ina/views/screens/warung/edit_product_warung.dart';
import 'package:mbw204_club_ina/views/screens/warung/product.dart';
import 'package:mbw204_club_ina/views/screens/warung/search_product.dart';

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
  int _current = 0;
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
    await Provider.of<WarungProvider>(context, listen: false).getDataStore(context, 'buyer').then((value) {
      setState(() {
        isLoadingBottom = false;
        sellerStoreModel = value;
      });
    });
  }

  _getProductByCategory() async {
    await Provider.of<WarungProvider>(context, listen: false).getDataProductByCategoryConsumen(context, productSingleWarungModel.body.category.id, 0).then((valueCategory) {
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

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
        return Future.value(true);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: isLoadingBottom 
        ? loadingDetailPage() 
        : isLoadingProduct ? loadingDetailPage() 
        : _detailProduct(),
      ),
    );
  }

  Widget _detailProduct() {
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
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
                                  Icon(Icons.arrow_back_ios,
                                      color: Colors.white),
                                  shadowColor: Colors.black,
                                ))
                      : isShrink
                          ? Icon(Icons.arrow_back, color: Colors.black)
                          : IconShadowWidget(
                              Icon(Icons.arrow_back, color: Colors.white),
                              shadowColor: Colors.black,
                            ),
                ),
              ),
              pinned: true,
              expandedHeight: 280.0,
              floating: true,
              title: isShrink ? _searchCard() : Container(),
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
                          style: TextStyle(color: Colors.white, fontSize: 12),
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
              delegate: SliverChildListDelegate(<Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 16),
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
                            style: TextStyle(
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
                        style: TextStyle(
                          fontSize: 16.0
                        )
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                          productSingleWarungModel.body.stock < 1
                              ? "Stok Habis"
                              : "Stok  " +
                                  productSingleWarungModel.body.stock
                                      .toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15.0)),
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
                          child: Text(
                              productSingleWarungModel.body.stats.ratingAvg
                                  .toString()
                                  .substring(0, 3),
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    )
                    // : Container(),
                  ],
                ),
              ),
              Divider(
                thickness: 15,
                color: Colors.grey[100],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(55)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(55),
                          child: CachedNetworkImage(
                            imageUrl:
                                productSingleWarungModel.body.store.picture ==
                                        null
                                    ? ""
                                    : AppConstants.BASE_URL_FEED_IMG +
                                        productSingleWarungModel
                                            .body.store.picture.path,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Loader(
                              color: ColorResources.PRIMARY,
                            ),
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/default_toko.jpg"),
                          ),
                        )),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(productSingleWarungModel.body.store.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text(productSingleWarungModel.body.store.city,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14)),
                      ],
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 15,
                color: Colors.grey[100],
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () {
                    _showKurirAvailable(
                        productSingleWarungModel.body.store.supportedCouriers);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dukungan Kurir",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
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
                thickness: 15,
                color: Colors.grey[100],
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Informasi Produk",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Berat",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          Container(
                            child: Text(
                                productSingleWarungModel.body.weight
                                        .toString() +
                                    " Gram",
                                style: TextStyle(
                                    color: ColorResources.PRIMARY,
                                    fontSize: 16)),
                          )
                        ]),
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Kondisi",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          Container(
                            child: Text(
                                productSingleWarungModel.body.condition == "NEW"
                                    ? "Baru"
                                    : "Bekas",
                                style: TextStyle(
                                    color: ColorResources.PRIMARY,
                                    fontSize: 16)),
                          )
                        ]),
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Pemesanan Min",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          Container(
                            child: Text(
                                productSingleWarungModel.body.minOrder
                                        .toString() +
                                    " Buah",
                                style: TextStyle(
                                    color: ColorResources.PRIMARY,
                                    fontSize: 16)),
                          )
                        ]),
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Kategori",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ProductPage(
                                    idCategory: productSingleWarungModel
                                        .body.category.id,
                                    nameCategory: productSingleWarungModel
                                        .body.category.name,
                                    typeProduct: widget.typeProduct,
                                    path: widget.path);
                              }));
                            },
                            child: Text(
                                productSingleWarungModel.body.category.name,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: ColorResources.PRIMARY)),
                          )
                        ]),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Divider(
                thickness: 15,
                color: Colors.grey[100],
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Deskripsi",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: productSingleWarungModel.body.description.length > 200
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productSingleWarungModel.body.description
                                    .substring(0, 200) +
                                "...",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              _modalDeskripsi(productSingleWarungModel);
                            },
                            child: Text(
                              "Baca Selengkapnya",
                              style: TextStyle(
                                  fontSize: 16, color: ColorResources.PRIMARY),
                            ),
                          )
                        ],
                      )
                    : Text(
                        productSingleWarungModel.body.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
              ),
              Divider(
                thickness: 15,
                color: Colors.grey[100],
              ),
            ])),
            getAdapter(),
            SliverToBoxAdapter(
                child: SizedBox(
              height: 80,
            )),
          ],
        ),
        isLoadingBottom
        ? Container()
        : Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 60,
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (sellerStoreModel.body != null) {
                            if (productSingleWarungModel.body.store.id !=
                                sellerStoreModel.body.id) {
                              if (productSingleWarungModel.body.stock < 1) {
                                Fluttertoast.showToast(
                                    msg: "Stok Barang Habis",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white);
                              } else {
                                pr.show();
                                await warungVM
                                    .postAddCart(
                                      context,
                                      productSingleWarungModel.body.id,
                                      productSingleWarungModel.body.minOrder)
                                    .then((value) {
                                  if (value.code == 0) {
                                    pr.hide();
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) {
                                      return CartProdukPage();
                                    }));
                                  } else {
                                    pr.hide();
                                    Fluttertoast.showToast(
                                        msg:
                                            "Terjadi kesalahan ketika tambah keranjang",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white);
                                  }
                                });
                              }
                            } else {
                              if (productSingleWarungModel.body.stock < 1) {
                                Fluttertoast.showToast(
                                    msg: "Stok Barang Habis",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white);
                              } else {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return EditProductWarungPage(
                                      idProduct:
                                          productSingleWarungModel.body.id,
                                      typeProduct: widget.typeProduct,
                                      path: widget.path);
                                }));
                              }
                            }
                          } else {
                            if (productSingleWarungModel.body.stock < 1) {
                              Fluttertoast.showToast(
                                msg: "Stok Barang Habis",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white
                              );
                            } else {
                              pr.show();
                              await warungVM.postAddCart(
                                context, 
                                productSingleWarungModel.body.id,
                                productSingleWarungModel.body.minOrder
                              ).then((value) {
                                if (value.code == 0) {
                                  pr.hide();
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                    return CartProdukPage();
                                  }));
                                } else {
                                  pr.hide();
                                  Fluttertoast.showToast(
                                    msg: "Terjadi kesalahan ketika tambah keranjang",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white
                                  );
                                }
                              });
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: getStatusColor()
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
    if (sellerStoreModel.body != null) {
      if (productSingleWarungModel.body.store.id != sellerStoreModel.body.id) {
        return isLoadingCategory
            ? loadingWarungId()
            : getDataProductByCategory();
      } else {
        return SliverToBoxAdapter(
            child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            "Pembeli akan melihat barangmu tampil seperti ini",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ));
      }
    } else {
      return isLoadingCategory ? loadingWarungId() : getDataProductByCategory();
    }
  }

  Color getStatusColor() {
    if (sellerStoreModel.body != null) {
      if (productSingleWarungModel.body.store.id != sellerStoreModel.body.id) {
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
    if (sellerStoreModel.body != null) {
      if (productSingleWarungModel.body.store.id != sellerStoreModel.body.id) {
        if (productSingleWarungModel.body.stock < 1) {
          return Text("Stok Habis",
              style: TextStyle(color: Colors.black, fontSize: 16));
        } else {
          return Text("Tambah Keranjang",
              style: TextStyle(color: Colors.white, fontSize: 16));
        }
      } else {
        if (productSingleWarungModel.body.stock < 1) {
          return Text("Stok Habis",
              style: TextStyle(color: Colors.black, fontSize: 16));
        } else {
          return Text("Ubah Produk",
              style: TextStyle(color: Colors.black, fontSize: 16));
        }
      }
    } else {
      if (productSingleWarungModel.body.stock < 1) {
        return Text("Stok Habis",
            style: TextStyle(color: Colors.black, fontSize: 16));
      } else {
        return Text("Tambah Keranjang",
            style: TextStyle(color: Colors.white, fontSize: 16));
      }
    }
  }

  Widget _searchCard() => GestureDetector(
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
                padding: const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
                child: Icon(
                  Icons.search,
                  color: Color(0xffC4C6CC),
                ),
              ),
              Text(
                "Cari Produk di Indomini Mart",
                style: TextStyle(
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
                onTap: () {
                  _modalBottomimages(context, _current, imageUrl);
                },
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
                  setState(() => _current = index);
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
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ? Colors.red[600]
                                : Colors.grey[200]),
                      );
                    }).toList(),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  void _modalBottomimages(
      BuildContext context, int number, ProductSingleWarungModel imageUrl) {
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
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
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
                            imageProvider: NetworkImage(AppConstants.BASE_URL_FEED_IMG +
                                imageUrl.body.pictures[index].path),
                            initialScale: PhotoViewComputedScale.contained * 1,
                            heroAttributes: PhotoViewHeroAttributes(
                                tag: AppConstants.BASE_URL_FEED_IMG +
                                    imageUrl.body.pictures[index].path),
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
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 40),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ],
                )),
          );
        });
  }

  Widget getDataProductByCategory() {
    var delivered = productWarungModel.body
        .where((element) => element.id != widget.idProduct)
        .toList();
    return SliverToBoxAdapter(
      child: Container(
        height: delivered.length == 0 || delivered == null ? 10 : 360.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            delivered.length == 0 || delivered == null
                ? Container()
                : Container(
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Produk yang serupa",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ProductPage(
                                  idCategory:
                                      productSingleWarungModel.body.category.id,
                                  nameCategory: productSingleWarungModel
                                      .body.category.name,
                                  typeProduct: widget.typeProduct,
                                  path: widget.path);
                            }));
                          },
                          child: Text(
                            "Lihat Semua",
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorResources.PRIMARY,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            delivered.length == 0 || delivered == null
                ? Container()
                : Container(
                    height: 300.0,
                    child: ListView(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: productWarungModel.body
                          .where((element) => element.id != widget.idProduct)
                          .map((resultProduct) {
                        return _itemsData(context, resultProduct);
                      }).toList(),
                    ),
                  ),
          ],
        ),
      ),
    );
    //     }
    //     return loadingWarungId();
    //   },
    // );
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
                    width: 180,
                    height: 15,
                    margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                  ),
                  Container(
                      height: 280.0,
                      padding: EdgeInsets.only(left: 16, right: 7, bottom: 16),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 150,
                            margin: EdgeInsets.only(right: 7),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                          );
                        },
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemsData(BuildContext context, ProductWarungList productWarungList) {
    return Container(
      width: 170,
      margin: EdgeInsets.only(right: 5),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
            children: <Widget>[
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
                    productWarungList.name.length > 35
                        ? Text(
                            productWarungList.name.substring(0, 35) + "...",
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
                    Text(
                        ConnexistHelper.formatCurrency(productWarungList.price),
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
                                color: ColorResources.PRIMARY),
                            child: Center(
                                child: Icon(Icons.store,
                                    color: Colors.white, size: 15))),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productWarungList.store.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              Text(productWarungList.store.city,
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
                    // productWarungList.stats.ratingAvg > 0
                    //     ?
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

  void _showKurirAvailable(List<SupportedCourierProductWarungSingle> kurir) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
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
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black))),
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
                                      // height: 40.0,
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
                                          errorWidget: (context, url, error) =>
                                              Center(
                                                  child: Image.asset(
                                            "assets/default_image.png",
                                            fit: BoxFit.cover,
                                          )),
                                        ),
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        kurir[index].name,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      )),
                                ],
                              ));
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 1,
                          );
                        },
                      )),
                )
              ],
            ));
      },
    );
  }

  _modalDeskripsi(ProductSingleWarungModel productSingleWarungModel) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (context) {
        return new Container(
            height: MediaQuery.of(context).size.height * 0.96,
            // margin: MediaQuery.of(context).padding,
            color: Colors.transparent,
            child: Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 8),
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close)),
                              Container(
                                  margin: EdgeInsets.only(left: 16),
                                  child: Text("Deskripsi Produk",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black))),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 3,
                        ),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.all(16),
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      child: Stack(
                                        children: [
                                          Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: CachedNetworkImage(
                                                  imageUrl: productSingleWarungModel
                                                              .body
                                                              .pictures
                                                              .length ==
                                                          0
                                                      ? ""
                                                      : AppConstants.BASE_URL_FEED_IMG +
                                                          productSingleWarungModel
                                                              .body
                                                              .pictures
                                                              .first
                                                              .path,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child: Shimmer
                                                              .fromColors(
                                                    baseColor: Colors.grey[200],
                                                    highlightColor:
                                                        Colors.grey[100],
                                                    child: Container(
                                                      color: Colors.white,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    ),
                                                  )),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Center(
                                                          child: Image.asset(
                                                    "assets/default_image.png",
                                                    fit: BoxFit.cover,
                                                  )),
                                                ),
                                              )),
                                          productSingleWarungModel
                                                      .body.discount !=
                                                  null
                                              ? Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Container(
                                                    height: 20,
                                                    // width: 100,
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            12),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        12)),
                                                        color: Colors.red[900]),
                                                    child: Text(
                                                      productSingleWarungModel
                                                              .body
                                                              .discount
                                                              .discount
                                                              .toString()
                                                              .replaceAll(
                                                                  RegExp(
                                                                      r"([.]*0)(?!.*\d)"),
                                                                  "") +
                                                          "%",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
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
                                          productSingleWarungModel
                                                      .body.name.length >
                                                  90
                                              ? Text(
                                                  productSingleWarungModel
                                                          .body.name
                                                          .substring(0, 90) +
                                                      "...",
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                )
                                              : Text(
                                                  productSingleWarungModel
                                                      .body.name,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              ConnexistHelper.formatCurrency(
                                                  productSingleWarungModel
                                                      .body.price),
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text("STOK: ",
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: ColorResources.PRIMARY)),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                  productSingleWarungModel
                                                      .body.stock
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: ColorResources.PRIMARY)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                              SizedBox(
                                height: 8,
                              ),
                              Divider(
                                thickness: 2,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                productSingleWarungModel.body.description,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                )));
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
                  width: double.infinity, height: 280, color: Colors.white),
              Container(
                width: double.infinity,
                height: 20,
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white),
              ),
              Container(
                width: double.infinity,
                height: 20,
                margin: EdgeInsets.only(left: 16, right: 100, top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white),
              ),
              Container(
                width: 120,
                height: 20,
                margin:
                    EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 15,
          color: Colors.grey[100],
        ),
        SizedBox(height: 16),
        Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[100],
          child: Row(
            children: [
              Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white)),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140,
                    height: 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 80,
                    height: 15,
                    margin: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 16),
        Divider(
          thickness: 15,
          color: Colors.grey[100],
        ),
        SizedBox(height: 16),
        Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 150,
                height: 15,
                margin: EdgeInsets.only(
                  left: 16,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white),
              ),
              Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Divider(
          thickness: 15,
          color: Colors.grey[100],
        ),
        SizedBox(height: 16),
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
                      width: 180,
                      height: 15,
                      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
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
                                borderRadius: BorderRadius.circular(15)),
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
