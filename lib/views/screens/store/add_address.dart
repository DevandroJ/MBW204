import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';


import 'package:mbw204_club_ina/data/models/warung/region_subdistrict_model.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/maps/src/place_picker.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/location.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/models/warung/region_model.dart';
import 'package:mbw204_club_ina/providers/region.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';

class TambahAlamatPage extends StatefulWidget {
  @override
  _TambahAlamatPageState createState() => _TambahAlamatPageState();
}

class _TambahAlamatPageState extends State<TambahAlamatPage> {
  TextEditingController detailAddressController = TextEditingController();
  TextEditingController typeAddressController = TextEditingController();
  TextEditingController subDistrictController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController villageController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String province;
  String cityName;
  String idCity;
  String idSubDistrictId;
  String subDistrictName;
  String idProvince;
  
  bool isCheck = true;
  List<String> typeTempat = ['Rumah', 'Kantor', 'Apartement', 'Kos'];

  @override
  void initState() {
    super.initState();
    phoneController.text = Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber ??  "";
  
    typeAddressController.addListener(() {
      setState(() {});
    });
  }

  Future submit() async {
    try {
      if(detailAddressController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          msg: "Detail Alamat tidak boleh kosong",
          fontSize: 14.0,
        );
        return;
      }
      if(typeAddressController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          msg: "Label Alamat tidak boleh kosong",
          fontSize: 14.0,
        );
        return;
      }
      if(province == null || province == "") {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          msg: "Provinsi tidak boleh kosong",
          fontSize: 14.0,
        );
        return;
      }
      if(cityName == null || cityName == "") {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          msg: "Kota tidak boleh kosong",
          fontSize: 14.0,
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
      if(subDistrictName == null || subDistrictName.isEmpty){
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          msg: "Kecamatan tidak boleh kosong",
          fontSize: 14.0,
        );
        return;
      }
      if(villageController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          msg: "Kelurahan / Desa tidak boleh kosong",
          fontSize: 14.0,
        );
        return;
      }
      await Provider.of<RegionProvider>(context, listen: false).postDataAddress(
        context, 
        typeAddressController.text, 
        detailAddressController.text, 
        province, 
        cityName, 
        subDistrictName,
        villageController.text, 
        postCodeController.text, 
      );
    } catch(e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Tambah Alamat Baru",
          style: poppinsRegular,
        ),
        backgroundColor: ColorResources.PRIMARY,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
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
                  inputFieldAddress(context),
                  SizedBox(
                    height: 15.0,
                  ),
                  inputFieldDetailAddress(context, "Detail Alamat", detailAddressController, "Detail Alamat"),
                  SizedBox(
                    height: 15.0,
                  ),
                  inputFieldLocationAddress(context),
                  SizedBox(
                    height: 15,
                  ),
                  isCheck
                  ? Container()
                  : Container(
                      height: 35,
                      margin: EdgeInsets.only(bottom: 15),
                      child: ListView(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...typeTempat
                            .map((e) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  typeAddressController.text = e;
                                  isCheck = true;
                                });
                              },
                              child: Container(
                                height: 20,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey[350]
                                  )
                                ),
                                child: Center(
                                  child: Text(e,
                                    style: poppinsRegular.copyWith(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    )
                                  )
                                )
                              ),
                          )).toList()
                        ],
                      )
                    ),

                  inputFieldProvince(context, "Provinsi", "Provinsi"),
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
                  inputFieldSubDistrict(context),
                  SizedBox(height: 15.0),
                  inputFieldKelurahanDesa(context, "Kelurahan / Desa", villageController, "Kelurahan / Desa"),
                  SizedBox(height: 15.0),
                  inputFieldPhoneNumber(context, "Nomor HP", phoneController, "Nomor HP"),
                  SizedBox(height: 25.0),
                  SizedBox(
                    height: 55.0,
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: ColorResources.PRIMARY,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text("Simpan",
                          style: poppinsRegular.copyWith(
                            fontSize: 14.0, 
                            color: Colors.white
                          )
                        ),
                      ),
                      onPressed: submit,   
                    )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  

  Widget inputFieldProvince(BuildContext context, String title, String hintText) {
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
            onTap: () {
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

  Widget inputFieldSubDistrict(BuildContext context) {
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
            onTap: () {
               if (idCity == null) {
                Fluttertoast.showToast(
                  msg: "Pilih Kota Anda Terlebih Dahulu",
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
                                      thickness: 3,
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

  Widget inputFieldLocationAddress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Label Alamat",
          style: poppinsRegular.copyWith(
            fontSize: 14.0,
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
          child:   Container(
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
              onTap: () {
              setState(() {
                  isCheck = false;
                });
              },
              cursorColor: ColorResources.BLACK,
              controller: typeAddressController,
              keyboardType: TextInputType.text,
              style: poppinsRegular,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
              decoration: InputDecoration(
                hintText: "Ex: Rumah",
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
        )
      ],
    );
  }

}

Widget inputFieldKelurahanDesa(BuildContext context, String title, TextEditingController controller, String hintText) {
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

Widget inputFieldAddress(BuildContext context) {
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
                            fontSize: 14.0,
                            color: Colors.grey[600]
                          )
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () =>
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
                          fontSize: 14.0,
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
                  ? getTranslated("LOCATION_NO_SELECTED", context) 
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