import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
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
              child: Container(
                margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            if(type != "default")
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SelectableText("No Transaksi", 
                                    style: poppinsRegular,
                                  ),
                                  SelectableText(field1.toString() == null ? "-" : field1,
                                    style: poppinsRegular,
                                  )
                                ],
                              ),
                            type == "default" ? SizedBox() : SizedBox(height: 8.0),
                            if(type != "default")
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SelectableText("Harga",
                                    style: poppinsRegular,
                                  ),
                                  SelectableText(field2.toString() == null ? "-" : ConnexistHelper.formatCurrency(double.parse(field2)),
                                    style: poppinsRegular,
                                  )
                                ],
                              ),
                            type == "default" ? SizedBox() : SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SelectableText(type != "default" 
                                ? "Status" : "Subject",
                                  style: poppinsRegular,
                                ),
                                SelectableText(subject.toString() == null ? "-" : subject,
                                  style: poppinsRegular,
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
                          SelectableText(body,
                            style: poppinsRegular.copyWith(
                              height: 1.8
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          type == "default" ? SizedBox() : SizedBox(height: 10.0),
                          type == "default" 
                          ? SizedBox()
                          : SelectableText(field6.toString() == null ? "-" : field6, 
                            textAlign: TextAlign.justify,
                            style: poppinsRegular,
                          ),
                          type == "default" ? SizedBox() : SizedBox(height: 10.0),
                          type != "payment.waiting"
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
                              child: SelectableText("Lihat Tagihan",
                                style: poppinsRegular.copyWith(
                                  color: ColorResources.WHITE
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                          type != "payment.waiting" 
                          ? SizedBox()
                          : Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  await launch("${AppConstants.BASE_URL_HELP_INBOX_PAYMENT}/${field1.toString()}");
                                } catch(e) {
                                  print(e);
                                }
                              }, 
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(ColorResources.GREEN)
                              ),
                              child: SelectableText("Cara Pembayaran",
                                style: poppinsRegular.copyWith(
                                  color: ColorResources.WHITE
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
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
            )

          ],
        ),
      ),
    );
  }
}