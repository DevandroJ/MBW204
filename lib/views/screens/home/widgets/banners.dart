import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/banner.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/constant.dart';

class BannersView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
       
    return Consumer<BannerProvider>(
      builder: (BuildContext context, BannerProvider bannerProvider, Widget child) {
        if(bannerProvider.bannerStatus == BannerStatus.loading)
          return Container(
            width: double.infinity,
            height: 150.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0), 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: ColorResources.WHITE,
                    )
                  ),
                )
              ]
            )
          );
        if(bannerProvider.bannerStatus == BannerStatus.empty)      
          return Container(
            width: double.infinity,
            height: 150.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: Text(getTranslated("NO_BANNER_AVAILABLE", context))
                )  
              ]
            )
          );
        if(bannerProvider.bannerStatus == BannerStatus.error)      
          return Container(
            width: double.infinity,
            height: 150.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: Text(getTranslated("THERE_WAS_PROBLEM", context))
                )  
              ]
            )
          );

        return Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          width: double.infinity,
          height: 150.0,
          child: Stack(
            fit: StackFit.expand,
            children: [
              
              CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                  onPageChanged: (int index, CarouselPageChangedReason reason) {
                    bannerProvider.setCurrentIndex(index);
                  },
                ),
                itemCount: bannerProvider.bannerListMap.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: () { 
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network("${AppConstants.BASE_URL_IMG}${bannerProvider.bannerListMap[i]["path"]}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  );                  
                },
              ),

              Positioned(
                bottom: 5.0,
                left: 0.0,
                right: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: bannerProvider.bannerListMap.map((banner) {
                    int index = bannerProvider.bannerListMap.indexOf(banner);
                    return TabPageSelectorIndicator(
                      backgroundColor: index == bannerProvider.currentIndex ? ColorResources.PRIMARY : ColorResources.WHITE,
                      borderColor: Colors.white,
                      size: 10.0,
                    );
                  }).toList(),
                ),
              ),

            ],
          )
        );
      },
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
