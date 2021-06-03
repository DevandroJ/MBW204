import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_picker/flutter_picker.dart';

import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/providers/theme.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/data/models/profile.dart';
import 'package:mbw204_club_ina/helpers/show_snackbar.dart';
import 'package:mbw204_club_ina/views/basewidget/textfield/custom_textfield.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FocusNode fullnameFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode cardNumberFocus = FocusNode();
  FocusNode shortBioFocus = FocusNode();
  TextEditingController fullnameTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  TextEditingController cardNumberTextController = TextEditingController();
  TextEditingController shortBioTextController = TextEditingController();
  
  ImagePicker picker = ImagePicker();
  ProfileData profileData = ProfileData();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  File file;
  String selectedGender;

  List<String> genders = [
    "Male",
    "Female",
  ];

  void _choose() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery, 
      imageQuality: 70,
      maxHeight: 500, 
      maxWidth: 500
    );
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } 
    });
  }

  void updateProfile(context) async {
    try {
      profileData.fullname = fullnameTextController.text;
      profileData.address = addressTextController.text;
      profileData.shortBio = shortBioTextController.text;
      profileData.idCardNumber = cardNumberTextController.text;
      profileData.gender = selectedGender;
      await Provider.of<ProfileProvider>(context, listen: false).updateProfile(context, profileData, file);
      ShowSnackbar.snackbar(context, getTranslated("UPDATE_ACCOUNT_SUCCESSFUL" ,context), "", Colors.green);
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    } catch(e) {
      ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM" ,context), "", Colors.red);
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fullnameTextController.dispose();
    addressTextController.dispose();
    cardNumberTextController.dispose();
    shortBioTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text("My Account",
          style: poppinsRegular,
        ),
        backgroundColor: ColorResources.GRAY_DARK_PRIMARY,
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
                alignment: Alignment.bottomCenter,
                child: Container(

                  margin: EdgeInsets.only(top: 70.0),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage("https://cdn0-production-images-kly.akamaized.net/0r0vo4waPk9g2ZOtSePxceTuoyE=/640x480/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/706185/original/Daniel-Radcliffe-140710.gif"),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 180.0),
                  child: Text("Nurhalizah",
                    style: poppinsRegular.copyWith(
                      color: ColorResources.BTN_PRIMARY_SECOND,
                      fontSize: 19.0
                    ),
                  )
                ),
              )
    
            ],
          ),

          Container(
            margin: EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
            width: double.infinity,
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
                    onPressed: () {}, 
                    child: Text("Profil",
                      style: poppinsRegular.copyWith(
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
                    child: Text("Kartu Digital",
                      style: poppinsRegular.copyWith(
                        color: ColorResources.YELLOW_PRIMARY
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
            width: double.infinity,
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    Row(
                      children: [
                        Text("Saldoku",
                          style: poppinsRegular.copyWith(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Text("125.000",
                          style: poppinsRegular.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Container(
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
                            child: Text("Topup",
                              style: poppinsRegular.copyWith(
                                fontSize: 14.0,
                                color: ColorResources.YELLOW_PRIMARY
                              ),
                            )
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Icon(
                          Icons.refresh,
                          color: ColorResources.BLACK,
                        )
                      ],
                    ),

                  ]
                )
              
              

              ],
            )
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
