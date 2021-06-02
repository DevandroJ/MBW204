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
    ProfileData userProfile = Provider.of<ProfileProvider>(context, listen: false).userProfile;
    fullnameTextController.text = userProfile.fullname;
    addressTextController.text = userProfile.address;
    cardNumberTextController.text = userProfile.idCardNumber;   
    shortBioTextController.text = userProfile.shortBio;
    if(userProfile.gender.toLowerCase() == "male") {
      setState(() => selectedGender = "Male");
    } else if(userProfile.gender.toLowerCase() == "female") {
      setState(() => selectedGender = "Female");
    } else {
      setState(() => selectedGender = "Select Your Gender");
    }
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
      body: Consumer<ProfileProvider>(
        builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
          return Stack(
            clipBehavior: Clip.none,
            children: [

              // Background Profile
              Image.asset(
                Images.toolbar_background, fit: BoxFit.fill, height: 500.0,
                color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : null,
              ),

              // Profile Title
              Container(
                padding: EdgeInsets.only(top: 35.0, left: 15.0),
                child: Row(
                  children: [
                  CupertinoNavigationBarBackButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.0),
                  Text(getTranslated('PROFILE', context), 
                    style: titilliumRegular.copyWith(
                      fontSize: 20.0, 
                      color: Colors.white
                    ), 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis
                  ),
                ]),
              ),

              Container(
                padding: EdgeInsets.only(top: 55.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [    

                              // Profile Pic & Fullname
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: file == null ? profileProvider.userProfile.profilePic == "" ? Icon(
                                  Icons.person,
                                  size: 90.0,
                                  color: Colors.white,
                                )  : Image.network("${AppConstants.BASE_URL_IMG}${profileProvider.userProfile.profilePic}",
                                  width: 80.0,
                                  height: 80.0,
                                  fit: BoxFit.fitWidth
                                ) : Image.file(file,
                                  width: 80.0,
                                  height: 80.0,
                                  fit: BoxFit.fitWidth
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: -10,
                                child: CircleAvatar(
                                  backgroundColor: ColorResources.WHITE,
                                  radius: 14.0,
                                  child: IconButton(
                                    onPressed: _choose,
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(
                                      Icons.edit, 
                                      color: ColorResources.getPrimaryToBlack(context), 
                                      size: 18.0
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                        Text('${profileProvider.userProfile.fullname ?? ""}',
                          style: titilliumRegular.copyWith(
                            color: ColorResources.WHITE, 
                            fontSize: 20.0
                          ),
                        ),

                        Text('${profileProvider.getUserPhoneNumber ?? ""}',
                          style: titilliumRegular.copyWith(
                            color: ColorResources.WHITE, 
                            fontSize: 16.0
                          ),
                        )

                      ],
                    ),

                    // Space for Form
                    SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                    
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorResources.getBlackSoft(context),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                            topRight: Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                          )
                        ),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [

                            // Form Fullname
                            Container(
                              margin: EdgeInsets.only(
                                left: Dimensions.MARGIN_SIZE_DEFAULT, 
                                right: Dimensions.MARGIN_SIZE_DEFAULT
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person, 
                                              color: ColorResources.getPrimaryToWhite(context), 
                                              size: 20.0
                                            ),
                                            SizedBox(
                                              width: Dimensions.MARGIN_SIZE_EXTRA_SMALL
                                            ),
                                            Text(getTranslated('FULL_NAME', context), style: titilliumRegular)
                                          ],
                                        ),
                                        SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                        CustomTextField(
                                          textInputType: TextInputType.text,
                                          focusNode: fullnameFocus,
                                          nextNode: addressFocus,
                                          hintText: profileProvider.userProfile.fullname ?? "",
                                          controller: fullnameTextController
                                        ),
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            ),

                            // Form Address
                            Container(
                              margin: EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_SMALL,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.home, 
                                        color: ColorResources.getPrimaryToWhite(context), 
                                        size: 20.0
                                      ),
                                      SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                      Text(getTranslated('ADDRESS', context), style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType: TextInputType.text,
                                    focusNode: addressFocus,
                                    nextNode: shortBioFocus,
                                    hintText: profileProvider.userProfile.address,
                                    isAddress: true,
                                    controller: addressTextController,
                                  ),
                                ],
                              ),
                            ),

                            // Form Short Bio
                            Container(
                              margin: EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_SMALL,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person_pin_rounded,
                                        color: ColorResources.getPrimaryToWhite(context), 
                                        size: 20.0
                                      ),
                                      SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                      Text(getTranslated('SHORT_BIO', context), style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType: TextInputType.text,
                                    focusNode: shortBioFocus,
                                    hintText: profileProvider.userProfile.shortBio ?? "",
                                    controller: shortBioTextController,
                                    isShortBio: true,
                                  ),
                                ],
                              ),
                            ),

                            // Form Card Number 
                            Container(
                              margin: EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_SMALL,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.credit_card,
                                        color: ColorResources.getPrimaryToWhite(context), 
                                        size: 20.0
                                      ),
                                      SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                      Text(getTranslated('MEMBER_NO', context), style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType: TextInputType.text,
                                    focusNode: cardNumberFocus,
                                    hintText: profileProvider.userProfile.idCardNumber ?? "",
                                    controller: cardNumberTextController,
                                  ),
                                ],
                              ),
                            ),

                            // Form Gender
                            Container(
                              margin: EdgeInsets.only(   
                                top: Dimensions.MARGIN_SIZE_SMALL,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT
                              ),
                              child: Column(
                                children: [
                                 Row(
                                    children: [
                                      Icon(
                                        Icons.person_sharp,
                                        color: ColorResources.getPrimaryToWhite(context), 
                                        size: 20.0
                                      ),
                                      SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                      Text(getTranslated('GENDER', context), style: titilliumRegular)
                                    ],
                                  ),  
                                  SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius:  BorderRadius.circular(6.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1), 
                                          spreadRadius: 1.0, 
                                          blurRadius: 3.0, 
                                          offset: Offset(0.0, 1.0)
                                        ) 
                                      ],
                                    ),
                                    child: TextFormField(
                                      readOnly: true,
                                      onTap: () {
                                        Picker(
                                          adapter: PickerDataAdapter<String>(pickerdata: genders),
                                          hideHeader: true,
                                          confirmText: getTranslated("CONFIRM", context),
                                          confirmTextStyle: TextStyle(
                                            color: Colors.blue
                                          ),
                                          cancelText: getTranslated("CANCEL", context),
                                          cancelTextStyle: TextStyle(
                                            color: Colors.red
                                          ),
                                          selecteds: selectedGender.toLowerCase() == "male" ? [0] : selectedGender.toLowerCase() == "select your gender" ? [0] : [1],
                                          title: Text(getTranslated("SELECT_GENDER", context)),
                                          onConfirm: (Picker picker, List value) {
                                            setState(() => selectedGender = picker.getSelectedValues()[0]);                        
                                          }
                                        ).showDialog(context);
                                      },
                                      cursorColor: Colors.black,
                                      maxLines:  1,
                                      keyboardType: TextInputType.text,
                                      initialValue: null,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        hintText: selectedGender ?? selectedGender,
                                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                                        isDense: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey, 
                                            width: 0.5
                                          ),
                                        ),
                                        hintStyle: titilliumRegular.copyWith(color: ColorResources.getBlackToWhite(context)),
                                        errorStyle: TextStyle(height: 1.5),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  )
                                ]
                              )
                            )
                          ],
                        ),
                      ),
                    ),

                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: Dimensions.MARGIN_SIZE_LARGE, 
                      vertical: Dimensions.MARGIN_SIZE_SMALL
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero
                      ),
                      onPressed: () => updateProfile(context),
                      child: Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorResources.getPrimaryToWhite(context),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2), 
                              spreadRadius: 1.0, 
                              blurRadius: 7.0, 
                              offset: Offset(0, 1)
                            ), 
                          ],
                          borderRadius: BorderRadius.circular(10.0)),
                            child: profileProvider.updateProfileStatus == UpdateProfileStatus.loading 
                            ? Center(
                                child: SizedBox(
                                  width: 18.0,
                                  height: 18.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).accentColor
                                    )
                                  )
                                )
                              ) 
                            : Text(getTranslated('UPDATE_ACCOUNT', context),
                              style: titilliumSemiBold.copyWith(
                                fontSize: 16.0,
                                color: ColorResources.getWhiteToBlack(context),
                              )
                            ),
                          ),
                        )
                    ),

                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
