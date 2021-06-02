import 'dart:io';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/data/models/feed/reply.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/constant.dart';

class ReplyDetailScreen extends StatefulWidget {
  final String replyId;

  ReplyDetailScreen({this.replyId});

  @override
  _ReplyDetailScreenState createState() => _ReplyDetailScreenState();
}

class _ReplyDetailScreenState extends State<ReplyDetailScreen> {
  FeedState groupsState = getIt<FeedState>();
  TextEditingController replyTextEditingController = TextEditingController();
  FocusNode replyFocusNode = FocusNode();

  Widget replyText(ReplyBody reply) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ReadMoreText(
        reply.content.text,
        trimLines: 2,
        colorClickableText: ColorResources.BLACK,
        trimMode: TrimMode.Line,
        trimCollapsedText: 'Tampilkan Lebih',
        trimExpandedText: 'Tutup',
        style: TextStyle(fontSize: 14.0),
        moreStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        lessStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    ]);
  }

  Widget reply(BuildContext context) {
    return SliverToBoxAdapter(
      child: Observer(
        builder: (_) {
          if (groupsState.singleReplyStatus == SingleReplyStatus.loading) {
            return Container(
              height: 150.0,
              child: Loader(
                color: ColorResources.getPrimaryToWhite(context),
              )
            );
          }
          if (groupsState.singleReplyStatus == SingleReplyStatus.empty) {
            return Center(
              child: Text('Belum ada balasan')
            );
          }
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(groupsState.singleReply.body.user.nickname),
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    backgroundImage: NetworkImage("${AppConstants.BASE_URL_IMG}${groupsState.singleReply.body.user.profilePic.path}"),
                    radius: 20.0,
                  ),
                  subtitle: Text(timeago.format(DateTime.parse(groupsState.singleReply.body.created).toLocal(), locale: 'id'), 
                    style: TextStyle(
                      fontSize: 12.0
                    ),
                  ),
                ),
              Container(
                  width: 250.0,
                  margin: EdgeInsets.only(left: 70.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReadMoreText(
                        groupsState.singleReply.body.content.text,
                        trimLines: 2,
                        colorClickableText: Colors.black,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Tampilkan Lebih',
                        trimExpandedText: 'Tutup',
                        style: TextStyle(fontSize: 14.0),
                        moreStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                        lessStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                SizedBox(height: 8.0),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(groupsState.singleReply.body.numOfLikes.toString(),
                              style: TextStyle(fontSize: 15.0)),
                            ),
                            InkWell(
                              onTap: () {
                                groupsState.like(groupsState.singleReply.body.id, "REPLY");
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(Icons.thumb_up,
                                  size: 16.0,
                                  color: groupsState.singleReply.body.liked.isNotEmpty ? Colors.blue : Colors.black
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  )
                ),
              ]
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    groupsState.fetchAllReply(widget.replyId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title: Text('Balasan Komentar', style: TextStyle(color: Colors.black)),
            leading: IconButton(
              icon: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            elevation: 0.0,
            pinned: false,
            centerTitle: false,
            floating: true,
          ),
          reply(context)
        ]
      )
    );
  }
}
