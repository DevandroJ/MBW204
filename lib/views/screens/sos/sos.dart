import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/views/screens/sos/detail.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/providers/location.dart';
import 'package:mbw204_club_ina/providers/sos.dart';
import 'package:url_launcher/url_launcher.dart';

class SosScreen extends StatefulWidget {
  final bool isBacButtonExist;
  SosScreen({this.isBacButtonExist = true});

  @override
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {

  Future<bool> onWillPop() {
    Navigator.of(context).pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<LocationProvider>(context, listen: false).getCurrentPosition(context);
    Provider.of<SosProvider>(context, listen: false).initSosList();

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: ColorResources.GRAY_DARK_PRIMARY,
          title: Text("SOS",
            style: poppinsRegular,
          ),
          automaticallyImplyLeading: false,
          actions: [],
        ),
        body: ListView(
          children: [
            
            Stack(
              children: [

                ClipPath(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200.0,
                    color: ColorResources.GRAY_DARK_PRIMARY,
                  ),
                  clipper: CustomClipPath(),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Column(
                      children: [
                        getSosList(context, "AMBULANCE", Images.ambulance, "Sebar permintaan tolong Ambulan"),
                        SizedBox(height: 10.0),
                        getSosList(context, "KECELAKAAN", Images.strike, "Sebar permintaan tolong Kecelakaan"),
                        SizedBox(height: 10.0),
                        getSosList(context, "TROUBLE", Images.trouble, "Sebar permintaan tolong Mogok"),
                        SizedBox(height: 10.0),
                        getSosList(context, "PENCURIAN / PERAMPOKAN", Images.thief, "Sebar permintaan tolong Pencurian"),
                        SizedBox(height: 10.0),
                        getSosList(context, "KEBAKARAN", Images.fire, "Sebar permintaan tolong Kebakaran"),
                        SizedBox(height: 10.0),
                        getSosList(context, "INFO BENGKEL", Images.workshop_info, "O81316982889 StarPro Service"),
                        SizedBox(height: 10.0),
                        getSosList(context, "BENCANA ALAM", Images.disaster, "Sebar permintaan tolong Bencana"),
                      ],
                    ),
                  ),
                )

              ],
            ),

          ],
        )
      )
    );
  }
}

Widget getSosList(BuildContext context, String label, String images, String content) {
  return InkWell(
    onTap: () async => label == "INFO BENGKEL" ? await launch("tel://O81316982889") : Navigator.push(context, MaterialPageRoute(builder: (context) => SosDetailScreen(
      label: label,
      content: content,
    ))),
    child: Container(
      width: double.infinity,
      height: 80.0,
      decoration: BoxDecoration(
        color: ColorResources.GRAY_LIGHT_PRIMARY,
        borderRadius: BorderRadius.circular(10.0)
      ),
      margin: EdgeInsets.only(left: 16.0, right: 16.0),
      padding: EdgeInsets.all(10.0),
      child: Container(
        child: ListTile(
          dense: true,
          leading: Image.asset(images,
            height: 30.0,
            width: 30.0,
          ),
          title: Text(label,
            style: poppinsRegular.copyWith(
              color: ColorResources.BTN_PRIMARY_SECOND,
              fontSize: 12.0 * MediaQuery.of(context).textScaleFactor
            ),
          ),
          subtitle: Text(content,
            style: poppinsRegular.copyWith(
              fontSize: 11.0 * MediaQuery.of(context).textScaleFactor
            ),
          ),
        ),
      )
    ),
  );
}

class CustomClipPath extends CustomClipper<Path> {
  double radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 140);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 140);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}