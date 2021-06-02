import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/views/screens/ppob/confirm_payment.dart';

class VerifyScreen extends StatelessWidget {

  final String accountName;
  final String accountNumber;
  final double productPrice;
  final String productId;
  final String transactionId;

  VerifyScreen({
    this.accountName,
    this.accountNumber,
    this.productPrice,
    this.productId,
    this.transactionId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
             
            CustomAppBar(title: "Aktivasi Akun Anda", isBackButtonExist: true),

            Expanded(
              child: ListView(
                children: [

                  Container(
                    margin: EdgeInsets.only(top: 60.0, bottom: 55.0, left: 16.0, right: 16.0),
                    child: Image.asset(Images.logo,
                      width: 80.0,
                      height: 80.0,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    width: double.infinity,
                    child: Center(
                      child: Text("Akun Belum diaktivasi, silahkan aktivasi terlebih dahulu",
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 150.0,
                                  child: Text(
                                    "Nama",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                Container(
                                  width: 8.0,
                                  child: Text(
                                    ":",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(accountName,
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 14.0),
                            Row(
                              children: [
                                Container(
                                  width: 150.0,
                                  child: Text(
                                    "No Handphone",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                Container(
                                  width: 8.0,
                                  child: Text(
                                    ":",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(accountNumber,
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 14.0),
                            Row(
                              children: [
                                Container(
                                  width: 150.0,
                                  child: Text(
                                    "Biaya Kartu Anggota",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                Container(
                                  width: 8.0,
                                  child: Text(
                                    ":",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(ConnexistHelper.formatCurrency(double.parse(productPrice.toString())),
                                      style: TextStyle(
                                        fontSize: 14.0
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30.0),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: ColorResources.YELLOW,
                                borderRadius: BorderRadius.circular(8.0)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: ColorResources.WHITE,
                                  ),
                                  Container(
                                    width: 250.0,
                                    child: Text("Silahkan lakukan pembayaran terlebih dahulu untuk menyelesaikan registrasi Anda.",
                                      softWrap: true,
                                      style: TextStyle(
                                        color: ColorResources.WHITE,
                                        height: 1.5
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            )
                          ]
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 3.0,
                          primary: ColorResources.WHITE,
                          textStyle: titilliumRegular
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text("Kembali",
                          style: titilliumRegular.copyWith(
                            color: ColorResources.BLACK
                          ),
                        ),
                      ),
                      
                      SizedBox(width: 12.0),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 3.0,
                          primary: ColorResources.getPrimaryToWhite(context),
                          textStyle: titilliumRegular
                        ),
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ConfirmPaymentScreen(
                              type: "register",
                              description: "REGISTER",
                              nominal: productPrice,
                              transactionId: transactionId,
                              provider: "register",
                              accountNumber: accountNumber,
                              productId: productId,
                            )),
                          );
                        },
                        child: Text("Pilih Pembayaran",
                          style: titilliumRegular.copyWith(
                            color: ColorResources.BLACK
                          ),
                        ),
                      ),
                    ],
                  )

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}