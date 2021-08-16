import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/localization.dart';
import 'package:mbw204_club_ina/views/basewidget/animated_custom_dialog.dart';
import 'package:mbw204_club_ina/views/screens/setting/widgets/language_dialog.dart';
import 'package:mbw204_club_ina/views/screens/dashboard/dashboard.dart';
import 'package:mbw204_club_ina/data/models/user.dart';
import 'package:mbw204_club_ina/helpers/show_snackbar.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/auth/sign_up.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool passwordObscure = false;

  UserData userData = UserData();

  Future login(BuildContext context) async {
    try {
      String phoneNumber = phoneNumberController.text;
      String password = passwordController.text;
      if(phoneNumber.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Phone Number / No Member is Required", "", ColorResources.ERROR); 
        return;
      } 
      if(password.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Password is Required", "", ColorResources.ERROR); 
        return;
      }
      userData.phoneNumber = phoneNumberController.text;
      userData.password = passwordController.text;
      await Provider.of<AuthProvider>(context, listen: false).login(context, globalKey, userData);
    } on CustomException catch(e) {
      String error = e.toString();
      ShowSnackbar.snackbar(context, error, "", ColorResources.ERROR); 
    } on ConnectionTimeoutException catch(e) {
      String error = e.toString();
      ShowSnackbar.snackbar(context, getTranslated(error, context), "", ColorResources.ERROR); 
    } catch(_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: Consumer<AuthProvider>(
        builder: (BuildContext context, AuthProvider authProvider, Widget child) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  SizedBox(height: 30.0),

                  Image.asset(
                    Images.logo_login, 
                    height: 150.0, 
                    width: 200.0, 
                  ),

                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: ColorResources.BLACK,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)
                        )
                      ),
                      child: ListView(
                        children: [
                          
                          Container(
                            margin: EdgeInsets.only(left: 16.0, right: 16.0),
                            padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.login,
                                            color: ColorResources.WHITE,
                                          ),
                                          SizedBox(width: 15.0),
                                          Text("${getTranslated("PHONE_NUMBER", context)} / ${getTranslated("NO_MEMBER", context)}", style: poppinsRegular.copyWith(
                                            color: ColorResources.WHITE,
                                            fontSize: 9.0.sp
                                          ))
                                        ],
                                      ),
                                      Container(
                                        child: TextField(
                                          controller: phoneNumberController,
                                          style: poppinsRegular.copyWith(
                                            color: ColorResources.WHITE,
                                            fontSize: 9.0.sp
                                          ),
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: "ex. 0896xxxxxxxx / W204xxxxxxx",
                                            hintStyle: poppinsRegular.copyWith(
                                              color: ColorResources.GRAY_PRIMARY,
                                              fontSize: 9.0.sp
                                            ),
                                            isDense: true,
                                            enabledBorder: UnderlineInputBorder(      
                                              borderSide: BorderSide(color: ColorResources.WHITE),   
                                            ),  
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: ColorResources.WHITE),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(color: ColorResources.WHITE),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(top: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.lock,
                                            color: ColorResources.WHITE,
                                          ),
                                          SizedBox(width: 15.0),
                                          Text(getTranslated("PASSWORD", context), style: poppinsRegular.copyWith(
                                            color: ColorResources.WHITE,
                                            fontSize: 9.0.sp
                                          ))
                                        ],
                                      ),
                                      StatefulBuilder(
                                        builder: (BuildContext context, Function setState) {
                                          return TextField(
                                            controller: passwordController,
                                            obscureText: passwordObscure,
                                            style: poppinsRegular.copyWith(
                                              color: ColorResources.WHITE,
                                              fontSize: 9.0.sp
                                            ),
                                            decoration: InputDecoration(
                                              hintText: getTranslated("ENTER_YOUR_PASSWORD", context),
                                              suffixIcon: InkWell(
                                                onTap: () => setState(() => passwordObscure = !passwordObscure), 
                                                child: Icon(
                                                  passwordObscure 
                                                  ? Icons.visibility_off 
                                                  : Icons.visibility,
                                                  color: ColorResources.WHITE
                                                ),
                                              ),
                                              contentPadding: EdgeInsets.only(top: 13),
                                              hintStyle: poppinsRegular.copyWith(
                                                color: ColorResources.GRAY_PRIMARY,
                                                fontSize: 9.0.sp
                                              ),
                                              isDense: true,
                                              enabledBorder: UnderlineInputBorder(      
                                                borderSide: BorderSide(color: ColorResources.WHITE),   
                                              ),  
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: ColorResources.WHITE),
                                              ),
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(color: ColorResources.WHITE),
                                              ),
                                            ),
                                            textInputAction: TextInputAction.next,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 15.0),
                                  child: ElevatedButton(
                                    onPressed: () => login(context),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0)
                                      ),
                                      primary: ColorResources.YELLOW_PRIMARY
                                    ),
                                    child: authProvider.loginStatus == LoginStatus.loading 
                                    ? Loader(
                                      color: ColorResources.BTN_PRIMARY_SECOND,
                                    )
                                    : Text(getTranslated("SIGN_IN", context),
                                      style: poppinsRegular.copyWith(
                                        color: ColorResources.BLACK,
                                        fontSize: 9.0.sp
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 5.0),
                                  child: ElevatedButton(
                                    onPressed: () =>  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => DashBoardScreen()),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0)
                                      ),
                                      primary: ColorResources.BTN_PRIMARY_SECOND
                                    ),
                                    child: Text(getTranslated("SIGN_AS_ANONYM", context),
                                      style: poppinsRegular.copyWith(
                                        color: ColorResources.WHITE,
                                        fontSize: 9.0.sp
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                                  child: InkWell(
                                    onTap: () => showAnimatedDialog(context, LanguageDialog()),
                                    child: Consumer<LocalizationProvider>(
                                      builder: (BuildContext context, LocalizationProvider localizationProvider, Widget child) {
                                        return Text("${getTranslated("CHOOSE_LANGUAGE", context)} - ${localizationProvider.locale}",
                                          style: poppinsRegular.copyWith(
                                            color: ColorResources.WHITE,
                                            fontSize: 9.0.sp
                                          ), 
                                        );
                                      },
                                    )
                                  ),
                                ),
                                    
                                Container(
                                  margin: EdgeInsets.only(top: 30.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10.0, right: 20.0),
                                          child: Divider(
                                            color: ColorResources.WHITE,
                                            height: 36.0,
                                          )
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())),
                                        child: Text(getTranslated("CREATE_ACCOUNT", context),
                                          style: poppinsRegular.copyWith(
                                            color: ColorResources.YELLOW_PRIMARY,
                                            fontSize: 9.0.sp
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 20.0, right: 10.0),
                                          child: Divider(
                                            color: ColorResources.WHITE,
                                            height: 36.0,
                                          )
                                        ),
                                      ),
                                    ]
                                  ),
                                )      

                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  )
                  
                ],
              )
            ],
          );
        },
      ) 
    );
  }
}