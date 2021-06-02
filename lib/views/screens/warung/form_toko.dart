import 'dart:async';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/models/warung/couriers_model.dart';
import 'package:mbw204_club_ina/data/models/warung/region_model.dart';
import 'package:mbw204_club_ina/providers/region.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';

class FormTokoPage extends StatefulWidget {
  @override
  _FormTokoPageState createState() => _FormTokoPageState();
}

class _FormTokoPageState extends State<FormTokoPage> {
  File f1;
  final _namaToko = TextEditingController();
  final _deskripsi = TextEditingController();
  final _provinsi = TextEditingController();
  final _kota = TextEditingController();
  final _kodePos = TextEditingController();
  final _detailAlamat = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final Geolocator geolocator = Geolocator();
  Position currentPosition;
  double lat = 0;
  double long = 0;
  Map<String, dynamic> basket;
  LatLng posisi;
  String userId;
  String idx;
  double latitude = -6.1966192;
  double longitude = 106.7635515;
  String _currentAddress;
  String idProvince;
  String provinsi;
  String nameKota;

  BitmapDescriptor pinLocationIcon;
  Completer<GoogleMapController> mapsController = Completer();
  GoogleMapController controller;

  final search = TextEditingController();
  static PickResult selectedPlace;

  List<String> isCheckedKurir = [];
  List<double> lokasi = [];

  @override
  void initState() {
    super.initState();
    _namaToko.addListener(() {
      setState(() {});
    });
    _deskripsi.addListener(() {
      setState(() {});
    });
    _provinsi.addListener(() {
      setState(() {});
    });
    _kota.addListener(() {
      setState(() {});
    });
    _kodePos.addListener(() {
      setState(() {});
    });
    _detailAlamat.addListener(() {
      setState(() {});
    });
  }

  _getAddressFromLatLng(double _getLat, double _getLng) async {
    try {
      List<Placemark> p =  await placemarkFromCoordinates(_getLat, _getLng);
      Placemark place = p[0];
      setState(() => _currentAddress = "${place.locality}, ${place.administrativeArea}, ${place.country}" );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    basket = Provider.of(context, listen: false);
    final _getLocations = LatLng(basket['geo-position']['lat'], basket['geo-position']['long']);
    double _getLat = selectedPlace == null ? basket['geo-position']['lat'] : selectedPlace.geometry.location.lat;
    double _getLng = selectedPlace == null ? basket['geo-position']['long'] : selectedPlace.geometry.location.lng;
    LatLng _getLatLngFromPickers = LatLng(_getLat, _getLng);
    LatLng _posisiSaatini = selectedPlace != null ? _getLatLngFromPickers : _getLocations;
    List<Marker> markers = [];
    markers.add(Marker(
      markerId: MarkerId("1"),
      position: _posisiSaatini,
      icon: BitmapDescriptor.defaultMarker,
    ));
    var alamat = basket['geo-position']['addressView'];
    if (selectedPlace != null) {
      _getAddressFromLatLng(selectedPlace.geometry.location.lat, selectedPlace.geometry.location.lng);
    }
    var _alamatLengkap = selectedPlace == null ? alamat : _currentAddress ?? "";
    if (selectedPlace == null) {
      lokasi.clear();
      setState(() {
        lokasi.add(basket['geo-position']['long']);
        lokasi.add(basket['geo-position']['lat']);
      });
    } else {
      lokasi.clear();
      setState(() {
        lokasi.add(selectedPlace.geometry.location.lng);
        lokasi.add(selectedPlace.geometry.location.lat);
      });
    }
    
    ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorResources.WHITE,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20.0,
            color: ColorResources.GREY,
          ),
          onPressed: () => Navigator.of(context).pop()
        ),
        centerTitle: true,
        elevation: 0,
        title: Text( "Form Warung"),
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
                  Text("Nama Toko",
                    style: TextStyle(
                      fontSize: 16.0,
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
                      controller: _namaToko,
                      decoration: InputDecoration(
                        hintText: "Masukan Nama Toko",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(),
                        ),
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Nama Toko tidak boleh kosong";
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
                  Text("Provinsi",
                      style: TextStyle(
                        fontSize: 16.0,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _modalInputan("province");
                    },
                    child: Container(
                      height: 60.0,
                      width: double.infinity,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                        color: Colors.grey[100]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(provinsi == null ? "Masukan Provinsi Anda" : provinsi,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[600]
                            )
                          ),
                        ],
                      )
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
                                Text("Kota", 
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  )
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                GestureDetector(
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
                                      _modalInputan("city");
                                    }
                                  },
                                  child: Container(
                                      height: 60,
                                      width: double.infinity,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.grey),
                                          color: Colors.grey[100]),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              nameKota == null
                                                  ? "Masukan Kota Anda"
                                                  : nameKota,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.grey[600])),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Kode Pos",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child:  TextFormField(
                                    controller: _kodePos,
                                    decoration:  InputDecoration(
                                      hintText: "Kode Pos",
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(),
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return "Kode Pos tidak boleh kosong";
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
                      Row(
                        children: [
                          Text("Pilih Jasa Pengiriman",
                            style: TextStyle(
                              fontSize: 16.0, 
                              color: Colors.black
                            )
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: Text("(Minimal 1 Jasa Pengiriman)",
                              style: TextStyle(
                                fontSize: 14.0, 
                                color: Colors.grey[600]
                              )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          _modalInputan("kurir");
                        },
                        child: isCheckedKurir == null || isCheckedKurir.length == 0
                            ? Container(
                                height: 60,
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.grey[100]),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Masukan Jasa Pengiriman",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey[600])),
                                    ]))
                            : Container(
                                // height: 80,
                                width: double.infinity,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.grey[100]),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: isCheckedKurir.map((e) {
                                      return Text(e.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey[600]));
                                    }).toList())),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    Container(
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
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.black
                                          )
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text("(Berdasarkan pinpoint)",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey[600]
                                          )
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                          return PlacePicker(
                                            apiKey: AppConstants.API_KEY_GMAPS,
                                            useCurrentLocation: true,
                                            onPlacePicked: (result) {
                                              setState(() {
                                                selectedPlace = result;
                                                latitude = selectedPlace.geometry.location.lat;
                                                longitude = selectedPlace.geometry.location.lng;
                                                _getLat = selectedPlace == null ? basket['geo-position']['lat'] : selectedPlace.geometry.location.lat;
                                                _getLng = selectedPlace == null ? basket['geo-position']['long'] : selectedPlace.geometry.location.lng;
                                                _getLatLngFromPickers = LatLng( _getLat, _getLng);
                                              });
                                              Navigator.pop(context, true);
                                            },
                                            autocompleteLanguage: "id",
                                            initialPosition: null,
                                          );
                                        }));
                                      },
                                      child: Text("Ubah Lokasi",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: ColorResources.PRIMARY
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 3,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
                                child: Text(_alamatLengkap == null ? "Sedang mencari lokasi..." : _alamatLengkap,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0
                                  )
                                ),
                              ),
                            ]
                          )
                        )
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Detail Alamat Warung",
                        style: TextStyle(
                          fontSize: 16.0,
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
                          controller: _detailAlamat,
                          decoration: InputDecoration(
                            hintText: "Ex: Jl. Benda Raya",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(),
                            ),
                          ),
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Detail alamat warung tidak boleh kosong";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.multiline,
                          maxLength: null,
                          maxLines: null,
                          style: TextStyle(
                            fontFamily: 'Proppins',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text("Deskripsi", 
                        style: TextStyle(
                          fontSize: 16.0,
                        )
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          _modalInputan("Deskripsi");
                        },
                        child: Container(
                          height: 120.0,
                          width: double.infinity,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey),
                            color: Colors.grey[100]
                          ),
                          child: Text( _deskripsi.text == '' ? "Masukan Deskripsi Warung Anda" : _deskripsi.text,
                            style: TextStyle(
                              fontSize: 16.0, color: Colors.grey[600]
                            )
                          )
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: RaisedButton(
                            color: _namaToko.text == '' ||
                                    provinsi == null ||
                                    nameKota == null ||
                                    _kodePos.text == '' ||
                                    lokasi.length == 0 ||
                                    isCheckedKurir.length == 0 ||
                                    _detailAlamat.text == ''
                                ? Colors.grey[350]
                                : ColorResources.PRIMARY,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text("Submit",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            ),
                            onPressed: _namaToko.text == '' ||
                                    provinsi == null ||
                                    nameKota == null ||
                                    _kodePos.text == '' ||
                                    lokasi.length == 0 ||
                                    isCheckedKurir.length == 0 ||
                                    _detailAlamat.text == ''
                                ? () {
                                    Fluttertoast.showToast(
                                        msg: "Terjadi kesalahan, Lengkapi data",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.black);
                                  }
                                : () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    pr.show();
                                    final form = formKey.currentState;
                                    if (form.validate()) {
                                      form.save();
                                      if (_deskripsi.text == '') {
                                        await Provider.of<WarungProvider>(context, listen: false).postCreateDataStore(context, _namaToko.text, provinsi, nameKota, _kodePos.text, _detailAlamat.text, isCheckedKurir, lokasi, _deskripsi.text).then((value) {
                                          if (value.code == 0) {
                                            selectedPlace = null;
                                            pr.hide();
                                            prefs.setBool("haveWarung", true);
                                            Fluttertoast.showToast(
                                              msg: "Buat Warung Sukses",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green[300],
                                              textColor: Colors.white
                                            );
                                            Navigator.pushNamed(context, '/');
                                          } else {
                                            pr.hide();
                                            Fluttertoast.showToast(
                                              msg: "Terjadi Kesalahan, Periksa Kembali Data",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red[300],
                                              textColor: Colors.white
                                            );
                                          }
                                        });
                                      } else {
                                        await Provider.of<WarungProvider>(context, listen: false).postCreateDataStore(context, _namaToko.text, provinsi, nameKota, _kodePos.text, _detailAlamat.text, isCheckedKurir, lokasi).then((value) {
                                          if (value.code == 0) {
                                            selectedPlace = null;
                                            pr.hide();
                                            prefs.setBool("haveWarung", true);
                                            Fluttertoast.showToast(
                                              msg: "Buat Warung Sukses",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green[300],
                                              textColor: Colors.white
                                            );
                                            Navigator.pushNamed(context, '/');
                                          } else {
                                            pr.hide();
                                            Fluttertoast.showToast(
                                              msg: "Terjadi Kesalahan, Periksa Kembali Data",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red[300],
                                              textColor: Colors.white
                                            );
                                          }
                                        });
                                      }
                                    }
                                  }),
                      )
                    ],
                  )))
        ],
      ),
    );
  }
  _modalInputan(String typeInput) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
                                        child: Text(
                                            typeInput == "city"
                                                ? "Pilih Kota Anda"
                                                : typeInput == "province"
                                                    ? "Pilih Provinsi Anda"
                                                    : typeInput == "kurir"
                                                        ? "Pilih Jasa Pengiriman"
                                                        : "Masukan $typeInput",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black))),
                                  ],
                                )),
                                isCheckedKurir.length > 0 ||
                                        _deskripsi.text.length > 0
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Icon(Icons.done,
                                            color: ColorResources.PRIMARY))
                                    : Container(),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 3,
                          ),
                          typeInput == "Deskripsi"
                              ? Container(
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
                                      hintText: "Masukan Deskripsi Warung Anda",
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
                                )
                              : typeInput == "kurir"
                                  ? Expanded(
                                      flex: 40,
                                      child: FutureBuilder<CouriersModel>(
                                        future: Provider.of<RegionProvider>(context, listen: false).getDataCouriers(context),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final CouriersModel couriersModel =
                                                snapshot.data;
                                            return ListView(
                                              shrinkWrap: true,
                                              physics: BouncingScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              children: [
                                                ...couriersModel.body
                                                    .map((item) =>
                                                        CheckboxListTile(
                                                          title:
                                                              Text(item.name),
                                                          value: isCheckedKurir
                                                              .contains(
                                                                  item.id),
                                                          onChanged:
                                                              (bool value) {
                                                            if (value) {
                                                              setState(() {
                                                                isCheckedKurir
                                                                    .add(item
                                                                        .id);
                                                                print(
                                                                    isCheckedKurir);
                                                              });
                                                            } else {
                                                              setState(() {
                                                                isCheckedKurir
                                                                    .remove(item
                                                                        .id);
                                                                print(
                                                                    isCheckedKurir);
                                                              });
                                                            }
                                                          },
                                                        ))
                                                    .toList()
                                              ],
                                            );
                                          }
                                          return Loader(
                                            color: ColorResources.PRIMARY,
                                          );
                                        },
                                      )
                                    )
                                  : typeInput == "city"
                                      ? Expanded(
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
                                                        setState(() => nameKota = regionModel.body[index].name);
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
                                      : Expanded(
                                        flex: 40,
                                        child: FutureBuilder<RegionModel>(
                                          future: Provider.of<RegionProvider>(context, listen: false).getRegion(context, typeInput),
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
                                                        provinsi = regionModel.body[index].name;
                                                        nameKota = null;
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
                  ],
                )
              )
            );
          }
        );
      },
    );
  }
}
