import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';

class InboxDetailScreen extends StatelessWidget {
  final String type;
  final String body;
  final String subject;
  final String field1;
  final String field2;
  final String field5;
  final String field6;

  InboxDetailScreen({
    this.type,
    this.body,
    this.subject,
    this.field1,
    this.field2,
    this.field5,
    this.field6
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(
              title: type == "payment.waiting" 
              ? "Menunggu Pembayaran" 
              : type == "payment.success" 
              ? "Pembayaran Berhasil" 
              : type == "purchase" 
              ? "Purchase" 
              : "Info", 
              isBackButtonExist: true
            ),

            Expanded(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                    child: Column(
                      children: [

                        Card(
                          elevation: 0.0,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 0.1
                              )
                            ),
                            child: Column(
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("No Transaksi", 
                                      style: titilliumRegular,
                                    ),
                                    Text(field1.toString() == null ? "-" : field1,
                                      style: titilliumRegular,
                                    )
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Harga",
                                      style: titilliumRegular,
                                    ),
                                    Text(field2.toString() == null ? "-" : ConnexistHelper.formatCurrency(double.parse(field2)),
                                      style: titilliumRegular,
                                    )
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Status",
                                      style: titilliumRegular,
                                    ),
                                    Text(subject.toString() == null ? "-" : subject,
                                      style: titilliumRegular,
                                    )
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),

                        Card(
                          elevation: 0.0,
                          child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 0.1
                            )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            
                              Text(body,
                                style: titilliumRegular.copyWith(
                                  height: 1.8
                                ),
                                textAlign: TextAlign.justify,
                                softWrap: true,
                              ),
                              SizedBox(height: 10.0),
                              Text(field6.toString() == null ? "-" : field6, 
                                textAlign: TextAlign.justify,
                                softWrap: true,
                                style: titilliumRegular,
                              ),
                              SizedBox(height: 10.0),
                              type == "payment.paid" || type == "purchase.success" || type == "disbursement.success"
                              ? SizedBox() 
                              : Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    try {
                                      launch(field5.toString());
                                    } catch(e) {
                                      print(e);
                                    }
                                  }, 
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(ColorResources.GREEN)
                                  ),
                                  child: Text("Lihat Tagihan",
                                    style: titilliumRegular.copyWith(
                                      color: ColorResources.WHITE
                                    ),
                                    textAlign: TextAlign.justify,
                                    softWrap: true,
                                  ),
                                ),
                              )
                              // InkWell(
                              //   onTap: () {
                              //     try {
                              //       launch(field5.toString());
                              //     } catch(e) {
                              //       print(e);
                              //     }
                              //   },
                              //   child: Text(field5.toString() == null ? "-" : field5,
                              //     style: titilliumRegular.copyWith(
                              //       color: ColorResources.BLUE
                              //     ),
                              //     textAlign: TextAlign.justify,
                              //     softWrap: true,
                              //   ),
                              // )

                            ],
                          ),
                        ))
                      ],
                    ),
                    
                    // Card(
                    //   child: Container(
                    //     padding: EdgeInsets.all(10.0),
                    //     child:Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Text("No Transaksi"),
                    //             Text(field1.toString() == null ? "-" : field1)
                    //           ],
                    //         ),
                    //         SizedBox(height: 8.0),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Text("Harga"),
                    //             Text(field2.toString() == null ? "-" : ConnexistHelper.formatCurrency(double.parse(field2)))
                    //           ],
                    //         ),
                    //         SizedBox(height: 8.0),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Text("Status"),
                    //             Text(subject.toString() == null ? "-" : subject)
                    //           ],
                    //         ),
                    //         Divider(),
                    //         Text(body,
                    //           style: TextStyle(
                    //             height: 1.8
                    //           ),
                    //           textAlign: TextAlign.justify,
                    //           softWrap: true,
                    //         ),
                    //         SizedBox(height: 10.0),
                    //         Text(field6.toString() == null ? "-" : field6, 
                    //           textAlign: TextAlign.justify,
                    //           softWrap: true,
                    //         ),
                    //         SizedBox(height: 10.0),
                    //         InkWell(
                    //           onTap: () {
                    //             try {
                    //               launch(field5.toString());
                    //             } catch(e) {
                    //               print(e);
                    //             }
                    //           },
                    //           child: Text(field5.toString() == null ? "-" : field5,
                    //             style: TextStyle(
                    //               color: ColorResources.BLUE
                    //             ),
                    //             textAlign: TextAlign.justify,
                    //             softWrap: true,
                    //           ),
                    //         )
                    //       ],
                    //     )
                    //   ),
                    // )


                  )
                ],
              )
            )

          ],
        ),
      ),
    );
  }
}