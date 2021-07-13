import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/views/screens/news/list.dart';
import 'package:mbw204_club_ina/views/screens/media/media.dart';
import 'package:mbw204_club_ina/views/screens/event/event.dart';
import 'package:mbw204_club_ina/views/screens/feed/feed_index.dart';
import 'package:mbw204_club_ina/views/screens/ppob/ppob.dart';
import 'package:mbw204_club_ina/views/screens/warung/warung_index.dart';
import 'package:mbw204_club_ina/providers/category.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';

class CategoryView extends StatelessWidget {
  final bool isHomePage;
  CategoryView({@required this.isHomePage});

  @override
  Widget build(BuildContext context) {

    Provider.of<CategoryProvider>(context, listen: false).initCategoryList(context);
    
    return Consumer<CategoryProvider>(
      builder: (BuildContext context, CategoryProvider categoryProvider, Widget child) {
        return categoryProvider.categoryList.length != 0 ? Container(
          margin: EdgeInsets.only(top: 20.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1 / 1,
            ),
            itemCount: isHomePage ? categoryProvider.categoryList.length > 8 ? 8 : categoryProvider.categoryList.length : categoryProvider.categoryList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int i) {

              return Container(
                  margin: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: ColorResources.WHITE,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1.0,
                        blurRadius: 3.0,
                        offset: Offset(0.0, 3.0),
                      )
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () {
                      switch (i) {
                        case 0:
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FeedIndex()));
                        break;
                        case 1:
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EventScreen())); 
                        break; 
                        case 2: 
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MediaScreen())); 
                        break;
                        case 3:
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => CheckInScreen())); 
                        break;
                        case 4:
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen())); 
                        break;
                        case 5: 
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsScreen())); 
                        break;
                        case 6:
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PPOBScreen()));
                        break;
                        case 7:
                          Navigator.push(context, MaterialPageRoute(builder: (context) => JualBeliPage()));
                        break;
                        default:
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch, 
                      children: [
                      
                      // Category Icon
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
                          child: Image.asset(
                            categoryProvider.categoryList[i].icon,
                            fit: BoxFit.fitHeight,
                            width: 28.0,
                            height: 28.0,
                          ),
                        ),
                      ),

                      // Category Name
                      Expanded(
                        flex: 3, 
                        child: Container(
                        decoration: BoxDecoration(
                          color: ColorResources.getPrimaryToBlack(context),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                             categoryProvider.categoryList[i].name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: titilliumSemiBold.copyWith(
                              color: ColorResources.WHITE,
                              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL
                            ),
                          ),
                        ),
                      )),
                    ]),
                  ),
                );
            
            },
          ),
        ) : CategoryShimmer();
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: (1/1),
      ),
      itemCount: 8,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200], 
                spreadRadius: 2.0, 
                blurRadius: 5.0
              )
            ]
          ),
          margin: EdgeInsets.all(3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: [

              Expanded(
                flex: 7,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[200],
                  highlightColor: Colors.grey[300],
                  enabled: Provider.of<CategoryProvider>(context).categoryList.length == 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0), 
                        topRight: Radius.circular(10.0)
                      ),
                    )
                  ),
                ),
              ),

              Expanded(
                flex: 3, 
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorResources.getTextBg(context),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0), 
                      bottomRight: Radius.circular(10.0)
                    ),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[200],
                    highlightColor: Colors.grey[300],
                    enabled: Provider.of<CategoryProvider>(context).categoryList.length == 0,
                    child: Container(
                      height: 10.0, 
                      color: Colors.white, 
                      margin: EdgeInsets.only(
                        left: 15.0, 
                        right: 15.0
                      )
                    ),
                  ),
                )
              ),

            ]
          ),
        );
      },
    );
  }
}

