import 'dart:io';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/data/models/feed/reply.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/socket.dart';

class CommentDetailScreen extends StatefulWidget {
  final String commentId;
  final String postId;

  CommentDetailScreen({
    this.commentId,
    this.postId
  });

  @override
  _CommentDetailScreenState createState() => _CommentDetailScreenState();
}

class _CommentDetailScreenState extends State<CommentDetailScreen> {
  FeedState feedState = getIt<FeedState>();
  TextEditingController replyTextEditingController = TextEditingController();
  FocusNode replyFocusNode = FocusNode();

  Widget replyText(ReplyBody reply) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReadMoreText(reply.content.text,
          trimLines: 2,
          colorClickableText: Colors.black,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Tampilkan Lebih',
          trimExpandedText: 'Tutup',
          style: TextStyle(
            fontSize: 14.0
          ),
          moreStyle: TextStyle(
            fontSize: 14.0, 
            fontWeight: FontWeight.bold
          ),
          lessStyle: TextStyle(
            fontSize: 14.0, 
            fontWeight: FontWeight.bold
          ),
        ),
      ]
    );
  }

  Widget comment(BuildContext context) {
    return SliverToBoxAdapter(
      child: Observer(
        builder: (_) {
          if(feedState.singleCommentStatus == SingleCommentStatus.loading) {
            return Container(
              height: 100.0,
              child: Loader(
                color: ColorResources.PRIMARY,
              )
            );
          }
          if(feedState.singleCommentStatus == SingleCommentStatus.empty) {
            return Container(
              height: 100.0,
              child: Center(
                child: Text('Belum ada komentar')
              ),
            );
          }
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(feedState.singleComment.body.user.nickname),
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    backgroundImage: NetworkImage("${AppConstants.BASE_URL_IMG}${feedState.singleComment.body.user.profilePic.path}"),
                    radius: 20.0,
                  ),
                  subtitle: Text(timeago.format(DateTime.parse(feedState.singleComment.body.created).toLocal(), locale: 'id')),
                ),
                Container(
                  width: 250.0,
                  margin: EdgeInsets.only(left: 70.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    if (feedState.singleComment.body.type == "STICKER")
                      Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.centerLeft,
                            image: NetworkImage('${AppConstants.BASE_URL_IMG}${feedState.singleComment.body.content.url}') 
                          )
                        ),
                      ),
                    if (feedState.singleComment.body.type == "TEXT")
                      ReadMoreText(
                        feedState.singleComment.body.content.text,                       
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
                  ) 
                ),
                SizedBox(height: 5.0),
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
                              child: Text(
                                  feedState.singleComment.body.numOfLikes
                                      .toString(),
                                  style: TextStyle(fontSize: 15.0)),
                            ),
                            InkWell(
                              onTap: () {
                                feedState.like(feedState.singleComment.body.id, "COMMENT");
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.thumb_up,
                                  size: 16.0,
                                  color: feedState.singleComment.body.liked.isNotEmpty ? Colors.blue : Colors.black
                                ),
                              ),
                            )
                            ],
                          ),
                        ),
                        Text(
                          '${feedState.singleComment.body.numOfReplies.toString()} Balasan',
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ])),
            ]),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    feedState.fetchComment(widget.commentId);
    feedState.fetchAllReply(widget.commentId);
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return [
            SliverAppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              title: Text('Komentar', style: TextStyle(color: Colors.black)),
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
            comment(context)
          ];
        },
        body: Observer(
          builder: (_) {
            if (feedState.replyStatus == ReplyStatus.loading) {
              return Container(
                height: 80.0,
                child: Loader(
                  color: ColorResources.PRIMARY,
                )
              );
            }
            if (feedState.replyStatus == ReplyStatus.empty) {
              return Center(child: Text('Belum ada balasan'));
            }
            return NotificationListener<ScrollNotification>(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int i) {
                  return SizedBox(height: 16.0);
                },
                physics: BouncingScrollPhysics(),
                itemCount: feedState.reply.nextCursor != null
                    ? feedState.replyList.length + 1
                    : feedState.replyList.length,
                itemBuilder: (BuildContext context, int i) {
                  if (feedState.replyList.length == i) {
                    return Center(
                      child: SizedBox(
                      width: 15.0,
                      height: 15.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.red
                        ),
                      ),
                      )
                    );
                  }
                  return Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            backgroundImage: NetworkImage("${AppConstants.BASE_URL_IMG}${feedState.replyList[i].user.profilePic.path}"),
                            radius: 20.0,
                          ),
                          title: Container( 
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feedState.replyList[i].user.nickname,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  child: Text(timeago.format(DateTime.parse(feedState.replyList[i].created).toLocal(), locale: 'id'),
                                    style: TextStyle(
                                      fontSize: 12.0
                                    ),
                                  )
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    if(feedState.replyList[i].type == "TEXT")
                                      replyText(feedState.replyList[i]),
                                      Row(
                                        children: [
                                          Container(
                                              child: Text(
                                            feedState.replyList[i].numOfLikes
                                                .toString(),
                                            style: TextStyle(fontSize: 15.0),
                                          )),
                                          InkWell(
                                            onTap: () {
                                              feedState.like(
                                                  feedState.replyList[i].id,
                                                  "REPLY");
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(5.0),
                                              child: Icon(Icons.thumb_up,
                                                  size: 16.0,
                                                  color: feedState
                                                          .replyList[i]
                                                          .liked
                                                          .isNotEmpty
                                                      ? Colors.blue
                                                      : Colors.black),
                                            ),
                                          ),
                                        ])
                                      ],
                                    )),
                              ]),
                        ),
                      ),
                    ]),
                  );
                },
              ),
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  if (feedState.reply.nextCursor != null) {
                    feedState.fetchAllReplyLoad(
                        widget.commentId, feedState.reply.nextCursor);
                  }
                }
                return false;
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: MediaQuery.of(context).viewInsets,
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 16.0),
            Expanded(
              child: Container(
                child: TextField(
                  focusNode: replyFocusNode,
                  controller: replyTextEditingController,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Tulis Balasan disini ...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                String replyText = replyTextEditingController.text;
                if (replyTextEditingController.text.trim().isEmpty) {   
                  throw Error();
                }    
                try {
                  replyFocusNode.unfocus();
                  replyTextEditingController.clear();
                  await SocketHelper.shared.sendReply(replyText, widget.commentId, widget.postId); 
                } catch(e) {
                  print(e);
                }                              
              }
            ),
          ],
        ),
      ),
    );
  }
}
