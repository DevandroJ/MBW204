import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
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
  GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();
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
          ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
            SnackBar(
              backgroundColor: ColorResources.ERROR,
              content: Text("Please select destination cash out method",
                style: poppinsRegular,
              )
            )
          );
          return;
        }
        if(Provider.of<PPOBProvider>(context, listen: false).getGlobalPaymentAccount.trim().isEmpty) {
          ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
            SnackBar(
              backgroundColor: ColorResources.ERROR,
              content: Text("Please fill no account",
                style: poppinsRegular,
              )
            )
          );
          return;
        }
        showMaterialModalBottomSheet(
          context: context, 
          builder: (context) {
            return Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Container(
                height: 50.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16, bottom: 20.0),
                      child: Text(getTranslated("ENTER_YOUR_PASSWORD", context),
                        style: poppinsRegular.copyWith(
                          fontSize: 9.0.sp 
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(
                        left: Dimensions.MARGIN_SIZE_DEFAULT, 
                        right: Dimensions.MARGIN_SIZE_DEFAULT, 
                        bottom: Dimensions.MARGIN_SIZE_DEFAULT
                      ),
                      child: CustomPasswordTextField(
                        hintTxt: getTranslated("PASSWORD", context),
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
                        ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
                          SnackBar(
                            backgroundColor: ColorResources.ERROR,
                            content: Text(error,
                              style: poppinsRegular,
                            )
                          )
                        );
                      } on ServerErrorException catch(e) {
                        String error = e.toString();
                        ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
                          SnackBar(
                            backgroundColor: ColorResources.ERROR,
                            content: Text(error,
                              style: poppinsRegular,
                            )
                          )
                        );  
                      } catch(_) {}
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: ColorResources.BTN_PRIMARY
                    ),
                    child: Container(
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
                                color: ColorResources.WHITE,
                              )
                            : Text(getTranslated('CONTINUE', context),
                              style: poppinsRegular.copyWith(
                                fontSize: 9.0.sp,
                                color: ColorResources.WHITE,
                              )
                            );
                          } 
                        )
                      ),
                    )  
                  ),
                  ],
                ),
              ),
            )
          );
      });
      } catch(e) {
        print(e);
      }
    }
    
    return Scaffold(
      key: globalKey,
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
                            fontSize: 9.0.sp,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        SizedBox(height: 8.0),
                        Text(ConnexistHelper.formatCurrency(double.parse(widget.totalDeduction.toString())),
                          style: poppinsRegular.copyWith(
                            fontSize: 9.0.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.BLACK
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 20.0),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("Cash out on",
                        style: poppinsRegular.copyWith(
                          fontSize: 9.0.sp,
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
                                            style: poppinsRegular.copyWith(
                                              fontSize: 9.0.sp
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Provider.of<PPOBProvider>(context, listen: false).removePaymentMethod();
                                            },
                                            child: Icon(
                                              Icons.remove_circle,
                                              color: ColorResources.BTN_PRIMARY,  
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
                                            backgroundColor: MaterialStateProperty.all(ColorResources.BTN_PRIMARY),
                                            
                                          ),
                                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListTileComponent(
                                            title: "Bank Transfer",
                                            items: ppobProvider.bankDisbursement
                                          ))),
                                          child: Text("Bank Transfer",
                                            style: poppinsRegular.copyWith(
                                              fontSize: 9.0.sp,
                                              color: ColorResources.WHITE
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
                                            backgroundColor: MaterialStateProperty.all(ColorResources.BTN_PRIMARY),
                                          ),
                                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListTileComponent(
                                            title: getTranslated("E_MONEY", context),
                                            items: ppobProvider.emoneyDisbursement
                                          ))), 
                                          child: Text(getTranslated("E_MONEY", context),
                                            style: poppinsRegular.copyWith(
                                              fontSize: 9.0.sp,
                                              color: ColorResources.WHITE
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

                  SizedBox(height: 10.0),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("Cash out detail",
                          style: poppinsRegular.copyWith(
                            fontSize: 9.0.sp,
                            fontWeight: FontWeight.w500
                          )
                        ),

                        SizedBox(height: 8.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Cash out amount",
                              style: poppinsRegular.copyWith(
                                fontSize: 9.0.sp
                              ),
                            ),
                            Text(ConnexistHelper.formatCurrency(double.parse(widget.totalDeduction.toString())),
                              style: poppinsRegular.copyWith(
                                fontSize: 9.0.sp,
                                color: ColorResources.BLACK
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
                                fontSize: 9.0.sp
                              ),
                            ),
                            Text(ConnexistHelper.formatCurrency(double.parse(widget.adminFee.toString())),
                              style: poppinsRegular.copyWith(
                                fontSize: 9.0.sp,
                                color: ColorResources.BLACK
                              ),
                            )
                          ],
                        ),

                        Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total deduction",
                              style: poppinsRegular.copyWith(
                                fontSize: 9.0.sp
                              ),
                            ),
                            Text(ConnexistHelper.formatCurrency(double.parse(grandTotal.toString())),
                              style: poppinsRegular.copyWith(
                                fontSize: 9.0.sp,
                                color: ColorResources.BLACK
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
                color: Colors.transparent,
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
                    backgroundColor: MaterialStateProperty.all(ColorResources.BTN_PRIMARY),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
                            valueColor: AlwaysStoppedAnimation<Color>(ColorResources.WHITE),
                          )
                        )
                      : Text(getTranslated("CONTINUE", context),
                        style: poppinsRegular.copyWith(
                          color: ColorResources.WHITE,
                          fontSize: 9.0.sp
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