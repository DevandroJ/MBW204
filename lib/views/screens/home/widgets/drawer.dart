import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/views/screens/about/about.dart';
import 'package:mbw204_club_ina/views/screens/auth/change_password.dart';
import 'package:mbw204_club_ina/views/screens/profile/profile.dart';
import 'package:provider/provider.dart';

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
            drawerUserDisplayName(context),
            Container(
              padding: EdgeInsets.only(top: 0, bottom: 20.0, left: 10.0, right: 10.0),
              child: Column(
                children: [
                  drawerItems(context, AboutUsScreen(), Images.logo_app, "Tentang MBW204\nClub Indonesia"),
                  drawerItems(context, ProfileScreen(), Images.profile_drawer, "Profil"),
                  drawerItems(context, ProfileScreen(), Images.settings_drawer, "Pengaturan"),
                  drawerItems(context, ChangePasswordScreen(), Images.lock_drawer, "Ubah Kata Sandi"),
                  drawerItems(context, ProfileScreen(), Images.tos_drawer, "Term of Service"),
                  drawerItems(context, ProfileScreen(), Images.bantuan_drawer, "Bantuan"),
                  drawerItems(context, AboutUsScreen(), Images.logout_drawer, "Logout")
                ],
              ),
            )
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
        child: CachedNetworkImage(
          imageUrl: "https://cdn0-production-images-kly.akamaized.net/0r0vo4waPk9g2ZOtSePxceTuoyE=/640x480/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/706185/original/Daniel-Radcliffe-140710.gif",
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
        )
      ),
    );
  }

  Widget drawerUserDisplayName(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Text(Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.loading 
            ? "..." 
            : Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.error 
            ? "..." 
            : Provider.of<ProfileProvider>(context, listen: false).getUserFullname,
            style: poppinsRegular.copyWith(
              fontWeight: FontWeight.bold
            )
          ),
          Text("ID 0123456789",
            style: poppinsRegular.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12.0
            )
          )
        ],
      ),
    );
  }

  Widget drawerItems(BuildContext context, Widget widget, String icon, String title) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      child: ListTile(
        dense: true,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => widget)),
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