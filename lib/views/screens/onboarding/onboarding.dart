import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/views/screens/auth/sign_in.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/onboarding.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';

class OnBoardingScreen extends StatelessWidget {
  final Color indicatorColor;
  final Color selectedIndicatorColor;

  OnBoardingScreen({
    this.indicatorColor = Colors.grey,
    this.selectedIndicatorColor = Colors.black,
  });

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Provider.of<OnBoardingProvider>(context, listen: false).initBoardingList();

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Consumer<OnBoardingProvider>(
                builder: (BuildContext context, OnBoardingProvider onBoardingProvider, Widget child) => Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: PageView.builder(
                        itemCount: onBoardingProvider.onBoardingList.length,
                        controller: pageController,
                        itemBuilder: (BuildContext context, int i) {
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: constraints.maxHeight / 2,
                                decoration: BoxDecoration(
                                  color: ColorResources.BLACK,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0)
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(ColorResources.BLACK.withOpacity(0.5), BlendMode.dstATop),
                                    image: AssetImage(onBoardingProvider.onBoardingList[i].imageUrl)
                                  )
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20.0),
                                  child: Stack(
                                    children: [
                                      if(i == 2)
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            child: Image.asset(Images.onboarding_sos,
                                              width: 200.0,
                                            ),
                                          )
                                        ),
                                      if(i == 3)
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            child: Image.asset(Images.onboarding_mart,
                                              width: 200.0,
                                            ),
                                          )
                                        ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          child: Image.asset(Images.logo,
                                            width: 200.0,
                                          )
                                        ),
                                      ),
                                    ],
                                  )
                                )
                              ),
                              if(i == 0)
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Text("Selamat Datang", 
                                  style: poppinsRegular.copyWith(
                                    fontSize: 30.0, 
                                    color: ColorResources.BLACK
                                  ))
                                ),
                              if(i == 1)
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Text("News & Event", 
                                    style: poppinsRegular.copyWith(
                                      fontSize: 30.0, 
                                      color: ColorResources.PRIMARY
                                    )
                                  ),
                                ),
                              if(i == 2) 
                                Container( 
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Text("Panic Button",
                                    textAlign: TextAlign.center, 
                                    style: poppinsRegular.copyWith(
                                      color: ColorResources.PRIMARY,
                                      fontSize: 25.0
                                    )
                                  ),
                                ),
                              if(i == 3) 
                                Container( 
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Text("W204 Mart",
                                    textAlign: TextAlign.center, 
                                    style: poppinsRegular.copyWith(
                                      color: ColorResources.PRIMARY,
                                      fontSize: 25.0
                                    )
                                  ),
                                ),
                              Container(
                                // margin: EdgeInsets.only(top: 10.0),
                                child: Text(onBoardingProvider.onBoardingList[i].title, 
                                  textAlign: TextAlign.center, 
                                  style: poppinsRegular.copyWith(
                                    fontSize: 25.0
                                  )
                                ),
                              ),
                              if(i == 0)
                                Container(
                                  child: Text("MBW204 Club Indonesia",
                                    textAlign: TextAlign.center, 
                                    style: poppinsRegular.copyWith(
                                      color: ColorResources.PRIMARY,
                                      fontSize: 25.0
                                    )
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                                child: Text(onBoardingProvider.onBoardingList[i].description, 
                                  textAlign: TextAlign.center, 
                                  style: poppinsRegular.copyWith(
                                    color: ColorResources.DIM_GRAY,
                                  )
                                )
                              ),
                            ],
                          );
                        },
                        onPageChanged: (index) {
                          onBoardingProvider.changeSelectIndex(index);
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _pageIndicators(onBoardingProvider.onBoardingList, context),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 40.0,
                            margin: EdgeInsets.symmetric(horizontal: 70.0),
                            decoration: BoxDecoration(
                              color: onBoardingProvider.selectedIndex == onBoardingProvider.onBoardingList.length - 1 ? ColorResources.BTN_PRIMARY_SECOND : ColorResources.BTN_PRIMARY,
                              borderRadius: BorderRadius.circular(30.0),
                              image: DecorationImage(
                                alignment: Alignment.centerLeft,
                                image: AssetImage(Images.wheel_btn)
                              )
                            ),
                            child: TextButton(
                              onPressed: () {
                                if (Provider.of<OnBoardingProvider>(context, listen: false).selectedIndex == onBoardingProvider.onBoardingList.length - 1) {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInScreen()));
                                } else {
                                  pageController.animateToPage(Provider.of<OnBoardingProvider>(context, listen: false).selectedIndex+1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(onBoardingProvider.selectedIndex == onBoardingProvider.onBoardingList.length - 1
                                  ? getTranslated('GET_STARTED', context) 
                                  : getTranslated('NEXT', context),
                                  style: poppinsRegular.copyWith(
                                    color: onBoardingProvider.selectedIndex == onBoardingProvider.onBoardingList.length - 1 ? ColorResources.YELLOW_PRIMARY : ColorResources.WHITE, 
                                    fontSize: Dimensions.FONT_SIZE_LARGE
                                  )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );           
        }, 
      )
    );
  }

  List<Widget> _pageIndicators(var onBoardingList, BuildContext context) {
    List<Container> _indicators = [];

    for (int i = 0; i < onBoardingList.length; i++) {
      _indicators.add(
        Container(
          width: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? 18 : 7,
          height: 7,
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? ColorResources.DIM_GRAY : ColorResources.GREY,
            borderRadius: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? BorderRadius.circular(50) : BorderRadius.circular(25),
          ),
        ),
      );
    }
    return _indicators;
  }
}
