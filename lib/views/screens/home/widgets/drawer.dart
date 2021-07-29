import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/views/screens/store/form_store.dart';
import 'package:mbw204_club_ina/views/screens/store/store_index.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/views/screens/ppob/cashout/list.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/views/screens/setting/settings.dart';
import 'package:mbw204_club_ina/views/screens/more/webview.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/screens/auth/sign_in.dart';
import 'package:mbw204_club_ina/views/basewidget/animated_custom_dialog.dart' as custom_widget;
import 'package:mbw204_club_ina/views/screens/more/widgets/signout.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/views/screens/about/about.dart';
import 'package:mbw204_club_ina/views/screens/profile/profile.dart';

class DrawerWidget extends StatefulWidget {

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  
  PackageInfo packageInfo;

  @override 
  void initState() {
    super.initState();
    (() async {
      PackageInfo _packageInfo = await PackageInfo.fromPlatform();
      setState(() {      
        packageInfo = PackageInfo(
          appName: _packageInfo.appName,
          buildNumber: _packageInfo.buildNumber,
          packageName: _packageInfo.packageName,
          version: _packageInfo.version
        );
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: ColorResources.WHITE
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            drawerHeader(context),

              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(top: 8.0, right: 10.0),
                child: Text("Version ${packageInfo?.version}+${packageInfo?.buildNumber}",
                  style: poppinsRegular.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.0
                  )
                ),
              ),

            Consumer<AuthProvider>(
              builder: (BuildContext context, AuthProvider authProvider, Widget child) {
                if(authProvider.isLoggedIn()) {
                  return drawerUserDisplayName(context);
                }
                return Container();
              },
            ),
            
            Consumer<AuthProvider>(
              builder: (BuildContext context, AuthProvider authProvider, Widget child) {
                if(authProvider.isLoggedIn()) {
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        drawerItems(context, AboutUsScreen(), "about", Images.logo_app, "${getTranslated("ABOUT", context)} MBW204\nClub Indonesia"),
                        drawerItems(context, ProfileScreen(), "profil", Images.profile_drawer, getTranslated("PROFILE", context)),
                        drawerItems(context, null, "store", Images.shopping_image, getTranslated("MY_STORE", context)),
                        drawerItems(context, null, "cashout", Images.cash_out, getTranslated("CASH_OUT", context)),
                        drawerItems(context, SettingsScreen(), "setting", Images.settings_drawer, getTranslated("SETTINGS", context)),
                        drawerItems(context, null, "bantuan", Images.bantuan_drawer, getTranslated("SUPPORT", context)),
                        drawerItems(context, null, "logout", Images.logout_drawer, getTranslated("LOGOUT", context))
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                      child: TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen())),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                          ),
                          backgroundColor: ColorResources.YELLOW_PRIMARY
                        ),
                        child: Text(getTranslated("SIGN_IN", context),
                          style: poppinsRegular.copyWith(
                            color: ColorResources.BLACK
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),

    
          ],
        ),
      ),
    );
  }


  Widget drawerHeader(BuildContext context) {
    return Container(
      height: 250.0,
      child: DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: Consumer<ProfileProvider>(
          builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
            if(profileProvider.profileStatus == ProfileStatus.loading) {
              return CircularProgressIndicator();
            }
            return CachedNetworkImage(
              errorWidget: (BuildContext context, String url, dynamic error) {
                return Container(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  decoration: BoxDecoration(
                    color: ColorResources.BLACK,
                  ),
                  child: Image.asset('assets/images/logo.png'),
                );
              },
              placeholder: (BuildContext context, String url) {
                return Container(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  decoration: BoxDecoration(
                    color: ColorResources.BLACK,
                  ),
                  child: Image.asset('assets/images/logo.png'),
                );
              },
              imageUrl: "${AppConstants.BASE_URL_IMG}${profileProvider?.userProfile?.profilePic}",
              imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fitWidth
                    ),
                  ),
                  child: Stack(
                    children: [

                      // Positioned(
                      //   top: 12.0,
                      //   right: 17.0,
                      //   child: Container(
                      //     width: 34.0,
                      //     height: 34.0,
                      //     decoration: BoxDecoration(
                      //       color: ColorResources.BTN_PRIMARY_SECOND,
                      //       borderRadius: BorderRadius.circular(20.0)
                      //     ),
                      //     child: Icon(
                      //       Icons.more_vert,
                      //       color: ColorResources.BLACK,
                      //       size: 17.0,
                      //     ),
                      //   ),
                      // ),

                      // Positioned(
                      //   top: 60.0,
                      //   right: 5.0,
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         width: 28.0,
                      //         height: 28.0,
                      //         decoration: BoxDecoration(
                      //           color: ColorResources.PINK_PRIMARY,
                      //           borderRadius: BorderRadius.circular(20.0)
                      //         ),
                      //         child: Icon(
                      //           Icons.edit,
                      //           color: ColorResources.BLACK,
                      //           size: 17.0,
                      //         ),
                      //       ),
                      //       SizedBox(height: 5.0),
                      //       Text("Edit Nama",
                      //         style: poppinsRegular.copyWith(
                      //           fontSize: 11.0,
                      //           color: ColorResources.WHITE
                      //         ),
                      //       )
                      //     ],
                      //   ) 
                      // ),

                      // Positioned(
                      //   top: 120.0,
                      //   right: 5.0,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //         width: 28.0,
                      //         height: 28.0,
                      //         decoration: BoxDecoration(
                      //           color: ColorResources.YELLOW_PRIMARY,
                      //           borderRadius: BorderRadius.circular(20.0)
                      //         ),
                      //         child: Icon(
                      //           Icons.camera_alt,
                      //           color: ColorResources.BLACK,
                      //           size: 17.0,
                      //         ),
                      //       ),
                      //       SizedBox(height: 5.0),
                      //       Text("Ganti Foto",
                      //         style: poppinsRegular.copyWith(
                      //           fontSize: 11.0,
                      //           color: ColorResources.WHITE
                      //         ),
                      //       )
                      //     ],
                      //   )
                      // ),

                      // Positioned(
                      //   bottom: 0.0,
                      //   child: Container(
                      //     padding: EdgeInsets.zero,
                      //     margin: EdgeInsets.zero,
                      //     width: 303.0,
                      //     height: 30.0,
                      //     decoration: BoxDecoration(
                      //       color: ColorResources.WHITE,
                      //       borderRadius: BorderRadius.only(
                      //         topLeft: Radius.circular(20.0),
                      //         topRight: Radius.circular(20.0)
                      //       )
                      //     ),   
                      //   ),     
                      // ),
                      
                    ]
                  )
                );
              },
            );

            
          },
        ) 
      ),
    );
  }

  Widget drawerUserDisplayName(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.0),
      child: Consumer<ProfileProvider>(
        builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
          return Column(
            children: [
              Text(profileProvider.profileStatus == ProfileStatus.loading 
                ? "..." 
                : profileProvider.profileStatus == ProfileStatus.error 
                ? "..." 
                : profileProvider.getUserFullname,
                style: poppinsRegular.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold
                )
              ),
              Text("ID ${profileProvider.profileStatus == ProfileStatus.loading 
                ? "..." 
                : profileProvider.profileStatus == ProfileStatus.error 
                ? "..." 
                : profileProvider.getUserIdNumber}",
                style: poppinsRegular.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 11.0
                )
              ),
            ],
          );
        },
      ),
    );
  }

  Widget drawerItems(BuildContext context, Widget widget, String menu, String icon, String title) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: ListTile(
        dense: true,
        isThreeLine: false,
        visualDensity: VisualDensity(horizontal: 0.0, vertical: -1.0),
        minVerticalPadding: 0.0,
        minLeadingWidth: 0.0,
        contentPadding: EdgeInsets.symmetric(vertical: 0.0),
        onTap: () { 
          if(menu == "logout") {
            custom_widget.showAnimatedDialog(
              context,
              SignOutConfirmationDialog(),
              isFlip: true
            );
            // showAnimatedDialog(
            //   barrierDismissible: true,
            //   context: context,
            //   builder: (BuildContext context) {
            //     return Dialog(
            //       child: Padding(
            //         padding: EdgeInsets.all(8.0),
            //         child: Container(
            //           height: 110.0,
            //           child: Container(
            //             margin: EdgeInsets.only(top: 20.0),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Text("Apa kamu ingin Logout?",
            //                   style: poppinsRegular.copyWith(
            //                     fontWeight: FontWeight.bold
            //                   ),
            //                 ),
            //                 SizedBox(height: 15.0),
            //                 Container(
            //                   child: Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                     children: [
            //                       ElevatedButton(
            //                         style: ElevatedButton.styleFrom(
            //                           primary: ColorResources.BTN_PRIMARY,
            //                         ),
            //                         onPressed: () => Navigator.of(context).pop(), 
            //                         child: Text("Tidak")
            //                       ),
            //                       ElevatedButton(
            //                         style: ElevatedButton.styleFrom(
            //                           primary: ColorResources.BTN_PRIMARY_SECOND
            //                         ),
            //                         onPressed: () => SignOutConfirmationDialog(), 
            //                         child: Text("Ya")
            //                       ),
            //                     ],
            //                   ),
            //                 )
            //               ],
            //             )
            //           )
            //         ),
            //       ),
            //     );
            //   },
            // );
          } else if(menu == "store") {
            int balance = int.parse(Provider.of<PPOBProvider>(context, listen: false).balance.toStringAsFixed(0));
            if(balance >= 50000) {
              if(Provider.of<WarungProvider>(context, listen: false).sellerStoreModel?.code == 0) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StoreScreen()));
              } else {
                Navigator.push(context,  MaterialPageRoute(builder: (context) => FormStoreScreen()));
              }
            } else {
              showAnimatedDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return Dialog( 
                    child: Container(
                      height: 230.0,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text("${getTranslated("ATTENTION", context)} !",
                            style: poppinsRegular,
                          ),
                          SizedBox(height: 8.0),
                          Text("Tenant/Penjual diwajibkan mengisi e-Wallet minimal Rp. 50.000,- untuk mengcover beban biaya yang timbul, jika tidak memproses pemesanan pembeli dalam waktu yang ditentukan",
                            softWrap: true,
                            textAlign: TextAlign.justify,
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
                                primary: ColorResources.DIM_GRAY
                              ),
                              onPressed: () => Navigator.of(context).pop(), 
                              child: Text("OK",
                                style: poppinsRegular,
                              )
                            ),
                          )
                        ],
                      ),
                    ),
                  );      
                }
              );
            }
          } else if(menu == "cashout") {
            Navigator.push(context,  MaterialPageRoute(builder: (context) => CashoutScreen()));
          } else if(menu == "tos") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(
              title: 'Term of Service',
              url: 'https://connexist.com/mobile-bantuan'
            )));
          } else if(menu == "bantuan") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(
              title: 'Bantuan',
              url: 'https://commboard.connexist.id/contactus'
            )));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
          }
        },  
        title: Text(title,
          style: poppinsRegular.copyWith(
            fontSize: 13.0
          ),
        ),
        leading: Container(
          width: 20.0,
          height: 20.0,
          child: Container(
            child: Image.asset(icon,
              color: menu == "store" ? ColorResources.BLACK : null,
            )
          )
        ),
      )
    );
  }
  
}