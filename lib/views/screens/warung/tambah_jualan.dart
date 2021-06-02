import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hex/hex.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/data/models/warung/category_product_model.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/warung/barang_jualan.dart';
import 'package:mbw204_club_ina/views/screens/warung/pilih_kategori.dart';

class TambahJualanPage extends StatefulWidget {
  final String idStore;

  TambahJualanPage({
    Key key,
    @required this.idStore,
  }) : super(key: key);
  @override
  _TambahJualanPageState createState() => _TambahJualanPageState();
}

class _TambahJualanPageState extends State<TambahJualanPage> {
  File f1;
  final _namaBarang = TextEditingController();
  final _harga = TextEditingController();
  final _stok = TextEditingController();
  final _berat = TextEditingController();
  final _deskripsi = TextEditingController();
  final _minOrder = TextEditingController();

  String kategoriProduct;
  String idCategory;
  String kondisi = "NEW";
  int _value = 1;
  bool isLoadingParent = true;
  final formKey = new GlobalKey<FormState>();

  ImageSource imageSource;
  List<Asset> images = List<Asset>();
  bool _isLoading = true;

  List<File> files = [];
  List<File> before = [];

  CategoryProductModel categoryProductParent;
  String idCategoryparent;

  @override
  void initState() {
    super.initState();
    _namaBarang.addListener(() {
      setState(() {});
    });
    _harga.addListener(() {
      setState(() {});
    });
    _stok.addListener(() {
      setState(() {});
    });
    _berat.addListener(() {
      setState(() {});
    });
    _deskripsi.addListener(() {
      setState(() {});
    });
    _minOrder.addListener(() {
      setState(() {});
    });
  }

  getRequests() async {
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    await warungVM.getDataCategoryProductByParent(context, "seller", idCategoryparent).then((value) {
      setState(() {
        isLoadingParent = false;
        categoryProductParent = value;
      });
    });
  }

  void _pickImage() async {
    var imageSource = await showDialog<ImageSource>(context: context, 
      builder: (context) => AlertDialog(
        title: Text("Pilih sumber gambar",
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.orange[700]
          ),
        ),
        actions: [
          MaterialButton(
            child: Text("Camera",
              style: TextStyle(color: Colors.orange[700]),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: Text( "Gallery",
              style: TextStyle(color: Colors.orange[700]),
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
    List<Asset> resultList = List<Asset>();
    resultList = await MultiImagePicker.pickImages(
      maxImages: 5,
      enableCamera: false,
      selectedAssets: images,
      materialOptions: MaterialOptions(
        actionBarColor: "#FF7700", 
        statusBarColor: "#FF7700"
      )
    );
    Navigator.of(context, rootNavigator: true).pop();
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
    idCategory = basket['idCategory'] == null ? null : basket['idCategory'];
    return Scaffold(
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
          setState(() {
            basket.addAll({
              "idCategory": null,
              "nameCategory": null,
            });
          });
          Navigator.of(context).pop();
        }
      ),
      centerTitle: true,
      elevation: 0,
      title: Text( "Jual Barang"),
    ),
    body: ListView(
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
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                        return PilihKategoriPage(
                          idCategory: "",
                          typeProduct: "seller",
                          idProduct: "",
                          path: '/fetch',
                        );
                      }));
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        color: Colors.grey[100]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(basket['nameCategory'] == null ? "Masukan Kategori Produk" : basket['nameCategory'],
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600])
                          ),
                        ],
                      )
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Nama Barang",
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
                      controller: _namaBarang,
                      decoration: InputDecoration(
                        hintText: "Masukan Nama Barang",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Nama barang tidak boleh kosong";
                        } else {
                          return null;
                        }
                      },
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Harga",
                              style: TextStyle(
                                fontSize: 18.0,
                              )
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,                                 
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: TextFormField(
                                controller: _harga,
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
                                            fontWeight: FontWeight.bold),
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
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: TextFormField(
                                controller: _minOrder,
                                decoration: InputDecoration(
                                  hintText: "0",
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return "Min Order tidak boleh kosong";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                controller: _stok,
                                decoration: InputDecoration(
                                  hintText: "0",
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return "Stok tidak boleh kosong";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
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
                                controller: _berat,
                                decoration: InputDecoration(
                                  hintText: "0",
                                  fillColor: Colors.white,
                                  suffixIcon: Container(
                                    width: 80,
                                    child: Center(
                                      child: Text(
                                        "Gram",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
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
                              borderRadius: BorderRadius.circular(55),
                              border: Border.all(color: Colors.grey),
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
                              borderRadius: BorderRadius.circular(55),
                              border: Border.all(color: Colors.grey),
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
                  GestureDetector(
                    onTap: () {
                      _modalInputan();
                    },
                    child: Container(
                        height: 120,
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                            color: Colors.grey[100]),
                        child: Text(
                            _deskripsi.text == ''
                                ? "Masukan Deskripsi Produk Anda"
                                : _deskripsi.text,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600]))),
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
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[600]),
                        borderRadius: BorderRadius.circular(10)),
                    child: files == null || files.length == 0
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey[400]),
                                      color: Colors.grey[350]),
                                  child: Center(
                                    child: files == null ||
                                            files.length == 0
                                        ? Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey[600],
                                            size: 35,
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: FadeInImage(
                                                fit: BoxFit.cover,
                                                height: double.infinity,
                                                width: double.infinity,
                                                image: FileImage(
                                                    files.first),
                                                placeholder: AssetImage(
                                                    "assets/default_profile.png")),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text("Upload Gambar Barang",
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      "Maksimum 5 gambar, ukuran minimal 300x300px berformat JPG atau PNG",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600])),
                                ],
                              ))
                            ],
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
                                          image: FileImage(files[index]),
                                          placeholder: AssetImage(
                                              "assets/default_profile.png")),
                                    ),
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    if (files.length < 5) {
                                      _pickImage();
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
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey[400]),
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
                        color: _namaBarang.text == '' ||
                                _harga.text == '' ||
                                _harga.text == '0' ||
                                _stok.text == '' ||
                                _stok.text == '0' ||
                                _berat.text == '' ||
                                _berat.text == '0' ||
                                _deskripsi.text == '' ||
                                _minOrder.text == '' ||
                                _minOrder.text == '0' ||
                                idCategory == null ||
                                kondisi == null ||
                                files.length == 0 ||
                                files == null
                            ? Colors.grey[350]
                            : Colors.orange[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("Jual Barang",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ),
                        onPressed: () async {
                          if (_namaBarang.text == '' ||
                              _harga.text == '' ||
                              _harga.text == '0' ||
                              _stok.text == '' ||
                              _stok.text == '0' ||
                              _berat.text == '' ||
                              _berat.text == '0' ||
                              _deskripsi.text == '' ||
                              _minOrder.text == '' ||
                              _minOrder.text == '0' ||
                              idCategory == null ||
                              kondisi == null ||
                              files.length == 0 ||
                              files == null) {
                            Fluttertoast.showToast(
                                msg: "Terjadi kesalahan, Lengkapi data",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white);
                          } else {
                            print("Tap 1");
                            pr.show();
                            final form = formKey.currentState;
                            if (form.validate()) {
                              form.save();
                              print("Tap 2");
                              for (int i = 0; i < files.length; i++) {
                                String body =
                                    await warungVM.getMediaKeyMedia(context);
                                File file = File(files[i].path);
                                Uint8List bytes =
                                    files[i].readAsBytesSync();
                                String digestFile =
                                    sha256.convert(bytes).toString();
                                String imageHash = base64Url
                                    .encode(HEX.decode(digestFile));
                                warungVM
                                    .uploadImageProduct(context, body, imageHash,
                                        widget.idStore, file)
                                    .then((res) {
                                  print(res);
                                });
                              }
                              print("Tap 3");
                              await warungVM
                                  .postDataProductWarung(
                                      context,
                                      _namaBarang.text,
                                      idCategory,
                                      int.parse(_harga.text),
                                      files,
                                      int.parse(_berat.text),
                                      _deskripsi.text,
                                      int.parse(_stok.text),
                                      kondisi,
                                      int.parse(_minOrder.text),
                                      widget.idStore)
                                  .then((value) {
                                if (value.code == 0) {
                                  pr.hide();
                                  Fluttertoast.showToast(
                                      msg: "Tambah Produk Sukses",
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
                                  return Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) {
                                    return BarangJualanPage(
                                      idStore: widget.idStore,
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
                          }
                        }),
                  )
                ],
              )),
        )
      ],
    )
  );
  }

  void _modalInputan() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.96,
            color: Colors.transparent,
            child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0)
                )
              ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 16, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close)),
                              Container(
                                  margin: EdgeInsets.only(left: 16),
                                  child: Text("Masukan Deskripsi",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black))),
                            ],
                          )),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.done,
                                  color: ColorResources.PRIMARY)),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextFormField(
                        controller: _deskripsi,
                        autocorrect: true,
                        autofocus: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Masukan Deskripsi Produk Anda",
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Deskripsi tidak boleh kosong";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          fontFamily: 'Proppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          )
        );
        });
      },
    );
  }
}
