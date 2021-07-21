import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';

class TokenListrikScreen extends StatefulWidget {
  @override
  _TokenListrikScreenState createState() => _TokenListrikScreenState();
}

class _TokenListrikScreenState extends State<TokenListrikScreen> {

  int selected;
  bool error = false;
  Timer debounce;
  TextEditingController noMeterPelangganController = TextEditingController();
  FocusNode focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  noMeterPelangganChange() {
    if(noMeterPelangganController.text.length <= 9) {
      if(debounce?.isActive ?? false) debounce.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        Provider.of<PPOBProvider>(context, listen: false).getListPricePLNPrabayar(context);
      });
    } 
  }

  @override
  void dispose() {
    debounce?.cancel();
    noMeterPelangganController.dispose();
    noMeterPelangganController.removeListener(noMeterPelangganChange);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();  
    noMeterPelangganController.addListener(noMeterPelangganChange);
  }

  Future postInquiryPLNPrabayarStatus(String productId) async {
    try { 
      if(noMeterPelangganController.text.length <= 9) {
        throw Exception();
      } else {
        setState(() => error = false);
      }
      await Provider.of<PPOBProvider>(context, listen: false).postInquiryPLNPrabayarStatus(context, productId, noMeterPelangganController.text, "WALLET");
    } on Exception catch(_) {
      setState(() => error = true);
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorResources.BG_GREY,
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: "Token Listrik", isBackButtonExist: true),

            Container(
              color: ColorResources.WHITE,
              padding: EdgeInsets.all(10.0),
              width: double.infinity,
              height: 135.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(top: 10.0, left: 14.0),
                    child: Text("Nomor Meter",
                      style: poppinsRegular.copyWith(
                        color: ColorResources.BLACK,
                        fontSize: 13.0
                      ),
                    ),
                  ),

                  Form(
                    key: formKey,
                    child: Container(
                      margin: EdgeInsets.only(top: 8.0, left: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: TextFormField(
                        controller: noMeterPelangganController,
                        focusNode: focusNode,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: error ? ColorResources.WHITE : ColorResources.DIM_GRAY.withOpacity(0.8)
                        ),
                        decoration: InputDecoration(
                          errorMaxLines: 1,
                          hintText: "Contoh 1234567890",
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                            color: error ? ColorResources.WHITE : ColorResources.DIM_GRAY.withOpacity(0.8)
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0, 
                            horizontal: 22.0
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(style: BorderStyle.none, width: 0),
                          ),
                          fillColor: error ? Colors.red[300] : Colors.transparent,
                          filled: true,
                          isDense: true
                        ),
                      ),
                    ),
                  ),

                  error ? Container(
                    margin: EdgeInsets.only(left: 14.0, top: 10.0),
                    child: Text("Nomor Ponsel minimal 10 karakter",
                      softWrap: true,
                      style: TextStyle(
                        color: ColorResources.ERROR
                      ),
                    ),
                  ) : Container()

                ],
              ),
            ),
            
            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                if(ppobProvider.listPricePLNPrabayarStatus == ListPricePLNPrabayarStatus.loading) {
                  return Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 18.0,
                        height: 18.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(ColorResources.BTN_PRIMARY),
                        )
                      )
                    ),
                  );
                }
                if(ppobProvider.listPricePLNPrabayarStatus == ListPricePLNPrabayarStatus.empty) {
                  return Container();
                }
                return Expanded(
                  child: GridView.builder(
                    itemCount: ppobProvider.listPricePLNPrabayarData.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1/1,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 0.0,
                    ),
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int i) {
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              height: 80.0,
                              child: Card(
                                elevation: 0.0,
                                color: ColorResources.WHITE,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    width: 0.5,
                                    color: selected == i ? ColorResources.PURPLE_DARK : Colors.transparent
                                  )
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() => selected = i);
                                    setState(() {
                                      error = false;
                                    });
                                    if(error == true) {
                                      focusNode.requestFocus();
                                    } else {
                                      await postInquiryPLNPrabayarStatus(ppobProvider.listPricePLNPrabayarData[i].productId);
                                    }
                                  },
                                  child: Container(
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius .circular(4.0)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(NumberFormat("###,000", "id_ID").format(ppobProvider.listPricePLNPrabayarData[i].price),
                                            style: poppinsRegular.copyWith(
                                              color: selected == i ? ColorResources.PURPLE_DARK : ColorResources.DIM_GRAY.withOpacity(0.8),
                                              fontSize: 16.0
                                            ),
                                          )
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ),
                          )
                        ]
                      );
                    },
                  ),
                );
              },
            ), 

            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                return ppobProvider.btnNextBuyPLNPrabayar 
                ? Container(
                    width: double.infinity,
                    color: ColorResources.WHITE,
                    height: 60.0,
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: SizedBox(
                        width: 18.0,
                        height: 18.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(ColorResources.BTN_PRIMARY),
                        ),
                      ),
                    ),
                  )  
                : SizedBox();
              },
            )

          ],
        ),
      ),
    );
  }
}