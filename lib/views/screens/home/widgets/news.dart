import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/screens/news/detail.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/providers/news.dart';


class NewsView extends StatefulWidget {
  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  @override
  Widget build(BuildContext context) {

    Provider.of<NewsProvider>(context, listen: false).getNews(context);

    return Consumer<NewsProvider>(
      builder: (BuildContext context, NewsProvider newsProvider, Widget child) {
        return  Container(
          height: 180.0,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: newsProvider.getNewsStatus == GetNewsStatus.loading ? 3 : 1,
            itemBuilder: (BuildContext context, int i) {
              return Stack(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3.0,
                    child: Container(
                      width: 160.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DetailNewsScreen(
                              title: newsProvider.newsBody[i].title,
                              content: newsProvider.newsBody[i].content,
                              date: newsProvider.newsBody[i].created,
                              imageUrl: newsProvider.newsBody[i].media[0].path,
                            )),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: newsProvider.getNewsStatus == GetNewsStatus.loading 
                          ? "https://eastkameng.nic.in/wp-content/themes/district-theme-5/images/blank.jpg"
                          : "${AppConstants.BASE_URL_IMG}/${newsProvider.newsBody[i].media[0].path}" ,
                          imageBuilder: (context, imageProvider) => Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              image: DecorationImage(
                                image: imageProvider, 
                                fit: BoxFit.cover
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      )
                    ),
                  ),
                  Positioned.fill(
                    bottom: 4.0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DetailNewsScreen(
                              title: newsProvider.newsBody[i].title,
                              content: newsProvider.newsBody[i].content,
                              date: newsProvider.newsBody[i].created,
                              imageUrl: newsProvider.newsBody[i].media[0].path,
                            )),
                          )
                        },
                        child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(8.0),
                        height: 70.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.0), 
                            bottomRight: Radius.circular(12.0)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              spreadRadius: 5.0,
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(newsProvider.getNewsStatus == GetNewsStatus.loading 
                            ? "..."
                            : newsProvider.getNewsStatus == GetNewsStatus.error 
                            ? "..." 
                            : newsProvider.newsBody[i].title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0 * MediaQuery.of(context).textScaleFactor
                              )
                            ),
                            SizedBox(height: 8.0),
                            Text(newsProvider.getNewsStatus == GetNewsStatus.loading 
                            ? "..."
                            : newsProvider.getNewsStatus == GetNewsStatus.error 
                            ? "..." 
                            : DateFormat('dd MMM yyyy kk:mm').format(newsProvider.newsBody[i].created),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0 * MediaQuery.of(context).textScaleFactor
                              )
                            ),
                            SizedBox(height: 4.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DetailNewsScreen(
                                    title: newsProvider.newsBody[i].title,
                                    content: newsProvider.newsBody[i].content,
                                    date: newsProvider.newsBody[i].created,
                                    imageUrl: newsProvider.newsBody[i].media[0].path,
                                  )),
                                );
                              },
                              child: Text("Baca Selengkapnya", 
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0 * MediaQuery.of(context).textScaleFactor
                                )
                              )
                            )
                          ]
                        )
                        )
                      )
                    )
                  )
                ],
              );

            },
          ),
        );
      },
    );
  }
}