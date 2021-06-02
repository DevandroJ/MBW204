import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:hex/hex.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/data/models/warung/couriers_model.dart';
import 'package:mbw204_club_ina/data/models/warung/region_model.dart';
import 'package:mbw204_club_ina/data/models/warung/seller_store_model.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/providers/region.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/warung/warung_index.dart';

class EditTokoPage extends StatefulWidget {
  final String idStore;
  final String nameStore;
  final String description;
  final String province;
  final String city;
  final String postalCode;
  final String address;
  final List<double> location;
  final List<SupportedCourier> supportedCouriers;
  final Picture picture;
  final bool status;

  EditTokoPage({
    Key key,
    @required this.idStore,
    @required this.nameStore,
    @required this.description,
    @required this.province,
    @required this.city,
    @required this.postalCode,
    @required this.address,
    @required this.location,
    @required this.supportedCouriers,
    @required this.picture,
    @required this.status,
  }) : super(key: key);
  @override
  _EditTokoPageState createState() => _EditTokoPageState();
}

class _EditTokoPageState extends State<EditTokoPage> {
  File f1;
  TextEditingController _namaToko;
  TextEditingController _deskripsi;
  TextEditingController _provinsi;
  TextEditingController _kota;
  TextEditingController _kodePos;
  TextEditingController _detailAlamat;
  final formKey = new GlobalKey<FormState>();
  bool statusToko;

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

  // List<SupportedCourier> isChecked = [];
  // bool isCheck = false;
  List<String> isChecked = [];
  List<double> lokasi = [];
  List<SupportedCourier> supportedCouriers;

  BitmapDescriptor pinLocationIcon;
  Completer<GoogleMapController> mapsController = Completer();
  GoogleMapController _controller;

  final search = TextEditingController();
  static PickResult selectedPlace;

  @override
  void initState() {
    super.initState();
    _namaToko = TextEditingController(text: widget.nameStore);
    _deskripsi = TextEditingController(text: widget.description);
    _provinsi = TextEditingController(text: widget.province);
    _kota = TextEditingController(text: widget.city);
    _kodePos = TextEditingController(text: widget.postalCode);
    _detailAlamat = TextEditingController(text: widget.address);
    statusToko = widget.status;
    for (int i = 0; i < widget.supportedCouriers.length; i++) {
      setState(() {
        isChecked.add(widget.supportedCouriers[i].id);
      });
    }
    for (int j = 0; j < widget.location.length; j++) {
      setState(() {
        lokasi.add(widget.location[j]);
      });
    }
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
    // _getCurrentLocation();
    Timer.periodic(Duration(milliseconds: 3000), (timer) {
      setState(() {
        // return isChecked;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // _getCurrentLocation() {
  //   geolocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
  //       .then((Position position) {
  //     setState(() {
  //       currentPosition = position;
  //       lat = currentPosition.latitude;
  //       long = currentPosition.longitude;
  //     });

  //     _getAddressFromLatLng();
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  _getAddressFromLatLng(double _getLat, double _getLng) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(_getLat, _getLng);
      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  void _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Pilih sumber gambar",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text(
                    "Camera",
                    style: TextStyle(color: ColorResources.PRIMARY),
                  ),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text(
                    "Gallery",
                    style: TextStyle(color: ColorResources.PRIMARY),
                  ),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final file =
          await ImagePicker.pickImage(source: imageSource, maxHeight: 720);
      if (file != null) {
        setState(() => f1 = file);
      }
    }
  }

  Future<bool> onWillPop() {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return JualBeliPage();
    }));
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
    // var alamat = basket['geo-position']['address'];
    if (selectedPlace == null) {
      _getAddressFromLatLng(widget.location[1], widget.location[0]);
    } else {
      _getAddressFromLatLng(selectedPlace.geometry.location.lat,
          selectedPlace.geometry.location.lng);
    }
    var _alamatLengkap =
        selectedPlace == null ? _currentAddress : _currentAddress ?? "";
    if (selectedPlace != null) {
      lokasi.clear();
      setState(() {
        lokasi.add(selectedPlace.geometry.location.lng);
        lokasi.add(selectedPlace.geometry.location.lat);
      });
    }
    
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: ' Mohon Tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Loader(),
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
        selectedPlace = null;
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Ubah Warung",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.orange[700],
          iconTheme: IconThemeData(color: Colors.white),
          leading: GestureDetector(
              onTap: () {
                selectedPlace = null;
                Navigator.pop(context);
              },
              child: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back)),
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
                        Stack(children: [
                          Center(
                            child: Container(
                              width: 120.0,
                              height: 120.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(120),
                                child: f1 == null
                                ? CachedNetworkImage(
                                  imageUrl: widget.picture == null ? "" : AppConstants.BASE_URL_FEED_IMG + widget.picture.path,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Loader(color: ColorResources.PRIMARY),
                                  errorWidget: (context, url, error) => Image.asset("assets/default_toko.jpg"),
                                )
                                : FadeInImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(f1),
                                  placeholder: AssetImage("assets/default_toko.jpg")
                                ),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              )
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 120,
                              height: 120,
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        _pickImage();
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(blurRadius: 5),
                                            ],
                                            color: Colors.orange[700],
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.photo_camera,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Status Toko",
                                style: TextStyle(
                                  fontSize: 18.0,
                                )),
                            FlutterSwitch(
                              showOnOff: true,
                              activeTextColor: Colors.white,
                              inactiveTextColor: Colors.white,
                              activeColor: ColorResources.PRIMARY,
                              width: 90,
                              activeText: "Buka",
                              inactiveText: "Tutup",
                              value: statusToko,
                              onToggle: (val) {
                                setState(() {
                                  statusToko = val;
                                  print(statusToko);
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Text("Nama Toko",
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
                            controller: _namaToko,
                            decoration: new InputDecoration(
                              // labelText: "No Ponsel",
                              hintText: "Masukan Nama Toko",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Nama Toko tidak boleh kosong";
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
                                          ? widget.province
                                          : provinsi,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[600])),
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
                                            msg:
                                                "Pilih provinsi Anda Terlebih Dahulu",
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
                                                    ? widget.city
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
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Kode Pos",
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
                                      controller: _kodePos,
                                      decoration: InputDecoration(
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
                        Text("Pilih Jasa Pengiriman",
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _modalInputan("kurir");
                          },
                          child: isChecked == null || isChecked.length == 0
                              ? Container(
                                  height: 80,
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: isChecked.map((e) {
                                        return Text(e.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 18.0,
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
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            bottom: 8,
                                            top: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text("Alamat",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text("(Berdasarkan pinpoint)",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Colors.grey[600])),
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
                                                            .geometry
                                                            .location
                                                            .lat;
                                                        longitude =
                                                            selectedPlace
                                                                .geometry
                                                                .location
                                                                .lng;
                                                        _getLat = selectedPlace ==
                                                                null
                                                            ? basket[
                                                                    'geo-position']
                                                                ['lat']
                                                            : selectedPlace
                                                                .geometry
                                                                .location
                                                                .lat;
                                                        _getLng = selectedPlace ==
                                                                null
                                                            ? basket[
                                                                    'geo-position']
                                                                ['long']
                                                            : selectedPlace
                                                                .geometry
                                                                .location
                                                                .lng
                                                                .toDouble();
                                                        _getLatLngFromPickers =
                                                            LatLng(_getLat,
                                                                _getLng);
                                                      });
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                    autocompleteLanguage: "id",
                                                    initialPosition: null,
                                                  );
                                                }));
                                              },
                                              child: Text("Ubah Lokasi",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: ColorResources.PRIMARY)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        thickness: 3,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            bottom: 16,
                                            top: 8),
                                        child: Text(_alamatLengkap,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16)),
                                      ),
                                    ]))),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Detail Alamat Warung",
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
                              hintText: "Ex: Jl. Benda Raya",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
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
                            style: new TextStyle(
                              fontFamily: 'Proppins',
                            ),
                          ),
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
                            _modalInputan("Deskripsi");
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
                                      ? "Masukan Deskripsi Warung Anda"
                                      : _deskripsi.text,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey[600]))),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: 55,
                          width: double.infinity,
                          child: RaisedButton(
                              color: _namaToko.text == '' ||
                                      _provinsi.text == '' ||
                                      _kota.text == '' ||
                                      _kodePos.text == '' ||
                                      _alamatLengkap == null
                                  ? Colors.grey[350]
                                  : Colors.orange[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text("Simpan",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              ),
                              onPressed: _namaToko.text == '' ||
                                      _provinsi.text == '' ||
                                      _kota.text == '' ||
                                      _kodePos.text == '' ||
                                      _alamatLengkap == null
                                  ? () {
                                      // print(isChecked);
                                      Fluttertoast.showToast(
                                          msg:
                                              "Terjadi kesalahan, Lengkapi data",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white);
                                    }
                                  : () async {
                                      print(lokasi);
                                      pr.show();
                                      final form = formKey.currentState;
                                      if (form.validate()) {
                                        form.save();
                                        if (f1 != null) {
                                          String body =
                                              await warungVM.getMediaKeyMedia(context);
                                          File file = File(f1.path);
                                          Uint8List bytes =
                                              f1.readAsBytesSync();
                                          String digestFile =
                                              sha256.convert(bytes).toString();
                                          String imageHash = base64Url
                                              .encode(HEX.decode(digestFile));
                                          warungVM
                                              .uploadImageProduct(
                                                context,
                                                body,
                                                imageHash,
                                                widget.idStore,
                                                file
                                              )
                                              .then((res) {
                                            print(res);
                                          });
                                          await warungVM
                                              .postEditDataStore(
                                                context,
                                                  widget.idStore,
                                                _namaToko.text,
                                                provinsi == null
                                                    ? widget.province
                                                    : provinsi,
                                                nameKota == null
                                                    ? widget.city
                                                    : nameKota,
                                                _kodePos.text,
                                                _detailAlamat.text,
                                                _deskripsi.text,
                                                statusToko,
                                                isChecked,
                                                lokasi,
                                                f1
                                              )
                                              .then((value) {
                                            if (value.code == 0) {
                                              selectedPlace = null;
                                              pr.hide();
                                              Fluttertoast.showToast(
                                                  msg: "Ubah Warung Sukses",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      ColorResources.PRIMARY,
                                                  textColor: Colors.white);
                                              Navigator.pushNamed(
                                                  context, '/beranda-toko');
                                            } else {
                                              pr.hide();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Terjadi Kesalahan, Periksa Kembali Data",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white);
                                            }
                                          });
                                        } else {
                                          await warungVM
                                              .postEditDataStore(
                                                  context,
                                                  widget.idStore,
                                                  _namaToko.text,
                                                  provinsi == null
                                                      ? widget.province
                                                      : provinsi,
                                                  nameKota == null
                                                      ? widget.city
                                                      : nameKota,
                                                  _kodePos.text,
                                                  _alamatLengkap,
                                                  _deskripsi.text,
                                                  statusToko,
                                                  isChecked,
                                                  lokasi)
                                              .then((value) {
                                            if (value.code == 0) {
                                              selectedPlace = null;
                                              pr.hide();
                                              Fluttertoast.showToast(
                                                  msg: "Ubah Warung Sukses",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      ColorResources.PRIMARY,
                                                  textColor: Colors.white);
                                              Navigator.pushNamed(
                                                  context, '/beranda-toko');
                                            } else {
                                              pr.hide();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Terjadi Kesalahan, Periksa Kembali Data",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
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
                    )))
          ],
        ),
      ),
    );
  }

  // _getAddress() {
  //   final alamat = basket['geo-position']['address'];
  //   final _alamatLengkap =
  //       selectedPlace == null ? alamat : selectedPlace.formattedAddress ?? "";
  //   print(_alamatLengkap);

  //   if (_alamatLengkap != null) {
  //     return Text(_alamatLengkap,
  //         style: TextStyle(color: Colors.black, fontSize: 16));
  //   } else {
  //     return Text("Sedang mencari lokasi...",
  //         style: TextStyle(color: Colors.black, fontSize: 16));
  //   }
  // }

  _modalInputan(String typeInput) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  isChecked.length > 0
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
                                        left: 16,
                                        right: 16,
                                        top: 8,
                                        bottom: 16),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: new TextFormField(
                                      controller: _deskripsi,
                                      autocorrect: true,
                                      autofocus: true,
                                      maxLines: null,
                                      decoration: new InputDecoration(
                                        hintText:
                                            "Masukan Deskripsi Warung Anda",
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
                                      style: new TextStyle(
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
                                              final CouriersModel
                                                  couriersModel = snapshot.data;
                                              return ListView(
                                                shrinkWrap: true,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  ...couriersModel.body
                                                      .map((item) =>
                                                          CheckboxListTile(
                                                            title:
                                                                Text(item.name),
                                                            value: isChecked
                                                                .contains(
                                                                    item.id),
                                                            onChanged:
                                                                (bool value) {
                                                              if (value) {
                                                                setState(() {
                                                                  isChecked.add(
                                                                      item.id);
                                                                  print(
                                                                      isChecked);
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  isChecked
                                                                      .remove(item
                                                                          .id);
                                                                  print(
                                                                      isChecked);
                                                                });
                                                              }
                                                            },
                                                          ))
                                                      .toList()
                                                ],
                                              );
                                            }
                                            return Center(
                                              child: Loader(
                                                color: ColorResources.PRIMARY,
                                              )
                                            );
                                          },
                                        ))
                                    : typeInput == "city"
                                        ? Expanded(
                                            flex: 40,
                                            child: FutureBuilder<RegionModel>(
                                              future: Provider.of<RegionProvider>(context, listen: false)
                                                  .getCity(context, idProvince),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  final RegionModel
                                                      regionModel =
                                                      snapshot.data;
                                                  return ListView.separated(
                                                    shrinkWrap: true,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        regionModel.body.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return ListTile(
                                                        title: Text(regionModel
                                                            .body[index].name),
                                                        onTap: () {
                                                          setState(() {
                                                            nameKota =
                                                                regionModel
                                                                    .body[index]
                                                                    .name;
                                                          });
                                                          Navigator.pop(
                                                              context);
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
                                              },
                                            ))
                                        : Expanded(
                                            flex: 40,
                                            child: FutureBuilder<RegionModel>(
                                              future: Provider.of<RegionProvider>(context, listen: false).getRegion(context, typeInput),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  final RegionModel
                                                      regionModel =
                                                      snapshot.data;
                                                  return ListView.separated(
                                                    shrinkWrap: true,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        regionModel.body.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return ListTile(
                                                        title: Text(regionModel
                                                            .body[index].name),
                                                        onTap: () {
                                                          setState(() {
                                                            idProvince =
                                                                regionModel
                                                                    .body[index]
                                                                    .id;
                                                            provinsi =
                                                                regionModel
                                                                    .body[index]
                                                                    .name;
                                                            nameKota = null;
                                                          });
                                                          Navigator.pop(
                                                              context);
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
                                                  color: ColorResources.PRIMARY
                                                );
                                              },
                                            )
                                          ),
                          ],
                        ),
                      ],
                    )));
          },
        );
      },
    );
  }
}
