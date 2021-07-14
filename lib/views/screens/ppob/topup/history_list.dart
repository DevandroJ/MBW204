import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';

class HistoryTopUpTransaksiListScreen extends StatelessWidget {

  final String startDate;
  final String endDate;

  HistoryTopUpTransaksiListScreen({
    this.startDate,
    this.endDate
  });
  
  @override
  Widget build(BuildContext context) {

    Provider.of<PPOBProvider>(context, listen: false).getHistoryBalance(context, startDate, endDate);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: getTranslated("HISTORY_BALANCE", context), isBackButtonExist: true),

            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                
                if(ppobProvider.historyBalanceStatus == HistoryBalanceStatus.loading)
                  return Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Loader(
                            color: ColorResources.getPrimaryToWhite(context)
                          )
                        ],
                      ),
                    ),
                  );
                if(ppobProvider.historyBalanceStatus == HistoryBalanceStatus.empty) 
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          LottieBuilder.asset(
                            "assets/lottie/empty_transaction.json",
                            height: 200,
                            width: 200,
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: Text("Wah, Anda belum memiliki history",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            child: Text("Yuk, isi history anda dengan melakukan transaksi",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ]
                      )
                    ),
                  );
                
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemCount: ppobProvider.historyBalanceData.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ppobProvider.historyBalanceData[i].type,
                                    style: poppinsRegular.copyWith(
                                      color: ColorResources.getBlackToWhite(context), 
                                      fontSize: 16.0
                                    )
                                  ),
                                  Text(ConnexistHelper.formatCurrency(double.parse(ppobProvider.historyBalanceData[i].amount.toString())).toString(),
                                  style: poppinsRegular.copyWith(
                                    color: ppobProvider.historyBalanceData[i].type != "CREDIT" ? ColorResources.ERROR : ColorResources.SUCCESS, fontSize: 16.0)
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(ppobProvider.historyBalanceData[i].description,
                                style: poppinsRegular.copyWith(
                                  color: ColorResources.getBlackToWhite(context), 
                                  fontSize: ppobProvider.historyBalanceData[i].type != "CREDIT" ? 14.0 : 16.0 
                                )
                              ),
                              SizedBox(
                                height: 14.0,
                              ),
                              Text(ConnexistHelper.formatDate(DateTime.parse(ppobProvider.historyBalanceData[i].created)),
                                style: poppinsRegular.copyWith(
                                  color: ColorResources.getBlackToWhite(context), 
                                  fontSize: 14.0
                                )
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int i) {
                        return Divider(
                          thickness: 1.0,
                        );
                      },
                    ),
                  ),
                );
              },            
            ),

          ],
        ),
      ),
    );
  }

}