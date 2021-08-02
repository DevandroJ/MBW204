import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/screens/news/detail.dart';
import 'package:mbw204_club_ina/providers/news.dart';
import 'package:mbw204_club_ina/utils/constant.dart';

class NewsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: "News", isBackButtonExist: true),

            Expanded(
              child: Consumer<NewsProvider>(
                builder: (BuildContext context, NewsProvider newsProvider, Widget child) {

                  if(newsProvider.getNewsStatus == GetNewsStatus.empty) 
                    return Center(
                      child: Text("There is no News"),
                    );
                  return Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
                    child: ListView.builder(
                      itemCount: newsProvider.getNewsStatus == GetNewsStatus.loading
                       ? 3 
                       : newsProvider.getNewsStatus == GetNewsStatus.error 
                       ? 3 
                       : newsProvider.newsBody.length,
                      itemBuilder: (BuildContext context,  int i) {
                        return Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Card(
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                            ),
                            child: InkWell(
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)
                              ),
                              onTap: () {
                                if(newsProvider.getNewsStatus != GetNewsStatus.error)
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => DetailNewsScreen(
                                      title: newsProvider.newsBody[i].title,
                                      content: newsProvider.newsBody[i].content,
                                      date: newsProvider.newsBody[i].created,
                                      imageUrl: newsProvider.newsBody[i].media[0].path,
                                    )),
                                  );
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: newsProvider.getNewsStatus == GetNewsStatus.loading 
                                          ? "https://eastkameng.nic.in/wp-content/themes/district-theme-5/images/blank.jpg"
                                          : newsProvider.getNewsStatus == GetNewsStatus.error
                                          ? "https://eastkameng.nic.in/wp-content/themes/district-theme-5/images/blank.jpg"
                                          : "${AppConstants.BASE_URL_IMG}/${newsProvider.newsBody[i].media[0].path}" ,
                                          imageBuilder: (context, imageProvider) => Container(
                                            width: 120.0,
                                            height: 80.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                            ),
                                          ),
                                          placeholder: (context, url) => Container(),
                                          errorWidget: (context, url, error) => Icon(Icons.error)
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5.0, left: 16.0),
                                          child: Container(
                                            width: 200.0,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(newsProvider.getNewsStatus == GetNewsStatus.loading 
                                                  ? "..."
                                                  : newsProvider.getNewsStatus == GetNewsStatus.error 
                                                  ? "..." 
                                                  : newsProvider.newsBody[i].title,
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 6.0),
                                                Text(newsProvider.getNewsStatus == GetNewsStatus.loading 
                                                ? "..."
                                                : newsProvider.getNewsStatus == GetNewsStatus.error 
                                                ? "..." 
                                                : DateFormat('dd MMM yyyy kk:mm').format(newsProvider.newsBody[i].created),
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: ColorResources.DIM_GRAY
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ) 
            )

          ],
        ),
      ),
    );
  }
}