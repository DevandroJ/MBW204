import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:native_contact_picker/native_contact_picker.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/screens/ppob/confirm_payment.dart';
import 'package:mbw204_club_ina/views/basewidget/separator_dash.dart';

class ListVoucherPulsaByPrefixScreen extends StatefulWidget {
  @override
  _ListVoucherPulsaByPrefixScreenState createState() => _ListVoucherPulsaByPrefixScreenState();
}

class _ListVoucherPulsaByPrefixScreenState extends State<ListVoucherPulsaByPrefixScreen> {
  TextEditingController getController = TextEditingController();
  NativeContactPicker contactPicker = NativeContactPicker();
  Timer debounce;
  int selected;
  String phoneNumber;
  String nominal;
  
  phoneNumberChange() {
    if(getController.text.length >= 10) {
      if (getController.text.startsWith('0')) {
        phoneNumber = '62' + getController.text.replaceFirst(RegExp(r'0'), '');
      } else {
        phoneNumber = phoneNumber;
      }
      if (debounce?.isActive ?? false) debounce.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        Provider.of<PPOBProvider>(context, listen: false).getVoucherPulsaByPrefix(context, int.parse(phoneNumber));
      });
    } else {
      Provider.of<PPOBProvider>(context, listen: false).getVoucherPulsaByPrefix(context, 0);
    }
  }

  @override 
  void dispose() {
    super.dispose();
    debounce?.cancel();
    getController.removeListener(phoneNumberChange);
    getController.dispose();
  }

  @override 
  void initState() {
    super.initState();   
    getController.addListener(phoneNumberChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.BG_GREY,
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: getTranslated("TOPUP_PULSA", context), isBackButtonExist: true),
            
            Container(
              height: 60.0,
              width: double.infinity,
              margin: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0, bottom: 5.0),
              child: Card(
                color: Colors.white,
                elevation: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0)
                      ),
                      child: TextField(
                        controller: getController,
                        style: TextStyle(
                          color: ColorResources.BLACK
                        ),
                        decoration: InputDecoration(
                          hintText: getTranslated("PHONE_NUMBER", context),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(12.0)
                        ),
                        onSubmitted: (value) => setState(() => getController.text),
                        keyboardType: TextInputType.number,
                      )
                    ),
                    InkWell(
                      onTap: () async {
                        Contact contact = await contactPicker.selectContact();
                        if(contact != null) {
                          var selectedPhoneContact;
                          var selectedContact = contact.phoneNumber.replaceAll(RegExp("[()+\\s-]+"), "");
                          if (selectedContact.startsWith('0')) {
                            selectedPhoneContact = '62' + selectedContact.replaceFirst(RegExp(r'0'), '');
                          } else {
                            selectedPhoneContact = selectedContact;
                          }
                          setState(() {
                            getController = TextEditingController(text: selectedPhoneContact);
                            getController.addListener(phoneNumberChange);
                            Provider.of<PPOBProvider>(context, listen: false).getVoucherPulsaByPrefix(context, int.parse(selectedPhoneContact));
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.contacts,
                          color: ColorResources.BLACK
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  Consumer<PPOBProvider>(
                    builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                      if(ppobProvider.listVoucherPulsaByPrefixStatus == ListVoucherPulsaByPrefixStatus.loading) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Center(
                            child: SizedBox(
                              width: 18.0,
                              height: 18.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(ColorResources.BTN_PRIMARY),
                              )
                            )
                          ),
                        );
                      }
                      if(ppobProvider.listVoucherPulsaByPrefixStatus == ListVoucherPulsaByPrefixStatus.empty) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Center(
                            child: Text(getTranslated("DATA_NOT_FOUND", context),
                              style: poppinsRegular.copyWith(
                                color: ColorResources.BLACK
                              ),
                            ),
                          ),
                        );
                      }
                      if(ppobProvider.listVoucherPulsaByPrefixStatus == ListVoucherPulsaByPrefixStatus.error) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Center(
                            child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                              style: poppinsRegular.copyWith(
                                color: ColorResources.BLACK
                              ),
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: ppobProvider.listVoucherPulsaByPrefixData.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2 / 1
                        ),
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int i) {
                          return Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(5.0),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 0.5,
                                        color: selected == i ? ColorResources.PURPLE_DARK : Colors.transparent
                                      )
                                    ),
                                    // color: selected == i ? ColorResources.PRIMARY : ColorResources.WHITE,
                                    child: GestureDetector(
                                      onTap: () async {
                                        try {
                                          if(getController.text.length <= 11) {
                                            throw CustomException("PHONE_NUMBER_10_REQUIRED");
                                          }
                                          setState(() => selected = i);
                                          getController.removeListener(phoneNumberChange);
                                          showMaterialModalBottomSheet(        
                                            isDismissible: false,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                                            ),
                                            context: context,
                                            builder: (ctx) => SingleChildScrollView(
                                              child: Container(
                                                height: 320.0,
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
                                                              Text(getTranslated("PHONE_NUMBER", context)),
                                                              Text(getController.text)
                                                            ],
                                                          ),
                                                          SizedBox(height: 8.0),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(ppobProvider.listVoucherPulsaByPrefixData[i].description),
                                                              Text(ConnexistHelper.formatCurrency(double.parse(ppobProvider.listVoucherPulsaByPrefixData[i].price.toString())))
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
                                                              Text(getTranslated("VOUCHER_PRICE", context),
                                                                style: poppinsRegular,
                                                              ),
                                                              Text(ConnexistHelper.formatCurrency(ppobProvider.listVoucherPulsaByPrefixData[i].price),
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
                                                              Text(ConnexistHelper.formatCurrency(ppobProvider.listVoucherPulsaByPrefixData[i].price),
                                                                style: TextStyle(
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
                                                          child:TextButton(
                                                            style: TextButton.styleFrom(
                                                              elevation: 0.0,
                                                              backgroundColor: ColorResources.WHITE,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20.0),
                                                                side: BorderSide.none
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Future.delayed(Duration(seconds: 1), () {
                                                                getController.addListener(phoneNumberChange);
                                                              });
                                                              Navigator.of(ctx).pop();
                                                            },
                                                            child: Text(getTranslated("CHANGE", context),
                                                              style: poppinsRegular.copyWith(
                                                                color: ColorResources.PURPLE_DARK
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 140.0,
                                                          child: TextButton(
                                                            style: TextButton.styleFrom(
                                                              elevation: 0.0,
                                                              backgroundColor: ColorResources.PURPLE_DARK,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20.0),
                                                                side: BorderSide.none
                                                              )
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(context,
                                                                MaterialPageRoute(builder: (context) => ConfirmPaymentScreen(
                                                                  type: "pulsa",
                                                                  description: ppobProvider.listVoucherPulsaByPrefixData[i].description,
                                                                  nominal : ppobProvider.listVoucherPulsaByPrefixData[i].price,
                                                                  provider: ppobProvider.listVoucherPulsaByPrefixData[i].category.toLowerCase(),
                                                                  accountNumber: getController.text,
                                                                  productId: ppobProvider.listVoucherPulsaByPrefixData[i].productId,
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
                                        } on CustomException catch(e) {
                                          Fluttertoast.showToast(
                                            msg: getTranslated(e.toString(), context),
                                            backgroundColor: ColorResources.ERROR
                                          );
                                        } catch(e) {
                                          print(e);
                                        }
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
                                            Column(
                                              children: [
                                                Center(
                                                  child: Text(ppobProvider.listVoucherPulsaByPrefixData[i].name,
                                                    style: poppinsRegular.copyWith(
                                                      color: selected == i ? ColorResources.PURPLE_DARK : ColorResources.DIM_GRAY,
                                                      fontSize: 12.0
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 5.0),
                                              ],
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
                  )
                ],
              ),
            ),

          ]
        ),
      )
    );
  }
}