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
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/screens/store/select_category.dart';

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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ImageSource imageSource;

  List<Asset> images = [];
  List<File> files = [];
  List<File> before = [];

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

  Future submit() async {
    try {
      if(Provider.of<WarungProvider>(context, listen: false).categoryAddProductTitle == null || Provider.of<WarungProvider>(context, listen: false).categoryAddProductTitle.isEmpty){
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
      if(typeConditionName.isEmpty || typeConditionName == null) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Kondisi Barang belum diisi"
        );
        return;
      }
      if(typeStuffName.isEmpty || typeStuffName == null) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Jenis Barang belum diisi"
        );
        return;
      }
      if(Provider.of<WarungProvider>(context, listen: false).descAddSellerStore == "" || Provider.of<WarungProvider>(context, listen: false).descAddSellerStore == null) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Deskripsi Barang belum diisi"
        );
        return;
      }
      if(files == null || files.isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Gambar belum diisi",
        );
        return;
      } 
      for (int i = 0; i < files.length; i++) {
        String body = await Provider.of<WarungProvider>(context, listen: false).getMediaKeyMedia(context);
        File file = File(files[i].path);
        Uint8List bytes = files[i].readAsBytesSync();
        String digestFile = sha256.convert(bytes).toString();
        String imageHash = base64Url.encode(HEX.decode(digestFile));
        Provider.of<WarungProvider>(context, listen: false).uploadImageProduct(context, body, imageHash, file);
      }
      await Provider.of<WarungProvider>(context, listen: false).postDataProductWarung(
        context,
        nameStuffController.text,
        int.parse(priceController.text),
        files,
        int.parse(weightController.text),
        int.parse(stockController.text),
        typeConditionName,
        typeStuffName,
        int.parse(minOrderController.text),
        widget.idStore
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
    return WillPopScope(
      onWillPop: () {
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
          onPressed: () {
            // int count = 0;
            // Navigator.popUntil(context, (route) {
            //   return count++ == 1;
            // });
            return onWillPop();
          }
        ),
        centerTitle: true,
        elevation: 0,
        title: Text( "Jual Barang",
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
                child: Column(
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
                    inputFieldDescriptionStore(context),
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
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTap: pickImage,
                                  child: Container(
                                    height: 80.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                      color: Colors.grey.withOpacity(0.5)
                                    ),
                                    child: Center(
                                      child: files == null || files.length == 0
                                      ? Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[600],
                                          size: 35,
                                        )
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: FadeInImage(
                                            fit: BoxFit.cover,
                                            height: double.infinity,
                                            width: double.infinity,
                                            image: FileImage(files.first),
                                            placeholder: AssetImage("assets/default_profile.png")
                                          ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Upload Gambar Barang",
                                      style: poppinsRegular.copyWith(
                                        fontSize: 14.0,
                                      )
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text("Maksimum 5 gambar, ukuran minimal 300x300px berformat JPG atau PNG",
                                      style: poppinsRegular.copyWith(
                                        fontSize: 14.0,
                                        color: Colors.grey[600]
                                      )
                                    ),
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
                      color: ColorResources.PRIMARY,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
                )
              ),
            )
          ],
        )
      ),
    );
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
                                                  warungProvider.changeCategoryAddProductTitle(warungProvider.categoryProductList[i].name,warungProvider.categoryProductList[i].id);
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
                cursorColor: ColorResources.getBlackToWhite(context),
                keyboardType: TextInputType.text,
                style: poppinsRegular,
                inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                decoration: InputDecoration(
                  hintText: warungProvider.categoryAddProductTitle == null
                  ? "Kategori Barang"
                  : warungProvider.categoryAddProductTitle,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                  isDense: true,
                  hintStyle: poppinsRegular.copyWith(
                    color: warungProvider.categoryAddProductTitle == null 
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
          cursorColor: ColorResources.getBlackToWhite(context),
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
          cursorColor: ColorResources.getBlackToWhite(context),
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
          cursorColor: ColorResources.getBlackToWhite(context),
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
          cursorColor: ColorResources.getBlackToWhite(context),
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

Widget inputFieldDescriptionStore(BuildContext context) {
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
                                    warungProvider.descAddSellerStore != null
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
                                  initialValue: warungProvider.descAddSellerStore,
                                  onChanged: (val) {
                                    warungProvider.changeDescAddSellerStore(val);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Masukan Deskripsi Toko Anda",
                                    hintStyle: poppinsRegular.copyWith(
                                      color: warungProvider.descAddSellerStore != null
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
              child: Text(warungProvider.descAddSellerStore == null 
              ? "Masukan Deskripsi Barang Anda" 
              : warungProvider.descAddSellerStore,
                style: poppinsRegular.copyWith(
                  fontSize: 14.0, 
                  color: warungProvider.descAddSellerStore != null 
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
          cursorColor: ColorResources.getBlackToWhite(context),
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

