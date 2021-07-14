import 'dart:io';

import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/providers/region.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/store/edit_address.dart';
import 'package:mbw204_club_ina/views/screens/store/add_address.dart';

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

  @override
  Widget build(BuildContext context) {

    Provider.of<RegionProvider>(context, listen: false).getDataAddress(context);

    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: 'Mohon Tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Loader(
        color: ColorResources.PRIMARY,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 13.0, 
        fontWeight: FontWeight.w400
      ),
      messageTextStyle: poppinsRegular.copyWith(
        color: Colors.black, 
        fontSize: 19.0, 
        fontWeight: FontWeight.w600
      )
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
            style: poppinsRegular.copyWith(
              color: Colors.black, 
              fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: widget.title == "Daftar Alamat" 
          ? ColorResources.PRIMARY 
          : Colors.white,
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
              : Icons.close
            )
          ),
          elevation: 0,
        ),
          body: Stack(
          children: [
            Consumer(
              builder: (BuildContext context, RegionProvider regionProvider, Widget child) {
                if(regionProvider.getAddressStatus == GetAddressStatus.loading) {
                  return Loader(
                    color: ColorResources.PRIMARY,
                  );
                }
                return regionProvider.addresList.length == 0
                ? emptyAddress()
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 60.0, left: 16.0, right: 16.0, top: 16.0),
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: regionProvider.addresList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Card(
                        elevation: 2.0,
                        margin: EdgeInsets.only(bottom: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async {
                            if (widget.title != "Daftar Alamat") {
                              pr.show();
                              await Provider.of<RegionProvider>(context, listen: false).selectedAddress(context, regionProvider.addresList, i);                          
                              pr.hide();
                              Navigator.pop(context, true);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(regionProvider.addresList[i].name,
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold
                                            )
                                          ),
                                          SizedBox(height: 5),
                                          Text(regionProvider.addresList[i].phoneNumber,
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            )
                                          ),
                                          SizedBox(height: 3),
                                          Text(regionProvider.addresList[i].address,
                                            style: poppinsRegular.copyWith(
                                              color: Colors.black,
                                              fontSize: 14,
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    widget.title != "Daftar Alamat"
                                    ? regionProvider.addresList[i].defaultLocation == true
                                      ? Icon(
                                          Icons.check_circle,
                                          color: ColorResources.PRIMARY
                                        )
                                      : Container()
                                    : Container()
                                  ],
                                ),
                                SizedBox(height: 14),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                      return EditAlamatPage(
                                        idAddress: regionProvider.addresList[i].id,
                                        typeAddress: regionProvider.addresList[i].name,
                                        province: regionProvider.addresList[i].province,
                                        city: regionProvider.addresList[i].city,
                                        village: regionProvider.addresList[i].village,
                                        postalCode: regionProvider.addresList[i].postalCode,
                                        address: regionProvider.addresList[i].address,
                                        subDistrict: regionProvider.addresList[i].subdistrict,
                                        phoneNumber: regionProvider.addresList[i].phoneNumber,
                                        defaultLocation: regionProvider.addresList[i].defaultLocation,
                                      );
                                    }));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        width: 2.0,
                                        color: Colors.grey[350],
                                      )
                                    ),
                                    child: Center(
                                      child: Text("Ubah Alamat",
                                        style: poppinsRegular.copyWith(
                                          color: ColorResources.PRIMARY,
                                          fontSize: 14.0,
                                        )
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
              }
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60.0,
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: SizedBox(
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
                      child: Text("Tambah Alamat Baru",
                        style: poppinsRegular.copyWith(
                        fontSize: 14.0, 
                        color: Colors.white
                      )),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                        return TambahAlamatPage();
                      }));
                    },
                  )
                )
              )
            )
          ],
        )
      ),
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
                style: poppinsRegular.copyWith(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Container(
              child: Text(
                "Yuk, isi alamat anda dengan menambah alamat baru",
                textAlign: TextAlign.center,
                style: poppinsRegular.copyWith(
                  fontSize: 16.0, 
                  color: Colors.black
                ),
              ),
            ),
          ]
        )
      ),
    );
  }
}
