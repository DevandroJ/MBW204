import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/data/models/profile.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  ProfileData profileData = ProfileData();
  File file;
  ImageSource imageSource;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController noAnggotaController = TextEditingController();
  TextEditingController noHpController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void uploadPic() async {
    imageSource = await showDialog<ImageSource>(context: context, builder: (context) => 
      AlertDialog(
        title: Text(getTranslated("SOURCE_IMAGE", context),
        style: TextStyle(
          color: ColorResources.BTN_PRIMARY_SECOND,
          fontWeight: FontWeight.bold, 
        ),
      ),
      actions: [
        MaterialButton(
          child: Text(getTranslated("CAMERA", context),
            style: TextStyle(
              color: Colors.black
            )
          ),
          onPressed: () => Navigator.pop(context, ImageSource.camera),
        ),
        MaterialButton(
          child: Text(getTranslated("GALLERY", context),
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context, ImageSource.gallery)
          )
        ],
      )
    );
    if(imageSource == ImageSource.camera) {
      PickedFile pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxHeight: 480.0, 
        maxWidth: 640.0,
        imageQuality: 70
      );
      if(pickedFile != null) {
        setState(() {
          file = File(pickedFile.path); 
        });
      }
    }
  }

  Future save(BuildContext context) async {
    try {

      if(fullnameController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "Nama Lengkap tidak boleh kosong",
          backgroundColor: ColorResources.ERROR
        );
        return;
      }
      if(noHpController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "No HP tidak boleh kosong",
          backgroundColor: ColorResources.ERROR
        );
        return;
      }
      profileData.fullname = fullnameController.text;
      profileData.address = addressController.text;

      await Provider.of<ProfileProvider>(context, listen: false).updateProfile(context, profileData, file);  
    } catch(e) {
      print(e);
    }
  }
   

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      Provider.of<ProfileProvider>(context, listen: false).getUserProfile(context);
      fullnameController.text = Provider.of<ProfileProvider>(context, listen: false).getUserFullname;
      noAnggotaController.text = Provider.of<ProfileProvider>(context, listen: false).getUserIdNumber;
      emailController.text = Provider.of<ProfileProvider>(context, listen: false).getUserEmail;
      noHpController.text = Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber;
      addressController.text = Provider.of<ProfileProvider>(context, listen: false).getUserAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(getTranslated("MY_PROFILE", context),
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
                      Consumer<ProfileProvider>(
                        builder: (BuildContext context, ProfileProvider profileProvider,  Widget child) {
                          return profileProvider.profileStatus == ProfileStatus.loading 
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorResources.BLACK,
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Center(
                                  child: Text("...",
                                    style: poppinsRegular.copyWith(
                                      color: ColorResources.WHITE
                                    )
                                  ),
                                ),
                                width: 100.0,
                                height: 100.0,
                              ),
                            )
                          : profileProvider.profileStatus == ProfileStatus.error 
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorResources.BLACK,
                                  borderRadius: BorderRadius.circular(50.0),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/logo.png'),
                                    fit: BoxFit.cover
                                  )
                                ),
                                width: 100.0,
                                height: 100.0,
                              ),
                            )
                          : file == null 
                          ? CachedNetworkImage(
                              imageUrl: "${AppConstants.BASE_URL_IMG}${profileProvider.userProfile.profilePic}",
                              imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorResources.BLACK,
                                      borderRadius: BorderRadius.circular(50.0),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover
                                      )
                                    ),
                                    width: 100.0,
                                    height: 100.0,
                                  ),
                                );
                              },
                              placeholder: (BuildContext context, String url) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                    decoration: BoxDecoration(
                                      color: ColorResources.BLACK,
                                      borderRadius: BorderRadius.circular(50.0)
                                    ),
                                    width: 100.0,
                                    height: 100.0,
                                    child: Image.asset('assets/images/logo.png'),
                                  ),
                                );
                              },
                              errorWidget: (BuildContext context, String url, dynamic error) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                    decoration: BoxDecoration(
                                      color: ColorResources.BLACK,
                                      borderRadius: BorderRadius.circular(50.0)
                                    ),
                                    width: 100.0,
                                    height: 100.0,
                                    child: Image.asset('assets/images/logo.png'),
                                  ),
                                );
                              },
                            ) 
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Container(
                              decoration: BoxDecoration(
                                color: ColorResources.BLACK,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              width: 100.0,
                              height: 100.0,
                              child: Image.file(
                              file,
                              fit: BoxFit.cover,
                            )),
                          );
                        },
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
                          child: InkWell(
                            onTap: () => uploadPic(),
                            child: Icon(
                              Icons.camera_alt,
                              size: 14.0,
                              color: ColorResources.BLACK    
                            ),
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
            margin: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Card(
              elevation: 3.0,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inputComponent(context, getTranslated("EMAIL", context), emailController, true),
                      SizedBox(height: 10.0),
                      inputComponent(context, getTranslated("NO_MEMBER", context), noAnggotaController, true),
                      SizedBox(height: 10.0),
                      inputComponent(context, getTranslated("PHONE_NUMBER", context), noHpController, false),
                      SizedBox(height: 10.0),
                      inputComponent(context, getTranslated("ADDRESS", context), addressController, false),
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
                FittedBox(
                  child: Container(
                    width: 150.0,
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
                      child: Text(getTranslated("BACK", context),
                        style: poppinsRegular.copyWith(
                          fontSize: 14.0,
                          color: ColorResources.YELLOW_PRIMARY
                        ),
                      )
                    ),
                  ),
                ),
                Consumer<ProfileProvider>(
                  builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                    return FittedBox(
                      child: Container(
                        width: 150.0,
                        height: 30.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            primary: ColorResources.BLACK,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                            )
                          ),
                          onPressed: () => save(context), 
                          child: profileProvider.updateProfileStatus == UpdateProfileStatus.loading 
                          ? Loader(
                            color: ColorResources.WHITE,
                          ) 
                          : Text(getTranslated("SAVE", context),
                            style: poppinsRegular.copyWith(
                              fontSize: 14.0,
                              color: ColorResources.YELLOW_PRIMARY
                            ),
                          )
                        ),
                      ),
                    );
                  },
                )
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
