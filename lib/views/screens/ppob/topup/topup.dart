import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/screens/ppob/confirm_payment.dart';
import 'package:mbw204_club_ina/views/basewidget/separator_dash.dart';

class TopUpScreen extends StatefulWidget {
  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  int selected;

  @override
  Widget build(BuildContext context) {

    Provider.of<PPOBProvider>(context, listen: false).getListEmoney(context, "CX_WALLET");
   
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: getTranslated("TOPUP", context), isBackButtonExist: true),

            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                if(ppobProvider.listTopUpEmoneyStatus == ListTopUpEmoneyStatus.loading) {
                  return Expanded(
                      child: Loader(
                      color: ColorResources.BTN_PRIMARY,
                    ),
                  );
                }
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: StatefulBuilder(
                      builder: (BuildContext context, s) {
                        return GridView.builder(
                          itemCount: ppobProvider.listTopUpEmoney.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                          ),
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext ctx, int i) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    child: Card(
                                      elevation: 3.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        side: BorderSide(
                                          width: 1.0,
                                          color: ColorResources.BTN_PRIMARY
                                        )
                                      ),
                                      color: selected == i ? ColorResources.BTN_PRIMARY : ColorResources.WHITE,
                                      child: GestureDetector(
                                        onTap: () {
                                          s(() => selected = i);
                                          showMaterialModalBottomSheet(        
                                            isDismissible: false,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                                            ),
                                            context: context,
                                              builder: (ctx) => SingleChildScrollView(
                                                child: Container(
                                                  height: 300.0,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              child: Text(getTranslated("CUSTOMER_INFORMATION", context),
                                                                softWrap: true,
                                                                style: poppinsRegular.copyWith(
                                                                  fontSize: 17.0,
                                                                  fontWeight: FontWeight.bold
                                                                ),
                                                              )
                                                            ),
                                                            SizedBox(height: 12.0),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(getTranslated("PHONE_NUMBER", context),
                                                                  style: poppinsRegular,
                                                                ),
                                                                Text(Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber)
                                                              ],
                                                            ),
                                                            SizedBox(height: 8.0),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(ppobProvider.listTopUpEmoney[i].description),
                                                                Text(ConnexistHelper.formatCurrency(double.parse(ppobProvider.listTopUpEmoney[i].price.toString())))
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 20.0),
                                                      Container(
                                                        width: double.infinity,
                                                        color: Colors.blueGrey[50],
                                                        height: 8.0,
                                                      ),
                                                      SizedBox(height: 12.0),
                                                      Container(
                                                        margin: EdgeInsets.only(left: 16.0, right: 16.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              child: Text(getTranslated("DETAIL_PAYMENT", context),
                                                                softWrap: true,
                                                                style: poppinsRegular.copyWith(
                                                                  fontSize: 17.0,
                                                                  fontWeight: FontWeight.bold
                                                                ),
                                                              )
                                                            ),
                                                            SizedBox(height: 12.0),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(getTranslated("VOUHCER_PRICE", context),
                                                                  style: poppinsRegular,
                                                                ),
                                                                Text(ConnexistHelper.formatCurrency(double.parse(ppobProvider.listTopUpEmoney[i].price.toString())),
                                                                  style: poppinsRegular,
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(height: 10.0),
                                                            MySeparatorDash(
                                                              color: Colors.blueGrey[50],
                                                              height: 3.0,
                                                            ),
                                                            SizedBox(height: 12.0),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(getTranslated("TOTAL_PAYMENT", context),
                                                                  style: poppinsRegular.copyWith(
                                                                    fontWeight: FontWeight.bold
                                                                  ),
                                                                ),
                                                                Text(ConnexistHelper.formatCurrency(double.parse(ppobProvider.listTopUpEmoney[i].price.toString())),
                                                                  style: poppinsRegular.copyWith(
                                                                    fontWeight: FontWeight.bold
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 12.0),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Container(
                                                            width: 140.0,
                                                            child: TextButton(
                                                              style: TextButton.styleFrom(
                                                                elevation: 0.0,
                                                                backgroundColor: ColorResources.WHITE,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                  side: BorderSide.none
                                                                )
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(ctx).pop();
                                                              },
                                                              child: Text(getTranslated("CHANGE", context),
                                                                style: poppinsRegular.copyWith(
                                                                  color: ColorResources.BTN_PRIMARY
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 140.0,
                                                            child: TextButton(
                                                              style: TextButton.styleFrom(
                                                                elevation: 0.0,
                                                                shadowColor: ColorResources.BTN_PRIMARY,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                  side: BorderSide.none
                                                                )
                                                              ),
                                                              onPressed: () {
                                                                Navigator.push(ctx,
                                                                  MaterialPageRoute(builder: (ctx) => ConfirmPaymentScreen(
                                                                    type: "topup",
                                                                    description: ppobProvider.listTopUpEmoney[i].description,
                                                                    nominal: ppobProvider.listTopUpEmoney[i].price,
                                                                    provider: ppobProvider.listTopUpEmoney[i].category.toLowerCase(),
                                                                    accountNumber: Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber,
                                                                    productId: ppobProvider.listTopUpEmoney[i].productId,
                                                                  )),
                                                                );
                                                              },
                                                              child: Text(getTranslated("CONFIRM", context),
                                                                style: poppinsRegular.copyWith(
                                                                  color: ColorResources.WHITE
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10.0),
                                          width: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius .circular(4.0)
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Text(NumberFormat("###,000", "id_ID").format(ppobProvider.listTopUpEmoney[i].price),
                                                  style: poppinsRegular.copyWith(
                                                    color: selected == i ? ColorResources.WHITE : ColorResources.BTN_PRIMARY,
                                                    fontSize:16.0
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
                        );
                      },
                    ),
                  ));
                },
              )
            ],
          ),
        ),
      );
    }

  }
