import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/views/screens/historyactivity/history_activity.dart';
import 'package:mbw204_club_ina/views/screens/ppob/topup/history.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/screens/ppob/topup/topup.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/views/screens/profile/edit.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/data/models/profile.dart';
import 'package:mbw204_club_ina/helpers/show_snackbar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin{
  TabController tabController;
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
  int tabbarIndex = 0;

  List<String> genders = [
    "Male",
    "Female",
  ];

  void chooseProfileAvatar() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery, 
      imageQuality: 70,
      maxHeight: 500, 
      maxWidth: 500
    );
    if (pickedFile != null) {
      setState(() => file = File(pickedFile.path));
    }
  }

  void updateProfile(context) async {
    try {
      profileData.fullname = fullnameTextController.text;
      profileData.address = addressTextController.text;
      profileData.shortBio = shortBioTextController.text;
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
    tabController = TabController(length: 2, vsync: this);
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
        title: Text(getTranslated("MY_ACCOUNT", context),
          style: poppinsRegular.copyWith(
            fontSize: 10.0.sp
          ),
        ),
        backgroundColor: ColorResources.GRAY_DARK_PRIMARY,
      ),
      body: ListView(
        children: [

          Stack(
            clipBehavior: Clip.none,
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
                  child: Consumer<ProfileProvider>(
                    builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                      return CachedNetworkImage(
                        imageUrl: "${AppConstants.BASE_URL_IMG}${profileProvider.getUserProfilePic}",
                        imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                          return CircleAvatar(
                            radius: 50.0,
                            backgroundColor: ColorResources.WHITE,
                            backgroundImage: imageProvider
                          );
                        },
                        errorWidget: (BuildContext context, String url, dynamic error) {
                          return CircleAvatar(
                            radius: 50.0,
                            backgroundColor: ColorResources.WHITE,
                            backgroundImage: AssetImage('assets/images/profile-drawer.png'),
                          );
                        },  
                        placeholder: (BuildContext context, String url) {
                          return Loader(
                            color: ColorResources.PRIMARY,
                          );
                        },
                      );
                    },
                  )
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 180.0),
                  child: Consumer<ProfileProvider>(
                    builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                      return Text(profileProvider.profileStatus == ProfileStatus.loading  
                      ? "..." 
                      : profileProvider.profileStatus == ProfileStatus.error 
                      ? "..." 
                      : profileProvider.getUserFullname, 
                        style: poppinsRegular.copyWith(
                          color: ColorResources.BTN_PRIMARY_SECOND,
                          fontSize: 10.sp
                        )
                      );
                    },
                  )
                ),
              )
    
            ],
          ),

          TabBar(
            controller: tabController,
            onTap: (int i) {
              setState(() {
                tabbarIndex = i;
              });
            },
            indicatorColor: ColorResources.BLACK,
            labelColor: ColorResources.BLACK,
            unselectedLabelColor: ColorResources.GRAY_PRIMARY,
            labelStyle: poppinsRegular.copyWith(
              fontSize: 9.0.sp
            ),
            tabs: [
              Tab(
                text: getTranslated("PROFILE", context),
              ),
              Tab(
                text: getTranslated("CARD_DIGITAL", context),
              ),
            ],
          ),

          Builder(
            builder:(BuildContext context) {
              if(tabbarIndex == 0) {
                return profileAccount(context);
              } 
              return digitalCard(context);
              // return 
            },
          )
        ],  
      ) 
    );
  }

  Widget profileAccount(BuildContext context) {
    return Column(
      children: [
    
        Container(
          margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    
                    Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          Row(
                            children: [
                              Text(getTranslated("MY_BALANCE", context),
                                style: poppinsRegular.copyWith(
                                  fontSize: 9.0.sp,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Consumer<PPOBProvider>(
                                builder: (BuildContext context, PPOBProvider ppobProvider, Widget child) {
                                  return Text(ppobProvider.balanceStatus == BalanceStatus.loading 
                                    ? "..." 
                                    : ppobProvider.balanceStatus == BalanceStatus.error 
                                    ? "..."
                                    : ConnexistHelper.formatCurrency(double.parse(ppobProvider.balance.toString())),
                                    style: poppinsRegular.copyWith(
                                      fontSize: 9.0.sp,
                                      fontWeight: FontWeight.normal
                                    ),
                                  );
                                },
                              )
                            ],
                          ),

                          SizedBox(width: 15.0),
                          
                          InkWell(
                            onTap: () => Provider.of<PPOBProvider>(context, listen: false).getBalance(context),
                            child: Icon(
                              Icons.refresh,
                              color: ColorResources.BLACK,
                            ),
                          ),

                        ]
                      ),
                    ),

                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 2.h, bottom: 2.h, left: 3.w, right: 3.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    FittedBox(
                      child: Container(
                        height: 30.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            primary: ColorResources.BLACK,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                            )
                          ),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TopUpScreen())), 
                          child: Text(getTranslated("TOPUP", context),
                            style: poppinsRegular.copyWith(
                              fontSize: 9.0.sp,
                              color: ColorResources.YELLOW_PRIMARY
                            ),
                          )
                        ),
                      ),
                    ),

                    SizedBox(width: 10.0),
                    
                    FittedBox(
                      child: Container(
                        height: 30.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            primary: ColorResources.BLACK,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                            )
                          ),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TopUpHistoryScreen())), 
                          child: Text(getTranslated("HISTORY_BALANCE", context),
                            style: poppinsRegular.copyWith(
                              fontSize: 9.0.sp,
                              color: ColorResources.YELLOW_PRIMARY
                            ),
                          )
                        ),
                      ),
                    ),
                      
                  ],
                ),
              ),

              if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "user")
                FittedBox(
                  child: Container(
                    margin: EdgeInsets.only(left: 3.w),
                    height: 30.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        primary: ColorResources.BLACK,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        )
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryActivityScreen())), 
                      child: Text(getTranslated("HISTORY_ACTIVITY", context),
                        style: poppinsRegular.copyWith(
                          fontSize: 9.0.sp,
                          color: ColorResources.YELLOW_PRIMARY
                        ),
                      )
                    ),
                  ),
                ),

              if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "user")
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Consumer<ProfileProvider>(
                        builder: (BuildContext context, ProfileProvider profileProviuder, Widget child) {
                          return profileListAccount(context, getTranslated("REFERRAL_CODE", context), profileProviuder.profileStatus == ProfileStatus.loading
                          ? "..."
                          : profileProviuder.profileStatus == ProfileStatus.error 
                          ? "..."
                          : profileProviuder.getUserCodeReferral
                          );
                        },
                      )
                    ],
                  ),
                ),
              if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "user")
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Consumer<ProfileProvider>(
                        builder: (BuildContext context, ProfileProvider profileProviuder, Widget child) {
                          return profileListAccount(context, getTranslated("ADDRESS", context), profileProviuder.profileStatus == ProfileStatus.loading
                          ? "..."
                          : profileProviuder.profileStatus == ProfileStatus.error 
                          ? "..."
                          : profileProviuder.getUserAddress
                          );
                        },
                      )
                    ],
                  ),
                ),
              if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "relatives")
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Consumer<ProfileProvider>(
                        builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                          return profileListAccount(context, getTranslated("REFERRAL_BY", context), profileProvider.profileStatus == ProfileStatus.loading
                            ? "..."
                            : profileProvider.profileStatus == ProfileStatus.error 
                            ? "..."
                            : profileProvider.getUserReferralBy
                          );  
                        }
                      )
                    ],
                  ),
                ),
              if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "user")
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Consumer<ProfileProvider>(
                        builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                          return profileListAccount(context, getTranslated("CHAPTER", context), profileProvider.profileStatus == ProfileStatus.loading
                          ? "..."
                          : profileProvider.profileStatus == ProfileStatus.error 
                          ? "..."
                          : profileProvider.getUserChapter
                          );
                        },
                      )
                    ],  
                  ),
                ),
              if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "user")
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Consumer<ProfileProvider>(
                        builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                          return profileListAccount(context, getTranslated("SUB_MODEL", context), Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.loading
                          ? "..."
                          : Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.error 
                          ? "..."
                          : Provider.of<ProfileProvider>(context, listen: false).getUserSubModel
                          );                    
                        },  
                      )
                    ],
                  ),
                ),
              if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "user")
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Consumer<ProfileProvider>(
                        builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                          return profileListAccount(context, getTranslated("BODY_STYLE", context), profileProvider.profileStatus == ProfileStatus.loading
                          ? "..."
                          : profileProvider.profileStatus == ProfileStatus.error 
                          ? "..."
                          : profileProvider.getUserBodyStyle
                          );
                        },
                      )
                    ],
                  ),
                ),
              if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "lead")
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Consumer<ProfileProvider>(
                        builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                          return profileListAccount(context, "No KTP", profileProvider.profileStatus == ProfileStatus.loading
                          ? "..."
                          : profileProvider.profileStatus == ProfileStatus.error 
                          ? "..."
                          : profileProvider.getUserNoKtp
                          );
                        }         
                      )
                    ],
                  ),
                ),
              if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "lead")
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Consumer<ProfileProvider>(
                        builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                          return profileListAccount(context, getTranslated("COMPANY_NAME", context), Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.loading
                          ? "..."
                          : profileProvider.profileStatus == ProfileStatus.error 
                          ? "..."
                          : profileProvider.getUserCompany
                          );
                        },
                      ),
                    ],
                  ),
                ),
             
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Consumer<ProfileProvider>(
                  builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                    return profileListAccount(context, getTranslated("EMAIL", context), Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.loading
                    ? "..."
                    : profileProvider.profileStatus == ProfileStatus.error 
                    ? "..."
                    : profileProvider.getUserEmail
                    );          
                  },
                ) 
              ),
              if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "user")
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Consumer<ProfileProvider>(
                        builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                          return profileListAccount(context, getTranslated("NO_MEMBER", context), Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.loading
                          ? "..."
                          : profileProvider.profileStatus == ProfileStatus.error 
                          ? "..."
                          : profileProvider.getUserIdNumber
                          );                    
                        },  
                      )
                      
                    ],
                  ),
                ),
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Consumer<ProfileProvider>(
                  builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                    return profileListAccount(context, getTranslated("PHONE_NUMBER", context), Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.loading 
                    ? "..." 
                    : profileProvider.profileStatus == ProfileStatus.error 
                    ? "..." 
                    : profileProvider.getUserPhoneNumber);                  
                  },
                ) 
              ),
              SizedBox(height: 10.0),
              Center(
                child: FittedBox(
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    height: 30.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        primary: ColorResources.BLACK,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        )
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileEditScreen())),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            size: 16.0,
                            color: ColorResources.YELLOW_PRIMARY
                          ),
                          SizedBox(width: 10.0),
                          Text(getTranslated("EDIT", context),
                            style: poppinsRegular.copyWith(
                              fontSize: 9.0.sp,
                              color: ColorResources.YELLOW_PRIMARY
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                ),
              ),

            ],
          )
        )
      ],
    );
  }
 
  Widget digitalCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        children: [
        
          Container(
            margin: EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
            child: Stack(
              children: [
                
                if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "user")
                  Image.asset(Images.card),

                if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "lead" || Provider.of<ProfileProvider>(context, listen: false).getUserRole == "relatives") 
                  Image.asset(Images.card_partnership), 
                
                if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "user") 
                  Positioned(
                    top: 125.0,
                    left: 30.0,
                    child: CachedNetworkImage(
                      imageUrl: "${AppConstants.BASE_URL_IMG}${Provider.of<ProfileProvider>(context, listen: false).getUserProfilePic}",
                      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                        return CircleAvatar(
                          radius: 30.0,
                          backgroundColor: ColorResources.WHITE,
                          backgroundImage: imageProvider,
                        );
                      },
                      placeholder: (BuildContext context, String url) {
                        return Container(
                          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 18.0,
                            height: 18.0,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorWidget: (BuildContext context, String url, dynamic error) {
                        return CircleAvatar(
                          radius: 30.0,
                          backgroundColor: ColorResources.WHITE,
                          backgroundImage: AssetImage('assets/images/profile-drawer.png'),
                        );
                      },
                    )
                  ),  
                  

                if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "lead")
                  Positioned(
                    top: 20.0,
                    left: 30.0,
                    child: Text("PARTNERSHIP",
                      style: poppinsRegular.copyWith(
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorResources.YELLOW_PRIMARY
                      ),
                    ),
                  ),

                if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "relatives")
                  Positioned(
                    top: 20.0,
                    left: 30.0,
                    child: Text("RELATIONSHIP",
                      style: poppinsRegular.copyWith(
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorResources.YELLOW_PRIMARY
                      ),
                    ),
                  ),

                if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "lead" || Provider.of<ProfileProvider>(context, listen: false).getUserRole == "relatives")
                  Positioned(
                    top: 20.0,
                    right: 20.0,
                    child: Image.asset(
                      Images.logo_app,
                      width: 40.0,
                      height: 40.0,  
                    )
                  ),

                if(Provider.of<ProfileProvider>(context, listen: false).getUserRole == "lead" || Provider.of<ProfileProvider>(context, listen: false).getUserRole == "relatives")
                  Positioned(
                    top: 50.0,
                    left: 30.0,
                    child: Text("MERCEDES BENZ W204 CLUB INDONESIA",
                      style: poppinsRegular.copyWith(
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorResources.WHITE
                      ),
                    ),
                  ),

                Positioned(
                  top: Provider.of<ProfileProvider>(context, listen: false).getUserRole == "lead" || Provider.of<ProfileProvider>(context, listen: false).getUserRole == "relatives" ? 90.0 : 130.0,
                  left: Provider.of<ProfileProvider>(context, listen: false).getUserRole == "lead" || Provider.of<ProfileProvider>(context, listen: false).getUserRole == "relatives" ? 32.0 : 105.0,
                  child:  Consumer<ProfileProvider>(
                    builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                      return Text(profileProvider.profileStatus == ProfileStatus.loading  
                      ? "..." 
                      : profileProvider.profileStatus == ProfileStatus.error 
                      ? "..." 
                      : profileProvider.getUserFullname,
                        style: poppinsRegular.copyWith(
                          color: Provider.of<ProfileProvider>(context, listen: false).getUserRole == "lead" ? ColorResources.YELLOW_PRIMARY : ColorResources.WHITE,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0.sp
                        ),
                      );
                    },
                  )
                ),

                Positioned(
                  top: Provider.of<ProfileProvider>(context, listen: false).getUserRole == "lead" || Provider.of<ProfileProvider>(context, listen: false).getUserRole == "relatives" ? 110.0 : 150.0,
                  left: Provider.of<ProfileProvider>(context, listen: false).getUserRole == "lead" || Provider.of<ProfileProvider>(context, listen: false).getUserRole == "relatives" ? 32.0 : 105.0,
                  child: Consumer<ProfileProvider>(
                    builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                      return Text(profileProvider.profileStatus == ProfileStatus.loading  
                      ? "..." 
                      : profileProvider.profileStatus == ProfileStatus.error 
                      ? "..." 
                      : "${profileProvider.getUserIdNumber}",
                        style: poppinsRegular.copyWith(
                          color: Provider.of<ProfileProvider>(context, listen: false).getUserRole == "lead" ? ColorResources.YELLOW_PRIMARY : ColorResources.BTN_PRIMARY_SECOND,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0.sp
                        ),
                      );
                    },
                  )
                ),
                      
                Positioned(
                  bottom: 10.0,
                  left: Provider.of<ProfileProvider>(context, listen: false).getUserRole == "lead" ? 15.0 : null,
                  right: Provider.of<ProfileProvider>(context, listen: false).getUserRole == "lead" ? null : 10.0,
                  child: Container(
                    height: 18.0,
                    child: Image.asset(Images.logo_cx)
                  )
                ),

                Positioned(
                  right: 10.0,
                  bottom: 40.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorResources.WHITE
                    ),
                    child: Consumer<ProfileProvider>(
                      builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                        return profileProvider.profileStatus == ProfileStatus.loading 
                        ? Container()
                        : profileProvider.profileStatus == ProfileStatus.error 
                        ? Text("...")
                        : QrImage(
                          data: profileProvider.getUserIdNumber,
                          version: QrVersions.auto,
                          size: 70.0,
                        );
                      },
                    ),
                  ),
                ),

              ],
            ),
          ),

          // Container(
          //   width: double.infinity,
          //   margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
          //   height: 30.0,
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       elevation: 0.0,
          //       primary: ColorResources.BLACK,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(20.0)
          //       )
          //     ),
          //     onPressed: () {}, 
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Container(
          //           height: 20.0,
          //           child: Image.asset(Images.scan)
          //         ),
          //         SizedBox(width: 20.0),
          //         Text("Scan disini",
          //           style: poppinsRegular.copyWith(
          //             fontSize: 14.0,
          //             color: ColorResources.YELLOW_PRIMARY
          //           ),
          //         )
          //       ],
          //     )
          //   ),
          // ),

          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
            height: 30.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                primary: ColorResources.WHITE,
                side: BorderSide(
                  color: ColorResources.BLACK
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                )
              ),
              onPressed: () {}, 
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 20.0,
                    child: Image.asset(Images.profile_drawer)
                  ),
                  SizedBox(width: 20.0),
                  Consumer<ProfileProvider>(
                    builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                      return profileProvider.profileStatus == ProfileStatus.loading 
                      ? Text("...",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: ColorResources.BLACK
                        ),
                      )
                      : profileProvider.profileStatus == ProfileStatus.error 
                      ? Text("...",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: ColorResources.BLACK
                        ),
                      )
                      : Text("ID ${profileProvider.getUserIdNumber}",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: ColorResources.BLACK
                        ),
                      );
                    },
                  )

                ],
              )
            ),
          ),

        ],
      )
    );
  }

  Widget profileListAccount(BuildContext context, String label, String title) {
    return  Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
            style: poppinsRegular.copyWith(
              fontSize: 9.0.sp
            ),
          ),
          SizedBox(height: 5.0),
          Text(title,
            style: poppinsRegular.copyWith(
              color: ColorResources.BTN_PRIMARY_SECOND,
              fontSize: 9.0.sp
            ),
          ),
          Divider(
            height: 1.0,
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
