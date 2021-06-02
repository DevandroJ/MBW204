import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/data/models/warung/region_model.dart';
import 'package:mbw204_club_ina/data/models/warung/region_subdistrict_model.dart';
import 'package:mbw204_club_ina/providers/region.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';

class TambahAlamatPage extends StatefulWidget {
  @override
  _TambahAlamatPageState createState() => _TambahAlamatPageState();
}

class _TambahAlamatPageState extends State<TambahAlamatPage> {
  final _detailAlamat = TextEditingController();
  final _typeAlamat = TextEditingController();
  final _noPonsel = TextEditingController();
  final _kodePos = TextEditingController();
  final formKey = new GlobalKey<FormState>();

  final Geolocator geolocator = Geolocator();
  Map<String, dynamic> basket;
  LatLng posisi;
  String userId;
  String idx;
  double latitude = -6.1966192;
  double longitude = 106.7635515;
  String _currentAddress;
  String provinsi;
  String nameKota;
  String idProvince;
  String idCity;
  String nameKecamatan;
  List<double> lokasi = [];

  BitmapDescriptor pinLocationIcon;
  Completer<GoogleMapController> mapsController = Completer();
  GoogleMapController controller;
  static PickResult selectedPlace;

  bool isCheck = true;
  bool _isLoading = true;
  List<String> typeTempat = ['Rumah', 'Kantor', 'Apartement', 'Kos'];

  @override
  void initState() {
    super.initState();
    _detailAlamat.addListener(() {
      setState(() {});
    });
    _typeAlamat.addListener(() {
      setState(() {});
    });
    _noPonsel.addListener(() {
      setState(() {});
    });
    _kodePos.addListener(() {
      setState(() {});
    });
  }

  _getAddressFromLatLng(double _getLat, double _getLng) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(_getLat, _getLng);
      Placemark place = p[0];
      setState(() =>  _currentAddress ="${place.locality}, ${place.administrativeArea}, ${place.country}");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    basket = Provider.of(context, listen: false);
    final _getLocations =
        LatLng(basket['geo-position']['lat'], basket['geo-position']['long']);
    double _getLat = selectedPlace == null
        ? basket['geo-position']['lat']
        : selectedPlace.geometry.location.lat;
    double _getLng = selectedPlace == null
        ? basket['geo-position']['long']
        : selectedPlace.geometry.location.lng;
    LatLng _getLatLngFromPickers = LatLng(_getLat, _getLng);
    LatLng _posisiSaatini =
        selectedPlace != null ? _getLatLngFromPickers : _getLocations;
    List<Marker> markers = [];
    markers.add(Marker(
      markerId: MarkerId("1"),
      position: _posisiSaatini,
      icon: BitmapDescriptor.defaultMarker,
    ));
    var alamat = basket['geo-position']['addressView'];
    if (selectedPlace != null) {
      _getAddressFromLatLng(selectedPlace.geometry.location.lat,
          selectedPlace.geometry.location.lng);
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
     
    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
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
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Tambah Alamat Baru",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: ColorResources.PRIMARY,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
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
                  Container(
                      width: double.infinity,
                      child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 16, right: 16, bottom: 8, top: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Alamat",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("(Berdasarkan pinpoint)",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600])),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return PlacePicker(
                                              apiKey: AppConstants.API_KEY_GMAPS,
                                              useCurrentLocation: true,
                                              onPlacePicked: (result) {
                                                setState(() {
                                                  selectedPlace = result;
                                                  latitude = selectedPlace
                                                      .geometry.location.lat;
                                                  longitude = selectedPlace
                                                      .geometry.location.lng;
                                                  _getLat = selectedPlace ==
                                                          null
                                                      ? basket['geo-position']
                                                          ['lat']
                                                      : selectedPlace.geometry
                                                          .location.lat;
                                                  _getLng = selectedPlace ==
                                                          null
                                                      ? basket['geo-position']
                                                          ['long']
                                                      : selectedPlace
                                                          .geometry.location.lng
                                                          .toDouble();
                                                  _getLatLngFromPickers =
                                                      LatLng(_getLat, _getLng);
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
                                            fontSize: 14,
                                            color: Colors.orange[700]
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
                                  padding: EdgeInsets.only(
                                      left: 16, right: 16, bottom: 16, top: 8),
                                  child: Text(
                                      _alamatLengkap == null
                                          ? "Sedang mencari lokasi..."
                                          : _alamatLengkap,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14)),
                                ),
                              ]))),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Detail Alamat",
                      style: TextStyle(
                        fontSize: 16.0,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // color: Colors.white,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: new TextFormField(
                      controller: _detailAlamat,
                      decoration: new InputDecoration(
                        // labelText: "No Ponsel",
                        hintText: "Tulis detail alamat Anda",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Detail alamat tidak boleh kosong";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      maxLength: null,
                      maxLines: null,
                      style: new TextStyle(
                        fontFamily: 'Proppins',
                      ),
                    ),
                  ),
                  Container(),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Lokasi Alamat",
                      style: TextStyle(
                        fontSize: 16.0,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // color: Colors.white,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: new TextFormField(
                      controller: _typeAlamat,
                      onTap: () {
                        setState(() {
                          isCheck = false;
                        });
                      },
                      decoration: new InputDecoration(
                        // labelText: "No Ponsel",
                        hintText: "Ex: Rumah",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Lokasi Alamat tidak boleh kosong";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        fontFamily: 'Proppins',
                      ),
                    ),
                  ),
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
                                            _typeAlamat.text = e;
                                            isCheck = true;
                                          });
                                        },
                                        child: Container(
                                            height: 20,
                                            padding: EdgeInsets.all(8),
                                            margin: EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey[350])),
                                            child: Center(
                                                child: Text(e,
                                                    style: new TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    )))),
                                      ))
                                  .toList()
                            ],
                          )),
                  Text("Provinsi",
                      style: TextStyle(
                        fontSize: 18.0,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _modalInputan("province");
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                provinsi == null
                                    ? "Masukan Provinsi Anda"
                                    : provinsi,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey[600])),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Kota",
                      style: TextStyle(
                        fontSize: 18.0,
                      )),
                  SizedBox(
                    height: 10,
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
                            textColor: Colors.white);
                      } else {
                        _modalInputan("city");
                      }
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                nameKota == null
                                    ? "Masukan Kota Anda"
                                    : nameKota,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey[600])),
                          ],
                        )),
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
                            Text("Kecamatan",
                                style: TextStyle(
                                  fontSize: 18.0,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (idCity == null) {
                                  Fluttertoast.showToast(
                                      msg: "Pilih Kota Anda Terlebih Dahulu",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white);
                                } else {
                                  _modalInputan("subdistrict");
                                }
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          nameKecamatan == null
                                              ? "Masukan Kecamatan Anda"
                                              : nameKecamatan,
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
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Kode Pos",
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
                              child: new TextFormField(
                                controller: _kodePos,
                                decoration: new InputDecoration(
                                  // labelText: "No Ponsel",
                                  hintText: "Kode Pos",
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  //fillColor: Colors.green
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
                                style: new TextStyle(
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
                  Text("No Ponsel",
                      style: TextStyle(
                        fontSize: 16.0,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // color: Colors.white,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: new TextFormField(
                      controller: _noPonsel,
                      decoration: new InputDecoration(
                        // labelText: "No Ponsel",
                        hintText: "Isi No Ponsel Anda",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "No Ponsel tidak boleh kosong";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      style: new TextStyle(
                        fontFamily: 'Proppins',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: RaisedButton(
                        color: lokasi.length == 0 ||
                                _detailAlamat.text == '' ||
                                _typeAlamat.text == '' ||
                                provinsi == null ||
                                nameKota == null ||
                                nameKecamatan == null ||
                                _kodePos.text == '' ||
                                _noPonsel.text == ''
                            ? Colors.grey[350]
                            : Colors.orange[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("Simpan",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                        onPressed: () async {
                          if (lokasi.length == 0 ||
                              _detailAlamat.text == '' ||
                              _typeAlamat.text == '' ||
                              provinsi == null ||
                              nameKota == null ||
                              nameKecamatan == null ||
                              _kodePos.text == '' ||
                              _noPonsel.text == '') {
                            Fluttertoast.showToast(
                                msg: "Terjadi kesalahan, Lengkapi data",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.black);
                          } else {
                            pr.show();
                            final form = formKey.currentState;
                            if (form.validate()) {
                              await Provider.of<RegionProvider>(context, listen: false)
                                  .postDataAddress(
                                      context,
                                      _typeAlamat.text,
                                      _noPonsel.text,
                                      _detailAlamat.text,
                                      provinsi,
                                      nameKota,
                                      _kodePos.text,
                                      nameKecamatan,
                                      lokasi)
                                  .then((value) {
                                if (value.code == 0) {
                                  selectedPlace = null;
                                  pr.hide();
                                  Fluttertoast.showToast(
                                      msg: "Tambah Alamat Sukses",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.orange[700],
                                      textColor: Colors.white);
                                  Navigator.pop(context, true);
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
                        },
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _modalInputan(String typeInput) {
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
            // margin: EdgeInsets.only(top: 24),
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
                                  child: Text(
                                      typeInput == "city"
                                          ? "Pilih Kota Anda"
                                          : typeInput == "province"
                                              ? "Pilih Provinsi Anda"
                                              : typeInput == "subdistrict"
                                                  ? "Pilih Kecamatan Anda"
                                                  : "Masukan $typeInput",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black))),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 3,
                        ),
                        typeInput == "subdistrict"
                            ? Expanded(
                                flex: 40,
                                child: FutureBuilder<RegionSubdistrictModel>(
                                  future: Provider.of<RegionProvider>(context, listen: false).getSubdistrict(context, idCity),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final RegionSubdistrictModel
                                          regionSubdistrictModel =
                                          snapshot.data;
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount:
                                            regionSubdistrictModel.body.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(regionSubdistrictModel
                                                .body[index].name),
                                            onTap: () {
                                              setState(() {
                                                nameKecamatan =
                                                    regionSubdistrictModel
                                                        .body[index].name;
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
                                  },
                                ))
                            : typeInput == "city"
                                ? Expanded(
                                    flex: 40,
                                    child: FutureBuilder<RegionModel>(
                                      future: Provider.of<RegionProvider>(context, listen: false).getCity(context, idProvince),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final RegionModel regionModel =
                                              snapshot.data;
                                          return ListView.separated(
                                            shrinkWrap: true,
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemCount: regionModel.body.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(regionModel
                                                    .body[index].name),
                                                onTap: () {
                                                  setState(() {
                                                    idCity = regionModel
                                                        .body[index].id;
                                                    nameKota = regionModel
                                                        .body[index].name;
                                                    nameKecamatan = null;
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
                                      },
                                    ))
                                : Expanded(
                                    flex: 40,
                                    child: FutureBuilder<RegionModel>(
                                      future: Provider.of<RegionProvider>(context, listen: false).getRegion(context, typeInput),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final RegionModel regionModel =
                                              snapshot.data;
                                          return ListView.separated(
                                            shrinkWrap: true,
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemCount: regionModel.body.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(regionModel
                                                    .body[index].name),
                                                onTap: () {
                                                  setState(() {
                                                    idProvince = regionModel
                                                        .body[index].id;
                                                    provinsi = regionModel
                                                        .body[index].name;
                                                    nameKota = null;
                                                    nameKecamatan = null;
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
                                      },
                                    )),
                      ],
                    ),
                  ],
                )));
      },
    );
  }
}
