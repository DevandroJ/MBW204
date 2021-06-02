import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/data/models/warung/category_product_model.dart';
import 'package:mbw204_club_ina/data/models/warung/seller_store_model.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/screens/warung/edit_product_warung.dart';
import 'package:mbw204_club_ina/views/screens/warung/tambah_jualan.dart';

class PilihKategoriPage extends StatefulWidget {
  final String idCategory;
  final String idProduct;
  final String typeProduct;
  final String path;

  PilihKategoriPage({
    Key key,
    @required this.idCategory,
    @required this.idProduct,
    @required this.typeProduct,
    @required this.path,
  }) : super(key: key);
  @override
  _PilihKategoriPageState createState() => _PilihKategoriPageState();
}

class _PilihKategoriPageState extends State<PilihKategoriPage> {
  SellerStoreModel sellerStoreModel;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    warungVM.getDataStore(context, 'seller').then((value) {
      print(value.code);
      if (value != null) {
        setState(() {
          sellerStoreModel = value;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Pilih Kategori",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleSpacing: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Icon(Icons.close)),
          elevation: 0,
        ),
        body: isLoading
            ? loadingList()
            : widget.idCategory == ''
                ? getCategory()
                : getCategoryParent());
  }

  Widget getCategory() {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    return FutureBuilder<CategoryProductModel>(
      future: warungVM.getDataCategoryProduct(context, widget.typeProduct),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final CategoryProductModel productCategory = snapshot.data;
          return ListView.separated(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: productCategory.body.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(productCategory.body[index].name),
                    Container(
                        child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                basket.addAll({
                                  "idCategory": productCategory.body[index].id,
                                  "nameCategory":
                                      productCategory.body[index].name,
                                });
                              });
                              widget.idProduct == ''
                                  ? Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                      return TambahJualanPage(
                                        idStore: sellerStoreModel.body.id,
                                      );
                                    }))
                                  : Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                      return EditProductWarungPage(
                                          idProduct: widget.idProduct,
                                          typeProduct: widget.typeProduct,
                                          path: widget.path);
                                    }));
                            },
                            child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                        color: ColorResources.PRIMARY)),
                                child: Center(
                                    child: Text("Pilih",
                                        style:
                                            TextStyle(color: Colors.black))))),
                        productCategory.body[index].childs.length != 0
                            ? SizedBox(width: 10)
                            : Container(),
                        productCategory.body[index].childs.length != 0
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return PilihKategoriPage(
                                        idCategory:
                                            productCategory.body[index].id,
                                        typeProduct: "seller",
                                        idProduct: widget.idProduct,
                                        path: widget.path);
                                  }));
                                },
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                            color: ColorResources.PRIMARY)),
                                    child: Center(
                                        child: Text("Lanjut",
                                            style: TextStyle(
                                                color: Colors.black)))))
                            : Container(),
                      ],
                    ))
                  ],
                ),
                // onTap: () {
                //   if (productCategory.body[index].childs.length == 0) {
                //     setState(() {
                //       basket.addAll({
                //         "idCategory": productCategory.body[index].id,
                //         "nameCategory": productCategory.body[index].name,
                //       });
                //     });
                //     widget.idProduct == ''
                //         ? Navigator.push(context,
                //             MaterialPageRoute(builder: (context) {
                //             return TambahJualanPage(
                //               idStore: sellerStoreModel.body.id,
                //             );
                //           }))
                //         : Navigator.push(context,
                //             MaterialPageRoute(builder: (context) {
                //             return EditProductWarungPage(
                //                 idProduct: widget.idProduct,
                //                 typeProduct: widget.typeProduct,
                //                 path: widget.path);
                //           }));
                //   } else {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) {
                //       return PilihKategoriPage(
                //           idCategory: productCategory.body[index].id,
                //           typeProduct: "seller",
                //           idProduct: widget.idProduct,
                //           path: widget.path);
                //     }));
                //   }
                // },
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                thickness: 1,
              );
            },
          );
        }
        return loadingList();
      },
    );
  }

  Widget getCategoryParent() {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    return FutureBuilder<CategoryProductModel>(
      future: warungVM.getDataCategoryProductByParent(context,
          widget.typeProduct, widget.idCategory),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final CategoryProductModel categoryPM = snapshot.data;
          if (categoryPM.body.length == 0) {
            return Container();
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: categoryPM.body.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(categoryPM.body[index].name),
                    Container(
                        child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                basket.addAll({
                                  "idCategory": categoryPM.body[index].id,
                                  "nameCategory": categoryPM.body[index].name,
                                });
                              });
                              widget.idProduct == ''
                                  ? Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                      return TambahJualanPage(
                                        idStore: sellerStoreModel.body.id,
                                      );
                                    }))
                                  : Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                      return EditProductWarungPage(
                                          idProduct: widget.idProduct,
                                          typeProduct: widget.typeProduct,
                                          path: widget.path);
                                    }));
                            },
                            child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                        color: ColorResources.PRIMARY)),
                                child: Center(
                                    child: Text("Pilih",
                                        style:
                                            TextStyle(color: Colors.black))))),
                        categoryPM.body[index].childs.length != 0
                            ? SizedBox(width: 10)
                            : Container(),
                        categoryPM.body[index].childs.length != 0
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return PilihKategoriPage(
                                        idCategory: categoryPM.body[index].id,
                                        typeProduct: "seller",
                                        idProduct: widget.idProduct,
                                        path: widget.path);
                                  }));
                                },
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                            color: ColorResources.PRIMARY)),
                                    child: Center(
                                        child: Text("Lanjut",
                                            style: TextStyle(
                                                color: Colors.black)))))
                            : Container(),
                      ],
                    ))
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                thickness: 1,
              );
            },
          );
        }
        return loadingList();
      },
    );
  }

  Widget loadingList() {
    return Container(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: ListView.separated(
          // padding: EdgeInsets.only(left: 8, right: 8),
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 1,
            );
          },
        ),
      ),
    );
  }
}
