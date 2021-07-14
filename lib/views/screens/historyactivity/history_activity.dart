import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/providers/history_activity.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';

class HistoryActivityScreen extends StatefulWidget {

  @override
  _HistoryActivityScreenState createState() => _HistoryActivityScreenState();
}

class _HistoryActivityScreenState extends State<HistoryActivityScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<HistoryActivityProvider>(context, listen: false).getHistoryActivity(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.BTN_PRIMARY,
        elevation: 0.0,
        title: Text(getTranslated("HISTORY_ACTIVITY", context),
          style: poppinsRegular,
        ),
      ),
      body: Consumer<HistoryActivityProvider>(
        builder: (BuildContext context, HistoryActivityProvider historyActivityProvider, Widget child) {
          if(historyActivityProvider.getHistoryActivityStatus == GetHistoryActivityStatus.loading) {
            return Loader(
              color: ColorResources.BTN_PRIMARY_SECOND,
            );
          }  
          return Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemCount: historyActivityProvider.historyActivityData.length,
              itemBuilder: (BuildContext context, int i) {
                return Container(
                     margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(historyActivityProvider.historyActivityData[i].description,
                        style: poppinsRegular.copyWith(
                          color: ColorResources.getBlackToWhite(context), 
                          fontSize: 13.0
                        )
                      ),
                      SizedBox(height: 6.0),
                      Text(DateFormat('dd MMMM yyyy kk:mm').format(historyActivityProvider.historyActivityData[i].created),
                      style: poppinsRegular.copyWith(
                        fontSize: 12.0
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
          );
        },
      )
    );
  }

}