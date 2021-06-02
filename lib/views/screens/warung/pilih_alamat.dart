import 'dart:io';

import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/providers/region.dart';
import 'package:mbw204_club_ina/data/models/warung/address_model.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/warung/edit_alamat.dart';
import 'package:mbw204_club_ina/views/screens/warung/tambah_alamat.dart';

class PilihAlamatPage extends StatefulWidget {
  final String title;

  PilihAlamatPage({
    Key key,
    @required this.title,
  }) : super(key: key);
  @override
  _PilihAlamatPageState createState() => _PilihAlamatPageState();
}

class _PilihAlamatPageState extends State<PilihAlamatPage> {
  AddressModel addressModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getRequests();
  }

  _getRequests() async {
    await Provider.of<RegionProvider>(context, listen: false).getDataAddress(context).then((value) {
      setState(() {
        addressModel = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: ' Mohon Tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Loader(
        color: Colors.white,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
        return Future.value(true);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(widget.title,
              style: TextStyle(
                color: Colors.black, 
                fontWeight: FontWeight.bold
              ),
            ),
            backgroundColor: widget.title == "Daftar Alamat" ? Colors.orange[700] : Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            titleSpacing: 0,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context, true);
                },
                child: Icon(widget.title == "Daftar Alamat"
                    ? Platform.isIOS
                        ? Icons.arrow_back_ios
                        : Icons.arrow_back
                    : Icons.close)),
            elevation: 0,
          ),
          body: isLoading
              ? Loader(
                color: ColorResources.PRIMARY,
              )
              : Stack(
                  children: [
                    addressModel.body.length == 0
                        ? emptyAddress()
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                                bottom: 60, left: 16, right: 16, top: 16),
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: addressModel.body.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 2,
                                margin: EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () async {
                                    if (widget.title != "Daftar Alamat") {
                                      pr.show();
                                      await Provider.of<RegionProvider>(context, listen: false).selectedAddress(context,
                                              addressModel.body[index].id, true)
                                          .then((value) {
                                        if (value.code == 0) {
                                          pr.hide();
                                          Navigator.pop(context, true);
                                        }
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      addressModel
                                                          .body[index].name,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 5),
                                                  Text(
                                                      addressModel.body[index]
                                                          .phoneNumber,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      )),
                                                  SizedBox(height: 3),
                                                  Text(
                                                      addressModel
                                                          .body[index].address,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            widget.title != "Daftar Alamat"
                                                ? addressModel.body[index]
                                                            .defaultLocation ==
                                                        true
                                                    ? Icon(Icons.check_circle,
                                                        color: ColorResources.PRIMARY)
                                                    : Container()
                                                : Container()
                                          ],
                                        ),
                                        SizedBox(height: 14),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return EditAlamatPage(
                                                  idAddress: addressModel
                                                      .body[index].id,
                                                  typeAlamat: addressModel
                                                      .body[index].name,
                                                  province: addressModel
                                                      .body[index].province,
                                                  city: addressModel
                                                      .body[index].city,
                                                  postalCode: addressModel
                                                      .body[index].postalCode,
                                                  address: addressModel
                                                      .body[index].address,
                                                  subdistrict: addressModel
                                                      .body[index].subdistrict,
                                                  noPonsel: addressModel
                                                      .body[index].phoneNumber,
                                                  defaultLocation: addressModel
                                                      .body[index]
                                                      .defaultLocation,
                                                  location: addressModel
                                                      .body[index].location);
                                            })).then((val) =>
                                                val ? _getRequests() : null);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  width: 2,
                                                  color: Colors.grey[350],
                                                )),
                                            child: Center(
                                              child: Text("Ubah Alamat",
                                                  style: TextStyle(
                                                    color:
                                                        ColorResources.PRIMARY,
                                                    fontSize: 14,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            height: 60,
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: SizedBox(
                                height: 55,
                                width: double.infinity,
                                child: RaisedButton(
                                  color: ColorResources.PRIMARY,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text("Tambah Alamat Baru",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return TambahAlamatPage();
                                    })).then((nilai) =>
                                        nilai ? _getRequests() : null);
                                  },
                                ))))
                  ],
                )),
    );
  }

  Widget emptyAddress() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            LottieBuilder.asset(
              "assets/lottie/add_address.json",
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20),
            Container(
              child: Text(
                "Wah, Anda belum mengisi alamat",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 5),
            Container(
              child: Text(
                "Yuk, isi alamat anda dengan menambah alamat baru",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ])),
    );
  }
}
