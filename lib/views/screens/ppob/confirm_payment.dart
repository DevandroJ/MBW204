import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/basewidget/separator_dash.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  final String productId;
  final String transactionId;
  final String description;
  final double nominal;
  final int bankFee;
  final String provider;
  final String accountNumber;
  final String type;

  ConfirmPaymentScreen({
    this.productId,
    this.transactionId,
    this.description,
    this.nominal,
    this.bankFee,
    this.provider,
    this.accountNumber,
    this.type
  });

  @override
  _ConfirmPaymentScreenState createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  bool method = false;
  bool loadingBuyBtn = false;
  String methodName = "";
  String paymentChannel = "";
  int selectedIndex;

  @override
  Widget build(BuildContext context) {

    Provider.of<PPOBProvider>(context, listen: false).getVA(context);

    return Scaffold(
      backgroundColor: ColorResources.BG_GREY,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CustomAppBar(title: getTranslated("CONFIRM_PAYMENT", context)),
            
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: double.infinity,
                height: 150.0,
                margin: EdgeInsets.only(bottom: 4.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: ColorResources.WHITE,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/icons/ic-${widget.provider}.png',
                          width: 32.0,
                          height: 32.0,
                        ),
                        SizedBox(width: 15.0),
                        Text(widget.description.toUpperCase(),
                          style: poppinsRegular.copyWith(
                            fontSize: 13.0,
                            color: ColorResources.BLACK
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 0.2,
                      )
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0, left: 12.0, right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(getTranslated("PAYMENT", context),
                                style: poppinsRegular.copyWith(
                                  fontSize: 12.0,
                                  color: ColorResources.DIM_GRAY.withOpacity(0.8)
                                )
                              ),
                              SizedBox(height: 5.0),   
                              Stack(
                                children: [
                                  if(widget.bankFee != null)                                   
                                    Container(
                                      margin: EdgeInsets.only(left: 18.0),
                                      child: Text(ConnexistHelper.formatCurrency(double.parse(widget.nominal.toString()) + double.parse(widget.bankFee.toString())),
                                        style: poppinsRegular.copyWith(
                                          fontSize: 20.0,
                                          color: ColorResources.BLACK
                                        )
                                      ),
                                    ),
                                  if(widget.bankFee == null)      
                                    Container(
                                      margin: EdgeInsets.only(left: 18.0),
                                      child: Text(ConnexistHelper.formatCurrency(double.parse(widget.nominal.toString())),
                                        style: poppinsRegular.copyWith(
                                          fontSize: 20.0,
                                          color: ColorResources.BLACK
                                        )
                                      ),
                                    )
                                ],
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              showMaterialModalBottomSheet(        
                                isDismissible: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                                ),
                                context: context,
                                builder: (ctx) => SingleChildScrollView(
                                  child: Container(
                                    height:  widget.bankFee != null ? 290.0 : 260.0,
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
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                )
                                              ),
                                              SizedBox(height: 12.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  if(widget.type == "pulsa" || widget.type == "register" || widget.type == "emoney" || widget.type == "topup")
                                                    Text(getTranslated("PHONE_NUMBER", context), style: poppinsRegular),
                                                  if(widget.type == "pln-prabayar")
                                                    Text(getTranslated("METER_NUMBER", context), style: poppinsRegular),
                                                  if(widget.type == "pln-pascabayar")
                                                    Text(getTranslated("CUSTOMER_ID", context), style: poppinsRegular),
                                                  Text(widget.accountNumber, style: poppinsRegular)
                                                ],
                                              ),
                                              SizedBox(height: 8.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(widget.description),
                                                  Text(ConnexistHelper.formatCurrency(double.parse(widget.nominal.toString())))
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
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                )
                                              ),
                                              SizedBox(height: 12.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  if(widget.type == "register")
                                                    Text(getTranslated("REGISTRATION_FEE", context), style: poppinsRegular),
                                                  if(widget.type == "pulsa" || widget.type == "emoney" || widget.type == "topup")
                                                    Text(getTranslated("VOUCHER_PRICE", context), style: poppinsRegular),
                                                  if(widget.type == "pln-prabayar")
                                                    Text(getTranslated("VOUCHER_PRICE", context), style: poppinsRegular),
                                                  if(widget.type == "pln-pascabayar")
                                                    Text(getTranslated("BILLS_TO_PAY", context), style: poppinsRegular),
                                                  Text(ConnexistHelper.formatCurrency(double.parse(widget.nominal.toString())))
                                                ],
                                              ),
                                              SizedBox(height: 10.0),
                                              if(widget.bankFee != null)
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Bank Fee",
                                                      style: poppinsRegular,
                                                    ),
                                                    Text(ConnexistHelper.formatCurrency(double.parse(widget.bankFee.toString())),
                                                      style: poppinsRegular,
                                                    )
                                                  ],
                                                ),
                                              if(widget.bankFee != null)
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
                                                  if(widget.bankFee != null)
                                                    Text(ConnexistHelper.formatCurrency(double.parse(widget.nominal.toString()) +  double.parse(widget.bankFee.toString())),
                                                      style: poppinsRegular.copyWith(
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  if(widget.bankFee == null)  
                                                    Text(ConnexistHelper.formatCurrency(double.parse(widget.nominal.toString())),
                                                      style: poppinsRegular.copyWith(
                                                        fontWeight: FontWeight.bold
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
                                ),
                              );
                            },
                            child: Text(getTranslated("SEE_DETAILS", context),
                              style: poppinsRegular.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w800,
                                color: ColorResources.BTN_PRIMARY
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ) 
              ),
            ),

          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Text(getTranslated("METHOD_PAYMENT", context),
              style: poppinsRegular.copyWith(
                color: ColorResources.BLACK
              )
            ),
          ),

          if(widget.type == "topup" || widget.type == "register")
            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                if(ppobProvider.vaStatus == VaStatus.loading) {
                  return Container();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: ppobProvider.listVa.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Row(
                        children: [
                        Expanded(
                          child: Container(
                          margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
                          child: Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                width: 1, 
                                color: ColorResources.BTN_PRIMARY
                              )
                            ),
                            color: ColorResources.WHITE,
                            child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = i;
                                paymentChannel = ppobProvider.listVa[i].channel;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: selectedIndex == i ? ColorResources.BTN_PRIMARY : Colors.transparent,
                                borderRadius: BorderRadius.circular(4.0)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        child: CachedNetworkImage(
                                          imageUrl: ppobProvider.listVa[i].paymentLogo,
                                          height: 30.0,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Center(
                                            child: Shimmer.fromColors(
                                            baseColor: Colors.grey[200],
                                            highlightColor: Colors.grey[300],
                                            child: Container(
                                              color: Colors.white,
                                              height: double.infinity,
                                            ),
                                          )),
                                          errorWidget: (context, url, error) => Center(
                                            child: Image.asset("assets/default_image.png",
                                            height: 20.0,
                                            fit: BoxFit.cover,
                                          )),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          ppobProvider.listVa[i].name,
                                          style: TextStyle(
                                            color: selectedIndex == i ? ColorResources.WHITE : ColorResources.BTN_PRIMARY
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))),
                      ],
                    );
                  }),
                );
              },
            ),
          if(widget.type != "topup" && widget.type != "register")
            Expanded(
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  padding: EdgeInsets.all(10.0),
                  color: ColorResources.WHITE,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("e-Rupiah",
                                style: poppinsRegular.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: ColorResources.BLACK
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Consumer<PPOBProvider>(
                                builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                                  return Text(
                                    ppobProvider.balanceStatus == BalanceStatus.loading 
                                    ? "..."
                                    : ppobProvider.balanceStatus == BalanceStatus.error 
                                    ?  "..."
                                    : ConnexistHelper.formatCurrency(double.parse(ppobProvider.balance.toString())),
                                    style: poppinsRegular.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ColorResources.BLACK
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0)
                            ),
                            child: CircularCheckBox(
                              inactiveColor: ColorResources.DIM_GRAY,
                              activeColor: ColorResources.PRIMARY,
                              value: method,
                              onChanged: (val) {
                                setState(() {
                                  method = val;
                                  methodName = val ? "wallet" : "";
                                });
                              },
                            )
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),     
            ),
            Container(
              color: ColorResources.BG_GREY,
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 15.0, bottom: 15.0),
              width: double.infinity,
              height: 80.0,
              child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ColorResources.BTN_PRIMARY_SECOND,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
              ),
              onPressed: () async {
                try {
                  if(widget.type != "topup" && widget.type != "register") {
                    if(methodName == "") {
                      throw CustomException("PLEASE_SELECT_BANK");
                    }
                  } else {
                    if(paymentChannel == "") {
                      throw CustomException("PLEASE_SELECT_BANK");
                    }
                  }
                  switch (widget.type) {
                    case "pulsa":
                      await Provider.of<PPOBProvider>(context, listen: false).purchasePulsa(context, widget.productId, widget.accountNumber);
                    break;
                    case "register": 
                      await Provider.of<PPOBProvider>(context, listen: false).payRegister(context, widget.productId, paymentChannel, widget.transactionId);
                    break;
                    case "emoney":
                      await Provider.of<PPOBProvider>(context, listen: false).purchaseEmoney(context, widget.productId, widget.accountNumber);
                    break;
                    case "pln-prabayar":
                      final getTransactionId = Provider.of<PPOBProvider>(context, listen: false).inquiryPLNPrabayarData.transactionId;
                      await Provider.of<PPOBProvider>(context, listen: false).payPLNPrabayar(context, widget.productId, widget.accountNumber, getTransactionId);
                    break;  
                    case "pln-pascabayar":
                      final getTransactionId = Provider.of<PPOBProvider>(context, listen: false).inquiryPLNPascaBayarData.transactionId;
                      await Provider.of<PPOBProvider>(context, listen: false).payPLNPascabayar(context, widget.accountNumber, getTransactionId);
                    break;
                    case "topup":
                      await Provider.of<PPOBProvider>(context, listen: false).inquiryTopUp(context, widget.productId, widget.accountNumber);
                      final inquiryTopUpData = Provider.of<PPOBProvider>(context, listen: false).inquiryTopUpData;
                      await Provider.of<PPOBProvider>(context, listen: false).payTopUp(context, inquiryTopUpData.productId, paymentChannel, inquiryTopUpData.transactionId);
                    break;
                    default:
                  }
                } on CustomException catch(e) {
                  Fluttertoast.showToast(
                    msg: getTranslated(e.toString(), context),
                    backgroundColor: ColorResources.ERROR
                  );
                } on ServerErrorException catch(e) {
                  Fluttertoast.showToast(
                    msg: e.toString(),
                    backgroundColor: ColorResources.ERROR
                  );
                } catch(e) {
                  print(e);
                }
              },
              child: Consumer<PPOBProvider>(
                builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                  return ppobProvider.loadingBuyBtn ? Center(
                    child: SizedBox(
                      width: 18.0,
                      height: 18.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(ColorResources.WHITE),
                      ),
                    ),
                  ) : Text(getTranslated("PAY", context),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.WHITE,
                    ),
                  );
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}