import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

class TagihanListrikScreen extends StatefulWidget {
  @override
  _TagihanListrikScreenState createState() => _TagihanListrikScreenState();
}

class _TagihanListrikScreenState extends State<TagihanListrikScreen> {
  bool next = false;
  Timer debounce;
  TextEditingController idPelangganController = TextEditingController();

  idPelangganNumberChange() {
    if(idPelangganController.text.length >= 10) {
      setState(() => next = true);
      if (debounce?.isActive ?? false) debounce.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        Provider.of<PPOBProvider>(context, listen: false).postInquiryPLNPascaBayar(context, idPelangganController.text, idPelangganController, idPelangganNumberChange);
      });
    } else {
      setState(() => next = false);
    }
  }

  @override
  void dispose() {
    debounce?.cancel();
    idPelangganController.removeListener(idPelangganNumberChange);
    idPelangganController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();  
    idPelangganController.addListener(idPelangganNumberChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.BG_GREY,
      body: Column(
        children: [

          CustomAppBar(title: "Tagihan Listrik"),
          
          Container(
            color: ColorResources.WHITE,
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.0, left: 14.0),
                  child: Text("ID Pelanggan",
                    style: poppinsRegular.copyWith(
                      fontSize: 13.0,
                      color: ColorResources.BLACK
                    )
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.0, left: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: TextField(
                    controller: idPelangganController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: ColorResources.BLACK
                    ),
                    decoration: InputDecoration(
                      hintText: "Contoh 1234567890",
                      hintStyle: TextStyle(
                        fontSize: 14.0
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.0, 
                        horizontal: 22.0
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(style: BorderStyle.none, width: 0),
                      ),
                      isDense: true
                    ),
                  ),
                )
              ],
            ),
          ),

          Consumer<PPOBProvider>(
            builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
              if(ppobProvider.inquiryPLNPascabayarStatus == InquiryPLNPascabayarStatus.loading)
                return Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 18.0, 
                      height: 18.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(ColorResources.BTN_PRIMARY),
                      )
                    ),
                  ),
                );
              return Container();
            },
          )

        ],
      ),
    );
  }
}