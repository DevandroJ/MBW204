import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/providers/splash.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/screens/dashboard/dashboard.dart';
import 'package:mbw204_club_ina/views/screens/onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<SplashProvider>(context, listen: false).initConfig().then((val) {
      if(val) {
        Timer(Duration(seconds: 1), () {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => DashBoardScreen()));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) =>
              OnBoardingScreen(
                indicatorColor: ColorResources.GREY, 
                selectedIndicatorColor: ColorResources.PRIMARY
              )
            ));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      width:  MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: ColorResources.BLACK,
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(ColorResources.BLACK.withOpacity(0.5), BlendMode.dstATop),
          image: AssetImage(Images.splash)
        )
      ),
      child: Stack(
        children: [
          
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              child: Image.asset(Images.logo,
                width: 200.0,
                height: 170.0,
              ),
            ) 
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 90.0),
              child: Text("Poweredby:",
                style: TextStyle(
                  color: ColorResources.WHITE
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30.0,
                    child: Image.asset(Images.logo_app),
                  ),
                  SizedBox(width: 10.0),
                  Text("|",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.normal,
                      color: ColorResources.WHITE
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    height: 30.0,
                    child: Image.asset(Images.logo_cx),
                  )
                ],
              ) 
            ),
          )
          
        ],
      ))
    );
  }
}
