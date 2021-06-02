import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:lottie/lottie.dart';

class ErrorComponent extends StatelessWidget {
  final double width;
  final double height;

  ErrorComponent({
    this.width,
    this.height
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset("assets/lottie/error.json",
            width: width,
            height: height,
          ),
          Text("Ups! Server lagi ada Masalah",
            style: titilliumRegular.copyWith(
              color: ColorResources.BLACK
            ),
          )
        ],
      )
    );
  }
}