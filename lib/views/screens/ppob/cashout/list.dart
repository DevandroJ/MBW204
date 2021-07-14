import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/data/models/ppob/cashout/inquiry.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/views/screens/ppob/cashout/confirmation.dart';

class CashoutScreen extends StatefulWidget {
  @override
  _CashoutScreenState createState() => _CashoutScreenState();
}

class _CashoutScreenState extends State<CashoutScreen> {

  int selected;
  int price = 0; 
  String priceDisplay = "Rp 0";

  Future inquiryDisbursement() async {
    try {
      int amount = price;
      if(amount == 0) {
        Fluttertoast.showToast(
          msg: getTranslated("PLEASE_SELECT_AMOUNT", context),
          backgroundColor: ColorResources.ERROR,
          toastLength: Toast.LENGTH_LONG,
          textColor: ColorResources.WHITE
        );
        return;
      }
      await Provider.of<PPOBProvider>(context, listen: false).inquiryDisbursement(context, amount, price);
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<PPOBProvider>(context, listen: false).getBankDisbursement(context);
    Provider.of<PPOBProvider>(context, listen: false).getEmoneyDisbursement(context);
    Provider.of<PPOBProvider>(context, listen: false).getDenomDisbursement(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            CustomAppBar(title: "Cash Out", isBackButtonExist: true),

              StatefulBuilder(
                builder: (BuildContext context, Function s) {
                return Container(
                  margin: EdgeInsets.only(top: 65.0, bottom: 20.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [    

                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getTranslated("AMOUNT", context),
                                  style: poppinsRegular.copyWith(
                                    fontSize: 12.0,
                                    color: Colors.grey
                                  )
                                ),
                                SizedBox(height: 2.0),
                                Text(priceDisplay,
                                  style: poppinsRegular.copyWith(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getTranslated("YOUR_BALANCE", context),
                                  style: poppinsRegular.copyWith(
                                    fontSize: 12.0,
                                    color: Colors.grey
                                  ),
                                ),
                                Consumer<PPOBProvider>(
                                  builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                                    return Container(
                                      child: Text(ppobProvider.balanceStatus == BalanceStatus.loading 
                                        ? "Rp ..." 
                                        : ppobProvider.balanceStatus == BalanceStatus.error 
                                        ? getTranslated("THERE_WAS_PROBLEM", context)
                                        : ConnexistHelper.formatCurrency(double.parse(ppobProvider.balance.toString())),
                                        softWrap: true,
                                        style: poppinsRegular.copyWith(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold
                                        ) 
                                      ),
                                    );          
                                  },
                                ),
                              ],
                            )

                          ]
                        ),
                      ),

                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 40.0, bottom: 20.0),
                          child: Consumer<PPOBProvider>(
                            builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                              
                              if(ppobProvider.denomDisbursementStatus == DenomDisbursementStatus.loading)
                                return Loader(
                                  color: ColorResources.getPrimaryToWhite(context)
                                );  
                              
                              if(ppobProvider.denomDisbursementStatus == DenomDisbursementStatus.loading)
                                return Loader(
                                  color: ColorResources.getPrimaryToWhite(context)
                                );  

                                return GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                    childAspectRatio: 3 / 1
                                  ),
                                  itemCount: ppobProvider.denomDisbursement.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      ),
                                      onTap: () {
                                        s(() { 
                                          selected = i;
                                          price = int.parse(ppobProvider.denomDisbursement[i].code);
                                          priceDisplay = ConnexistHelper.formatCurrency(double.parse(ppobProvider.denomDisbursement[i].code));
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(15.0),
                                        width: 240.0,
                                        height: 90.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: selected == i ? ColorResources.GREEN : Colors.grey),
                                          borderRadius: BorderRadius.circular(10.0)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text(ConnexistHelper.formatCurrency(double.parse(ppobProvider.denomDisbursement[i].code)),
                                                  style: poppinsRegular,
                                                )
                                              ),
                                            ),
                                            Container(
                                              width: 25.0,
                                              height: 25.0,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(color: selected == i ? ColorResources.GREEN : Colors.grey),
                                                shape: BoxShape.circle
                                              ),
                                              child: Container(
                                              margin: EdgeInsets.all(5.0),
                                              width: 5.0,
                                              height: 5.0,
                                              decoration: BoxDecoration(
                                                color: selected == i ? ColorResources.GREEN : Colors.transparent,
                                                border: Border.all(color: Colors.transparent),
                                                shape: BoxShape.circle
                                              )
                                              ),
                                            )
                                          ],
                                        ) 
                                      ),
                                    );
                                  },
                                );
                              
                            },
                          )
                        ),
                      )
                    
                    ]
                  ),
                );
              },
            ),

          
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: ColorResources.getBlackSoft(context),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                child: ElevatedButton(
                  onPressed: inquiryDisbursement,
                  style: ButtonStyle(
                  elevation: MaterialStateProperty.resolveWith<double>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return 0;
                      }
                      return 0;
                    },
                  ),
                   backgroundColor: MaterialStateProperty.all(ColorResources.getPrimaryToWhite(context)),
                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )
                    )
                  ),
                  child: Consumer<PPOBProvider>(
                    builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                      return ppobProvider.disbursementStatus == InquiryDisbursementStatus.loading 
                      ? SizedBox(
                        width: 18.0,
                        height: 18.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(ColorResources.getWhiteToBlack(context)),
                        ),
                      )
                      : Text(getTranslated("CONTINUE", context),
                        style: poppinsRegular.copyWith(
                          color: ColorResources.getWhiteToBlack(context)
                        ),
                      );
                    },
                  )
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}