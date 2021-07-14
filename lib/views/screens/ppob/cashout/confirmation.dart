import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/basewidget/textfield/custom_password_textfield.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/views/basewidget/list_component.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';

class CashOutInformationScreen extends StatefulWidget {
  final int totalDeduction;
  final double adminFee;
  final String token;

  CashOutInformationScreen({
    this.totalDeduction,
    this.adminFee,
    this.token
  });

  @override
  _CashOutInformationScreenState createState() => _CashOutInformationScreenState();
}

class _CashOutInformationScreenState extends State<CashOutInformationScreen> {
  FocusNode passNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController passwordTextController = TextEditingController();

  void initState() {
    super.initState();  
    passNode = FocusNode();
    formKey = GlobalKey<FormState>();
    passwordTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
 
    int adminFee = int.parse(widget.adminFee.toStringAsFixed(0));
    int grandTotal = (widget.totalDeduction + adminFee);

    void submit() async {
      try {
        if(Provider.of<PPOBProvider>(context, listen: false).getGlobalPaymentMethodName.isEmpty) {
          Fluttertoast.showToast(
            msg: "Please select destination cash out method",
            backgroundColor: ColorResources.ERROR,
            toastLength: Toast.LENGTH_LONG,
            textColor: ColorResources.WHITE
          );
          return;
        }
        if(Provider.of<PPOBProvider>(context, listen: false).getGlobalPaymentAccount.trim().isEmpty) {
          Fluttertoast.showToast(
            msg: "Please fill no account",
            backgroundColor: ColorResources.ERROR,
            toastLength: Toast.LENGTH_LONG,
            textColor: ColorResources.WHITE
          );
          return;
        }
        showMaterialModalBottomSheet(
          context: context, 
          builder: (context) {
            return Container(
            height: 300.0,
            margin: EdgeInsets.only(top: 60.0, bottom: 0.0, left: 0.0, right: 0.0),
            child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [

                Container(
                  margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_DEFAULT, 
                    right: Dimensions.MARGIN_SIZE_DEFAULT, 
                    bottom: Dimensions.MARGIN_SIZE_DEFAULT
                  ),
                  child: CustomPasswordTextField(
                    hintTxt: "Password",
                    textInputAction: TextInputAction.done,
                    focusNode: passNode,
                    controller: passwordTextController,
                  )
                ),

                Container(
                  margin: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0, 
                    bottom: 10.0, 
                    top: 15.0
                  ),
                  child: TextButton(
                  onPressed: () async {
                    try {
                      if(passwordTextController.text.trim().isEmpty) {
                        Fluttertoast.showToast(
                          msg: getTranslated("PASSWORD_REQUIRED", context),
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: ColorResources.ERROR,
                        );
                        return;
                      }
                      final res = await Provider.of<AuthProvider>(context, listen: false).authDisbursement(context, passwordTextController.text);
                      if(res == 200) {
                        await Provider.of<PPOBProvider>(context, listen: false).submitDisbursement(context, widget.token);
                      } 
                    } on CustomException catch(e) {
                      String error = e.toString();
                      Fluttertoast.showToast(
                        msg: error,
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: ColorResources.ERROR
                      );
                    } on ServerErrorException catch(e) {
                      Fluttertoast.showToast(
                        msg: e.toString(),
                        backgroundColor: ColorResources.ERROR,
                        toastLength: Toast.LENGTH_LONG,
                        textColor: ColorResources.WHITE
                      );  
                    } catch(e) {
                      print(e);
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: ColorResources.getPrimaryToWhite(context)
                  ),
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), 
                          spreadRadius: 1.0, 
                          blurRadius: 7.0, 
                          offset: Offset(0, 1)
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0)),
                      child: Consumer<AuthProvider>(
                        builder: (BuildContext context, AuthProvider authProvider, Widget child) {
                          return authProvider.authDisbursementStatus == AuthDisbursementStatus.loading 
                          ? Loader(
                              color: ColorResources.getWhiteToBlack(context),
                            )
                          : Text(getTranslated('SIGN_IN', context),
                            style: poppinsRegular.copyWith(
                              fontSize: 16.0,
                              color: ColorResources.getWhiteToBlack(context),
                            )
                          );
                        } 
                      )
                    ),
                  )  
                ),
                ],
              ),
            )
          ),
        );
      });
      } catch(e) {
        print(e);
      }
    }
    
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [

            CustomAppBar(title: "Cash out Information", isBackButtonExist: true),

            Container(
              margin: EdgeInsets.only(top: 90.0, bottom: 20.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total deduction",
                          style: poppinsRegular.copyWith(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        SizedBox(height: 8.0),
                        Text(ConnexistHelper.formatCurrency(double.parse(widget.totalDeduction.toString())),
                          style: poppinsRegular.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.getBlackToWhite(context)
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 20.0),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("Cash out on",
                          style: poppinsRegular.copyWith(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500
                          )
                        ),

                        Consumer<PPOBProvider>(
                          builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                            return StatefulBuilder(
                              builder: (BuildContext context, Function s) {
                                return ppobProvider.getGlobalPaymentMethodName != "" && 
                                ppobProvider.getGlobalPaymentAccount != "" 
                                ?  
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    child: Column(
                                      children: [

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${ppobProvider.getGlobalPaymentMethodName} - ${ppobProvider.getGlobalPaymentAccount}",
                                              style: poppinsRegular,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Provider.of<PPOBProvider>(context, listen: false).removePaymentMethod();
                                              },
                                              child: Icon(
                                                Icons.remove_circle,
                                                color: ColorResources.getPrimaryToWhite(context),  
                                              ),
                                            )
                                          ],
                                        ),

                                      ]
                                    ),
                                  )
                                : Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              elevation: MaterialStateProperty.resolveWith<double>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(MaterialState.disabled)) {
                                                    return 0;
                                                  }
                                                  return 0;
                                                },
                                              ),
                                              backgroundColor: MaterialStateProperty.all(ColorResources.getBlueToWhite(context)),
                                              
                                            ),
                                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListTileComponent(
                                              title: "Bank Transfer",
                                              items: ppobProvider.bankDisbursement
                                            ))),
                                            child: Text("Bank Transfer",
                                              style: poppinsRegular.copyWith(
                                                color: ColorResources.getWhiteToBlack(context)
                                              ),
                                            )
                                          ),
                                          SizedBox(width: 15.0),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              elevation: MaterialStateProperty.resolveWith<double>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(MaterialState.disabled)) {
                                                    return 0;
                                                  }
                                                  return 0;
                                                },
                                              ),
                                              backgroundColor: MaterialStateProperty.all(ColorResources.getBlueToWhite(context)),
                                            ),
                                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListTileComponent(
                                              title: "E Money",
                                              items: ppobProvider.emoneyDisbursement
                                            ))), 
                                            child: Text("E-Money",
                                              style: poppinsRegular.copyWith(
                                                color: ColorResources.getWhiteToBlack(context)
                                              ),
                                            )
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),                        
                       
                      ],
                    ),
                  ),

                  SizedBox(height: 10.0),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("Cash out detail",
                          style: poppinsRegular.copyWith(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500
                          )
                        ),

                        SizedBox(height: 8.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Cash out amount",
                              style: poppinsRegular.copyWith(
                                fontSize: 11.0
                              ),
                            ),
                            Text(ConnexistHelper.formatCurrency(double.parse(widget.totalDeduction.toString())),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: ColorResources.getBlackToWhite(context)
                              ),
                            )
                          ],
                        ),

                        SizedBox(height: 6.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Admin fee",
                              style: poppinsRegular.copyWith(
                                fontSize: 11.0
                              ),
                            ),
                            Text(ConnexistHelper.formatCurrency(double.parse(widget.adminFee.toString())),
                              style: poppinsRegular.copyWith(
                                fontSize: 12.0,
                                color: ColorResources.getBlackToWhite(context)
                              ),
                            )
                          ],
                        ),

                        Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total deduction",
                              style: TextStyle(
                                fontSize: 11.0
                              ),
                            ),
                            Text(ConnexistHelper.formatCurrency(double.parse(grandTotal.toString())),
                              style: poppinsRegular.copyWith(
                                fontSize: 12.0,
                                color: ColorResources.getBlackToWhite(context)
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: ColorResources.getBlackSoft(context),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                child: ElevatedButton(
                  onPressed: submit,
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
                    builder: (BuildContext context, PPOBProvider ppobProvider, Widget tchild) {
                      return ppobProvider.submitDisbursementStatus == SubmitDisbursementStatus.loading 
                      ? SizedBox(
                          width: 18.0,
                          height: 18.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(ColorResources.getWhiteToBlack(context)),
                          )
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