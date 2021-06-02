import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_expansion_tile.dart' as custom;

class VaScreen extends StatefulWidget {
  final String nextPage;
  final String type;

  VaScreen({
    this.nextPage,
    this.type
  });

  @override
  _VaScreenState createState() => _VaScreenState();
}

class _VaScreenState extends State<VaScreen> {
  int selectedIndex;

  @override
  Widget build(BuildContext context) {

    Provider.of<PPOBProvider>(context, listen: false).getBalance(context);
    Provider.of<PPOBProvider>(context, listen: false).getVA(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [ 
        
            Positioned.fill(
              top: 70.0,
              child: ListView(
                children: [
                  Card(
                    margin: EdgeInsets.only(left: 12.0, right: 12.0),
                    child: custom.ExpansionTile(
                    initiallyExpanded: true,
                    headerBackgroundColor: ColorResources.PRIMARY,
                    iconColor: Colors.white,
                    title: Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Text("Pilih Cara Pembayaran",
                            style: TextStyle(color: Colors.white),
                          )
                        )
                      ],
                    ),
                    children: [
                      if(widget.type == "pln")
                        vaComponent(),
                      if(widget.type == "pulsa")
                        walletComponent(),
                    ],
                  ) 
                ),
              ]
            ),
          ),


          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60.0,
              color: Colors.white,
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 5.0),
              width: double.infinity,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                color: ColorResources.PRIMARY,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Lanjut",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: ColorResources.WHITE
                  ),
                ),
              ),
            ),
          ),

          ]
        )
      )
    );
  }



  Widget vaComponent() {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text( "Transfer",
              style: TextStyle(
                color: ColorResources.PRIMARY
              ),
            )
          )
        ],
      ),
      children: [
        Consumer<PPOBProvider>(
          builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
            if(ppobProvider.vaStatus == VaStatus.loading) {
              return Container();
            }
            return ListView.builder(
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: ppobProvider.listVa.length,
              itemBuilder: (BuildContext context, int i) {
                return Row(
                  children: [
                  Expanded(
                    child: Container(
                    height: 70.0,
                    margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          width: 1, 
                          color: ColorResources.PRIMARY
                        )
                      ),
                      color: ColorResources.WHITE,
                      child: GestureDetector(
                      onTap: () {
                        setState(() => selectedIndex = i);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selectedIndex == i ? ColorResources.PRIMARY : Colors.transparent,
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
                                      color: selectedIndex == i ? ColorResources.WHITE : ColorResources.PRIMARY
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
            });
          },
        )
      ],
    );
  }

  Widget walletComponent() {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Row(
        children: [
          Container(
              margin: EdgeInsets.only(left: 5),
              child: Text( "e-Rupiah",
                style: TextStyle(
                  color: ColorResources.PRIMARY
                ),
              )
            )
        ],
      ),
      children: [
        Consumer<PPOBProvider>(
          builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
            if(ppobProvider.balanceStatus == BalanceStatus.loading) {
              return Container();
            }
            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
              padding: EdgeInsets.all(10.0),
              child: Text(
                ConnexistHelper.formatCurrency(double.parse(ppobProvider.balance.toString())),
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            );
          },
        )
      ],
    );
  }
}