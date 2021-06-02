import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/checkin.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';

class CheckInDetailScreen extends StatefulWidget {

  @override
  _CheckInDetailScreenState createState() => _CheckInDetailScreenState();
}

class _CheckInDetailScreenState extends State<CheckInDetailScreen> {

  
  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> basket = Provider.of(context, listen: false);
    Provider.of<CheckInProvider>(context, listen: false).getCheckInDetail(context, int.parse(basket['checkInId']));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            Consumer<CheckInProvider>(
              builder: (BuildContext context, CheckInProvider checkInProvider, Widget child) {
                return CustomAppBar(title: checkInProvider.checkInStatusDetail == CheckInStatusDetail.loading 
                ? '(...) ' 
                : checkInProvider.checkInStatusDetail == CheckInStatusDetail.error 
                ? '(...) '
                : '(${checkInProvider.checkInTotalUser.toString()}) ' + getTranslated('DETAIL_CHECKIN', context), isBackButtonExist: true);
              },
            ),

            Consumer<CheckInProvider>(
              builder: (BuildContext context, CheckInProvider checkInProvider, Widget child) {
                if(checkInProvider.checkInStatusDetail == CheckInStatusDetail.empty) 
                  return Expanded(
                    child: Center(
                      child: Text("Belum ada yang bergabung")
                    ),
                  );
                
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: checkInProvider.checkInStatusDetail == CheckInStatusDetail.loading 
                      ? 20 
                      : checkInProvider.checkInDetailData.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                
                              },
                              dense: true,
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: checkInProvider.checkInStatusDetail == CheckInStatusDetail.loading 
                                ? AssetImage("assets/images/profile.png") 
                                : checkInProvider.checkInDetailData[i].profilePic == "" || checkInProvider.checkInDetailData[i].profilePic == null
                                ? AssetImage("assets/images/profile.png")  
                                : NetworkImage("${AppConstants.BASE_URL_IMG}/${checkInProvider.checkInDetailData[i].profilePic}"),
                              ),
                              title: Text(checkInProvider.checkInStatusDetail == CheckInStatusDetail.loading 
                              ? "..." 
                              : checkInProvider.checkInStatusDetail == CheckInStatusDetail.error 
                              ? "..." 
                              : checkInProvider.checkInDetailData[i].fullname),
                            ),
                            Divider()
                          ],
                        ); 
                      },
                    ),
                  ),
                );
              },
            )           

          ],
        ),
      ),  
    );
  }
}