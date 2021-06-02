import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbw204_club_ina/data/models/news.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/views/screens/auth/widgets/signin.dart';
import 'package:mbw204_club_ina/views/screens/auth/widgets/signup.dart';
import 'package:select_form_field/select_form_field.dart';

class AuthScreen extends StatelessWidget{
  final int initialPage;
  AuthScreen({this.initialPage = 0});

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

    PageController pageController = PageController(initialPage: initialPage);
    int groupValue = 0;

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
                                            style: titilliumRegular.copyWith(
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
                                                        style: titilliumRegular.copyWith(
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
                                                        style: titilliumRegular.copyWith(
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
                                    style: titilliumRegular.copyWith(
                                      color: ColorResources.WHITE
                                    ),
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText: "Enter your ID Member",
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
                                          Text("Full Name", style: titilliumRegular.copyWith(
                                            color: ColorResources.WHITE
                                          ))
                                        ],
                                      ),
                                      TextField(
                                        controller: fullnameController,
                                        style: titilliumRegular.copyWith(
                                          color: ColorResources.WHITE
                                        ),
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          hintText: "Enter your Name",
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
                                          Text("UserName", style: titilliumRegular.copyWith(
                                            color: ColorResources.WHITE
                                          ))
                                        ],
                                      ),
                                      TextField(
                                        controller: usernameController,
                                        style: titilliumRegular.copyWith(
                                          color: ColorResources.WHITE
                                        ),
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          hintText: "ex. @johndoe",
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
                                          Text("Nomor Handphone", style: titilliumRegular.copyWith(
                                            color: ColorResources.WHITE
                                          ))
                                        ],
                                      ),
                                      TextField(
                                        controller: phoneController,
                                        style: titilliumRegular.copyWith(
                                          color: ColorResources.WHITE
                                        ),
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          hintText: "Enter your phone number",
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
                                          Text("Email", style: titilliumRegular.copyWith(
                                            color: ColorResources.WHITE
                                          ))
                                        ],
                                      ),
                                      TextField(
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
                                  margin: EdgeInsets.only(top: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.lock,
                                            color: ColorResources.WHITE,
                                          ),
                                          SizedBox(width: 15.0),
                                          Text("Confirm Password", style: titilliumRegular.copyWith(
                                            color: ColorResources.WHITE
                                          ))
                                        ],
                                      ),
                                      StatefulBuilder(
                                        builder: (BuildContext context, Function setState) {
                                          return TextField(
                                            controller: passwordConfirmController,
                                            obscureText: passwordConfirmObscure,
                                            style: titilliumRegular.copyWith(
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
                                      style: titilliumRegular,
                                    ),
                                  ),
                                )


                                // Container(
                                //   child: DropdownSearch<String>(
                                //     // dropdownBuilder: (context, selectedItem, itemAsString) {
                                //     //   return Container(
                                //     //     child: Text("Chapter $selectedItem",
                                //     //       style: titilliumRegular.copyWith(color: ColorResources.GREY),
                                //     //     ),
                                //     //   );
                                //     // },
                                //     dropdownSearchDecoration: InputDecoration(
                                //       isDense: true,
                                //       hintStyle: TextStyle(
                                //         color: Colors.red
                                //       ),
                                //       enabledBorder: UnderlineInputBorder(      
                                //         borderSide: BorderSide(color: ColorResources.WHITE),   
                                //       ),  
                                //       focusedBorder: UnderlineInputBorder(
                                //         borderSide: BorderSide(color: ColorResources.WHITE),
                                //       ),
                                //       border: UnderlineInputBorder(
                                //         borderSide: BorderSide(color: ColorResources.WHITE),
                                //       ),                                      
                                //     ),
                                //     mode: Mode.MENU,                                    
                                //     showSelectedItem: true,
                                //     items: ["Brazil", "Tunisia", 'Canada'],
                                //     hint: "TESTES",
                                    
                                //     onChanged: print,
                                //     selectedItem: ""
                                //   )
                                //
                                 
                                  // Row(
                                  //   children: [
                                  //     // Flexible(
                                  //     //   child: TextField(
                                  //     //     decoration: InputDecoration(
                                  //     //       hintText: "Chapter",
                                  //     //       hintStyle: titilliumRegular,
                                  //     //       enabledBorder: UnderlineInputBorder(      
                                  //     //         borderSide: BorderSide(color: ColorResources.WHITE),   
                                  //     //       ),  
                                  //     //       focusedBorder: UnderlineInputBorder(
                                  //     //         borderSide: BorderSide(color: ColorResources.WHITE),
                                  //     //       ),
                                  //     //       border: UnderlineInputBorder(
                                  //     //         borderSide: BorderSide(color: ColorResources.WHITE),
                                  //     //       ),
                                  //     //     ),
                                  //     //   ),
                                  //     // ),
                                  //     Container(
                                  //       child: DropdownButton<String>(
                                  //         value: "One",
                                  //         icon: Icon(
                                  //           Icons.arrow_downward,
                                  //           color: ColorResources.WHITE,  
                                  //         ),
                                  //         iconSize: 15.0,
                                  //         style: TextStyle(color: ColorResources.WHITE),
                                  //         underline: Container(
                                  //           margin: EdgeInsets.only(top: 10.0),
                                  //           height: 1.0,
                                  //           color: Colors.red,
                                  //         ),
                                  //         onChanged: (String newValue) {
                                          
                                  //         },
                                  //         items: <String>['One', 'Two', 'Free', 'Four'].map<DropdownMenuItem<String>>((String value) {
                                  //           return DropdownMenuItem<String>(
                                  //             value: value,
                                  //             child: Container(
                                  //               child: Text(value)
                                  //             ),
                                  //           );
                                  //         }).toList(),
                                  //       ),
                                  //     )                        
                                  //   ],
                                  // )


                                // )

                                    
                              ]
                            )
                          
                          )
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(Dimensions.MARGIN_SIZE_LARGE),
                  //   child: Stack(
                  //     clipBehavior: Clip.none,
                  //     children: [
                  //       Positioned(
                  //         bottom: 0,
                  //         right: Dimensions.MARGIN_SIZE_EXTRA_SMALL,
                  //         left: 0,
                  //         child: Container(
                  //           width: MediaQuery.of(context).size.width,
                  //           height: 1,
                  //           color: ColorResources.getGainsBoro(context),
                  //         ),
                  //       ),
                  //       Consumer<AuthProvider>(
                  //         builder: (BuildContext context, AuthProvider authProvider, Widget child) => Row(
                  //           children: [
                  //             InkWell(
                  //               onTap: () => pageController.animateToPage(0, duration: Duration(seconds: 1), curve: Curves.easeInOut),
                  //               child: Column(
                  //                 children: [
                  //                   Text(getTranslated('SIGN_IN', context), style: authProvider.selectedIndex == 0 ? titilliumSemiBold : titilliumRegular),
                  //                   Container(
                  //                     height: 1.0,
                  //                     width: 40.0,
                  //                     margin: EdgeInsets.only(top: 8.0),
                  //                     color: authProvider.selectedIndex == 0 ? ColorResources.PRIMARY : Colors.transparent,
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             SizedBox(width: 25.0),
                  //             InkWell(
                  //               onTap: () => pageController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.easeInOut),
                  //               child: Column(
                  //                 children: [
                  //                   Text(getTranslated('SIGN_UP', context), 
                  //                     style: authProvider.selectedIndex == 1 ? titilliumSemiBold : titilliumRegular),
                  //                   Container(
                  //                       height: 1.0,
                  //                       width: 50.0,
                  //                       margin: EdgeInsets.only(top: 8.0),
                  //                       color: authProvider.selectedIndex == 1 ? ColorResources.PRIMARY : Colors.transparent
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // Expanded(
                  //   child: Consumer<AuthProvider>(
                  //     builder: (BuildContext context, AuthProvider authProvider, Widget child)=> PageView.builder(
                  //       itemCount: 2,
                  //       controller: pageController,
                  //       itemBuilder: (context, index) {
                  //         if (authProvider.selectedIndex == 0) {
                  //           return SignInWidget();
                  //         } else {
                  //           return SignUpWidget();
                  //         }
                  //       },
                  //       onPageChanged: (index) {
                  //         authProvider.updateSelectedIndex(index);
                  //       },
                  //     ),
                  //   ),
                  // ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}

