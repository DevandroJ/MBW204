import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/screens/store/detail_product.dart';
import 'package:mbw204_club_ina/views/screens/store/seller_edit_product.dart';
import 'package:mbw204_club_ina/data/models/warung/product_warung_model.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/store/seller_add_product.dart';

class StuffSellerScreen extends StatefulWidget {
  final String idStore;

  StuffSellerScreen({ Key key, @required this.idStore, }) : super(key: key);
  @override
  _StuffSellerScreenState createState() => _StuffSellerScreenState();
}

class _StuffSellerScreenState extends State<StuffSellerScreen> with TickerProviderStateMixin {

  AnimationController controller;
  ScrollController scrollController;
  Animation<Offset> offset;
  
  String idCategory = "all";

  var isVisible;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Provider.of<WarungProvider>(context, listen: false).getDataCategoryProduct(context, "seller");
      Provider.of<WarungProvider>(context, listen: false).getDataProductByCategorySeller(context, idCategory);
    });     
   
    isVisible = true;

    scrollController = ScrollController();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 2.0)).animate(controller);

    scrollController.addListener(() {
      if (scrollController.position.minScrollExtent != null && scrollController.position.pixels != null) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          getMoreData();
        }
      }
      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (isVisible == true) {
          setState(() {
            isVisible = false;
            controller.forward();
          });
        }
      } else {
        if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
          if (isVisible == false) {
            setState(() {
              isVisible = true;
              controller.reverse();
            });
          }
        }
      }
    });
  }

  Future getMoreData() {
    Provider.of<WarungProvider>(context, listen: false).getDataProductByCategorySellerLoad(context, idCategory);
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
        floatingActionButton: SlideTransition(
          position: offset,
          child: FloatingActionButton(
            backgroundColor: ColorResources.PRIMARY,
            child: Center( 
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 40.0,
              )
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TambahJualanPage(idStore: widget.idStore))),
          ),
        ),
        appBar: AppBar(
          backgroundColor: ColorResources.PRIMARY,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 20.0,
              color: ColorResources.GREY,
            ),
            onPressed: onWillPop
          ),
          centerTitle: true,
          elevation: 0.0,
          title: Text("Daftar Produk",
            style: poppinsRegular.copyWith(
              fontSize: 16.0,
              color: ColorResources.WHITE
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Provider.of<WarungProvider>(context, listen: false).getDataProductByCategorySeller(context, idCategory);
          },
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 4.0),
                child: Text("Kategori Produk",
                  style: poppinsRegular.copyWith(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  )
                )
              ),
              getDataCategoryProductParent(),
              getCategoryChild(),
              getDataProductByCategory()
            ],
          ),
        )
      ),
    );
  }

  Widget getDataCategoryProductParent() {
    return Consumer<WarungProvider>(
      builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
        if(warungProvider.categoryProductStatus == CategoryProductStatus.loading) {
          return Container(
            height: 40.0,
            margin: EdgeInsets.only(top: 8.0, left: 16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200],
              highlightColor: Colors.grey[100],
              child: ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                    width: 100.0,
                    height: 40.0,
                    margin: EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0), 
                      color: Colors.white
                    ),
                  );
                },
              ),
            ),
          ); 
        }
        
        return Container(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0),
          height: 55.0,
          child: ListView.builder(
            itemCount: warungProvider.categoryHasManyProduct.length + 1,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int i) {
              if(i == 0) {
                return Container(
                  padding: EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: idCategory == "all" ? ColorResources.BTN_PRIMARY : ColorResources.WHITE,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          width: 1.0, 
                          color: ColorResources.PRIMARY
                        )
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        idCategory = "all";                        
                        // getMoreData();
                      });  
                      Provider.of<WarungProvider>(context, listen: false).getDataProductByCategorySeller(context, idCategory);                      
                      Provider.of<WarungProvider>(context, listen: false).getDataCategoryProductByParent(context, "seller", idCategory);                    
                    },
                    child: Text("All",
                      style: poppinsRegular.copyWith(
                        color: idCategory == "all" ? ColorResources.WHITE : ColorResources.BTN_PRIMARY,
                      )
                    ),
                  ),
                ); 
              }
              return Container(
                padding: EdgeInsets.only(right: 8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: idCategory == warungProvider.categoryHasManyProduct[i-1]["id"] ? ColorResources.BTN_PRIMARY : ColorResources.WHITE,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        width: 1.0, 
                        color: ColorResources.PRIMARY
                      )
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      idCategory = warungProvider.categoryHasManyProduct[i-1]["id"];                        
                    });  
                    Provider.of<WarungProvider>(context, listen: false).getDataCategoryProductByParent(context, "seller", idCategory);                  
                    Provider.of<WarungProvider>(context, listen: false).getDataProductByCategorySeller(context, idCategory);                      
                  },
                  child: Text(warungProvider.categoryHasManyProduct[i-1]["category"],
                    style: poppinsRegular.copyWith(
                      color: idCategory == warungProvider.categoryHasManyProduct[i-1]["id"] ? ColorResources.WHITE : ColorResources.BTN_PRIMARY,
                    )
                  ),
                ),
              );      
            }
          ),
        ); 
      },
    );
  }

  Widget getCategoryChild() {
    return Consumer<WarungProvider>(
      builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
        if(warungProvider.categoryProductByParentStatus == CategoryProductByParentStatus.loading) {
          return Container();
        }
        if(warungProvider.categoryProductByParentList.length == 0) {
          return Container();
        }
        return Container(
          height: 55.0,
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0),
          child: ListView.builder(
            itemCount: warungProvider.categoryProductByParentList.length,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int i) { 
              return Container(
                padding: EdgeInsets.only(right: 8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: warungProvider.categoryProductByParentList[i].id == idCategory ? ColorResources.PRIMARY : ColorResources.WHITE,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    side: BorderSide(
                      width: 1.0, 
                      color: ColorResources.PRIMARY
                    )
                  ),
                  onPressed: () {
                    setState(() {
                      idCategory = warungProvider.categoryProductByParentList[i].id;
                    });
                    Provider.of<WarungProvider>(context, listen: false).getDataProductByCategorySeller(context, idCategory);       
                  },
                  child: Text(warungProvider.categoryProductByParentList[i].name,
                    style: poppinsRegular.copyWith(
                      color: warungProvider.categoryProductByParentList[i].id == idCategory ? ColorResources.WHITE : ColorResources.PRIMARY
                    )
                  ),
                ),
              );
            }
          ),
        );
      },
    );
  }

  Widget getDataProductByCategory() {
    return Consumer<WarungProvider>(
      builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
        if(warungProvider.categoryProductByCategorySellerStatus == CategoryProductByCategorySellerStatus.loading) {
          return loadingList();
        }
        if(warungProvider.categoryProductByCategorySellerStatus == CategoryProductByCategorySellerStatus.empty) {
          return emptyAddProduct();
        }
        return ListView.builder(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
          controller: scrollController,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: warungProvider.productWarungList.length,
          itemBuilder: (BuildContext context, int i) {
            // return Text("test");
            return itemsData(context, warungProvider.productWarungList[i]);
            },
          );
        }
      );    
    }

    Widget itemsData(BuildContext context, ProductWarungList productWarungList) {

    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: 'Mohon Tunggu...',
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

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailProductPage(
            idProduct: productWarungList.id,
            typeProduct: 'seller',
            path: '/fetch',
          );
        }));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorResources.GREY,
            width: 1.0
          )
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${productWarungList.pictures.first.path}",
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
                                )
                              ),
                              errorWidget: (BuildContext context, String url, dynamic error) => Center(
                                child: Icon(Icons.store)
                              ),
                            ),
                          )
                        ),
                        productWarungList.discount != null
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
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        productWarungList.name.length > 75
                        ? Text(
                            productWarungList.name.substring(0, 75) + "...",
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("STOK: ",
                              style: poppinsRegular.copyWith(
                                fontSize: 14.0,
                                color: Colors.orange[700]
                              )
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(productWarungList.stock.toString(),
                              style: poppinsRegular.copyWith(
                                fontSize: 14.0,
                                color: Colors.orange[700]
                              )
                            ),
                          ],
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
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return EditProductWarungPage(
                          idProduct: productWarungList.id,
                          typeProduct: "seller",
                          path: "/fetch");
                        }));
                      },
                      child: Container(
                        height: 30.0,
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorResources.BLACK,
                            width: 0.5
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                          color: ColorResources.WHITE
                        ),
                        child: Center(
                          child: Text("Ubah",
                            style: poppinsRegular,
                          )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                          return DetailProductPage(
                            idProduct: productWarungList.id,
                            typeProduct: 'seller',
                            path: '/fetch',
                          );
                        }));
                      },
                      child: Container(
                        height: 30.0,
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorResources.BLACK,
                            width: 0.5
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                          color: ColorResources.WHITE
                        ),
                        child: Center(
                          child: Text("Lihat Barang",
                            style: poppinsRegular,
                          )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  InkWell(
                    onTap: () {
                      showAnimatedDialog(
                        context: context, 
                        barrierDismissible: true,
                        builder: (BuildContext ctx) {
                          return Dialog(
                            child: Container(
                              height: 120.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Apakah Anda yakin ingin Hapus ?",
                                    style: poppinsRegular,
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(), 
                                        child: Text("Batal",
                                          style: poppinsRegular.copyWith(
                                            color: ColorResources.BLACK
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Provider.of<WarungProvider>(context, listen: false).postDeleteProductWarung(context, productWarungList.id, -1).then((value) {
                                            if (value.code == 0) {
                                              pr.hide();
                                              Fluttertoast.showToast(
                                                msg: "Hapus Produk Berhasil",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.orange[700],
                                                textColor: Colors.white
                                              );
                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                return StuffSellerScreen(
                                                  idStore: widget.idStore,
                                                );
                                              }));
                                              Navigator.of(context, rootNavigator: true).pop();
                                            } else {
                                              pr.hide();
                                              Fluttertoast.showToast(
                                                msg: "Terjadi Kesalahan, Produk tidak dapat dihapus",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white
                                              );
                                            }
                                          });
                                        }, 
                                        child: Text("Hapus",
                                          style: poppinsRegular.copyWith(
                                            color: ColorResources.ERROR
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );                          
                        },
                      );
                    },
                    child: Container(
                      height: 30.0,
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[200]
                      ),
                      child: Center(
                        child: Icon(
                          Icons.delete,
                          size: 20.0, 
                          color: ColorResources.ERROR
                        )
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget loadingList() {
    return Container(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: ListView.builder(
          padding: EdgeInsets.only(left: 8, right: 8),
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                ),
                Container(
                  width: double.infinity,
                  height: 15.0,
                  margin: EdgeInsets.only(left: 8, right: 50, bottom: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                ),
                Container(
                  width: double.infinity,
                  height: 15.0,
                  margin: EdgeInsets.only(left: 8, right: 75, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget emptyAddProduct() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            "assets/lottie/add_product.json",
            height: 200,
            width: 200,
          ),
          SizedBox(height: 20.0),
          Container(
            child: Text("Wah, Anda belum menambahkan Produk",
              textAlign: TextAlign.center,
              style: poppinsRegular.copyWith(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            child: Text("Yuk, Tambah produk anda yang akan dijual",
            textAlign: TextAlign.center,
            style: poppinsRegular.copyWith(
              fontSize: 16.0, 
              color: ColorResources.PRIMARY
            )
            ),
          ),
        ]
      )),
    );
  }
}

