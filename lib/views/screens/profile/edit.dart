import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ColorResources.BLACK,
          ),
        ),
        title: Text("Profil Saya",
          style: poppinsRegular.copyWith(
            color: ColorResources.BLACK,
            fontSize: 17.0,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: ColorResources.GRAY_LIGHT_PRIMARY,
      ),
      body: ListView(
        children: [

          Stack(
            children: [

              ClipPath(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200.0,
                  color: ColorResources.GRAY_LIGHT_PRIMARY,
                ),
                clipper: CustomClipPath(),
              ),
              Align(  
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 40.0, left: 30.0),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage("https://cdn0-production-images-kly.akamaized.net/0r0vo4waPk9g2ZOtSePxceTuoyE=/640x480/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/706185/original/Daniel-Radcliffe-140710.gif"),
                      ),
                    ],
                  )
                ),
              ),
              Positioned(
                right: 20.0,
                bottom: 5.0,
                child: Text("hello"),
              ),
             

               Align(  
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 60.0, left: 145.0),
                  child: Text("Nurhalizah",
                    style: poppinsRegular.copyWith(
                      color: ColorResources.BTN_PRIMARY_SECOND,
                      fontSize: 16.0
                    ),
                  )
                ),
              ),

            ],
          )

        ],
      ),
    );
  }
}


class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 140);
    path.quadraticBezierTo(size.width / 2, size.height, 
    size.width, size.height - 140);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
