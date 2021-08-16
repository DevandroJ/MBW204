import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:crypto/crypto.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/data/repository/feed.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/data/models/warung/region_subdistrict_model.dart';
import 'package:mbw204_club_ina/maps/google_maps_place_picker.dart';
import 'package:mbw204_club_ina/providers/location.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/models/warung/region_model.dart';
import 'package:mbw204_club_ina/providers/region.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';

class FormStoreScreen extends StatefulWidget {
  @override
  _FormStoreScreenState createState() => _FormStoreScreenState();
}

class _FormStoreScreenState extends State<FormStoreScreen> {
  TextEditingController nameStoreController = TextEditingController();
  TextEditingController descStoreController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController villageController = TextEditingController(); 
  TextEditingController postCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File _file;

  String idProvince;
  String province;
  String idCity;
  String idSubDistrictId;
  String subDistrictName;
  String cityName;

  void pickImage() async {
    ImageSource imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pilih sumber gambar",
          style: poppinsRegular.copyWith(
            color: ColorResources.PRIMARY
          ),
        ),
        actions: [
          MaterialButton(
            child: Text(
              "Camera",
              style: poppinsRegular.copyWith(color: ColorResources.PRIMARY),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: Text(
              "Gallery",
              style: poppinsRegular.copyWith(color: ColorResources.PRIMARY),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          )
        ],
      )
    );
    if (imageSource != null) {
      File file = await ImagePicker.pickImage(source: imageSource, maxHeight: 720);
      if (file != null) {
        setState(() => _file = file);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    emailController.text = Provider.of<ProfileProvider>(context, listen: false).getUserEmail ??  "";
    phoneController.text = Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber ??  "";
  
    descStoreController.addListener(() {
      setState(() {});
    });
  }

  Future submit() async {
    try {
      if(_file == null) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Foto Profil tidak boleh kosong"
        );
        return;
      }
      if(nameStoreController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Nama Toko tidak boleh kosong"
        );
        return;
      }
      if(province == null || province.isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Provinsi tidak boleh kosong"
        );
        return;
      } 
      if(cityName == null || cityName.isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          fontSize: 14.0,
          msg: "Kota tidak boleh kosong"
        );
        return;
      }
      if(postCodeController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          msg: "Kode Pos tidak boleh kosong",
          fontSize: 14.0,
        );
        return;
      }
      if(subDistrictName == null || subDistrictName.isEmpty ) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          msg: "Kecamatan tidak boleh kosong",
          fontSize: 14.0
        );
        return;
      }
      if(villageController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          msg: "Kelurahan / Desa tidak boleh kosong",
          fontSize: 14.0
        );
        return;
      }
      if(emailController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          msg: "Alamat E-mail tidak boleh kosong",
          fontSize: 14.0
        );
        return;
      }
      if(phoneController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          msg: "Nomor HP tidak boleh kosong",
          fontSize: 14.0
        );
        return;
      }
      if(Provider.of<WarungProvider>(context, listen: false).isCheckedKurir.isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          msg: "Kurir tidak boleh kosong",
          fontSize: 14.0
        );
        return;
      }
      if(addressController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          msg: "Detail alamat tidak boleh kosong",
          fontSize: 14.0
        );
        return;
      }
      if(descStoreController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          msg: "Deskripsi toko tidak boleh kosong",
          fontSize: 14.0
        );
        return;
      }
      String body = await FeedService.shared.getMediaKey(); 
      Uint8List bytes = _file.readAsBytesSync();
      File file = File(_file.path);
      String digestFile = sha256.convert(bytes).toString();
      String imageHash = base64Url.encode(HEX.decode(digestFile)); 
      await Provider.of<WarungProvider>(context, listen: false).uploadImageProduct(
        context, 
        body, 
        imageHash, 
        file
      );
      await Provider.of<WarungProvider>(context, listen: false).postCreateDataStore(
        context, 
        file,
        nameStoreController.text, 
        province, 
        cityName, 
        villageController.text, 
        postCodeController.text, 
        addressController.text, 
        subDistrictName,
        emailController.text,
        phoneController.text,
        descStoreController.text
      );
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<WarungProvider>(context, listen: false).getDataCouriers(context);
 
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorResources.PRIMARY,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20.0,
            color: ColorResources.WHITE,
          ),
          onPressed: () => Navigator.of(context).pop()
        ),
        centerTitle: true,
        elevation: 0,
        title: Text("Form Buka Toko",
          style: poppinsRegular.copyWith(
            color: ColorResources.WHITE
          ),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Consumer<WarungProvider>(
            builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: pickImage,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: _file == null 
                        ? Container(
                          color: ColorResources.GREY,
                          child: Icon(
                            Icons.store,
                            size: 80.0,
                            color: ColorResources.PRIMARY,
                          ),
                        )  
                        : Container(
                          color: ColorResources.GREY,
                          child: Image.file(_file,
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.fitWidth
                          ),
                        ),
                      ),
                    ),
                      inputFieldStoreName(context, warungProvider, "Nama Toko", nameStoreController, "Nama Toko"),
                      SizedBox(
                        height: 15.0,
                      ),
                      inputFieldProvince(context, warungProvider, "Provinsi", "Provinsi"),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          inputFieldCity(context, "Kota", "Kota"),    
                          SizedBox(width: 15.0), 
                          inputFieldPostCode(context, "Kode Pos", postCodeController, "Kode Pos"),
                        ],
                      ),
                      SizedBox(height: 15.0),
                      inputFieldSubDistrict(context, warungProvider),
                      SizedBox(height: 15.0),
                      inputFieldKelurahanDesa(context, warungProvider, "Kelurahan / Desa", villageController, "Kelurahan / Desa"),
                      SizedBox(height: 15.0),
                      inputFieldEmailAddress(context, "E-mail Address", emailController, "E-mail Address"),
                      SizedBox(height: 15.0),
                      inputFieldPhoneNumber(context, "Nomor HP", phoneController, "Nomor HP"),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Jasa Kurir", 
                          style: poppinsRegular.copyWith(
                            fontSize: 14.0,
                          )
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Text("Pilih Jasa Pengiriman",
                            style: poppinsRegular.copyWith(
                              fontSize: 14.0, 
                            )
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: Text("(Minimal 1 Jasa Pengiriman)",
                              style: poppinsRegular.copyWith(
                                fontSize: 14.0, 
                              )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),          
                      inputFieldCourier(context, warungProvider),
                      SizedBox(
                        height: 15.0,
                      ),
                      inputFieldAddress(context, warungProvider),
                      SizedBox(
                        height: 15.0,
                      ),
                      inputFieldDetailAddress(context, "Detail Alamat Toko", addressController, "Ex: Jl. Benda Raya"),
                      SizedBox(
                        height: 15.0,
                      ),
                      inputFieldDescriptionStore(context, warungProvider, descStoreController),    
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
                              borderRadius: BorderRadius.circular(10.0),
                            )
                          ),
                          child: Center(
                            child: warungProvider.createStoreStatus == CreateStoreStatus.loading 
                            ? Loader(
                              color: ColorResources.WHITE,
                            ) 
                            : Text("Submit",
                              style: poppinsRegular.copyWith(
                                fontSize: 14.0,
                                color: Colors.white
                              )
                            ),
                          ),
                          onPressed: submit
                        ),
                      )
                    ],
                  )
                )
              );
            },
          )
        ],
      ),
    );
  }

  Widget inputFieldProvince(BuildContext context, WarungProvider warungProvider, String title, String hintText) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(title,
            style: poppinsRegular.copyWith(
              fontSize: 14.0,
            )
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.WHITE,
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
            onTap: warungProvider.createStoreStatus == CreateStoreStatus.loading ? null : () {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                context: context,
                builder: (BuildContext context) {
                  return Consumer<WarungProvider>(
                    builder: (BuildContext context, WarungProvider warungProviderChild, Widget child) {
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
                                  padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
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
                                            child: Icon(
                                              Icons.close
                                            )
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 16),
                                            child: Text("Pilih Provinsi Anda",
                                              style: poppinsRegular.copyWith(
                                                fontSize: 16.0,
                                                color: Colors.black
                                              )
                                            )
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 3,
                                ),
                                Expanded(
                                flex: 40,
                                child: FutureBuilder<RegionModel>(
                                  future: Provider.of<RegionProvider>(context, listen: false).getRegion(context, "province"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final RegionModel regionModel = snapshot.data;
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: regionModel.body.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(regionModel.body[index].name),
                                            onTap: () {
                                              setState(() {
                                                idProvince = regionModel.body[index].id;
                                                province = regionModel.body[index].name;
                                                subDistrictName = null;
                                                cityName = null;
                                              });
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                        separatorBuilder:
                                            (context, index) {
                                          return Divider(
                                            thickness: 1,
                                          );
                                        },
                                      );
                                    }
                                    return Loader(
                                      color: ColorResources.PRIMARY,
                                    );
                                  }
                                )
                              ),
                            ],
                          ),
                        ])
                        )
                      );
                    },
                  );
                }
              );
            },
            readOnly: true,
            cursorColor: ColorResources.BLACK,
            controller: provinceController,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: province == null ? hintText : province,
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: poppinsRegular.copyWith(
                color: province == null 
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
          ),
        )
      ],
    );          
  }

  Widget inputFieldCity(BuildContext context, String title, String hintText) {
    return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, 
          style: poppinsRegular.copyWith(
            fontSize: 14.0,
          )
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.WHITE,
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
            onTap: () {
              if (idProvince == null) {
                Fluttertoast.showToast(
                  msg: "Pilih provinsi Anda Terlebih Dahulu",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.black
                );
              } else {
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return Consumer(
                      builder: (BuildContext context, WarungProvider warungProviderChild, Widget child) {
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
                                      padding: EdgeInsets.only(
                                        left: 16.0, 
                                        right: 16.0, 
                                        top: 16.0,
                                        bottom: 8.0
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () => Navigator.pop(context),
                                                child: Icon(
                                                  Icons.close
                                                )
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 16),
                                                child: Text("Pilih Kota Anda",
                                                  style: poppinsRegular.copyWith(
                                                    fontSize: 14.0,
                                                    color: Colors.black
                                                  )
                                                )
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 3.0,
                                    ),
                                    Expanded(
                                      flex: 40,
                                      child: FutureBuilder<RegionModel>(
                                        future: Provider.of<RegionProvider>(context, listen: false).getCity(context, idProvince),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final RegionModel regionModel = snapshot.data;
                                            return ListView.separated(
                                              shrinkWrap: true,
                                              physics: BouncingScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemCount:regionModel.body.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  title: Text(regionModel.body[index].name),
                                                  onTap: () {
                                                    setState(() => idCity = regionModel.body[index].id);
                                                    setState(() => cityName = regionModel.body[index].name);
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              },
                                              separatorBuilder: (context, index) {
                                                return Divider(
                                                  thickness: 1,
                                                );
                                              },
                                            );
                                          }
                                          return Loader(
                                            color: ColorResources.PRIMARY,
                                          );
                                        },
                                      )
                                    )
                                  ]
                                )
                              ]
                            )
                          )
                        );
                      },
                    );
                  }
                );
              } 
            },
            readOnly: true,
            cursorColor: ColorResources.BLACK,
            controller: cityController,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: cityName == null 
              ? hintText 
              : cityName,
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: poppinsRegular.copyWith(
                color: cityName == null 
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
          ),
        ),
      ],
    ));
  }

  Widget inputFieldSubDistrict(BuildContext context, WarungProvider warungProvider) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text('Kecamatan',
            style: poppinsRegular.copyWith(
              fontSize: 14.0,
            )
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.WHITE,
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
            onTap: warungProvider.createStoreStatus == CreateStoreStatus.loading ? null : () {
              if (idCity == null) {
                Fluttertoast.showToast(
                  msg: "Pilih Kota Anda Terlebih Dahulu",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.black
                );
              } 
              else {  
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return Consumer<WarungProvider>(
                      builder: (BuildContext context, WarungProvider warungProviderChild, Widget child) {
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
                                    padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
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
                                              child: Icon(
                                                Icons.close
                                              )
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 16),
                                              child: Text("Pilih Kecamatan Anda",
                                                style: poppinsRegular.copyWith(
                                                  fontSize: 16.0,
                                                  color: Colors.black
                                                )
                                              )
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 3,
                                  ),
                                  Expanded(
                                  flex: 40,
                                  child: FutureBuilder<RegionSubdistrictModel>(
                                    future: Provider.of<RegionProvider>(context, listen: false).getSubdistrict(context, idCity),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final RegionSubdistrictModel regionModel = snapshot.data;
                                        return ListView.separated(
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: regionModel.body.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(regionModel.body[index].name),
                                              onTap: () {
                                                setState(() {
                                                  idSubDistrictId = regionModel.body[index].id;
                                                  subDistrictName = regionModel.body[index].name;
                                                });
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              thickness: 1,
                                            );
                                          },
                                        );
                                      }
                                      return Loader(
                                        color: ColorResources.PRIMARY,
                                      );
                                    }
                                  )
                                ),
                              ],
                            ),
                          ])
                          )
                        );
                      },
                    );
                  }
                );
              }
            },
            readOnly: true,
            cursorColor: ColorResources.BLACK,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: subDistrictName == null ? "Kecamatan" : subDistrictName,
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: poppinsRegular.copyWith(
                color: subDistrictName == null 
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
          ),
        )
      ],
    );       
  }


}

Widget inputFieldPhoneNumber(BuildContext context, String title, TextEditingController controller, String hintText) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
          child: Text(title,
            style: poppinsRegular.copyWith(
              fontSize: 14.0,
            )
          ),
        ),   
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.WHITE,
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
            readOnly: true,
            cursorColor: ColorResources.BLACK,
            controller: controller,
            keyboardType: TextInputType.text,
            style: poppinsRegular,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: hintText,
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
      ],
    );
  }
  

Widget inputFieldPostCode(BuildContext context, String title, TextEditingController controller, String hintText) {
  return Container(
    width: 150.0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title,
          style: poppinsRegular.copyWith(
            fontSize: 14.0,
          )
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.WHITE,
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
            cursorColor: ColorResources.BLACK,
            controller: controller,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: hintText,
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
        ),
      ],
    ),
  );
}

Widget inputFieldKecamatan(BuildContext context, String title, TextEditingController controller, String hintText) {
  return Column(
    children: [            
      Container(
        alignment: Alignment.centerLeft,
        child: Text(title,
          style: poppinsRegular.copyWith(
            fontSize: 14.0,
          )
        ),
      ),   
      SizedBox(
        height: 10.0,
      ),
        Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorResources.WHITE,
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
          cursorColor: ColorResources.BLACK,
          controller: controller,
          keyboardType: TextInputType.text,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          style: poppinsRegular,
          decoration: InputDecoration(
            hintText: hintText,
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

Widget inputFieldDetailAddress(BuildContext context, String title, TextEditingController controller, String hintText) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text(title,
          style: poppinsRegular.copyWith(
            fontSize: 14.0,
          )
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorResources.WHITE,
          borderRadius: BorderRadius.circular(6.0),
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
          cursorColor: ColorResources.BLACK,
          controller: controller,
          keyboardType: TextInputType.text,
          style: poppinsRegular,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          decoration: InputDecoration(
            hintText: hintText,
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

Widget inputFieldAddress(BuildContext context, WarungProvider warungProvider) {
  return Consumer<LocationProvider>(
    builder: (BuildContext context, LocationProvider locationProvider, Widget child) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder( 
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Alamat",
                          style: poppinsRegular.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.black
                          )
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text("(Berdasarkan pinpoint)",
                          style: poppinsRegular.copyWith(
                            fontSize: 12.0,
                            color: Colors.grey[600]
                          )
                        ),
                      ],
                    ),
                    SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: warungProvider.createStoreStatus == CreateStoreStatus.loading ? null : () =>
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PlacePicker(
                          apiKey: AppConstants.API_KEY_GMAPS,
                          useCurrentLocation: true,
                          onPlacePicked: (result) async {
                            await locationProvider.updateCurrentPosition(context, result); 
                            Navigator.of(context).pop();
                          },
                          autocompleteLanguage: "id",
                          initialPosition: null,
                        )
                      )),
                      child: Text("Ubah Lokasi",
                        style: poppinsRegular.copyWith(
                          fontSize: 12.0,
                          color: ColorResources.PRIMARY
                        )
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 3.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
                child: Text( locationProvider.getCurrentNameAddress == "Location no Selected" 
                  ? "Location no Selected"
                  : locationProvider.getCurrentNameAddress,
                  style: poppinsRegular.copyWith(
                    color: Colors.black,
                    fontSize: 14.0
                  )
                ),
              ),
            ]
          )
        )
      );
    },
  );
}

Widget inputFieldStoreName(BuildContext context, WarungProvider warungProvider,  String title, TextEditingController controller, String hintText) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Nama Toko",
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
          color: ColorResources.WHITE,
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
          readOnly: warungProvider.createStoreStatus == CreateStoreStatus.loading ? true : false,
          cursorColor: ColorResources.BLACK,
          controller: controller,
          keyboardType: TextInputType.text,
          style: poppinsRegular,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          decoration: InputDecoration(
            hintText: hintText,
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
    ],
  );
}

Widget inputFieldCourier(BuildContext context, WarungProvider warungProvider) {
  return Consumer<WarungProvider>(
    builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
      return InkWell(
        onTap: warungProvider.createStoreStatus == CreateStoreStatus.loading ? null : () {
          showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            context: context,
            builder: (BuildContext ctx) {
            return Consumer<WarungProvider>(
              builder: (BuildContext context, WarungProvider warungProviderChild, Widget child) {
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
                            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
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
                                      child: Icon(
                                        Icons.close
                                      )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 16),
                                      child: Text(
                                        "Pilih Jasa Pengiriman"
                                      )
                                    )
                                  ],
                                )),
                                warungProvider.isCheckedKurir.length > 0
                                ? InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
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
                          Expanded(
                            flex: 40,
                            child: ListView.builder(
                              itemCount: warungProviderChild.couriersModelList.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int i) {
                                return CheckboxListTile(
                                  title: Text( warungProviderChild.couriersModelList[i].name),
                                  activeColor: ColorResources.GREEN,
                                  value: warungProviderChild.isCheckedKurir.contains(warungProviderChild.couriersModelList[i].id),
                                  onChanged: (bool val) {   
                                    warungProviderChild.changeCourier(val, warungProviderChild.couriersModelList[i].id);                                                                                 
                                  },
                                );
                              },
                            )
                          )                  
                          ],
                        ),
                      ],
                    )
                  )
                );
              }
            );                 
          },
        );                                            
      },
      child: warungProvider.isCheckedKurir == null || warungProvider.isCheckedKurir.length == 0
        ? Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.WHITE,
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), 
                spreadRadius: 1.0, 
                blurRadius: 3.0, 
                offset: Offset(0.0, 1.0)
              )
            ],
          ),
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                color: Colors.grey.withOpacity(0.5)
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Text("Masukan Jasa Pengiriman",
                    style: poppinsRegular.copyWith(
                      fontSize: 14.0,
                      color: Colors.grey[600]
                    )
                  ),
                ),
              ]
            ),
          )
        )
      : Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorResources.WHITE,
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), 
              spreadRadius: 1.0, 
              blurRadius: 3.0, 
              offset: Offset(0.0, 1.0)
            )
          ],
        ),
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5)
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: warungProvider.isCheckedKurir.map((e) {
            return Container(
              margin: EdgeInsets.only(left: 15.0),
              child: Text(e.toUpperCase(),
                style: poppinsRegular.copyWith(
                  fontSize: 14.0,
                  color: warungProvider.isCheckedKurir.length > 0 
                  ? ColorResources.BLACK
                  : Theme.of(context).hintColor
                )
              ),
            );
          }).toList()),
        )
      ),
    );
  });
}

Widget inputFieldKelurahanDesa(BuildContext context, WarungProvider warungProvider, String title, TextEditingController controller, String hintText) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text(title,
          style: poppinsRegular.copyWith(
            fontSize: 14.0,
          )
        ),
      ),   
      SizedBox(
        height: 10.0,
      ),
        Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorResources.WHITE,
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
          readOnly: warungProvider.createStoreStatus == CreateStoreStatus.loading ? true : false,
          cursorColor: ColorResources.BLACK,
          controller: controller,
          style: poppinsRegular,
          keyboardType: TextInputType.text,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          decoration: InputDecoration(
            hintText: hintText,
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
    ],
  );
}

Widget inputFieldEmailAddress(BuildContext context, String title, TextEditingController controller, String hintText) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text(title,
          style: poppinsRegular.copyWith(
            fontSize: 14.0,
          )
        ),
      ),   
      SizedBox(
        height: 10.0,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorResources.WHITE,
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
          readOnly: true , 
          cursorColor: ColorResources.BLACK,
          controller: controller,
          keyboardType: TextInputType.text,
          style: poppinsRegular,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          decoration: InputDecoration(
            hintText: hintText,
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
    ],
  ); 
}



Widget inputFieldDescriptionStore(BuildContext context, WarungProvider warungProvider, TextEditingController controller) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Deskripsi Toko", 
          style: poppinsRegular.copyWith(
            fontSize: 14.0,
          )
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      InkWell(
        onTap: warungProvider.createStoreStatus == CreateStoreStatus.loading ? null : () {
          showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            context: context,
            builder: (BuildContext context) {
              return Consumer(
                builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
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
                                    controller.text.length > 0
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
                                  controller: controller,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: "Masukan Deskripsi Toko Anda",
                                    hintStyle: poppinsRegular.copyWith(
                                      color: controller.text.length > 0 
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
        child: Container(
          height: 120.0,
          width: double.infinity,
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
          ),
          child: Text(controller.text == '' 
          ? "Masukan Deskripsi Toko Anda" 
          : controller.text,
            style: poppinsRegular.copyWith(
              fontSize: 14.0, 
              color: controller.text.length > 0 
              ? ColorResources.BLACK 
              : Theme.of(context).hintColor
            )
          )
        ),
      ),
    ],
  );             
}