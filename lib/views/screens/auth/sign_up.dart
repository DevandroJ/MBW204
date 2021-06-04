import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_dropdown.dart';
import 'package:mbw204_club_ina/views/screens/auth/sign_in.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';

class SignUpScreen extends StatefulWidget{

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    
    TextEditingController fullnameController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController idMemberController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController passwordConfirmController = TextEditingController();

    bool passwordObscure = false;
    bool passwordConfirmObscure = false;

    int groupValue = 0;
    String chapter = "";
    String subModel = "";
    String bodyStyle = "";

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Consumer<AuthProvider>(
            builder: (BuildContext context, AuthProvider auth, Widget child) => SafeArea(
              child: Column(
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
                                          Text("Your Registration",
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
                                          child: StatefulBuilder(
                                            builder: (BuildContext context, Function setState) {
                                              return Row(
                                                children: [
                                              
                                                  Flexible(
                                                    child: RadioListTile(
                                                      value: 1, 
                                                      groupValue: groupValue, 
                                                      onChanged: (val) {
                                                        setState(() => groupValue = val);
                                                      },
                                                      dense: true,
                                                      title: Text("Member",
                                                        style: poppinsRegular.copyWith(
                                                          color: ColorResources.WHITE
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                    
                                                  Flexible(
                                                    child: RadioListTile(
                                                      value: 2, 
                                                      groupValue: groupValue, 
                                                      onChanged: (val) {
                                                        setState(() => groupValue = val);
                                                      },
                                                      dense: true,
                                                      title: Text("Partnership",
                                                        style: poppinsRegular.copyWith(
                                                          color: ColorResources.WHITE
                                                        ),
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
                                  ) 
                                ),

                                Container(
                                  child: TextField(
                                    controller: idMemberController,
                                    style: poppinsRegular.copyWith(
                                      color: ColorResources.WHITE
                                    ),
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText: "Enter your ID Member",
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
                                            "value": "jakarta",
                                          },
                                          {
                                            "display": "Bandung",
                                            "value": "bandung",
                                          },
                                          {
                                            "display": "Bali",
                                            "value": "bali",
                                          },
                                        ],
                                        textField: 'display',
                                        valueField: 'value',
                                      );
                                      
                                    }, 
                                  ),
                                ),

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
                                            "display": "Jakarta",
                                            "value": "jakarta",
                                          },
                                          {
                                            "display": "Bandung",
                                            "value": "bandung",
                                          },
                                          {
                                            "display": "Bali",
                                            "value": "bali",
                                          },
                                        ],
                                        textField: 'display',
                                        valueField: 'value',
                                      );
                                      
                                    }, 
                                  ),
                                ),

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
                                            "display": "Jakarta",
                                            "value": "jakarta",
                                          },
                                          {
                                            "display": "Bandung",
                                            "value": "bandung",
                                          },
                                          {
                                            "display": "Bali",
                                            "value": "bali",
                                          },
                                        ],
                                        textField: 'display',
                                        valueField: 'value',
                                      );
                                      
                                    }, 
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
                                          Text("Full Name", style: poppinsRegular.copyWith(
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
                                          hintText: "Enter your Name",
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
                                          Text("UserName", style: poppinsRegular.copyWith(
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
                                          Text("Nomor Handphone", style: poppinsRegular.copyWith(
                                            color: ColorResources.WHITE
                                          ))
                                        ],
                                      ),
                                      TextField(
                                        controller: phoneController,
                                        style: poppinsRegular.copyWith(
                                          color: ColorResources.WHITE
                                        ),
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          hintText: "Enter your phone number",
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
                                          Text("Email", style: poppinsRegular.copyWith(
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
                                          Text("Password", style: poppinsRegular.copyWith(
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
                                              hintText: "Enter your password",
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  setState(() => passwordObscure = !passwordObscure);
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
                                          Text("Confirm Password", style: poppinsRegular.copyWith(
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
                                              hintText: "Enter your confirm password",
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  setState(() => passwordConfirmObscure = !passwordConfirmObscure);
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
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0)
                                      ),
                                      primary: ColorResources.BTN_PRIMARY_SECOND
                                    ),
                                    child: Text("Sign Up",
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
                                      Text("Already have an account ?",
                                        style: poppinsRegular.copyWith(
                                          color: ColorResources.WHITE
                                        ),
                                      ),
                                      SizedBox(width: 5.0),
                                      InkWell(
                                        onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen())),
                                        child: Text("Sign in",
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

