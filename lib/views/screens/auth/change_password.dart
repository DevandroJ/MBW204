import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/data/models/user.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';

class ChangePasswordScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> formkey = GlobalKey();
  final UserData userData = UserData();

  bool passwordOldObscure = false;
  bool passwordNewObscure = false;
  bool passwordConfirmObscure = false;
  
  final TextEditingController passwordOldController = TextEditingController();
  final TextEditingController passwordNewController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {

    Future changePassword() async {
      try { 
        if(passwordOldController.text.trim().isEmpty) {
          Fluttertoast.showToast(
            msg: getTranslated("PASSWORD_OLD_IS_REQUIRED", context),
            backgroundColor: ColorResources.ERROR
          );
          return;
        }
        if(passwordNewController.text.trim().isEmpty) {
          Fluttertoast.showToast(
            msg: getTranslated("PASSWORD_NEW_IS_REQUIRED", context),
            backgroundColor: ColorResources.ERROR
          );
          return;
        }
        if(passwordConfirmController.text.trim().isEmpty) {
          Fluttertoast.showToast(
            msg: getTranslated("PASSWORD_CONFIRM_IS_REQUIRED", context),
            backgroundColor: ColorResources.ERROR
          );
          return;
        }
        if(passwordNewController.text != passwordConfirmController.text) {
          Fluttertoast.showToast(
            msg: getTranslated("PASSWORD_CONFIRM_IS_REQUIRED", context),
            backgroundColor: ColorResources.ERROR
          );
          return;
        }
        userData.password = passwordOldController.text;
        userData.passwordNew = passwordNewController.text;
        userData.passwordConfirm = passwordConfirmController.text;
        await Provider.of<AuthProvider>(context, listen: false).forgotPassword(context, userData);
        Fluttertoast.showToast(
          msg: getTranslated("UPDATE_PASSWORD_SUCCESS", context),
          backgroundColor: ColorResources.SUCCESS
        );
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      } on ServerErrorException catch(e) {
         Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: ColorResources.ERROR
        );
      } catch(e) {
        print(e);
      }
    }

    return Scaffold(
      key: formkey,
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
        title: Text("Ubah Kata Sandi",
          style: poppinsRegular.copyWith(
            color: ColorResources.BLACK,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: ColorResources.GRAY_LIGHT_PRIMARY,
      ),
      body: Stack(
        children: [

          ClipPath(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150.0,
              color: ColorResources.GRAY_LIGHT_PRIMARY,
            ),
            clipper: CustomClipPath(),
          ),

          Container(
            margin: EdgeInsets.only(top: 30.0),
            height: 250.0,
            child: Card(
              elevation: 3.0,
              child: Container(
                margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Kata Sandi Baru", 
                      style: poppinsRegular,
                    ),

                    StatefulBuilder(
                      builder: (BuildContext context, Function setState) {
                        return TextField(
                          controller: passwordOldController,
                          obscureText: passwordOldObscure,
                          decoration: InputDecoration(
                            hintText: "Kata Sandi Lama",
                            hintStyle: TextStyle(
                              fontSize: 14.0
                            ),
                            contentPadding: EdgeInsets.only(
                              top: 15.0
                            ),
                            isDense: true,
                            suffixIcon: InkWell(
                              onTap: () => setState(() => passwordOldObscure = !passwordOldObscure),
                              child: Icon(
                                passwordOldObscure ? Icons.visibility_off : Icons.visibility
                              ),
                            )
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 20.0),

                    StatefulBuilder(
                      builder: (BuildContext context, Function setState) {
                        return TextField(
                          controller: passwordNewController,
                          obscureText: passwordNewObscure,
                          decoration: InputDecoration(
                            hintText: "Kata Sandi Baru",
                            hintStyle: TextStyle(
                              fontSize: 14.0
                            ),
                            contentPadding: EdgeInsets.only(
                              top: 15.0
                            ),
                            isDense: true,
                            suffixIcon: InkWell(
                              onTap: () => setState(() => passwordNewObscure = !passwordNewObscure),
                              child: Icon(
                                passwordNewObscure ? Icons.visibility_off : Icons.visibility
                              ),
                            )
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 20.0),

                    StatefulBuilder(
                      builder: (BuildContext context, Function setState) {
                        return TextField(
                          controller: passwordConfirmController,
                          obscureText: passwordConfirmObscure,
                          decoration: InputDecoration(
                            hintText: "Konfirmasi Kata Sandi Baru",
                            hintStyle: TextStyle(
                              fontSize: 14.0
                            ),
                            contentPadding: EdgeInsets.only(
                              top: 15.0
                            ),
                            isDense: true,
                            suffixIcon: InkWell(
                              onTap: () => setState(() => passwordConfirmObscure = !passwordConfirmObscure),
                              child: Icon(
                                passwordConfirmObscure ? Icons.visibility_off : Icons.visibility
                              ),
                            )
                          ),
                        );
                      },
                    ),
    
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 30.0, left: 10.0, right: 10.0),
              height: 40.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: ColorResources.BLACK,
                  side: BorderSide(
                    color: ColorResources.BLACK
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  )
                ),
                onPressed: () {}, 
                child: Text("Simpan",
                  style: poppinsRegular.copyWith(
                    color: ColorResources.YELLOW_PRIMARY
                  ),
                )
              ),
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
