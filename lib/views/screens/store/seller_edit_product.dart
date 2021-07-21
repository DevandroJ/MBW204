import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:hex/hex.dart';
import 'package:crypto/crypto.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/data/models/warung/product_warung_model.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/data/models/warung/product_single_warung_model.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

class EditProductWarungPage extends StatefulWidget {
  final String idProduct;
  final String typeProduct;
  final String path;

  EditProductWarungPage({
    Key key,
    @required this.idProduct,
    @required this.typeProduct,
    @required this.path,
  }) : super(key: key);
  @override
  _EditProductWarungPageState createState() => _EditProductWarungPageState();
}

class _EditProductWarungPageState extends State<EditProductWarungPage> {
  TextEditingController nameStuffController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController minOrderController = TextEditingController();

  String typeConditionName = "NEW";
  int typeCondition = 0;
  String typeStuffName;
  String idCategoryparent;
  int typeStuff = 0;
  String descStuff;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ImageSource imageSource;
  List<Asset> images = [];
  List<File> files = [];
  List<File> before = [];
  List<PictureProductWarung> pictures = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    loading = true;
    Future.delayed(Duration.zero, () async {
      nameStuffController = TextEditingController(text: '...');
      priceController = TextEditingController(text: '...');
      stockController = TextEditingController(text: '...');
      weightController = TextEditingController(text: '...');
      minOrderController = TextEditingController(text: '...');
      ProductSingleWarungModel productSingleWarungModel = await Provider.of<WarungProvider>(context, listen: false).getDataSingleProduct(context, widget.idProduct, widget.typeProduct, widget.path);
      loading = false;
      nameStuffController = TextEditingController(text: productSingleWarungModel.body.name);
      priceController = TextEditingController(text: (productSingleWarungModel.body.price - productSingleWarungModel.body.adminCharge).toStringAsFixed(0).trim());
      stockController = TextEditingController(text: productSingleWarungModel.body.stock.toString());       
      weightController = TextEditingController(text: productSingleWarungModel.body.weight.toString());
      minOrderController = TextEditingController(text: productSingleWarungModel.body.minOrder.toString());
      typeConditionName = productSingleWarungModel.body.condition;
      pictures = productSingleWarungModel.body.pictures;
      typeCondition = typeConditionName == "NEW" ? 0 : 1;
      typeStuffName = productSingleWarungModel.body.harmful == true 
      ? "Berbahaya"
      : productSingleWarungModel.body.liquid == true 
      ? "Cair" 
      : productSingleWarungModel.body.flammable == true 
      ? "Mudah Terbakar"
      : productSingleWarungModel.body.fragile == true 
      ? "Mudah Pecah"
      : typeStuffName;
      typeStuff = productSingleWarungModel.body.harmful == true 
      ? 0
      : productSingleWarungModel.body.liquid == true 
      ? 1 
      : productSingleWarungModel.body.flammable == true 
      ? 2
      : productSingleWarungModel.body.fragile == true 
      ? 0
      : typeStuff;
    });
  }

  void pickImage() async {
    var imageSource = await showDialog<ImageSource>(context: context, 
      builder: (context) => AlertDialog(
        title: Text("Pilih sumber gambar",
          style: poppinsRegular.copyWith(
            color: ColorResources.PRIMARY
          ),
        ),
        actions: [
          MaterialButton(
            child: Text("Camera",
              style: poppinsRegular.copyWith(
                color: ColorResources.PRIMARY
              ),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: Text( "Gallery",
              style: poppinsRegular.copyWith(
                color: ColorResources.PRIMARY
              ),
            ),
            onPressed: uploadPic,
          )
        ],
      )
    );
    if (imageSource != null) {
      File file = await ImagePicker.pickImage(source: imageSource, maxHeight: 720);
      if (file != null) {
        setState(() {
          before.add(file);
          files = before.toSet().toList();
        });
      }
    }
  }

  void uploadPic() async {
    List<Asset> resultList = [];
    resultList = await MultiImagePicker.pickImages(
      maxImages: 5,
      enableCamera: false,
      selectedAssets: images,
      materialOptions: MaterialOptions(
        actionBarColor: "#FF7700", 
        statusBarColor: "#FF7700"
      )
    );
    resultList.forEach((imageAsset) async {
      final filePath = await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);
      File tempFile = File(filePath);
      setState(() {
        images = resultList;
        before.add(tempFile);
        files = before.toSet().toList();
      });
    });
  }

  Future submit() async {
    try {
      if(Provider.of<WarungProvider>(context, listen: false).categoryEditProductTitle == null || Provider.of<WarungProvider>(context, listen: false).categoryEditProductTitle.isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Kategori Barang belum diisi",
        );
        return;
      }
      if(nameStuffController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Nama Barang belum diisi"
        );
        return;
      }
      if(priceController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Harga Barang belum diisi"
        );
        return;
      }
      if(minOrderController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Minimal Order Barang belum diisi"
        );
        return;
      }
      if(stockController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Stok Barang belum diisi"
        );
        return;
      }
      if(weightController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Berat Barang belum diisi"
        );
        return;
      }
      if(typeConditionName == "" || typeConditionName == null) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Kondisi Barang belum diisi"
        );
        return;
      }
      if(typeStuffName == "" || typeStuffName == null) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Jenis Barang belum diisi"
        );
        return;
      }
      if(Provider.of<WarungProvider>(context, listen: false).descEditSellerStore == null || Provider.of<WarungProvider>(context, listen: false).descEditSellerStore.isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Deskripsi Barang belum diisi"
        );
        return;
      }
      if(files != null || files.isNotEmpty) {
        for (int i = 0; i < files.length; i++) {
          String body = await Provider.of<WarungProvider>(context, listen: false).getMediaKeyMedia(context);
          File file = File(files[i].path);
          Uint8List bytes = files[i].readAsBytesSync();
          String digestFile = sha256.convert(bytes).toString();
          String imageHash = base64Url.encode(HEX.decode(digestFile));
          Provider.of<WarungProvider>(context, listen: false).uploadImageProduct(context, body, imageHash, file);
        }
      }
      await Provider.of<WarungProvider>(context, listen: false).postEditDataProductWarung(
        context,
        widget.idProduct,
        nameStuffController.text,
        int.parse(priceController.text),
        files,
        int.parse(weightController.text),
        int.parse(stockController.text),
        typeConditionName,
        int.parse(minOrderController.text),
        typeStuffName
      );
    } catch(e) {
      print(e);
    }
  }

  Future<bool> onWillPop() {
    Navigator.of(context).pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> basket = Provider.of(context, listen: false);
    // Provider.of<WarungProvider>(context, listen: false).getDataCategoryProduct(context, "commerce");
 
    return WillPopScope(
      onWillPop: () {
        setState(() {
          basket.addAll({
            "idCategory": null,
            "nameCategory": null,
          });
        });
        return onWillPop();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorResources.PRIMARY,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 20.0,
              color: ColorResources.GREY,
            ),
            onPressed: () => onWillPop(),
          ),
          centerTitle: true,
          elevation: 0.0,
          title: Text("Ubah Barang",
            style: poppinsRegular.copyWith(
              fontSize: 16.0
            ),
          ),
        ),
        body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
                key: formKey,
                child: Consumer<WarungProvider>(
                  builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        inputFieldCategoryStuff(context, "Kategori Barang", "Kategori Barang"),
                        SizedBox(height: 15.0),
                        inputFieldNameStuff(context, nameStuffController),
                        SizedBox(height: 15.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  inputFieldPriceStuff(context, priceController)
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 120,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  inputFieldMinOrder(context, minOrderController)
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 120.0,
                              child: inputFieldStock(context, stockController)
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  inputFieldWeight(context, weightController),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text("Kondisi",
                          style: poppinsRegular.copyWith(
                            fontSize: 14.0,
                          )
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Wrap(
                          children: [ 
                            Container(
                              height: 30.0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: ['Baru', 'Bekas'].length,
                                itemBuilder: (BuildContext context, int i) {
                                  return Container(
                                    margin: EdgeInsets.only(left: i == 0 ? 0.0 : 10.0),
                                    child: ChoiceChip(
                                      label: Text(['Baru', 'Bekas'][i]),
                                      selected: typeCondition == i,
                                      onSelected: (bool selected) {
                                        setState(() {
                                          typeCondition = selected ? i : null;
                                          typeConditionName = ['Baru', 'Bekas'][i] == "Baru" ? "NEW" : "USED";
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ]
                        ),
                        SizedBox(height: 15.0),
                        Text("Jenis Barang",
                          style: poppinsRegular.copyWith(
                            fontSize: 14.0,
                          )
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Wrap(
                          children: [ 
                            Container(
                              height: 30.0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: ['Berbahaya', 'Cair', 'Mudah Terbakar', 'Mudah Pecah'].length,
                                itemBuilder: (BuildContext context, int i) {
                                  return Container(
                                    margin: EdgeInsets.only(left: i == 0 ? 0.0 : 10.0),
                                    child: ChoiceChip(
                                      label: Text(['Berbahaya', 'Cair', 'Mudah Terbakar', 'Mudah Pecah'][i]),
                                      selected: typeStuff == i,
                                      onSelected: (bool selected) {
                                        setState(() {
                                          typeStuff = selected ? i : null;
                                          typeStuffName = selected ? ['Berbahaya', 'Cair', 'Mudah Terbakar', 'Mudah Pecah'][i] : null;
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ]
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        inputFieldDescriptionStuff(context),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text("Gambar Barang",
                          style: poppinsRegular.copyWith(
                            fontSize: 14.0,
                          )
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 100.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5)
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: files == null || files.length == 0
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: pictures.length + 1,
                                itemBuilder: (BuildContext context, int i) {
                                  if (i < pictures.length) {
                                    return Container(
                                      height: 80,
                                      width: 80,
                                      margin: EdgeInsets.only(right: 4.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey[400]),
                                          color: Colors.grey[350]),
                                        child: Center(
                                          child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${pictures[i].path}",
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (BuildContext context, String url) => Loader(
                                              color: ColorResources.PRIMARY,
                                            ),
                                            errorWidget: (BuildContext context, String url, dynamic error) => Image.asset("assets/default_image.png"),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        uploadPic();
                                      },
                                      child: Container(
                                        height: 80.0,
                                        width: 80.0,
                                        margin: EdgeInsets.only(right: 4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey[400]),
                                          color: Colors.grey[350]),
                                        child: Center(
                                          child: Icon(Icons.camera_alt,
                                            color: Colors.grey[600],
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: files.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < files.length) {
                                    return Container(
                                      height: 80,
                                      width: 80,
                                      margin: EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey[400]),
                                          color: Colors.grey[350]
                                        ),
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: FadeInImage(
                                            fit: BoxFit.cover,
                                            height: double.infinity,
                                            width: double.infinity,
                                            image: FileImage(files[index]),
                                            placeholder: AssetImage("assets/default_profile.png")),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        if (files.length < 5) {
                                          pickImage();
                                        } else if (files.length >= 5) {
                                          setState(() {
                                            files.clear();
                                            images.clear();
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        margin: EdgeInsets.only(right: 4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.grey[400]),
                                            color: files.length < 5 ? Colors.grey[350] : Colors.red),
                                          child: Center(
                                          child: Icon(
                                            files.length < 5 ? Icons.camera_alt
                                              : Icons.delete,
                                            color: files.length < 5
                                              ? Colors.grey[600]
                                              : Colors.white,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        SizedBox(
                          height: 55.0,
                          width: double.infinity,
                          child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: ColorResources.PRIMARY,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                          ),
                          child: Center(
                            child: Text("Jual Barang",
                              style: poppinsRegular.copyWith(
                                fontSize: 16.0, 
                                color: Colors.white
                              )
                            ),
                          ),
                          onPressed: submit                        
                          ),
                        )
                      ],
                    );            
                  },
                ) 
              ),
            )
          ],
        )
          
          // isLoading
          //     ? Loader(
          //       color: ColorResources.PRIMARY,
          //     )
          //     : ListView(
          //         physics: BouncingScrollPhysics(),
          //         children: [
          //           Container(
          //             padding: EdgeInsets.all(16),
          //             child: Form(
          //                 key: formKey,
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text("Kategori Barang",
          //                       style: TextStyle(
          //                         fontSize: 18.0,
          //                       )
          //                     ),
          //                     SizedBox(
          //                       height: 10.0,
          //                     ),
          //                     GestureDetector(
          //                       onTap: () {
          //                         Navigator.push(context, MaterialPageRoute(builder: (context) {
          //                           return PilihKategoriPage(
          //                             idCategory: "",
          //                             idProduct: product.body.id,
          //                             typeProduct: "seller",
          //                             path: widget.path);
          //                            }
          //                           )
          //                         );
          //                       },
          //                       child: Container(
          //                           height: 60,
          //                           width: double.infinity,
          //                           padding: EdgeInsets.all(10),
          //                           decoration: BoxDecoration(
          //                               borderRadius: BorderRadius.circular(10),
          //                               border: Border.all(color: Colors.grey),
          //                               color: Colors.grey[100]),
          //                           child: Column(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.center,
          //                             crossAxisAlignment:
          //                                 CrossAxisAlignment.start,
          //                             children: [
          //                               Text(
          //                                   basket['nameCategory'] == null
          //                                       ? product.body.category.name
          //                                       : basket['nameCategory'],
          //                                   style: TextStyle(
          //                                       fontSize: 16.0,
          //                                       color: Colors.grey[600])),
          //                             ],
          //                           )),
          //                     ),
          //                     SizedBox(
          //                       height: 15.0,
          //                     ),
          //                     Text("Nama Barang",
          //                       style: TextStyle(
          //                         fontSize: 18.0,
          //                       )
          //                     ),
          //                     SizedBox(
          //                       height: 10.0,
          //                     ),
          //                     Container(
          //                       decoration: BoxDecoration(
          //                         color: Colors.white,
          //                         borderRadius: BorderRadius.circular(10.0)
          //                       ),
          //                       child: TextFormField(
          //                         initialValue: product.body.name,
          //                         decoration: InputDecoration(
          //                           hintText: "Masukan Nama Barang",
          //                           fillColor: Colors.white,
          //                           border: OutlineInputBorder(
          //                             borderRadius: BorderRadius.circular(10.0),
          //                             borderSide: BorderSide(),
          //                           ),
          //                         ),
          //                         validator: (val) {
          //                           if (val.isEmpty) {
          //                             return "Nama barang tidak boleh kosong";
          //                           } else {
          //                             return null;
          //                           }
          //                         },
          //                         onSaved: (newValue) => _namaBarang = newValue,
          //                         keyboardType: TextInputType.text,
          //                         style: TextStyle(
          //                           fontFamily: 'Proppins',
          //                         ),
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       height: 15,
          //                     ),
          //                     Row(
          //                       crossAxisAlignment: CrossAxisAlignment.center,
          //                       children: [
          //                         Expanded(
          //                           child: Column(
          //                             crossAxisAlignment:
          //                                 CrossAxisAlignment.start,
          //                             children: [
          //                               Text("Harga",
          //                                   style: TextStyle(
          //                                     fontSize: 18.0,
          //                                   )),
          //                               SizedBox(
          //                                 height: 10,
          //                               ),
          //                               Container(
          //                                 decoration: BoxDecoration(
          //                                   color: Colors.white,
          //                                   borderRadius: BorderRadius.circular(10.0)
          //                                 ),
          //                                 child: TextFormField(
          //                                   initialValue: (product.body.price - product.body.adminCharge).toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), ""),
          //                                   decoration: InputDecoration(
          //                                     hintText: "0",
          //                                     fillColor: Colors.white,
          //                                     prefixIcon: Container(
          //                                       width: 50,
          //                                       child: Center(
          //                                         child: Text(
          //                                           "Rp",
          //                                           textAlign: TextAlign.center,
          //                                           style: TextStyle(
          //                                               fontWeight:
          //                                                   FontWeight.bold),
          //                                         ),
          //                                       ),
          //                                     ),
          //                                     border: OutlineInputBorder(
          //                                       borderRadius: BorderRadius.circular(10.0),
          //                                       borderSide: BorderSide(),
          //                                     ),
          //                                     //fillColor: Colors.green
          //                                   ),
          //                                   validator: (val) {
          //                                     if (val.isEmpty) {
          //                                       return "Harga tidak boleh kosong";
          //                                     } else {
          //                                       return null;
          //                                     }
          //                                   },
          //                                   onSaved: (newValue) =>
          //                                       _harga = newValue,
          //                                   keyboardType: TextInputType.number,
          //                                   inputFormatters: <
          //                                       TextInputFormatter>[
          //                                     FilteringTextInputFormatter
          //                                         .digitsOnly
          //                                   ],
          //                                   style: TextStyle(
          //                                     fontFamily: 'Proppins',
          //                                   ),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                         SizedBox(
          //                           width: 10,
          //                         ),
          //                         Container(
          //                           width: 120,
          //                           child: Column(
          //                             crossAxisAlignment:
          //                                 CrossAxisAlignment.start,
          //                             children: [
          //                               Text("Min Order",
          //                                   style: TextStyle(
          //                                     fontSize: 18.0,
          //                                   )),
          //                               SizedBox(
          //                                 height: 10,
          //                               ),
          //                               Container(
          //                                 decoration: BoxDecoration(
          //                                     color: Colors.white,
          //                                     borderRadius:
          //                                         BorderRadius.circular(10.0)),
          //                                 child: TextFormField(
          //                                   initialValue: product.body.minOrder
          //                                       .toString(),
          //                                   decoration: InputDecoration(
          //                                     hintText: "0",
          //                                     fillColor: Colors.white,
          //                                     border: OutlineInputBorder(
          //                                       borderRadius: BorderRadius.circular(10.0),
          //                                       borderSide: BorderSide(),
          //                                     ),
          //                                     //fillColor: Colors.green
          //                                   ),
          //                                   validator: (val) {
          //                                     if (val.isEmpty) {
          //                                       return "Min Order tidak boleh kosong";
          //                                     } else {
          //                                       return null;
          //                                     }
          //                                   },
          //                                   onSaved: (newValue) =>
          //                                       _minOrder = newValue,
          //                                   keyboardType: TextInputType.number,
          //                                   inputFormatters: <
          //                                       TextInputFormatter>[
          //                                     FilteringTextInputFormatter
          //                                         .digitsOnly
          //                                   ],
          //                                   style: TextStyle(
          //                                     fontFamily: 'Proppins',
          //                                   ),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         )
          //                       ],
          //                     ),
          //                     SizedBox(
          //                       height: 15,
          //                     ),
          //                     Row(
          //                       children: [
          //                         Container(
          //                           width: 120,
          //                           child: Column(
          //                             crossAxisAlignment:
          //                                 CrossAxisAlignment.start,
          //                             children: [
          //                               Text("Stok",
          //                                 style: TextStyle(
          //                                   fontSize: 18.0,
          //                                 )
          //                               ),
          //                               SizedBox(
          //                                 height: 10.0,
          //                               ),
          //                               Container(
          //                                 decoration: BoxDecoration(
          //                                   color: Colors.white,
          //                                   borderRadius: BorderRadius.circular(10.0)
          //                                 ),
          //                                 child: TextFormField(
          //                                   initialValue: product.body.stock.toString(),
          //                                   decoration: InputDecoration(
          //                                     hintText: "0",
          //                                     fillColor: Colors.white,
          //                                     border: OutlineInputBorder(
          //                                       borderRadius: BorderRadius.circular(10.0),
          //                                       borderSide: BorderSide(),
          //                                     ),
          //                                     //fillColor: Colors.green
          //                                   ),
          //                                   validator: (val) {
          //                                     if (val.isEmpty) {
          //                                       return "Stok tidak boleh kosong";
          //                                     } else {
          //                                       return null;
          //                                     }
          //                                   },
          //                                   onSaved: (newValue) =>
          //                                       _stok = newValue,
          //                                   keyboardType: TextInputType.number,
          //                                   inputFormatters: <
          //                                       TextInputFormatter>[
          //                                     FilteringTextInputFormatter
          //                                         .digitsOnly
          //                                   ],
          //                                   style: TextStyle(
          //                                     fontFamily: 'Proppins',
          //                                   ),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                         SizedBox(
          //                           width: 10,
          //                         ),
          //                         Expanded(
          //                           child: Column(
          //                             crossAxisAlignment: CrossAxisAlignment.start,
          //                             children: [
          //                               Text("Berat",
          //                                 style: TextStyle(
          //                                   fontSize: 18.0,
          //                                 )
          //                               ),
          //                               SizedBox(
          //                                 height: 10.0,
          //                               ),
          //                               Container(
          //                                 decoration: BoxDecoration(
          //                                   color: Colors.white,
          //                                   borderRadius: BorderRadius.circular(10.0)
          //                                 ),
          //                                 child: TextFormField(
          //                                   initialValue: product.body.weight.toString(),
          //                                   decoration: InputDecoration(
          //                                     hintText: "0",
          //                                     fillColor: Colors.white,
          //                                     suffixIcon: Container(
          //                                       width: 80.0,
          //                                       child: Center(
          //                                         child: Text("Gram",
          //                                           textAlign: TextAlign.center,
          //                                           style: TextStyle(
          //                                             fontWeight: FontWeight.bold
          //                                           ),
          //                                         ),
          //                                       ),
          //                                     ),
          //                                     border: OutlineInputBorder(
          //                                       borderRadius: BorderRadius.circular(10.0),
          //                                       borderSide: BorderSide(),
          //                                     ),
          //                                     //fillColor: Colors.green
          //                                   ),
          //                                   validator: (val) {
          //                                     if (val.isEmpty) {
          //                                       return "Berat tidak boleh kosong";
          //                                     } else {
          //                                       return null;
          //                                     }
          //                                   },
          //                                   onSaved: (newValue) =>
          //                                       _berat = newValue,
          //                                   keyboardType: TextInputType.number,
          //                                   inputFormatters: <
          //                                       TextInputFormatter>[
          //                                     FilteringTextInputFormatter
          //                                         .digitsOnly
          //                                   ],
          //                                   style: TextStyle(
          //                                     fontFamily: 'Proppins',
          //                                   ),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                     SizedBox(
          //                       height: 15,
          //                     ),
          //                     Text("Kondisi",
          //                         style: TextStyle(
          //                           fontSize: 18.0,
          //                         )),
          //                     SizedBox(
          //                       height: 10,
          //                     ),
          //                     Row(
          //                       children: <Widget>[
          //                         Expanded(
          //                           child: GestureDetector(
          //                             onTap: () {
          //                               setState(() {
          //                                 _value = 0;
          //                                 kondisi = "USED";
          //                                 print(kondisi);
          //                               });
          //                             },
          //                             child: Container(
          //                               height: 55,
          //                               width: double.infinity,
          //                               padding: EdgeInsets.all(16),
          //                               decoration: BoxDecoration(
          //                                 borderRadius:
          //                                     BorderRadius.circular(55),
          //                                 border:
          //                                     Border.all(color: Colors.grey),
          //                                 color: _value == 0
          //                                     ? ColorResources.PRIMARY
          //                                     : Colors.transparent,
          //                               ),
          //                               child: Center(
          //                                   child: Text("Bekas",
          //                                       style: TextStyle(
          //                                           fontSize: 16.0,
          //                                           color: _value == 0
          //                                               ? Colors.white
          //                                               : Colors.black))),
          //                             ),
          //                           ),
          //                         ),
          //                         SizedBox(width: 10),
          //                         Expanded(
          //                           child: GestureDetector(
          //                             onTap: () {
          //                               setState(() {
          //                                 _value = 1;
          //                                 kondisi = "NEW";
          //                                 print(kondisi);
          //                               });
          //                             },
          //                             child: Container(
          //                               height: 55,
          //                               width: double.infinity,
          //                               padding: EdgeInsets.all(16),
          //                               decoration: BoxDecoration(
          //                                 borderRadius:
          //                                     BorderRadius.circular(55),
          //                                 border:
          //                                     Border.all(color: Colors.grey),
          //                                 color: _value == 1
          //                                     ? ColorResources.PRIMARY
          //                                     : Colors.transparent,
          //                               ),
          //                               child: Center(
          //                                   child: Text("Baru",
          //                                       style: TextStyle(
          //                                           fontSize: 16.0,
          //                                           color: _value == 1
          //                                               ? Colors.white
          //                                               : Colors.black))),
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                     SizedBox(
          //                       height: 15,
          //                     ),
          //                     Text("Deskripsi",
          //                         style: TextStyle(
          //                           fontSize: 18.0,
          //                         )),
          //                     SizedBox(
          //                       height: 10,
          //                     ),
          //                     Container(
          //                       // color: Colors.white,
          //                       decoration: BoxDecoration(
          //                           color: Colors.white,
          //                           borderRadius: BorderRadius.circular(10.0)),
          //                       child: TextFormField(
          //                         initialValue: product.body.description,
          //                         maxLines: null,
          //                         maxLength: null,
          //                         decoration: InputDecoration(
          //                           // labelText: "No Ponsel",
          //                           hintText: "Masukan Deskripsi",
          //                           fillColor: Colors.white,
          //                           border: OutlineInputBorder(
          //                             borderRadius: BorderRadius.circular(10.0),
          //                             borderSide: BorderSide(),
          //                           ),
          //                           //fillColor: Colors.green
          //                         ),
          //                         validator: (val) {
          //                           if (val.isEmpty) {
          //                             return "Deskripsi tidak boleh kosong";
          //                           } else {
          //                             return null;
          //                           }
          //                         },
          //                         onSaved: (newValue) => _deskripsi = newValue,
          //                         keyboardType: TextInputType.text,
          //                         style: TextStyle(
          //                           fontFamily: 'Proppins',
          //                         ),
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       height: 15,
          //                     ),
          //                     Text("Gambar Barang",
          //                         style: TextStyle(
          //                           fontSize: 18.0,
          //                         )),
          //                     SizedBox(
          //                       height: 10,
          //                     ),
          //                     Container(
          //                       height: 100,
          //                       width: double.infinity,
          //                       padding: EdgeInsets.all(10),
          //                       decoration: BoxDecoration(
          //                           border: Border.all(color: Colors.grey[600]),
          //                           borderRadius: BorderRadius.circular(10)),
          //                       child: files == null || files.length == 0
          //                           ? ListView.builder(
          //                               shrinkWrap: true,
          //                               scrollDirection: Axis.horizontal,
          //                               itemCount:
          //                                   product.body.pictures.length + 1,
          //                               itemBuilder: (context, index) {
          //                                 if (index <
          //                                     product.body.pictures.length) {
          //                                   return Container(
          //                                     height: 80,
          //                                     width: 80,
          //                                     margin: EdgeInsets.only(right: 4),
          //                                     decoration: BoxDecoration(
          //                                         borderRadius:
          //                                             BorderRadius.circular(10),
          //                                         border: Border.all(
          //                                             color: Colors.grey[400]),
          //                                         color: Colors.grey[350]),
          //                                     child: Center(
          //                                       child: ClipRRect(
          //                                         borderRadius:
          //                                             BorderRadius.circular(10),
          //                                         child: CachedNetworkImage(
          //                                           imageUrl: AppConstants.BASE_URL_FEED_IMG +
          //                                               product
          //                                                   .body
          //                                                   .pictures[index]
          //                                                   .path,
          //                                           width: double.infinity,
          //                                           height: double.infinity,
          //                                           fit: BoxFit.cover,
          //                                           placeholder: (context, url) => Loader(
          //                                             color: ColorResources.PRIMARY,
          //                                           ),
          //                                           errorWidget: (context, url, error) => Image.asset("assets/default_image.png"),
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   );
          //                                 } else {
          //                                   return GestureDetector(
          //                                     onTap: () {
          //                                       uploadPic();
          //                                     },
          //                                     child: Container(
          //                                       height: 80,
          //                                       width: 80,
          //                                       margin:
          //                                           EdgeInsets.only(right: 4),
          //                                       decoration: BoxDecoration(
          //                                           borderRadius:
          //                                               BorderRadius.circular(
          //                                                   10),
          //                                           border: Border.all(
          //                                               color:
          //                                                   Colors.grey[400]),
          //                                           color: Colors.grey[350]),
          //                                       child: Center(
          //                                         child: Icon(
          //                                           Icons.camera_alt,
          //                                           color: Colors.grey[600],
          //                                           size: 35,
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   );
          //                                 }
          //                               },
          //                             )
          //                           : ListView.builder(
          //                               scrollDirection: Axis.horizontal,
          //                               itemCount: files.length + 1,
          //                               itemBuilder: (context, index) {
          //                                 if (index < files.length) {
          //                                   return Container(
          //                                     height: 80,
          //                                     width: 80,
          //                                     margin: EdgeInsets.only(right: 4),
          //                                     decoration: BoxDecoration(
          //                                         borderRadius:
          //                                             BorderRadius.circular(10),
          //                                         border: Border.all(
          //                                             color: Colors.grey[400]),
          //                                         color: Colors.grey[350]),
          //                                     child: Center(
          //                                       child: ClipRRect(
          //                                         borderRadius:
          //                                             BorderRadius.circular(10),
          //                                         child: FadeInImage(
          //                                             fit: BoxFit.cover,
          //                                             height: double.infinity,
          //                                             width: double.infinity,
          //                                             image: FileImage(
          //                                                 files[index]),
          //                                             placeholder: AssetImage(
          //                                                 "assets/default_profile.png")),
          //                                       ),
          //                                     ),
          //                                   );
          //                                 } else {
          //                                   return GestureDetector(
          //                                     onTap: () {
          //                                       if (files.length < 5) {
          //                                         uploadPic();
          //                                       } else if (files.length >= 5) {
          //                                         setState(() {
          //                                           files.clear();
          //                                           images.clear();
          //                                         });
          //                                       }
          //                                     },
          //                                     child: Container(
          //                                       height: 80,
          //                                       width: 80,
          //                                       margin:
          //                                           EdgeInsets.only(right: 4),
          //                                       decoration: BoxDecoration(
          //                                           borderRadius:
          //                                               BorderRadius.circular(
          //                                                   10),
          //                                           border: Border.all(
          //                                               color:
          //                                                   Colors.grey[400]),
          //                                           color: files.length < 5
          //                                               ? Colors.grey[350]
          //                                               : Colors.red),
          //                                       child: Center(
          //                                         child: Icon(
          //                                           files.length < 5
          //                                               ? Icons.camera_alt
          //                                               : Icons.delete,
          //                                           color: files.length < 5
          //                                               ? Colors.grey[600]
          //                                               : Colors.white,
          //                                           size: 35,
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   );
          //                                 }
          //                               },
          //                             ),
          //                     ),
          //                     SizedBox(
          //                       height: 25,
          //                     ),
          //                     SizedBox(
          //                       height: 55,
          //                       width: double.infinity,
          //                       child: RaisedButton(
          //                           color: ColorResources.PRIMARY,
          //                           shape: RoundedRectangleBorder(
          //                             borderRadius: BorderRadius.circular(10),
          //                           ),
          //                           child: Center(
          //                             child: Text("Simpan",
          //                                 style: TextStyle(
          //                                     fontSize: 16,
          //                                     color: Colors.white)),
          //                           ),
          //                           onPressed: () async {
          //                             pr.show();
          //                             final form = formKey.currentState;
          //                             if (form.validate()) {
          //                               form.save();

          //                               if (files != null || files.length > 0) {
          //                                 for (int i = 0;
          //                                     i < files.length;
          //                                     i++) {
          //                                   String body = await warungVM
          //                                       .getMediaKeyMedia(context);
          //                                   File file = File(files[i].path);
          //                                   Uint8List bytes =
          //                                       files[i].readAsBytesSync();
          //                                   String digestFile = sha256
          //                                       .convert(bytes)
          //                                       .toString();
          //                                   String imageHash = base64Url
          //                                       .encode(HEX.decode(digestFile));
          //                                   warungVM
          //                                       .uploadImageProduct(
          //                                           context,
          //                                           body,
          //                                           imageHash,
          //                                           product.body.store.id,
          //                                           file)
          //                                       .then((res) {
          //                                     print(res);
          //                                   });
          //                                 }
          //                               }

          //                               await warungVM
          //                                   .postEditDataProductWarung(
          //                                       context,
          //                                       widget.idProduct,
          //                                       _namaBarang,
          //                                       idCategory,
          //                                       int.parse(_harga),
          //                                       files,
          //                                       int.parse(_berat),
          //                                       _deskripsi,
          //                                       int.parse(_stok),
          //                                       kondisi,
          //                                       int.parse(_minOrder),
          //                                       product.body.store.id)
          //                                   .then((value) {
          //                                 if (value.code == 0) {
          //                                   pr.hide();
          //                                   Fluttertoast.showToast(
          //                                       msg: "Ubah Produk Sukses",
          //                                       toastLength: Toast.LENGTH_SHORT,
          //                                       gravity: ToastGravity.BOTTOM,
          //                                       timeInSecForIosWeb: 1,
          //                                       backgroundColor:
          //                                           ColorResources.PRIMARY,
          //                                       textColor: Colors.white);
          //                                   basket.addAll({
          //                                     "idCategory": null,
          //                                     "nameCategory": null,
          //                                   });
          //                                   Navigator.push(context,
          //                                       MaterialPageRoute(
          //                                           builder: (context) {
          //                                     return BarangJualanPage(
          //                                       idStore: product.body.store.id,
          //                                     );
          //                                   }));
          //                                 } else {
          //                                   pr.hide();
          //                                   Fluttertoast.showToast(
          //                                       msg:
          //                                           "Terjadi Kesalahan, Periksa Kembali Data",
          //                                       toastLength: Toast.LENGTH_SHORT,
          //                                       gravity: ToastGravity.BOTTOM,
          //                                       timeInSecForIosWeb: 1,
          //                                       backgroundColor: Colors.red,
          //                                       textColor: Colors.white);
          //                                 }
          //                               });
          //                             }
          //                           }),
          //                     )
          //                   ],
          //                 )),
          //           )
          //         ],
          //       )),
      )    
    );
  }
}

Widget inputFieldCategoryStuff(BuildContext context, String title, String hintText) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text(title,
          style: poppinsRegular.copyWith(
            fontSize: 13.0,
          )
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), 
              spreadRadius: 1.0, 
              blurRadius: 3.0, 
              offset: Offset(0.0, 1.0)
            )
          ],
        ),
        child: Consumer<WarungProvider>(
          builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
            return TextFormField(
              readOnly: true,
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return Consumer(
                      builder: (BuildContext context, WarungProvider warungProvider,  Widget child) {
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
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              Icons.close
                                            )
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 16),
                                            child: Text("Kategori Barang",
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
                                      child: ListView.separated(
                                        separatorBuilder: (BuildContext context, int i) => Divider(
                                          color: ColorResources.DIM_GRAY,
                                          thickness: 0.1,
                                        ),
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: warungProvider.categoryProductList.length,
                                        itemBuilder: (BuildContext context, int i) {
                                          return ListTile(
                                            title: Text(warungProvider.categoryProductList[i].name,
                                              style: poppinsRegular,
                                            ),
                                            trailing: InkWell(
                                              onTap: () {
                                                warungProvider.changeCategoryEditProductTitle(warungProvider.categoryProductList[i].name,warungProvider.categoryProductList[i].id);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Pilih",
                                                style: poppinsRegular,
                                              ),
                                            )
                                          );                                    
                                        },
                                      )  
                                    )                                
                                  ],
                                ),
                              ],
                            ),
                          )
                        );
                      }, 
                    );
                  }
                );
              },
              cursorColor: ColorResources.BLACK,
              keyboardType: TextInputType.text,
              style: poppinsRegular,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
              decoration: InputDecoration(
                hintText: warungProvider.categoryEditProductTitle == null
                ? "Kategori Barang"
                : warungProvider.categoryEditProductTitle,
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                isDense: true,
                hintStyle: poppinsRegular.copyWith(
                  color: warungProvider.categoryEditProductTitle == null 
                  ? Theme.of(context).hintColor 
                  : ColorResources.BLACK
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 0.5
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 0.5
                  ),
                ),
              ),
            );
          },
        )
      )
    ]
  );
}


Widget inputFieldNameStuff(BuildContext context, TextEditingController controller) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Nama Barang",
          style: poppinsRegular.copyWith(
            fontSize: 13.0,
          )
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), 
              spreadRadius: 1.0, 
              blurRadius: 3.0, 
              offset: Offset(0.0, 1.0)
            )
          ],
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: ColorResources.BLACK,
          keyboardType: TextInputType.text,
          style: poppinsRegular,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          decoration: InputDecoration(
            hintText: "Masukan Nama Barang",
            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
            isDense: true,
            hintStyle: poppinsRegular.copyWith(
              color: Theme.of(context).hintColor
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
          ),
        ),
      )
    ]
  );
}

Widget inputFieldPriceStuff(BuildContext context, TextEditingController controller) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Harga",
          style: poppinsRegular.copyWith(
            fontSize: 13.0,
          )
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), 
              spreadRadius: 1.0, 
              blurRadius: 3.0, 
              offset: Offset(0.0, 1.0)
            )
          ],
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: ColorResources.BLACK,
          keyboardType: TextInputType.number,
          style: poppinsRegular,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
          fillColor: Colors.white,
          prefixIcon: Container(
            width: 50,
            child: Center(
              child: Text("Rp",
                textAlign: TextAlign.center,
                style: poppinsRegular.copyWith(
                  fontWeight: FontWeight.bold
                ),
              )),
            ),
            hintText: "0",
            isDense: true,
            hintStyle: poppinsRegular.copyWith(
              color: Theme.of(context).hintColor
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
          ),
        ),
      )
    ]
  );
}

Widget inputFieldMinOrder(BuildContext context, TextEditingController controller) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Min Order",
          style: poppinsRegular.copyWith(
            fontSize: 13.0,
          )
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), 
              spreadRadius: 1.0, 
              blurRadius: 3.0, 
              offset: Offset(0.0, 1.0)
            )
          ],
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: ColorResources.BLACK,
          keyboardType: TextInputType.number,
          style: poppinsRegular,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: "0",
            isDense: true,
            hintStyle: poppinsRegular.copyWith(
              color: Theme.of(context).hintColor
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
          ),
        ),
      )
    ]
  );
}

Widget inputFieldStock(BuildContext context, TextEditingController controller) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Stok",
          style: poppinsRegular.copyWith(
            fontSize: 13.0,
          )
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), 
              spreadRadius: 1.0, 
              blurRadius: 3.0, 
              offset: Offset(0.0, 1.0)
            )
          ],
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: ColorResources.BLACK,
          keyboardType: TextInputType.number,
          style: poppinsRegular,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: "0",
            isDense: true,
            hintStyle: poppinsRegular.copyWith(
              color: Theme.of(context).hintColor
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
          ),
        ),
      )
    ]
  );
}

Widget inputFieldDescriptionStuff(BuildContext context) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Deskripsi Barang", 
          style: poppinsRegular.copyWith(
            fontSize: 14.0,
          )
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      InkWell(
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            context: context,
            builder: (BuildContext context) {
              return Consumer(
                builder: (BuildContext context, WarungProvider warungProvider,  Widget child) {
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.close
                                      )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 16),
                                      child: Text("Masukan Deskripsi",
                                        style: poppinsRegular.copyWith(
                                          fontSize: 16.0,
                                          color: Colors.black
                                        )
                                      )
                                    ),
                                    warungProvider.descEditSellerStore != null
                                    ? InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.done,
                                        color: ColorResources.PRIMARY
                                      )
                                    )
                                    : Container(),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 3,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0)
                                ),
                                child: TextFormField(
                                  autofocus: true,
                                  initialValue: warungProvider.descEditSellerStore,
                                  onChanged: (val) {
                                    warungProvider.changeDescEditSellerStore(val);
                                  },
                                  decoration: InputDecoration(
                                    hintText:  "Masukan Deskripsi Barang Anda",
                                    hintStyle: poppinsRegular.copyWith(
                                      color: warungProvider.descEditSellerStore != null
                                      ? ColorResources.BLACK
                                      : Theme.of(context).hintColor
                                    ),
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  style: poppinsRegular
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  );
                }, 
              );
            }
          );
        },
        child: Consumer<WarungProvider>(
          builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
            return Container(
              height: 120.0,
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              child: Text(warungProvider.descEditSellerStore == null 
              ? "Masukan Deskripsi Barang Anda" 
              : warungProvider.descEditSellerStore,
                style: poppinsRegular.copyWith(
                  fontSize: 14.0, 
                  color: warungProvider.descEditSellerStore != null 
                  ? ColorResources.BLACK 
                  : Theme.of(context).hintColor
                )
              )
            );
          },
        )
      ),
    ],
  );             
}

Widget inputFieldWeight(BuildContext context, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Berat",
          style: poppinsRegular.copyWith(
            fontSize: 13.0,
          )
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), 
              spreadRadius: 1.0, 
              blurRadius: 3.0, 
              offset: Offset(0.0, 1.0)
            )
          ],
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: ColorResources.BLACK,
          keyboardType: TextInputType.number,
          style: poppinsRegular,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: "0",
            isDense: true,
            suffixIcon: Container(
              width: 80.0,
              child: Center(
                child: Text("Gram",
                  textAlign: TextAlign.center,
                  style: poppinsRegular.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            hintStyle: poppinsRegular.copyWith(
              color: Theme.of(context).hintColor
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
          ),
        ),
      )
    ]
  );
}

