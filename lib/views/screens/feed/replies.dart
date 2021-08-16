import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/data/models/feed/reply.dart';
import 'package:mbw204_club_ina/data/models/feed/singlecomment.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/socket.dart';

class RepliesScreen extends StatefulWidget {
  final String id;
  final String postId;

  RepliesScreen({
    this.id,
    this.postId
  });

  @override
  _RepliesScreenState createState() => _RepliesScreenState();
}

class _RepliesScreenState extends State<RepliesScreen> {
  FeedState groupsState = getIt<FeedState>();
  TextEditingController replyTextEditingController = TextEditingController();
  FocusNode replyFocusNode = FocusNode();
  bool isExpanded = false;

  Widget commentSticker(SingleCommentBody comment) {
    return CachedNetworkImage(
      imageUrl:'${AppConstants.BASE_URL_IMG}${comment.content.url}',
      imageBuilder: (BuildContext context, ImageProvider<Object> image) {
        return Container(
          height: 60.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.centerLeft,
              image: image
            ),
          )            
        );
      },
    );
  }

  Widget commentText(SingleCommentBody comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      ReadMoreText(
        comment.content.text,
        trimLines: 2,
        colorClickableText: Colors.black,
        trimMode: TrimMode.Line,
        trimCollapsedText: 'Tampilkan Lebih',
        trimExpandedText: 'Tutup',
        style: poppinsRegular.copyWith(fontSize: 14.0),
        moreStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        lessStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    ]);
  }

  Widget replyText(ReplyBody reply) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      ReadMoreText(
        reply.content.text,
        trimLines: 2,
        colorClickableText: Colors.black,
        trimMode: TrimMode.Line,
        trimCollapsedText: 'Tampilkan Lebih',
        trimExpandedText: 'Tutup',
        style: poppinsRegular.copyWith(fontSize: 14.0),
        moreStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        lessStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    ]);
  }

  Widget comment(BuildContext context) {
    return SliverToBoxAdapter(
      child: Observer(
        builder: (_) {
        if (groupsState.singleCommentStatus == SingleCommentStatus.loading) {
          return Container(
            height: 100.0,
            child: Loader(
              color: ColorResources.WHITE
            )
          );
        }
        if (groupsState.singleCommentStatus == SingleCommentStatus.empty) {
          return Container(
            height: 100.0,
            child: Center(
              child: Text('Belum ada komentar')
            )
          );
        }
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage("${AppConstants.BASE_URL_IMG}${groupsState.singleComment.body.user.profilePic.path}"),
                radius: 20.0,
              ),
              title: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groupsState.singleComment.body.user.nickname,
                      style: poppinsRegular.copyWith(
                        fontSize: 15.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Text(
                        timeago.format(DateTime.parse(groupsState.singleComment.body.created).toLocal(), locale: 'id'),
                        style: poppinsRegular.copyWith(
                          fontSize: 12.0
                        ),
                      )
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (groupsState.singleComment.body.type == "STICKER")
                            commentSticker(groupsState.singleComment.body),
                          if (groupsState.singleComment.body.type == "TEXT")
                            commentText(groupsState.singleComment.body)
                        ],
                      )
                    ),
                  ]
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              margin: EdgeInsets.only(top: 8.0),
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
                              child: Text( groupsState.singleComment.body.numOfLikes.toString(),
                              style: poppinsRegular.copyWith(
                                fontSize: 15.0
                              )),
                            ),
                            InkWell(
                              onTap: () =>  groupsState.like(groupsState.singleComment.body.id, "COMMENT"),
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(Icons.thumb_up,
                                  size: 16.0,
                                  color: groupsState.singleComment.body.liked.isNotEmpty ? Colors.blue : ColorResources.BLACK,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text('${groupsState.singleComment.body.numOfReplies.toString()} ${getTranslated("REPLY", context)}',
                        style: poppinsRegular.copyWith(fontSize: 15.0),
                      ),
                    ]
                  )
                ),
              ]
            )
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    groupsState.fetchComment(widget.id);
    groupsState.fetchAllReply(widget.id);
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title: Text(getTranslated("REPLY_COMMENT", context), 
            style: poppinsRegular.copyWith(
              color: Colors.black
            )
          ),
          leading: IconButton(
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop()
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
          if (groupsState.replyStatus == ReplyStatus.loading) {
            return Loader(
              color: ColorResources.WHITE
            );
          }
          if (groupsState.replyStatus == ReplyStatus.empty) {
            return Center(
              child: Text(getTranslated("THERE_IS_NO_REPLY", context),
                style: poppinsRegular,
              )
            );
          }
          return NotificationListener<ScrollNotification>(
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int i) {
                return SizedBox(height: 16.0);
              },
              physics: BouncingScrollPhysics(),
              itemCount: groupsState.reply.nextCursor != null
                ? groupsState.replyList.length + 1
                : groupsState.replyList.length,
              itemBuilder: (BuildContext context, int i) {
                if (groupsState.replyList.length == i) {
                  return Center(child: CupertinoActivityIndicator());
                }
                return Container(
                  margin: EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Column(
                    children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage("${AppConstants.BASE_URL_IMG}${groupsState.replyList[i].user.profilePic.path}"),
                        radius: 20.0,
                      ),
                      title: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: ColorResources.BLUE_GREY,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)
                        )
                      ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                groupsState.replyList[i].user.nickname,
                                style: poppinsRegular.copyWith(
                                  fontSize: 15.0,
                                  color: ColorResources.BLACK
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  timeago.format(DateTime.parse(groupsState.replyList[i].created).toLocal(), locale: 'id'),
                                  style: poppinsRegular.copyWith(
                                    fontSize: 12.0
                                  ),
                                )
                              ),

                              Container(
                                margin: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (groupsState.replyList[i].type == "TEXT")
                                      replyText(groupsState.replyList[i]),
                                  ],
                                )
                              ),
                              
                              Container(
                                width: 50.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child: Text(
                                        groupsState.replyList[i].numOfLikes.toString(),
                                        style: poppinsRegular.copyWith(fontSize: 15.0),
                                      )
                                    ),
                                    InkWell(
                                      onTap: () {
                                        groupsState.like(groupsState.replyList[i].id, "REPLY");
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(Icons.thumb_up,
                                          size: 16.0,
                                          color: groupsState.replyList[i].liked.isNotEmpty
                                          ? Colors.blue
                                          : ColorResources.BLACK
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ),

                          

                          ]
                        ),
                      ),
                    ),
                  ]
                ),
              );
            },
          ),
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                if (groupsState.reply.nextCursor != null) {
                  groupsState.fetchAllReplyLoad(widget.id, groupsState.reply.nextCursor);
                }
              }
              return false;
            },
          );
        },
      )),
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
                style: poppinsRegular.copyWith(
                  color: ColorResources.BLACK,
                  fontSize: 16.0
                ),
                decoration: InputDecoration.collapsed(
                  hintText: '${getTranslated("WRITE_REPLY", context)} ...',
                  hintStyle: poppinsRegular.copyWith(color: Colors.grey),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: ColorResources.BLACK,
            ),
            onPressed: () async {
              String replyText = replyTextEditingController.text;
              if (replyTextEditingController.text.trim().isEmpty) {
                throw Error();
              }
              try {
                replyFocusNode.unfocus();
                replyTextEditingController.clear();
                await SocketHelper.shared.sendReply(replyText, widget.id, widget.postId);
              } catch (e) {
                print(e);
              }
            }),
          ],
        ),
      ),
    );
  }
}
