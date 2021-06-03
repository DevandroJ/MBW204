import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:intl/intl.dart';

import 'package:mbw204_club_ina/views/screens/ppob/topup/history_list.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

class TopUpHistoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    String startDate = DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 7)).toString();
    String endDate = DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).toString();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: "History Saldo", isBackButtonExist: true),

            Container(
              margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
              child: Container(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [

                        StatefulBuilder(
                          builder: (BuildContext context, Function setState) {
                            return Container(
                              margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  width: 1.5,
                                  color: ColorResources.GREY
                                )
                              ),
                              child: DateTimePicker(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                                  ),
                                  hintText: 'Pilih Tanggal'
                                ),
                                initialValue: startDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                onChanged: (val) {
                                  setState(() => startDate = val);
                                },
                              ),
                            );
                          }, 
                        ),

                        SizedBox(height: 10.0),

                        StatefulBuilder(
                          builder: (BuildContext context, Function setState) {
                            return Container(
                              margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  width: 1.5,
                                  color: ColorResources.GREY
                                )
                              ),
                              child: DateTimePicker(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                                  ),
                                  hintText: 'Pilih Tanggal'
                                ),
                                initialValue: endDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                onChanged: (val) {
                                  setState(() => endDate = val);
                                },
                              ),
                            );
                          }
                        ),

                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) =>  HistoryTopUpTransaksiListScreen(startDate: startDate, endDate: endDate))), 
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(ColorResources.getPrimaryToWhite(context)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )
                              )
                            ),
                            child: Text("Submit",
                              style: poppinsRegular.copyWith(
                                color: ColorResources.getWhiteToBlack(context)
                              ),
                            )
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}