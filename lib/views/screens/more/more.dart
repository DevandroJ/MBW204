import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/views/screens/warung/beranda_toko.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/providers/theme.dart';
import 'package:mbw204_club_ina/views/screens/setting/settings.dart';
import 'package:mbw204_club_ina/views/screens/ppob/topup/history.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/views/screens/ppob/cashout/list.dart';
import 'package:mbw204_club_ina/views/screens/about/about.dart';
import 'package:mbw204_club_ina/views/screens/ppob/topup/topup.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart' as animated_dialog;
import 'package:mbw204_club_ina/views/basewidget/animated_custom_dialog.dart' as custom_animated_dialog;
import 'package:mbw204_club_ina/views/screens/more/webview.dart';
import 'package:mbw204_club_ina/views/screens/profile/profile.dart';
import 'package:mbw204_club_ina/views/screens/more/widgets/signout.dart';
import 'package:mbw204_club_ina/views/screens/warung/form_toko.dart';

import '../../../providers/ppob.dart';
import '../../../utils/colorResources.dart';
import '../../../utils/custom_themes.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    Provider.of<WarungProvider>(context, listen: false).getDataStore(context, "seller");
    bool isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
     
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          
          Container(
            height: 250.0,
            decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage(Images.splash),
                fit: BoxFit.cover,
              )
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                alignment: Alignment.center,
                color: Colors.grey.withOpacity(0.1)
              ),
            ),
            )
          ),
          
          Positioned(
            top: 20.0,
            left: 0.0,
            right: 0.0,
            child: Consumer<ProfileProvider>(
              builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                return Stack(
                  children: [
                    Positioned(
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset('assets/images/id-card.png')  
                      ),
                    ),
                    Positioned(
                      top: 18.0,
                      left: 60.0,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: Text("Kartu Anggota",
                            style: poppinsRegular.copyWith(
                              color: ColorResources.WHITE,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0 * MediaQuery.of(context).textScaleFactor
                            )
                          ) 
                        )
                      ),
                    ),
                    Positioned(
                      top: 45.0,
                      left: 60.0,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: Text("Indomini Club",
                            style: poppinsRegular.copyWith(
                              color: ColorResources.WHITE,
                              fontWeight: FontWeight.w200,
                              letterSpacing: 3.2,
                              fontSize: 16.0 * MediaQuery.of(context).textScaleFactor
                            )
                          ) 
                        )
                      ),
                    ),
                    Positioned(
                      top: 18.0,
                      right: 60.0,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          child: Image.asset(Images.logo,
                            width: 45.0,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 60.0,
                      bottom: 40.0,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          child: Text(profileProvider.userProfile == null ? "..." : profileProvider.getUserFullname,
                            style: poppinsRegular.copyWith(
                              color: ColorResources.WHITE,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 18.0 * MediaQuery.of(context).textScaleFactor
                            )
                          ),
                        )
                      ),
                    ),
                    Positioned(
                      left: 60.0,
                      bottom: 18.0,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          child: Text(profileProvider.userProfile == null ? "..." : profileProvider.getUserIdNumber,
                            style: poppinsRegular.copyWith(
                              color: ColorResources.WHITE,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 18.0 * MediaQuery.of(context).textScaleFactor
                            )
                          ),
                        )
                      ),
                    ),
                    Positioned(
                      left: 62.0,
                      bottom: 75.0,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: profileProvider.userProfile == null 
                        ? CircleAvatar(
                            radius: 30.0,
                            backgroundColor: ColorResources.PRIMARY,
                            child: Image.asset(
                              Images.profile,
                              color: Colors.white,
                              width: 35.0,
                            ),
                          ) 
                        : CachedNetworkImage(
                          imageUrl: "${AppConstants.BASE_URL_IMG}${profileProvider.getUserProfilePic}",
                          imageBuilder: (BuildContext context, ImageProvider image) {
                            return CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              backgroundImage: image,
                            );
                          },
                          errorWidget: (BuildContext context, String url, dynamic error) {
                            return CircleAvatar(
                              radius: 30.0,
                              backgroundColor: ColorResources.PRIMARY,
                              child: Image.asset(
                                Images.profile,
                                color: Colors.white,
                                width: 35.0,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      right: 55.0,
                      bottom: 5.0,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          child: Image.asset(
                            Images.logo_cx,
                            color: ColorResources.WHITE,
                            width: 40.0,
                            height: 40.0,
                          )
                        )
                      ),
                    )
                  ]
                ); 
              },
            ) 
          ),
        Container(
          margin: EdgeInsets.only(top: 230.0),
          decoration: BoxDecoration(
            color: ColorResources.getBlackSoft(context),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), 
              topRight: Radius.circular(20.0)
            ),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [

              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

              Container(
                margin: EdgeInsets.only(left: 40.0, right: 22.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

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
                    Container(
                      child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.resolveWith<double>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return 0;
                          }
                          return 0;
                        },
                      ),
                      backgroundColor: MaterialStateProperty.all(ColorResources.getPrimary(context)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )
                      )),
                      //
                      onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => TopUpHistoryScreen())),
                        child: Text("History Saldo",
                          style: poppinsRegular.copyWith(
                            color: ColorResources.getWhiteToBlack(context),
                            fontStyle: FontStyle.italic
                          )
                        ),
                      )
                    ),

                  ],
                )
              ),

              Container(
                child: Column(
                  children: [
                  SwitchListTile(
                    dense: true,
                    contentPadding: EdgeInsets.only(left: 40.0, right: 25.0),
                    value: Provider.of<ThemeProvider>(context).darkTheme,
                    onChanged: (bool isActive) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                    title: Text(getTranslated('DARK_THEME', context), 
                    style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),
                  ],
                ),
              ),

              TitleButton(
                image: Images.profile, 
                title: getTranslated('PROFILE', context), 
                navigateTo: ProfileScreen()
              ),
              TitleButton(
                image: Images.topup, 
                title: getTranslated('TOPUP', context), 
                navigateTo: TopUpScreen()
              ),
              TitleButton(
                image: Images.cash_out, 
                title: getTranslated('CASH_OUT', context), 
                navigateTo: CashoutScreen()
              ),
              TitleButton(
                image: Images.settings, 
                title: getTranslated('SETTINGS', context), 
                navigateTo: SettingsScreen()
              ),
              // TitleButton(
              //   image: Images.shopping_image, 
              //   title: getTranslated('MY_STORE', context), 
              //   navigateTo: int.parse(Provider.of<PPOBProvider>(context, listen: false).balance.toStringAsFixed(0)) >= 50000 
              //   ? FormTokoPage() 
              //   : showAnimatedDialog(context, SignOutConfirmationDialog(), isFlip: true)
              // ),
              Consumer<WarungProvider>(
                builder: (BuildContext context, WarungProvider warungProvider, Widget child) {
                  return Container(
                  margin: EdgeInsets.only(left: 22.0, right: 22.0),
                  child: ListTile(
                  leading: Image.asset(
                    Images.shopping_image, width: 25.0, height: 25.0, 
                    fit: BoxFit.fill, 
                    color: ColorResources.getPrimaryToWhite(context)
                  ),
                  title: Text(getTranslated('MY_STORE', context), 
                    style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                    onTap: () {
                      int.parse(Provider.of<PPOBProvider>(context, listen: false).balance.toStringAsFixed(0)) >= 50000 
                      ? warungProvider.sellerStoreModel.code == 0 
                        ? Navigator.push(context,
                            MaterialPageRoute(builder: (context) => BerandaTokoPage()),
                          )
                        : Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FormTokoPage()),
                        ) 
                      : animated_dialog.showAnimatedDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return Dialog( 
                            child: Container(
                              height: 210.0,
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text("PERHATIAN !",
                                    style: titilliumBold,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text("Tenant/Penjual diwajibkan mengisi e-Wallet \n minimal Rp. 50.000,- untuk mengcover beban \n biaya yang timbul, jika tidak memproses \n pemesanan pembeli dalam waktu yang ditentukan",
                                    softWrap: true,
                                    style: poppinsRegular.copyWith(
                                      height: 1.8
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: ColorResources.getPrimary(context)
                                      ),
                                      onPressed: () => Navigator.of(context).pop(), 
                                      child: Text("Ok")
                                    ),
                                  )
                                ],
                              ),
                          ),
                          );
                        } 
                      );
                    },
                  ),
                );
                },
              ),
          
              
              TitleButton(
                image: Images.privacy_policy, 
                title: getTranslated('SUPPORT', context), 
                navigateTo: WebViewScreen(
                  title: getTranslated('SUPPORT', context),
                  url: 'https://connexist.com/mobile-bantuan',
                )
              ),
              TitleButton(
                image: Images.about_us, 
                title: getTranslated('ABOUT_US', context), 
                navigateTo: AboutUsScreen()
              ),
              isGuestMode 
              ? SizedBox() 
              : Container(
                margin: EdgeInsets.only(left: 22.0, right: 22.0),
                child: ListTile(
                  leading: Icon(
                    Icons.exit_to_app, 
                    size: 25.0,
                    color: ColorResources.getPrimaryToWhite(context), 
                  ),
                  title: Text(
                    getTranslated('SIGN_OUT', context), 
                    style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)
                  ),
                  onTap: () => custom_animated_dialog.showAnimatedDialog(context, SignOutConfirmationDialog(), isFlip: true),
                ),
              ),
              ]
            ),
          ),
        ),
      ]),
    );
  }
}

class SquareButton extends StatelessWidget {
  final String image;
  final String title;
  final Widget navigateTo;

  SquareButton({@required this.image, @required this.title, @required this.navigateTo});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 100;
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo)),
      child: Column(
        children: [
          Container(
            width: width / 4,
            height: width / 4,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: ColorResources.getPrimary(context),
            ),
            child: Image.asset(image, color: Theme.of(context).accentColor),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(title, style: poppinsRegular),
          ),
        ]
      ),
    );
  }
}

class TitleButton extends StatelessWidget {
  final String image;
  final String title;
  final Widget navigateTo;
  TitleButton({@required this.image, @required this.title, @required this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 22.0, right: 22.0),
      child: ListTile(
        leading: Image.asset(
          image, width: 25.0, height: 25.0, 
          fit: BoxFit.fill, 
          color: ColorResources.getPrimaryToWhite(context)
        ),
        title: Text(title, 
          style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo),
        ),
      ),
    );
  }
}

