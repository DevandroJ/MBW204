import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/data/models/profile.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  bool loading = false;
  File _file;

  TextEditingController emailController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController noKtpController = TextEditingController();
  TextEditingController noHpController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  ProfileData profileData = ProfileData();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future save(BuildContext context) async {
    try {

      profileData.fullname = fullnameController.text;
      profileData.noKtp = noKtpController.text;
      profileData.address = addressController.text;

      await Provider.of<ProfileProvider>(context, listen: false).updateProfile(context, profileData, "");  
    } catch(e) {
      print(e);
    }
  }
   

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      Provider.of<ProfileProvider>(context, listen: false).getUserProfile(context);
      fullnameController.text = Provider.of<ProfileProvider>(context, listen: false).userProfile.fullname;
      emailController.text = Provider.of<ProfileProvider>(context, listen: false).getUserEmail;
      noKtpController.text = Provider.of<ProfileProvider>(context, listen: false).userProfile.idCardNumber;
      noHpController.text = Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber;
    });
  }

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
                      Positioned(
                        right: 5.0,
                        bottom: 0.0,
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: ColorResources.GRAY_LIGHT_PRIMARY,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 14.0,
                            color: ColorResources.BLACK    
                          ),
                        )
                      ),
                    ],
                  )
                ),
              ),
            
              Align(  
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 60.0, left: 145.0, right: 10.0),
                  child: TextField(
                    controller: fullnameController,
                  )
                ),
              ),

            ],
          ),

          Container(
            margin: EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
            child: Card(
              elevation: 3.0,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inputComponent(context, "Email", emailController, true),
                      SizedBox(height: 10.0),
                      inputComponent(context, "Nomor Identitas KTP", noKtpController, false),
                      SizedBox(height: 10.0),
                      inputComponent(context, "Nomor Handphone", noHpController, false),
                      SizedBox(height: 10.0),
                      inputComponent(context, "Alamat", addressController, false),
                      SizedBox(height: 10.0),
                    ],
                  ),
                )
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 180.0,
                  height: 30.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      primary: ColorResources.BLACK,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      )
                    ),
                    onPressed: () => Navigator.of(context).pop(), 
                    child: Text("Kembali",
                      style: poppinsRegular.copyWith(
                        fontSize: 14.0,
                        color: ColorResources.YELLOW_PRIMARY
                      ),
                    )
                  ),
                ),
                Container(
                  width: 180.0,
                  height: 30.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      primary: ColorResources.BLACK,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      )
                    ),
                    onPressed: () {}, 
                    child: Text("Simpan",
                      style: poppinsRegular.copyWith(
                        fontSize: 14.0,
                        color: ColorResources.YELLOW_PRIMARY
                      ),
                    )
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget inputComponent(BuildContext context, String label, TextEditingController textEditingController, bool readOnly) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: poppinsRegular,
        ),
        TextField(
          readOnly: readOnly,
          controller: textEditingController,
          decoration: InputDecoration(
            isDense: true
          ),
        ),
        Divider(
          height: 1.0,
        )
      ],
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
