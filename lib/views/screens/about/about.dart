import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: ColorResources.GRAY_LIGHT_PRIMARY,
        title: Text("About us",
          style: poppinsRegular.copyWith(
            color: ColorResources.BLACK,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
        ),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ColorResources.BLACK,
          )
        ),
      ),
      body: ListView(
        children: [
          Stack(
            children: [

              ClipPath(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 140.0,
                  color: ColorResources.GRAY_LIGHT_PRIMARY,
                ),
                clipper: CustomClipPath(),
              ),

              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 40.0),
                  child: Column(
                    children: [
                      Container(
                        height: 100.0,
                        child: Image.asset(Images.logo_app)
                      ),
                      SizedBox(height: 10.0),
                      Text("MERCEDES-BENZ W204 CLUB INDONESIA",
                        style: poppinsRegular.copyWith(
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ) 
                ),
              ),

            ],
          ),

          Container(
            margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
            child: Row(
              children: [ 
                Text("HISTORY",
                  style: poppinsRegular.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                  softWrap: true,
                ),

                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Divider(
                      color: Colors.black,
                      height: 50.0,
                    )
                  ),
                ),
              ]
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("VISION STATEMENT:",
                  style: poppinsRegular,
                  softWrap: true,
                ),
                Text("ELEVATE TO THE NEXT LEVEL",
                  style: poppinsRegular,
                  softWrap: true,
                ),
                Text("“Membawa MBW204 Club INA ketingkat yang lebih tinggi untuk menjadi organisasi otomotif yang sehat dan menyenangkan bagi semua  stakeholder didalam melakukan aktivitas kegiatan otomotif maupun cara berorganisasi yang lebih baik, transparan dan dapat dipertanggung jawabkan”.",
                  style: poppinsRegular,
                  softWrap: true,
                )
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Misi:",
                  style: poppinsRegular,
                  softWrap: true,
                ),
                Text("MBW204 Club INA Wonderful Journey",
                  style: poppinsRegular,
                  softWrap: true,
                ), 
                Text("Didalam perjalanan menuju Visi organisasi, semua stakeholder akan menikmati perjalanan yang sangat menyenangkan didalam:",
                  style: poppinsRegular,
                  softWrap: true,
                ),
                Text("• Melanjutkan Visi & Misi dari kepemimpinan sebelumnya\n• Mengembangkan dan memperbaiki aturan organisasi yang ada\n• Membangun Digital Platform MBW204 Club INA bagi pelaksanaan aturan organisasi, tata tertib organisasi, program kegiatan aktivitas sehari-hari maupun administrasi keanggotaan MBW204 Club INA\n• Melakukan kegiatan aktivitas yang mengutamakan kebersamaan antar sesama anggota MBW204 Club INA\n• Membangun kemitraan yang seluas-luasnya dengan pihak external maupun pihak internal untuk mengoptimalkan manfaat bagi seluruh stakeholder\n• Berpartisipasi aktif didalam kegiatan-kegiatan otomotif baik didalam negeri maupun diluar negeri\n• Membangun BUDAYA ORGANISASI MBW204 Club INA yang SPORTIF, BERETIKA dan BERTANGGUNG JAWAB dalam semangat KEKELUARGAAN",
                  style: poppinsRegular,
                  softWrap: true,
                )
              ],
            ),
          ),
          
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
            child: Row(
              children: [ 
                Text("VISI & MISI",
                  style: poppinsRegular.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                  softWrap: true,
                ),

                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Divider(
                      color: Colors.black,
                      height: 50.0,
                    )
                  ),
                ),
              ]
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Visi:",
                  style: poppinsRegular,
                  softWrap: true,
                ),
                Text("ELEVATE TO THE NEXT LEVEL",
                  style: poppinsRegular,
                  softWrap: true,
                ),
                Text("Misi:",
                  style: poppinsRegular,
                  softWrap: true,
                ),
                Text("MBW204 Club INA Wonderful Journey",
                  style: poppinsRegular,
                  softWrap: true,
                ),
                Text("Tagline:",
                  style: poppinsRegular,
                  softWrap: true,
                ),
                Text("MBW204 Club INA Wonderful Journey",
                  style: poppinsRegular,
                  softWrap: true,
                )
              ],
            ),
          )


        ],
      ) 
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