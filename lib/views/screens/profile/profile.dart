import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
                    backgroundColor: ColorResources.WHITE,
                    backgroundImage: NetworkImage("https://cdn0-production-images-kly.akamaized.net/0r0vo4waPk9g2ZOtSePxceTuoyE=/640x480/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/706185/original/Daniel-Radcliffe-140710.gif"),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 180.0),
                  child: Text(Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.loading  
                  ? "..." 
                  : Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.error 
                  ? "..." 
                  : Provider.of<ProfileProvider>(context, listen: false).getUserFullname, 
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
            child: TabBar(
              controller:tabController,
              indicatorColor: ColorResources.BLACK,
              labelColor: ColorResources.BLACK,
              unselectedLabelColor: ColorResources.GRAY_PRIMARY,
              tabs: [
                Tab(
                  text: "Profil",
                ),
                Tab(
                  text: "Kartu Digital",
                ),
              ],
            )
          ),

          Container(
            height: 520.0,
            child: TabBarView(
              controller: tabController,
              children: [
                profileAccount(context),
                digitalCard(context),
              ],
            ),
          ),
          
        ],  
      ) 
    );
  }

  Widget profileAccount(BuildContext context) {
    return Column(
      children: [
    
        Container(
          margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      Consumer<PPOBProvider>(
                        builder: (context, PPOBProvider ppobProvider, Widget child) {
                          return Text(ppobProvider.balanceStatus == BalanceStatus.loading 
                            ? "..." 
                            : ppobProvider.balanceStatus == BalanceStatus.error 
                            ? "..."
                            : ConnexistHelper.formatCurrency(double.parse(ppobProvider.balance.toString())),
                            style: poppinsRegular.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal
                            ),
                          );
                        },
                      )
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
                          onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => TopUpScreen()),
                          ), 
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
              ),

              SizedBox(height: 20.0),

              profileListAccount(context, "ID Anggota", Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.loading
              ? "..."
              : Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.error 
              ? "..."
              : Provider.of<ProfileProvider>(context, listen: false).getUserIdCardNumber
              ),
              SizedBox(height: 10.0),
              profileListAccount(context, "Nomor Identitas KTP", Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.loading 
              ? "..." 
              : Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.error 
              ? "..." 
              : Provider.of<ProfileProvider>(context, listen: false).getUserIdCardNumber),
              SizedBox(height: 10.0),
              profileListAccount(context, "Nomor Handphone", Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.loading 
              ? "..." 
              : Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.error 
              ? "..." 
              : Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber),
              SizedBox(height: 10.0),
              profileListAccount(context, "Alamat", Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.loading 
              ? "..." 
              : Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.error 
              ? "..." 
              : Provider.of<ProfileProvider>(context, listen: false).getUserAddress),
              SizedBox(height: 10.0),
              profileListAccount(context, "Tempat Lahir", "Jakarta"),
              SizedBox(height: 10.0),
              profileListAccount(context, "Tanggal Lahir", "7 Juli 2000"),

              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  width: 130.0,
                  height: 30.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      primary: ColorResources.BLACK,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      )
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileEditScreen()),
                      );
                    }, 
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
                        Text("Edit",
                          style: poppinsRegular.copyWith(
                            fontSize: 14.0,
                            color: ColorResources.YELLOW_PRIMARY
                          ),
                        )
                      ],
                    )
                  ),
                ),
              ),

            ],
          )
        )
      ],
    );
  }

  Widget profileListAccount(BuildContext context, String label, String title) {
    return  Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
            style: poppinsRegular,
          ),
          SizedBox(height: 5.0),
          Text(title,
            style: poppinsRegular.copyWith(
              color: ColorResources.BTN_PRIMARY_SECOND
            ),
          ),
          Divider(
            height: 1.0,
          )
        ],
      ),
    );
  }
 
  Widget digitalCard(BuildContext context) {
    return Column(
      children: [
    
        Container(
          margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
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
                      Consumer<PPOBProvider>(
                        builder: (context, PPOBProvider ppobProvider, Widget child) {
                          return Text(ppobProvider.balanceStatus == BalanceStatus.loading 
                            ? "..." 
                            : ppobProvider.balanceStatus == BalanceStatus.error 
                            ? "..."
                            : ConnexistHelper.formatCurrency(double.parse(ppobProvider.balance.toString())),
                            style: poppinsRegular.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal
                            ),
                          );
                        },
                      )
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
              ),
            
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Stack(
                  children: [

                    Image.asset(Images.card),

                    Positioned(
                      top: 125.0,
                      left: 30.0,
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: ColorResources.WHITE,
                        backgroundImage: NetworkImage("https://cdn0-production-images-kly.akamaized.net/0r0vo4waPk9g2ZOtSePxceTuoyE=/640x480/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/706185/original/Daniel-Radcliffe-140710.gif") ,
                      )
                    ),

                    Positioned(
                      top: 130.0,
                      left: 105.0,
                      child: Text(Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.loading  
                      ? "..." 
                      : Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.error 
                      ? "..." 
                      : Provider.of<ProfileProvider>(context, listen: false).getUserFullname,
                        style: poppinsRegular.copyWith(
                          color: ColorResources.WHITE,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                        ),
                      ),
                    ),

                    Positioned(
                      top: 155.0,
                      left: 105.0,
                      child: Text(Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.loading  
                      ? "..." 
                      : Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.error 
                      ? "..." 
                      : Provider.of<ProfileProvider>(context, listen: false).getUserIdNumber,
                        style: poppinsRegular.copyWith(
                          color: ColorResources.BTN_PRIMARY_SECOND,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 10.0,
                      right: 10.0,
                      child: Container(
                        height: 20.0,
                        child: Image.asset(Images.logo_cx)
                      )
                    )

                  ],
                ),
              ),

              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 20.0,
                        child: Image.asset(Images.scan)
                      ),
                      SizedBox(width: 20.0),
                      Text("Scan disini",
                        style: poppinsRegular.copyWith(
                          fontSize: 14.0,
                          color: ColorResources.YELLOW_PRIMARY
                        ),
                      )
                    ],
                  )
                ),
              ),

              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
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
                      Text("ID ${Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.loading  
                      ? "..." 
                      : Provider.of<ProfileProvider>(context, listen: false).profileStatus == ProfileStatus.error 
                      ? "..." 
                      : Provider.of<ProfileProvider>(context, listen: false).getUserIdNumber}",
                        style: poppinsRegular.copyWith(
                          fontSize: 14.0,
                          color: ColorResources.BLACK
                        ),
                      )
                    ],
                  )
                ),
              ),

            ],
          )
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
