import 'dart:io';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/data/models/feed/notification.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/screens/feed/comment_detail.dart';
import 'package:mbw204_club_ina/views/screens/feed/post_detail.dart';
import 'package:mbw204_club_ina/views/screens/feed/reply_detail.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  FeedState feedState = getIt<FeedState>();

  void initState() {
    super.initState();
    (() async {
      await feedState.fetchAllNotification();
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, innerBoxIsScrolled) {
          return [
           
            SliverAppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              title: Text(getTranslated("NOTIFICATION", context), 
              style: titilliumRegular.copyWith(color: Colors.black)),
              leading: IconButton(
                icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              elevation: 0.0,
              pinned: false,
              centerTitle: false,
              floating: true,
            ),

          ];
        },
        body: Observer(
          builder: (_) {
            if (feedState.notificationStatus == NotificationStatus.loading) {
              return Center(
                child: SizedBox(
                  width: 15.0,
                  height: 15.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(ColorResources.getPrimaryToWhite(context))
                  )    
                )
              );
            }
            if (feedState.notificationStatus == NotificationStatus.empty) {
              return Center(child: Text(getTranslated("THERE_IS_NO_NOTIFICATION", context), style: titilliumRegular));
            }
            return NotificationListener<ScrollNotification>(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int i) {
                  return Container(
                    color: Colors.blueGrey[50],
                    height: 20.0,
                  );
                },
                physics: BouncingScrollPhysics(),
                itemCount: feedState.notification.nextCursor != null
                ? feedState.notificationList.length + 1
                : feedState.notificationList.length,
                itemBuilder: (BuildContext context, int i) {
                  if (feedState.notificationList.length == i) {
                    return Center(
                      child: SizedBox(
                        width: 15.0,
                        height: 15.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ColorResources.getPrimaryToWhite(context)
                          )
                        )
                      )
                    );
                  }
                  return InkWell(
                    onTap: () {
                      if (feedState.notificationList[i].targetType == TargetType.REPLY) {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => ReplyDetailScreen(
                              replyId: feedState.notificationList[i].targetId,
                            ),
                          ),
                        );
                      }
                      if (feedState.notificationList[i].targetType == TargetType.COMMENT) {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => CommentDetailScreen(
                              postId: null,
                              commentId: feedState.notificationList[i].targetId,
                            ),
                          ),
                        );
                      }
                      if (feedState.notificationList[i].targetType == TargetType.POST) {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(
                              postId: feedState.notificationList[i].targetId,
                            ),
                          ),
                        );
                      }
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage("${AppConstants.BASE_URL_IMG}/${feedState.notificationList[i].refUser.profilePic.path}"),
                        radius: 20.0,
                      ),
                      title: Text(
                        feedState.notificationList[i].message,
                        style: titilliumRegular.copyWith(fontSize: 14.0),
                      ),
                      subtitle: Text(
                        timeago.format(DateTime.parse(feedState.notificationList[i].created).toLocal(),locale: 'id'),
                        style: titilliumRegular.copyWith(fontSize: 12.0)
                      ),
                    ),
                  );
                },
              ),
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if (feedState.notification.nextCursor != null) {
                    feedState.fetchAllNotificationLoad(feedState.notification.nextCursor);
                  }
                }
                return false;
              },
            );
          },
        ),
      ),
    );
  }
}
