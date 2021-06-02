import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/views/screens/dashboard/dashboard.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordObscure = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                                      Icon(Icons.email,
                                        color: ColorResources.WHITE,
                                      ),
                                      SizedBox(width: 15.0),
                                      Text("Email", style: titilliumRegular.copyWith(
                                        color: ColorResources.WHITE
                                      ))
                                    ],
                                  ),
                                  Container(
                                    child: TextField(
                                      controller: emailController,
                                      style: titilliumRegular.copyWith(
                                        color: ColorResources.WHITE
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        hintText: "ex. johndoe@gmail.com",
                                        hintStyle: titilliumRegular,
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
                                      Text("Password", style: titilliumRegular.copyWith(
                                        color: ColorResources.WHITE
                                      ))
                                    ],
                                  ),
                                  StatefulBuilder(
                                    builder: (BuildContext context, Function setState) {
                                      return TextField(
                                        controller: passwordController,
                                        obscureText: passwordObscure,
                                        style: titilliumRegular.copyWith(
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
                                          hintStyle: titilliumRegular,
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
                                onPressed: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => DashBoardScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)
                                  ),
                                  primary: ColorResources.YELLOW_PRIMARY
                                ),
                                child: Text("Sign In",
                                  style: titilliumRegular.copyWith(
                                    color: ColorResources.BLACK
                                  ),
                                ),
                              ),
                            ),         

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
      ),
    );
  }
}