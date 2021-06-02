import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import "package:crypto/crypto.dart";

import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hex/hex.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/data/models/warung/product_single_warung_model.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/warung/barang_jualan.dart';
import 'package:mbw204_club_ina/views/screens/warung/pilih_kategori.dart';



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
  File f1;
  ProductSingleWarungModel product;
  String _namaBarang;
  String _harga;
  String _stok;
  String _berat;
  String _deskripsi;
  String _minOrder;

  String kategoriProduct;
  String idCategory;
  int _value;
  String kondisi;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ImageSource imageSource;
  List<Asset> images = List<Asset>();

  List<File> files = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getRequests();
  }

  getRequests() {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    Provider.of<WarungProvider>(context, listen: false).getDataSingleProduct(context, widget.idProduct, widget.typeProduct, widget.path).then((value) {
      setState(() {
        isLoading = false;
        product = value;
        kondisi = product.body.condition;
        idCategory = product.body.category.id;
        _value = kondisi == "NEW" ? 1 : 0;
        idCategory = basket['idCategory'] == null ? product.body.category.id : basket['idCategory'];
      });
    });
  }

  void uploadPic() async {
    List<Asset> resultList = List<Asset>();
    List<File> before = [];
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

  Future<bool> onWillPop() {
    Navigator.of(context).pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
 
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
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
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 20.0,
                color: ColorResources.GREY,
              ),
              onPressed: () {
                return onWillPop();
              }
            ),
            centerTitle: true,
            elevation: 0,
            title: Text( "Ubah Barang"),
          ),
          body: isLoading
              ? Loader(
                color: ColorResources.PRIMARY,
              )
              : ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Kategori Barang",
                                style: TextStyle(
                                  fontSize: 18.0,
                                )
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return PilihKategoriPage(
                                      idCategory: "",
                                      idProduct: product.body.id,
                                      typeProduct: "seller",
                                      path: widget.path);
                                     }
                                    )
                                  );
                                },
                                child: Container(
                                    height: 60,
                                    width: double.infinity,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.grey[100]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            basket['nameCategory'] == null
                                                ? product.body.category.name
                                                : basket['nameCategory'],
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.grey[600])),
                                      ],
                                    )),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text("Nama Barang",
                                style: TextStyle(
                                  fontSize: 18.0,
                                )
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0)
                                ),
                                child: TextFormField(
                                  initialValue: product.body.name,
                                  decoration: InputDecoration(
                                    hintText: "Masukan Nama Barang",
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(),
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Nama barang tidak boleh kosong";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (newValue) => _namaBarang = newValue,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    fontFamily: 'Proppins',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Harga",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          child: TextFormField(
                                            initialValue: (product.body.price - product.body.adminCharge).toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), ""),
                                            decoration: InputDecoration(
                                              hintText: "0",
                                              fillColor: Colors.white,
                                              prefixIcon: Container(
                                                width: 50,
                                                child: Center(
                                                  child: Text(
                                                    "Rp",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            ),
                                            validator: (val) {
                                              if (val.isEmpty) {
                                                return "Harga tidak boleh kosong";
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSaved: (newValue) =>
                                                _harga = newValue,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            style: TextStyle(
                                              fontFamily: 'Proppins',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 120,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Min Order",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: TextFormField(
                                            initialValue: product.body.minOrder
                                                .toString(),
                                            decoration: InputDecoration(
                                              hintText: "0",
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            ),
                                            validator: (val) {
                                              if (val.isEmpty) {
                                                return "Min Order tidak boleh kosong";
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSaved: (newValue) =>
                                                _minOrder = newValue,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            style: TextStyle(
                                              fontFamily: 'Proppins',
                                            ),
                                          ),
                                        ),
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
                                    width: 120,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Stok",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          )
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          child: TextFormField(
                                            initialValue: product.body.stock.toString(),
                                            decoration: InputDecoration(
                                              hintText: "0",
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            ),
                                            validator: (val) {
                                              if (val.isEmpty) {
                                                return "Stok tidak boleh kosong";
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSaved: (newValue) =>
                                                _stok = newValue,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            style: TextStyle(
                                              fontFamily: 'Proppins',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Berat",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          )
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          child: TextFormField(
                                            initialValue: product.body.weight.toString(),
                                            decoration: InputDecoration(
                                              hintText: "0",
                                              fillColor: Colors.white,
                                              suffixIcon: Container(
                                                width: 80.0,
                                                child: Center(
                                                  child: Text("Gram",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            ),
                                            validator: (val) {
                                              if (val.isEmpty) {
                                                return "Berat tidak boleh kosong";
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSaved: (newValue) =>
                                                _berat = newValue,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            style: TextStyle(
                                              fontFamily: 'Proppins',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text("Kondisi",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _value = 0;
                                          kondisi = "USED";
                                          print(kondisi);
                                        });
                                      },
                                      child: Container(
                                        height: 55,
                                        width: double.infinity,
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(55),
                                          border:
                                              Border.all(color: Colors.grey),
                                          color: _value == 0
                                              ? ColorResources.PRIMARY
                                              : Colors.transparent,
                                        ),
                                        child: Center(
                                            child: Text("Bekas",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: _value == 0
                                                        ? Colors.white
                                                        : Colors.black))),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _value = 1;
                                          kondisi = "NEW";
                                          print(kondisi);
                                        });
                                      },
                                      child: Container(
                                        height: 55,
                                        width: double.infinity,
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(55),
                                          border:
                                              Border.all(color: Colors.grey),
                                          color: _value == 1
                                              ? ColorResources.PRIMARY
                                              : Colors.transparent,
                                        ),
                                        child: Center(
                                            child: Text("Baru",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: _value == 1
                                                        ? Colors.white
                                                        : Colors.black))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text("Deskripsi",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                // color: Colors.white,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: TextFormField(
                                  initialValue: product.body.description,
                                  maxLines: null,
                                  maxLength: null,
                                  decoration: InputDecoration(
                                    // labelText: "No Ponsel",
                                    hintText: "Masukan Deskripsi",
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Deskripsi tidak boleh kosong";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (newValue) => _deskripsi = newValue,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    fontFamily: 'Proppins',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text("Gambar Barang",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 100,
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[600]),
                                    borderRadius: BorderRadius.circular(10)),
                                child: files == null || files.length == 0
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            product.body.pictures.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index <
                                              product.body.pictures.length) {
                                            return Container(
                                              height: 80,
                                              width: 80,
                                              margin: EdgeInsets.only(right: 4),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.grey[400]),
                                                  color: Colors.grey[350]),
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    imageUrl: AppConstants.BASE_URL_FEED_IMG +
                                                        product
                                                            .body
                                                            .pictures[index]
                                                            .path,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) => Loader(
                                                      color: ColorResources.PRIMARY,
                                                    ),
                                                    errorWidget: (context, url, error) => Image.asset("assets/default_image.png"),
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
                                                height: 80,
                                                width: 80,
                                                margin:
                                                    EdgeInsets.only(right: 4),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color:
                                                            Colors.grey[400]),
                                                    color: Colors.grey[350]),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.camera_alt,
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
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.grey[400]),
                                                  color: Colors.grey[350]),
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: FadeInImage(
                                                      fit: BoxFit.cover,
                                                      height: double.infinity,
                                                      width: double.infinity,
                                                      image: FileImage(
                                                          files[index]),
                                                      placeholder: AssetImage(
                                                          "assets/default_profile.png")),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return GestureDetector(
                                              onTap: () {
                                                if (files.length < 5) {
                                                  uploadPic();
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
                                                margin:
                                                    EdgeInsets.only(right: 4),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color:
                                                            Colors.grey[400]),
                                                    color: files.length < 5
                                                        ? Colors.grey[350]
                                                        : Colors.red),
                                                child: Center(
                                                  child: Icon(
                                                    files.length < 5
                                                        ? Icons.camera_alt
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
                                height: 25,
                              ),
                              SizedBox(
                                height: 55,
                                width: double.infinity,
                                child: RaisedButton(
                                    color: ColorResources.PRIMARY,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text("Simpan",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white)),
                                    ),
                                    onPressed: () async {
                                      pr.show();
                                      final form = formKey.currentState;
                                      if (form.validate()) {
                                        form.save();

                                        if (files != null || files.length > 0) {
                                          for (int i = 0;
                                              i < files.length;
                                              i++) {
                                            String body = await warungVM
                                                .getMediaKeyMedia(context);
                                            File file = File(files[i].path);
                                            Uint8List bytes =
                                                files[i].readAsBytesSync();
                                            String digestFile = sha256
                                                .convert(bytes)
                                                .toString();
                                            String imageHash = base64Url
                                                .encode(HEX.decode(digestFile));
                                            warungVM
                                                .uploadImageProduct(
                                                    context,
                                                    body,
                                                    imageHash,
                                                    product.body.store.id,
                                                    file)
                                                .then((res) {
                                              print(res);
                                            });
                                          }
                                        }

                                        await warungVM
                                            .postEditDataProductWarung(
                                                context,
                                                widget.idProduct,
                                                _namaBarang,
                                                idCategory,
                                                int.parse(_harga),
                                                files,
                                                int.parse(_berat),
                                                _deskripsi,
                                                int.parse(_stok),
                                                kondisi,
                                                int.parse(_minOrder),
                                                product.body.store.id)
                                            .then((value) {
                                          if (value.code == 0) {
                                            pr.hide();
                                            Fluttertoast.showToast(
                                                msg: "Ubah Produk Sukses",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    ColorResources.PRIMARY,
                                                textColor: Colors.white);
                                            basket.addAll({
                                              "idCategory": null,
                                              "nameCategory": null,
                                            });
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return BarangJualanPage(
                                                idStore: product.body.store.id,
                                              );
                                            }));
                                          } else {
                                            pr.hide();
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Terjadi Kesalahan, Periksa Kembali Data",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white);
                                          }
                                        });
                                      }
                                    }),
                              )
                            ],
                          )),
                    )
                  ],
                )),
    );
  }
}
