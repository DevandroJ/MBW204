import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/data/models/user.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/helpers/show_snackbar.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_dropdown.dart';
import 'package:mbw204_club_ina/views/screens/auth/sign_in.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';

enum StatusRegister { member, partnership, partnership_member, relationship_member }

class SignUpScreen extends StatefulWidget{

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    
    /* Member & Partnership */ 
    TextEditingController referralCodeController = TextEditingController(); 
    TextEditingController fullnameController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();  
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController passwordConfirmController = TextEditingController();

    String userUrlRegister = "";

    /* Member */ 
    TextEditingController noMemberController = TextEditingController();
    String chapter = "";
    String subModel = "";
    String bodyStyle = "";

    /* Partnership */ 
    TextEditingController noKtpController = TextEditingController();
    TextEditingController companyNameController = TextEditingController();

    /* Relationship Member */
    TextEditingController relationshipMemberController = TextEditingController();

    bool passwordObscure = false;
    bool passwordConfirmObscure = false;

    UserData userData = UserData();
    StatusRegister _statusRegister = StatusRegister.member;

    Future register(BuildContext context) async {
      try {
        if(fullnameController.text.trim().isEmpty) {
          ShowSnackbar.snackbar(context, "Fullname is Required", "", ColorResources.ERROR);
          return;
        }
        if(usernameController.text.trim().isEmpty) {
          ShowSnackbar.snackbar(context, "Username is Required", "", ColorResources.ERROR);
          return;
        }
        if(!usernameController.text.startsWith('@')) {
          ShowSnackbar.snackbar(context, "ex. @johndoe", "", ColorResources.ERROR);
          return;
        }
        if(phoneNumberController.text.trim().isEmpty) {
          ShowSnackbar.snackbar(context, "Phone number is Required", "", ColorResources.ERROR);
          return;
        } 
        if(phoneNumberController.text.trim().length < 12) {
          ShowSnackbar.snackbar(context, "Phone number Must be 12 Character", "", ColorResources.ERROR);
          return;
        }
        
        if(emailController.text.trim().isEmpty) {
          ShowSnackbar.snackbar(context, "Email Address is Required", "", ColorResources.ERROR);
          return;
        }
        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text); 
        if(!emailValid) {
          ShowSnackbar.snackbar(context, "ex. johndoe@gmail.com", "", ColorResources.ERROR);
          return;
        }
        if(passwordController.text.trim().isEmpty) {
          ShowSnackbar.snackbar(context, "Password is Required", "", ColorResources.ERROR);
          return;
        }
        if(passwordConfirmController.text.trim().isEmpty) {
          ShowSnackbar.snackbar(context, "Password Confirm is Required", "", ColorResources.ERROR);
          return;
        }
        if(passwordController.text != passwordConfirmController.text) {
          ShowSnackbar.snackbar(context, "Password Confirm doest not match", "", ColorResources.ERROR);
          return;
        }
        if(_statusRegister == StatusRegister.member) {
          userUrlRegister = "user";
          if(noMemberController.text.trim().isEmpty) {
            ShowSnackbar.snackbar(context, "No Member is Required", "", ColorResources.ERROR);
            return;
          }
          if(chapter.trim().isEmpty) {
            ShowSnackbar.snackbar(context, "Chapter is Required", "", ColorResources.ERROR);
            return;
          }
          if(subModel.trim().isEmpty) {
            ShowSnackbar.snackbar(context, "Sub Model is Required", "", ColorResources.ERROR);
            return;
          }
          if(bodyStyle.trim().isEmpty) {
            ShowSnackbar.snackbar(context, "Body Style is Required", "", ColorResources.ERROR);
            return;
          }
          userData.fullname = fullnameController.text;
          userData.phoneNumber = phoneNumberController.text;
          userData.emailAddress = emailController.text;
          userData.password = passwordController.text;
          userData.noMember = noMemberController.text;
          userData.chapter = chapter;
          userData.codeChapter = chapter;
          userData.subModel = subModel;
          userData.bodyStyle = bodyStyle;
        }
        if(_statusRegister == StatusRegister.partnership_member) {
          userUrlRegister = "partnership";
          if(noKtpController.text.trim().isEmpty) {
            ShowSnackbar.snackbar(context, "No KTP is Required", "", ColorResources.ERROR);
            return; 
          }
          if(companyNameController.text.trim().isEmpty) {
            ShowSnackbar.snackbar(context, "Company is Required", "", ColorResources.ERROR);
            return; 
          }
          userData.fullname = fullnameController.text;
          userData.phoneNumber = phoneNumberController.text;
          userData.emailAddress = emailController.text;
          userData.password = passwordController.text;
          userData.noKtp = noKtpController.text;
          userData.companyName = companyNameController.text;
        }
        if(_statusRegister == StatusRegister.relationship_member) {
          userUrlRegister = "relatives";
          if(relationshipMemberController.text.trim().isEmpty) {
            ShowSnackbar.snackbar(context, "Code Referral is Required", "", ColorResources.ERROR);
            return;
          }
          userData.fullname = fullnameController.text;
          userData.phoneNumber = phoneNumberController.text;
          userData.emailAddress = emailController.text;
          userData.password = passwordController.text;
          userData.codeReferfall = referralCodeController.text;
        }

        await Provider.of<AuthProvider>(context, listen: false).register(context, userData, userUrlRegister);

      } on CustomException catch(e) {
        String error = e.toString();
        ShowSnackbar.snackbar(context, error, "", ColorResources.ERROR);    
      } catch(e) {
        print(e);
      }
    }

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Consumer<AuthProvider>(
            builder: (BuildContext context, AuthProvider authProvider, Widget child) => SafeArea(
              child: StatefulBuilder(
                builder: (BuildContext context, Function s) {
                  return Column(
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
                                              Icon(
                                                Icons.contact_phone,
                                                color: ColorResources.WHITE
                                              ),
                                              SizedBox(width: 15.0),
                                              Text(getTranslated("YOUR_REGISTRATION", context),
                                                style: poppinsRegular.copyWith(
                                                  color: ColorResources.WHITE,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 5.0),
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                unselectedWidgetColor: ColorResources.WHITE,
                                              ),
                                              child: Row(
                                                children: [
                                                  
                                                  Flexible(
                                                    child: RadioListTile<StatusRegister>(
                                                      value: StatusRegister.member, 
                                                      groupValue: _statusRegister, 
                                                      onChanged: (StatusRegister val) {
                                                        s(() {
                                                          _statusRegister = val;
                                                        });
                                                      },
                                                      
                                                      title: Text(getTranslated("MEMBER", context),
                                                        style: poppinsRegular.copyWith(
                                                          color: ColorResources.WHITE
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                    
                                                  Flexible(
                                                    child: RadioListTile<StatusRegister>(
                                                      value: StatusRegister.partnership, 
                                                      groupValue: _statusRegister, 
                                                      onChanged: (val) {
                                                        s(() {
                                                          _statusRegister = val;
                                                        });
                                                      },
                                              
                                                      title: Text(getTranslated("PARTNERSHIP", context),
                                                        style: poppinsRegular.copyWith(
                                                          color: ColorResources.WHITE
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                
                                                ],
                                              )
                                                      
                                              
                                            ),
                                          ),

                                        if(_statusRegister == StatusRegister.partnership 
                                        || _statusRegister == StatusRegister.partnership_member 
                                        || _statusRegister == StatusRegister.relationship_member)
                                          Theme(
                                            data: Theme.of(context).copyWith(
                                              unselectedWidgetColor: ColorResources.WHITE,
                                            ),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: RadioListTile<StatusRegister>(
                                                    value: StatusRegister.relationship_member, 
                                                    groupValue: _statusRegister, 
                                                    onChanged: (val) {
                                                      s(() {
                                                        _statusRegister = val;
                                                      });
                                                    },
                                                    title: Text(getTranslated("RELATIONSHIP_MEMBER", context),
                                                      style: poppinsRegular.copyWith(
                                                        color: ColorResources.WHITE
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: RadioListTile<StatusRegister>(
                                                    value: StatusRegister.partnership_member, 
                                                    groupValue: _statusRegister, 
                                                    onChanged: (val) {
                                                      s(() {
                                                        _statusRegister = val;
                                                      });
                                                    },
                                                    title: Text(getTranslated("PARTNERSHIP_MEMBER", context),
                                                      style: poppinsRegular.copyWith(
                                                        color: ColorResources.WHITE
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )                                     
                                          ),

                                        ],
                                      ) 
                                    ),

                                    if(_statusRegister == StatusRegister.relationship_member)
                                      Container(
                                        margin: EdgeInsets.only(top: 15.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.confirmation_number_outlined,
                                                  color: ColorResources.WHITE,
                                                ),
                                                SizedBox(width: 15.0),
                                                Text(getTranslated("REFERALL_CODE", context), style: poppinsRegular.copyWith(
                                                  color: ColorResources.WHITE
                                                ))
                                              ],
                                            ),
                                            TextField(
                                              controller: referralCodeController,
                                              style: poppinsRegular.copyWith(
                                                color: ColorResources.WHITE
                                              ),
                                              textInputAction: TextInputAction.next,
                                              decoration: InputDecoration(
                                                hintText: getTranslated("REFERALL_CODE", context),
                                                hintStyle: poppinsRegular,
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
                                          ],
                                        ),
                                      ),

                                    if(_statusRegister == StatusRegister.member)        
                                      Container(
                                        margin: EdgeInsets.only(top: 15.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.card_membership,
                                                  color: ColorResources.WHITE,
                                                ),
                                                SizedBox(width: 15.0),
                                                Text(getTranslated("MEMBER_NO", context), style: poppinsRegular.copyWith(
                                                  color: ColorResources.WHITE
                                                ))
                                              ],
                                            ),
                                            TextField(
                                              controller: noMemberController,
                                              style: poppinsRegular.copyWith(
                                                color: ColorResources.WHITE
                                              ),
                                              textInputAction: TextInputAction.next,
                                              decoration: InputDecoration(
                                                hintText: getTranslated("MEMBER_NO", context),
                                                hintStyle: poppinsRegular,
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
                                          ],
                                        )                                   
                                      ),

                                    if(_statusRegister == StatusRegister.member)
                                      Container(
                                        margin: EdgeInsets.only(top: 15.0),
                                        child: StatefulBuilder(
                                          builder: (BuildContext context, Function setState) {
                                            return CustomDropDownFormField(
                                              titleText: 'Chapter',
                                              hintText: 'Chapter',
                                              contentPadding: EdgeInsets.zero,
                                              value: chapter,
                                              filled: false,
                                              onSaved: (val) {
                                                setState(() => chapter = val);
                                              },
                                              onChanged: (val) {  
                                                setState(() => chapter = val);
                                              },
                                              dataSource: [
                                                {
                                                  "display": "Jakarta",
                                                  "value": "001",
                                                },
                                                {
                                                  "display": "Bandung",
                                                  "value": "002",
                                                },
                                                {
                                                  "display": "Tangerang",
                                                  "value": "003",
                                                },
                                                {
                                                  "display": "Surabaya",
                                                  "value": "004"
                                                }
                                              ],
                                              textField: 'display',
                                              valueField: 'value',
                                            );
                                            
                                          }, 
                                        ),
                                      ),

                                    if(_statusRegister == StatusRegister.member)
                                      Container(
                                        margin: EdgeInsets.only(top: 15.0),
                                        child: StatefulBuilder(
                                          builder: (BuildContext context, Function setState) {
                                            return CustomDropDownFormField(
                                              titleText: 'Sub Model',
                                              hintText: 'Sub Model',
                                              contentPadding: EdgeInsets.zero,
                                              value: subModel,
                                              filled: false,
                                              onSaved: (val) {
                                                setState(() => subModel = val);
                                              },
                                              onChanged: (val) {  
                                                setState(() => subModel = val);
                                              },
                                              dataSource: [
                                                {
                                                  "display": "C 180 Kompressor",
                                                  "value": "C 180 Kompressor",
                                                },
                                                {
                                                  "display": "C 200 Kompressor",
                                                  "value": "C 200 Kompressor",
                                                },
                                                {
                                                  "display": "C 230",
                                                  "value": "C 230",
                                                },
                                                {
                                                  "display": "C 250",
                                                  "value":"C 250"
                                                },
                                                {
                                                  "display": "C 280",
                                                  "value": "C 280",
                                                },
                                                {
                                                  "display": "C 350",
                                                  "value": "C 350",
                                                },
                                                {
                                                  "display": "C 200 CDI",
                                                  "value": "C 200 CDI",
                                                },
                                                {
                                                  "display": "C 220 CDI",
                                                  "value": "C 220 CDI",
                                                },
                                                {
                                                  "display": "C 250 CDI",
                                                  "value": "C 250 CDI"
                                                },
                                                {
                                                  "display": "C 320 CDI",
                                                  "value": "C 320 CDI",
                                                },
                                                {
                                                  "display": "C 180 CGI",
                                                  "value": "C 180 CGI"
                                                },
                                                {
                                                  "display": "C 200 CGI",
                                                  "value": "C 200 CGI"
                                                },
                                                {
                                                  "display": "C 250 CGI",
                                                  "value": "C 250 CGI"
                                                },
                                                {
                                                  "display": "C 350 CGI",
                                                  "value": "C 350 CGI"
                                                },
                                                {
                                                  "display": "C 63 AMG",
                                                  "value": "C 63 AMG"
                                                }
                                              ],
                                              textField: 'display',
                                              valueField: 'value',
                                            );
                                          }, 
                                        ),
                                      ),

                                    if(_statusRegister == StatusRegister.member)
                                      Container(
                                        margin: EdgeInsets.only(top: 15.0),
                                        child: StatefulBuilder(
                                          builder: (BuildContext context, Function setState) {
                                            return CustomDropDownFormField(
                                              titleText: 'Body Style',
                                              hintText: 'Body Style',
                                              contentPadding: EdgeInsets.zero,
                                              value: bodyStyle,
                                              filled: false,
                                              onSaved: (val) {
                                                setState(() => bodyStyle = val);
                                              },
                                              onChanged: (val) {  
                                                setState(() => bodyStyle = val);
                                              },
                                              dataSource: [
                                                {
                                                  "display": "Station Wagon",
                                                  "value": "Station Wagon",
                                                },
                                                {
                                                  "display": "Saloon",
                                                  "value": "Saloon",
                                                },
                                                {
                                                  "display": "Coupe",
                                                  "value": "Coupe",
                                                },
                                              ],
                                              textField: 'display',
                                              valueField: 'value',
                                            );
                                            
                                          }, 
                                        ),
                                      ),
                                    
                                    if(_statusRegister == StatusRegister.partnership_member)
                                      Container(
                                        margin: EdgeInsets.only(top: 15.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.calendar_view_day_sharp,
                                                  color: ColorResources.WHITE,
                                                ),
                                                SizedBox(width: 15.0),
                                                Text("No KTP", style: poppinsRegular.copyWith(
                                                  color: ColorResources.WHITE
                                                ))
                                              ],
                                            ),
                                            TextField(
                                              controller: noKtpController,
                                              style: poppinsRegular.copyWith(
                                                color: ColorResources.WHITE
                                              ),
                                              textInputAction: TextInputAction.next,
                                              decoration: InputDecoration(
                                                hintText: "Enter your KTP",
                                                hintStyle: poppinsRegular,
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
                                          ],
                                        ),
                                      ),

                                    if(_statusRegister == StatusRegister.partnership_member)
                                      Container(
                                        margin: EdgeInsets.only(top: 15.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.location_city,
                                                  color: ColorResources.WHITE,
                                                ),
                                                SizedBox(width: 15.0),
                                                Text(getTranslated("COMPANY_NAME", context), style: poppinsRegular.copyWith(
                                                  color: ColorResources.WHITE
                                                ))
                                              ],
                                            ),
                                            TextField(
                                              controller: companyNameController,
                                              style: poppinsRegular.copyWith(
                                                color: ColorResources.WHITE
                                              ),
                                              textInputAction: TextInputAction.next,
                                              decoration: InputDecoration(
                                                hintText: getTranslated("COMPANY_NAME", context),
                                                hintStyle: poppinsRegular,
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
                                          ],
                                        ),
                                      ),
                                    

                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.people,
                                                color: ColorResources.WHITE,
                                              ),
                                              SizedBox(width: 15.0),
                                              Text(getTranslated("FULL_NAME", context), style: poppinsRegular.copyWith(
                                                color: ColorResources.WHITE
                                              ))
                                            ],
                                          ),
                                          TextField(
                                            controller: fullnameController,
                                            style: poppinsRegular.copyWith(
                                              color: ColorResources.WHITE
                                            ),
                                            textInputAction: TextInputAction.next,
                                            decoration: InputDecoration(
                                              hintText: getTranslated("FULL_NAME", context),
                                              hintStyle: poppinsRegular,
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
                                        ],
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.person,
                                                color: ColorResources.WHITE,
                                              ),
                                              SizedBox(width: 15.0),
                                              Text(getTranslated("USER_NAME", context), style: poppinsRegular.copyWith(
                                                color: ColorResources.WHITE
                                              ))
                                            ],
                                          ),
                                          TextField(
                                            controller: usernameController,
                                            style: poppinsRegular.copyWith(
                                              color: ColorResources.WHITE
                                            ),
                                            textInputAction: TextInputAction.next,
                                            decoration: InputDecoration(
                                              hintText: "ex. @johndoe",
                                              hintStyle: poppinsRegular,
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
                                        ],
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.phone_android,
                                                color: ColorResources.WHITE,
                                              ),
                                              SizedBox(width: 15.0),
                                              Text(getTranslated("PHONE_NUMBER", context), style: poppinsRegular.copyWith(
                                                color: ColorResources.WHITE
                                              ))
                                            ],
                                          ),
                                          TextField(
                                            controller: phoneNumberController,
                                            style: poppinsRegular.copyWith(
                                              color: ColorResources.WHITE
                                            ),
                                            keyboardType: TextInputType.number,
                                            textInputAction: TextInputAction.next,
                                            decoration: InputDecoration(
                                              hintText: getTranslated("PHONE_NUMBER", context),
                                              hintStyle: poppinsRegular,
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
                                        ],
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.email,
                                                color: ColorResources.WHITE,
                                              ),
                                              SizedBox(width: 15.0),
                                              Text(getTranslated("EMAIL", context), style: poppinsRegular.copyWith(
                                                color: ColorResources.WHITE
                                              ))
                                            ],
                                          ),
                                          Container(
                                            child: TextField(
                                              controller: emailController,
                                              style: poppinsRegular.copyWith(
                                                color: ColorResources.WHITE
                                              ),
                                              keyboardType: TextInputType.emailAddress,
                                              textInputAction: TextInputAction.next,
                                              decoration: InputDecoration(
                                                hintText: "ex. johndoe@gmail.com",
                                                hintStyle: poppinsRegular,
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
                                                color: ColorResources.WHITE
                                              ))
                                            ],
                                          ),
                                          StatefulBuilder(
                                            builder: (BuildContext context, Function setState) {
                                              return TextField(
                                                controller: passwordController,
                                                obscureText: passwordObscure,
                                                style: poppinsRegular.copyWith(
                                                  color: ColorResources.WHITE
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: getTranslated("PASSWORD", context),
                                                  suffixIcon: InkWell(
                                                    onTap: () {
                                                      s(() => passwordObscure = !passwordObscure);
                                                    }, 
                                                    child: Icon(
                                                      passwordObscure ? Icons.visibility_off : Icons.visibility,
                                                      color: ColorResources.WHITE
                                                    ),
                                                  ),
                                                  contentPadding: EdgeInsets.only(top: 13),
                                                  hintStyle: poppinsRegular,
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
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.lock,
                                                color: ColorResources.WHITE,
                                              ),
                                              SizedBox(width: 15.0),
                                              Text(getTranslated("PASSWORD_CONFIRM", context), style: poppinsRegular.copyWith(
                                                color: ColorResources.WHITE
                                              ))
                                            ],
                                          ),
                                          StatefulBuilder(
                                            builder: (BuildContext context, Function setState) {
                                              return TextField(
                                                controller: passwordConfirmController,
                                                obscureText: passwordConfirmObscure,
                                                style: poppinsRegular.copyWith(
                                                  color: ColorResources.WHITE
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: getTranslated("PASSWORD_CONFIRM", context),
                                                  suffixIcon: InkWell(
                                                    onTap: () {
                                                      s(() => passwordConfirmObscure = !passwordConfirmObscure);
                                                    }, 
                                                    child: Icon(
                                                      passwordConfirmObscure ? Icons.visibility_off : Icons.visibility,
                                                      color: ColorResources.WHITE
                                                    ),
                                                  ),
                                                  contentPadding: EdgeInsets.only(top: 13),
                                                  hintStyle: poppinsRegular,
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
                                        onPressed: () => register(context),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0)
                                          ),
                                          primary: ColorResources.BTN_PRIMARY_SECOND
                                        ),
                                        child: authProvider.registerStatus == RegisterStatus.loading 
                                          ? Loader(
                                            color: ColorResources.YELLOW_PRIMARY
                                          )
                                          : Text(getTranslated("SIGN_UP", context),
                                          style: poppinsRegular,
                                        ),
                                      ),
                                    ),

                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(getTranslated("ALREADY_HAVE_A_ACCOUNT", context),
                                            style: poppinsRegular.copyWith(
                                              color: ColorResources.WHITE
                                            ),
                                          ),
                                          SizedBox(width: 5.0),
                                          InkWell(
                                            onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen())),
                                            child: Text(getTranslated("SIGN_IN", context),
                                              style: poppinsRegular.copyWith(
                                                color: ColorResources.YELLOW_PRIMARY
                                              )
                                            ),
                                          )
                                        ],
                                      ) 
                                    )

                                        
                                  ]
                                )
                              
                              )
                            ],
                          ),
                        ),
                      ),

                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

