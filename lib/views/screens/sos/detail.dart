import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';

class SosDetailScreen extends StatelessWidget {
  final String content;

  SosDetailScreen({
    this.content
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ColorResources.BLACK,  
          ),
        ),
        backgroundColor: ColorResources.GRAY_LIGHT_PRIMARY,
      ),
      body: Stack(
        children: [

          ClipPath(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 160.0,
              color: ColorResources.GRAY_LIGHT_PRIMARY,
            ),
            clipper: CustomClipPath(),
          ),

          Container(
            margin: EdgeInsets.only(top: 90.0),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                
                Text("SOS",
                  style: poppinsRegular.copyWith(
                    color: ColorResources.BTN_PRIMARY_SECOND,
                    fontSize: 70.0,
                    fontWeight: FontWeight.bold
                  )
                ),

                Container(
                  height: 200.0,
                  child: Image.asset(Images.sos_detail),
                ),

                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Text(content,
                    softWrap: false,
                    textAlign: TextAlign.center,
                    style: poppinsRegular.copyWith(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: ColorResources.BTN_PRIMARY_SECOND,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)
                      )
                    ),
                    onPressed: () {
                      
                    },
                    child: Text("Help Me",
                      style: poppinsRegular,
                    ),
                  ),
                )
                
              ] 
            ),  
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