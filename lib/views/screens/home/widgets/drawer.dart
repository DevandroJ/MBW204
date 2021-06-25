import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:provider/provider.dart';

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
import 'package:mbw204_club_ina/views/screens/auth/change_password.dart';
import 'package:mbw204_club_ina/views/screens/profile/profile.dart';

class DrawerWidget extends StatefulWidget {

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

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
                    padding: EdgeInsets.only(top: 0, bottom: 20.0, left: 10.0, right: 10.0),
                    child: Column(
                      children: [
                        drawerItems(context, AboutUsScreen(), "about", Images.logo_app, "${getTranslated("ABOUT", context)} MBW204\nClub Indonesia"),
                        drawerItems(context, ProfileScreen(), "profil", Images.profile_drawer, getTranslated("PROFILE", context)),
                        drawerItems(context, ProfileScreen(), "setting", Images.settings_drawer, getTranslated("SETTINGS", context)),
                        drawerItems(context, ChangePasswordScreen(), "ubah-kata-sandi", Images.lock_drawer, "Ubah Kata Sandi"),
                        drawerItems(context, ProfileScreen(), "tos", Images.tos_drawer, getTranslated("TOS", context)),
                        drawerItems(context, ProfileScreen(), "bantuan", Images.bantuan_drawer, getTranslated("SUPPORT", context)),
                        drawerItems(context, ProfileScreen(), "logout", Images.logout_drawer, getTranslated("LOGOUT", context))
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
                        child: Text("Sign In",
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
                return Center(
                  child: SizedBox(
                    width: 18.0,
                    height: 18.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(ColorResources.BTN_PRIMARY_SECOND),
                    ),
                  ),
                );
              },
              imageUrl: "${AppConstants.BASE_URL_IMG}${profileProvider?.userProfile?.profilePic}",
              imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
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
      margin: EdgeInsets.only(top: 10.0),
      child: Consumer<ProfileProvider>(
        builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
          return Column(
            children: [
              Text(profileProvider.profileStatus == ProfileStatus.loading 
                ? "..." 
                : profileProvider.profileStatus == ProfileStatus.error 
                ? "..." 
                : profileProvider?.getUserFullname,
                style: poppinsRegular.copyWith(
                  fontWeight: FontWeight.bold
                )
              ),
              Text("ID ${profileProvider.profileStatus == ProfileStatus.loading 
                ? "..." 
                : profileProvider.profileStatus == ProfileStatus.error 
                ? "..." 
                : profileProvider?.getUserIdNumber}",
                style: poppinsRegular.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0
                )
              )
            ],
          );
        },
      ),
    );
  }

  Widget drawerItems(BuildContext context, Widget widget, String menu, String icon, String title) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      child: ListTile(
        dense: true,
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
          } else if(menu == "tos") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(
              title: 'Term of Service',
              url: 'https://connexist.com/mobile-bantuan'
            )));
          } else if(menu == "bantuan") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(
              title: 'Bantuan',
              url: 'https://connexist.com/mobile-bantuan'
            )));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
          }
        },  
        title: Text(title,
          style: poppinsRegular,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            color: ColorResources.GRAY_PRIMARY,
            height: 40.0,
            child: Container(
              margin: EdgeInsets.all(11.0),
              child: Image.asset(icon)
            )
          ),
        ),
      )
    );
  }
  
}