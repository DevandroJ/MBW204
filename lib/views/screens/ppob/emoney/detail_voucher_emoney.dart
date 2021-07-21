import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:native_contact_picker/native_contact_picker.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/views/basewidget/separator_dash.dart';
import 'package:mbw204_club_ina/views/screens/ppob/confirm_payment.dart';

class DetailVoucherEmoneyScreen extends StatefulWidget {
  final String type;

  DetailVoucherEmoneyScreen({
    this.type
  });

  @override
  _DetailVoucherEmoneyScreenState createState() => _DetailVoucherEmoneyScreenState();
}

class _DetailVoucherEmoneyScreenState extends State<DetailVoucherEmoneyScreen> {
  int selected;
  TextEditingController getController = TextEditingController();
  NativeContactPicker contactPicker = NativeContactPicker();

  @override
  Widget build(BuildContext context) {

    Provider.of<PPOBProvider>(context, listen: false).getListEmoney(context, widget.type);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: widget.type, isBackButtonExist: true),
            
            Container(
              height: 60.0,
              width: double.infinity,
              margin: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0, bottom: 5.0),
              child: Card(
                color: ColorResources.WHITE,
                elevation: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: ColorResources.WHITE,
                        borderRadius: BorderRadius.circular(4.0)
                      ),
                      child: TextField(
                        controller: getController,
                        style: poppinsRegular.copyWith(
                          color: ColorResources.BLACK
                        ),
                        decoration: InputDecoration(
                          hintText: "No Ponsel",
                          fillColor: ColorResources.WHITE,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(12.0)
                        ),
                        onSubmitted: (val) {
                          setState(() => getController.text);
                        },
                        keyboardType: TextInputType.number,
                      )
                    ),
                    GestureDetector(
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
                          });
                        } 
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.contacts,
                          color: ColorResources.BLACK,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                if(ppobProvider.listTopUpEmoneyStatus == ListTopUpEmoneyStatus.loading)
                  return Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 18.0,
                        height: 18.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(ColorResources.BTN_PRIMARY,
                        )
                      )
                    )
                  ));
                if(ppobProvider.listTopUpEmoneyStatus == ListTopUpEmoneyStatus.empty) {
                  return Expanded(
                    child: Center(
                      child: Text("Data tidak ditemukan"),
                    ),
                  );
                }
                if(ppobProvider.listTopUpEmoneyStatus == ListTopUpEmoneyStatus.error) {
                  return Expanded(
                    child: Center(
                      child: Text("Ups! Terjadi kesalahan, mohon ulangi kembali"),
                    ),
                  );
                }
                return Expanded(
                  child: StatefulBuilder(
                    builder: (BuildContext context, Function s) {
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: ppobProvider.listTopUpEmoney.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0,
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
                                  height: 80.0,
                                  child: Card(
                                    elevation: 0.0,
                                    color: ColorResources.WHITE,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: selected == i ? ColorResources.PURPLE_LIGHT : Colors.transparent,
                                        width: 0.5
                                      )
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                      try {
                                        if(getController.text.length <= 11) {
                                          throw CustomException("Nomor Ponsel minimal 10 karakter");
                                        }
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
                                                            child: Text("Informasi Pelanggan",
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
                                                              Text("Nomor Ponsel"),
                                                              Text(getController.text)
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
                                                            child: Text("Detail Pembayaran",
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
                                                              Text("Harga Voucher"),
                                                              Text(ConnexistHelper.formatCurrency(double.parse(ppobProvider.listTopUpEmoney[i].price.toString())))
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
                                                              Text("Total Pembayaran",
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                              Text(ConnexistHelper.formatCurrency(double.parse(ppobProvider.listTopUpEmoney[i].price.toString())),
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
                                                          child: RaisedButton(
                                                            elevation: 0.0,
                                                            color: ColorResources.WHITE,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20.0),
                                                              side: BorderSide.none
                                                            ),
                                                            onPressed: () {
                                                              s(() { selected = null; });
                                                              Navigator.of(ctx).pop();
                                                            },
                                                            child: Text("Ubah",
                                                              style: TextStyle(
                                                                color: ColorResources.PURPLE_DARK
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 140.0,
                                                          child: RaisedButton(
                                                            elevation: 0.0,
                                                            color: ColorResources.PURPLE_DARK,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20.0),
                                                              side: BorderSide.none
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(ctx,
                                                                MaterialPageRoute(builder: (ctx) => ConfirmPaymentScreen(
                                                                  type: "emoney",
                                                                  description: ppobProvider.listTopUpEmoney[i].description,
                                                                  nominal : ppobProvider.listTopUpEmoney[i].price,
                                                                  provider: ppobProvider.listTopUpEmoney[i].category.toLowerCase(),
                                                                  accountNumber: getController.text,
                                                                  productId: ppobProvider.listTopUpEmoney[i].productId,
                                                                )),
                                                              );
                                                            },
                                                            child: Text("Konfirmasi",
                                                              style: TextStyle(
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
                                            msg: e.toString(),
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
                                                  child: Text(ppobProvider.listTopUpEmoney[i].name,
                                                    style: TextStyle(
                                                      color: selected == i ? ColorResources.PURPLE_DARK : ColorResources.DIM_GRAY.withOpacity(0.8),
                                                      fontSize: 12.0
                                                    ),
                                                  ),
                                                ),
                                                // SizedBox(height: 5.0),
                                                // Center(
                                                //   child: Text(NumberFormat("###,000", "id_ID").format(ppobProvider.listTopUpEmoney[i].price),
                                                //     style: TextStyle(
                                                //       color: selected == i ? ColorResources.WHITE : ColorResources.PRIMARY,
                                                //       fontSize: 12.0
                                                //     ),
                                                //   )
                                                // ),
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