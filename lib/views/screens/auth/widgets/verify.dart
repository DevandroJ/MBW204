import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/views/screens/ppob/confirm_payment.dart';

class VerifyScreen extends StatelessWidget {

  final String accountName;
  final String accountNumber;
  final int bankFee;
  final double productPrice;
  final String productId;
  final String transactionId;

  VerifyScreen({
    this.accountName,
    this.accountNumber,
    this.bankFee,
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
                    child: Image.asset('assets/images/logo-home-menu.png',
                      width: 120.0,
                      height: 120.0,
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
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[600],
                          width: 1.0
                        )
                      ),
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
                                  "Biaya Registrasi",
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
                                  child: Text(ConnexistHelper.formatCurrency(double.parse(productPrice.toString()) + double.parse(bankFee.toString())),
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
                              color: ColorResources.BTN_PRIMARY,
                              borderRadius: BorderRadius.circular(8.0)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.info,
                                  size: 40.0,
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

                  SizedBox(height: 30.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     elevation: 3.0,
                      //     side: BorderSide(
                      //       color: ColorResources.BTN_PRIMARY_SECOND,
                      //       width: 1.0
                      //     ),
                      //     primary: ColorResources.WHITE,
                      //     textStyle: poppinsRegular
                      //   ),
                      //   onPressed: () => Navigator.pop(context),
                      //   child: Text("Kembali",
                      //     style: poppinsRegular.copyWith(
                      //       color: ColorResources.BLACK
                      //     ),
                      //   ),
                      // ),

                      Container(
                        decoration: BoxDecoration(
                          color: ColorResources.WHITE,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: ColorResources.BTN_PRIMARY_SECOND,
                            width: 1.0
                          )
                        ),
                        child: Material(
                          color: Colors.transparent,                
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            splashColor: ColorResources.BTN_PRIMARY_SECOND,
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              width: 150.0,
                              height: 32.0,
                              child: Container(
                                margin: EdgeInsets.only(top: 6.0),
                                child: Text("Kembali",
                                  textAlign: TextAlign.center,
                                  style: poppinsRegular.copyWith(
                                    color: ColorResources.BLACK
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 20.0),

                       Container(
                        decoration: BoxDecoration(
                          color: ColorResources.WHITE,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: ColorResources.BTN_PRIMARY_SECOND,
                            width: 1.0
                          )
                        ),
                        child: Material(
                          color: Colors.transparent,                
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            splashColor: ColorResources.BTN_PRIMARY_SECOND,
                            onTap: () { 
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ConfirmPaymentScreen(
                                  type: "register",
                                  description: "REGISTER",
                                  nominal: productPrice,
                                  bankFee: bankFee,
                                  transactionId: transactionId,
                                  provider: "register",
                                  accountNumber: accountNumber,
                                  productId: productId,
                                )),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              width: 150.0,
                              height: 32.0,
                              child: Container(
                                margin: EdgeInsets.only(top: 6.0),
                                child: Text("Pilih Pembayaran",
                                  textAlign: TextAlign.center,
                                  style: poppinsRegular.copyWith(
                                    color: ColorResources.BLACK
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     elevation: 3.0,
                      //     side: BorderSide(
                      //       color: ColorResources.BTN_PRIMARY_SECOND,
                      //       width: 1.0
                      //     ),
                      //     primary: ColorResources.WHITE,
                      //     textStyle: poppinsRegular
                      //   ),
                      //   onPressed: () {
                      //     Navigator.push(context,
                      //       MaterialPageRoute(builder: (context) => ConfirmPaymentScreen(
                      //         type: "register",
                      //         description: "REGISTER",
                      //         nominal: productPrice,
                      //         transactionId: transactionId,
                      //         provider: "register",
                      //         accountNumber: accountNumber,
                      //         productId: productId,
                      //       )),
                      //     );
                      //   },
                      //   child: Text("Pilih Pembayaran",
                      //     style: poppinsRegular.copyWith(
                      //       color: ColorResources.BLACK
                      //     ),
                      //   ),
                      // ),

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