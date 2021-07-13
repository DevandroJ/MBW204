import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import 'package:mbw204_club_ina/providers/location.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/providers/sos.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';

class SosDetailScreen extends StatelessWidget {
  final String label;
  final String content;

  SosDetailScreen({
    this.label,
    this.content
  });

  Future submit(BuildContext context) async {
    try {
      String userId = Provider.of<ProfileProvider>(context, listen: false).getUserId;
      String sender = Provider.of<ProfileProvider>(context, listen: false).getUserFullname;
      String phoneNumber = Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber;
      String address = Provider.of<LocationProvider>(context, listen: false).getCurrentNameAddress; 
      double lat = Provider.of<LocationProvider>(context, listen: false).getCurrentLat;
      double long = Provider.of<LocationProvider>(context, listen: false).getCurrentLong;
      String geoPosition = "${lat.toString()} , ${long.toString()}"; 
      await Provider.of<SosProvider>(context, listen: false).insertSos(context, userId, geoPosition, "", content, address, sender, phoneNumber);
    } catch(e) {
      print(e);
    }
  }

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
                  margin: EdgeInsets.only(top: 30.0),
                  child: ConfirmationSlider(
                    foregroundColor: ColorResources.BTN_PRIMARY_SECOND,
                    text: 'Slide to confirm',
                    onConfirmation: () => {
                      showAnimatedDialog(
                        barrierDismissible: true,
                        context: context, 
                        builder: (context) {
                        Future.delayed(Duration(seconds: 60), () {
                          Navigator.of(context).pop();
                        });
                        return ClassicGeneralDialogWidget(
                          titleText: 'Sebar Berita ?',
                          contentText: 'Anda akan dihubungi pihak berwenang apabila menyalahgunakan SOS tanpa tujuan dan informasi yang benar',
                          positiveText: 'Ya, Lakukan',
                          negativeText: 'Tidak',
                          onPositiveClick: () => submit(context),
                          onNegativeClick: () => Navigator.of(context).pop(),
                        );
                      })
                    },
                  ),
                )

                // Container(
                //   margin: EdgeInsets.only(top: 20.0),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       primary: ColorResources.BTN_PRIMARY_SECOND,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30.0)
                //       )
                //     ),
                //     onPressed: () {
                      
                //     },
                //     child: Text("Help Me",
                //       style: poppinsRegular,
                //     ),
                //   ),
                // )
                
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