import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/post_link_component.dart';
import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/data/models/feed/comment.dart';
import 'package:mbw204_club_ina/data/models/feed/feedposttype.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/socket.dart';
import 'package:mbw204_club_ina/views/screens/feed/replies.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/post_doc_component.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/post_image_component.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/post_text_component.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/post_video_component.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  final GlobalKey<ScaffoldMessengerState> globalKey;

  PostDetailScreen({
    this.postId,
    this.globalKey,
  });

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  FeedState feedState = getIt<FeedState>();
  FocusNode commentFocusNode = FocusNode();
  bool deletePostBtn = false;
  TextEditingController commentTextEditingController = TextEditingController();

  void initState() {
    super.initState();
    (() async {
      await feedState.fetchListSticker();
      await feedState.fetchPost(widget.postId);
      await feedState.fetchListCommentMostRecent(widget.postId);
    })(); 
  }

  Widget commentSticker(BuildContext context, CommentContent comment) {
    return CachedNetworkImage(
      imageUrl: '${AppConstants.BASE_URL_IMG}${comment.url}',
      imageBuilder: (BuildContext context, ImageProvider<Object> image) {
        return Container(
          height: 60.0,
          decoration: BoxDecoration(
            image: DecorationImage(
            alignment: Alignment.centerLeft,
            image: image
            )
          ),
        );
      }
    );
  }

  Widget commentText(BuildContext context, CommentContent comment) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ReadMoreText(
        comment.text,
        style: poppinsRegular.copyWith(
          color: ColorResources.BLACK,
          fontSize: 14.0
        ),
        trimLines: 2,
        colorClickableText: Colors.black,
        trimMode: TrimMode.Line,
        trimCollapsedText: 'Tampilkan Lebih',
        trimExpandedText: 'Tutup',
        moreStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        lessStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    ]);
  }

  Widget post(BuildContext context) {
    return SliverToBoxAdapter(
      child: Observer(
        builder: (_) {
          if (feedState.postStatus == PostStatus.loading) {
            return Container(
              height: 120.0,
              child: Center(
                child: SizedBox(
                  height: 15.0,
                  width: 15.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(ColorResources.BTN_PRIMARY),
                  )
                )
              ),
            );
          }
          if(feedState.postStatus == PostStatus.empty) {
            return Center(
              child: Text(getTranslated("THERE_IS_NO_POST", context),
                style: poppinsRegular,
              )
            );
          }
          return Container(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListTile(
                dense: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage("${AppConstants.BASE_URL_FEED_IMG}/${feedState.post.body.user.profilePic.path}"),
                  radius: 20.0,
                ),
                title: Text(feedState.post.body.user.nickname,
                  style: poppinsRegular.copyWith(
                    color: ColorResources.BLACK
                  ),
                ),
                subtitle: Text(timeago.format((DateTime.parse(feedState.post.body.created).toLocal()), locale: 'id'),
                  style: poppinsRegular.copyWith(
                    fontSize: 12.0,
                    color: Colors.grey
                  ),
                ),
                trailing: Provider.of<ProfileProvider>(context, listen: false).getUserId == feedState.post.body.user.id 
                ? grantedDeletePost(context) 
                : SizedBox()
              ),

              if (feedState.post.body.postType == PostType.TEXT)
                PostTextComponent(feedState.post.body.content),
              if(feedState.post.body.postType == PostType.LINK)
                PostLinkComponent(url: feedState.post.body.content.url),
              if (feedState.post.body.postType == PostType.DOCUMENT)
                PostDocComponent(
                  globalKey: widget.globalKey,
                  medias: feedState.post.body.content.medias, 
                  caption: feedState.post.body.content.caption
                ),
              if (feedState.post.body.postType == PostType.IMAGE)
                PostImageComponent(feedState.post.body.content.medias, feedState.post.body.content.caption),
              if (feedState.post.body.postType == PostType.VIDEO)
                PostVideoComponent(feedState.post.body.content.medias[0], feedState.post.body.content.caption),
             
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
                            child: Text(feedState.post.body.numOfLikes.toString(),
                              style: TextStyle(fontSize: 15.0)
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              feedState.like(feedState.post.body.id, "POST");
                            },
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              child: Icon(Icons.thumb_up,
                                size: 16.0,
                                color: feedState.post.body.liked.isNotEmpty ? Colors.blue : ColorResources.WHITE
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  Text('${feedState.post.body.numOfComments.toString()} ${getTranslated("COMMENT", context)}',
                    style: poppinsRegular.copyWith(fontSize: 14.0),
                  ),
                ]
              )),

              ]
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return [
            SliverAppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              title: Text('Post', style: poppinsRegular.copyWith(color: Colors.black)),
              leading: IconButton(
                icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                  color: ColorResources.BLACK,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              elevation: 0.0,
              pinned: false,
              centerTitle: false,
              floating: true,
            ),
            post(context)
          ];
        },
          body: Observer(
            builder: (_) {
              if (feedState.commentMostRecentStatus == CommentMostRecentStatus.loading) {
                return Loader(
                  color: ColorResources.BTN_PRIMARY
                );
              }
              if (feedState.commentMostRecentStatus == CommentMostRecentStatus.empty) {
                return Center(
                  child: Text(getTranslated("THERE_IS_NO_COMMENT", context),
                    style: poppinsRegular,
                  )
                );
              }
              return NotificationListener<ScrollNotification>(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int i) {
                    return SizedBox(height: 8.0);
                  },
                  physics: BouncingScrollPhysics(),
                  itemCount: feedState.c1.nextCursor != null
                    ? feedState.c1List.length + 1
                    : feedState.c1List.length,
                  itemBuilder: (BuildContext context, int i) {
                    if (feedState.c1List.length == i) {
                      return Loader(
                        color: ColorResources.BTN_PRIMARY,
                      );
                    }
                    return Container(
                      margin: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Column(children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage("${AppConstants.BASE_URL_IMG}${feedState.c1List[i].user.profilePic.path}"),
                            radius: 20.0,
                          ),
                          title: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: ColorResources.BLACK,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0)
                              )
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    feedState.c1List[i].user.nickname,
                                    style: poppinsRegular.copyWith(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    child: Text(timeago.format(DateTime.parse(feedState.c1List[i].created).toLocal(), locale: 'id'),
                                      style: poppinsRegular.copyWith(fontSize: 12.0),
                                    )
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (feedState.c1List[i].type == "STICKER")
                                          commentSticker(context, feedState.c1List[i].content),
                                        if (feedState.c1List[i].type == "TEXT")
                                          commentText(context, feedState.c1List[i].content)
                                      ],
                                    )
                                  ),
                                ]
                              ),
                            )
                          ),
                        Container(
                          width: 150.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 50.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child: Text(feedState.c1List[i].numOfLikes.toString(),
                                      style: TextStyle(fontSize: 15.0),
                                    )),
                                    InkWell(
                                      onTap: () {
                                        feedState.like(feedState.c1List[i].id, "COMMENT");
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(Icons.thumb_up,
                                          size: 16.0,
                                          color: feedState.c1List[i].liked.isNotEmpty ? Colors.blue : ColorResources.BLACK),
                                      ),
                                    ),
                                  ]
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) => RepliesScreen(
                                        id: feedState.c1List[i].id,
                                        postId: widget.postId
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('${getTranslated("REPLY",context)} (${feedState.c1List[i].numOfReplies})',
                                  style: poppinsRegular.copyWith(
                                    fontSize: 14.0,
                                    fontStyle: FontStyle.italic)
                                  ),
                                )
                              ),
                            ]
                          ),
                        )
                      ]),
                    );
                  },
                ),
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    if (feedState.c1.nextCursor != null) {
                      feedState.fetchListCommentMostRecentLoad(widget.postId, feedState.c1.nextCursor);
                    }
                  }
                  return false;
                },
              );
            },
          )
        ),
      bottomNavigationBar: Container(
        padding: MediaQuery.of(context).viewInsets,
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 16.0),
            Material(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                child: IconButton(
                  icon: Icon(Icons.face),
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                      expand: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Scaffold(
                       body: SingleChildScrollView(
                         child: Observer(builder: (_) {
                        if (feedState.stickerStatus == StickerStatus.loading) {
                          return Center(
                            child: SizedBox(
                              width: 15.0,
                              height: 15.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(ColorResources.BTN_PRIMARY)
                              )
                            )
                          );
                        }
                        if (feedState.stickerStatus == StickerStatus.empty) {
                          return Center(child: Text(getTranslated("THERE_IS_NO_STICKER", context),
                            style: poppinsRegular,
                          ));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: feedState.sticker.body.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                              child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 0.0,
                                  mainAxisSpacing: 0.0,
                                  childAspectRatio: 3 / 1
                                ),
                                itemCount: feedState.sticker.body[i].stickers.length,
                                itemBuilder: (BuildContext ontext, int z) {
                                  return InkWell(
                                    onTap: () async {
                                      await SocketHelper.shared.sendCommentMostRecent( null, widget.postId, feedState.sticker.body[i].stickers[z].url, "STICKER");
                                      Navigator.pop(context);
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: '${AppConstants.BASE_URL_IMG}${feedState.sticker.body[i].stickers[z].url}',
                                      imageBuilder: (BuildContext context, ImageProvider<Object> image) {
                                        return Container(
                                          padding: EdgeInsets.all(8.0),
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: image
                                            )
                                          )
                                        );  
                                      },
                                    )
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }))),
                    );
                  },
                  color: Colors.black,
                ),
              ),
              color: Colors.white,
            ),
            Expanded(
              child: Container(
                child: TextField(
                  focusNode: commentFocusNode,
                  controller: commentTextEditingController,
                  style: poppinsRegular.copyWith(
                    color: ColorResources.BLACK,
                    fontSize: 9.0.sp
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: '${getTranslated("WRITE_COMMENT", context)} ...',
                    hintStyle: TextStyle(color: Colors.grey),
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
                String commentText = commentTextEditingController.text;
                if (commentTextEditingController.text.trim().isEmpty) {
                  throw new Error();
                }
                try {
                  commentFocusNode.unfocus();
                  commentTextEditingController.clear();
                  await SocketHelper.shared.sendCommentMostRecent(commentText, widget.postId);
                } catch (e) {
                  print(e);
                }
              }
            ),
          ],
        ),
      )
    );
  }

  Widget grantedDeletePost(context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext buildContext) { 
        return [
          PopupMenuItem(
            child: Text(getTranslated("DELETE_POST", context),
              style: poppinsRegular.copyWith(
                color: ColorResources.BTN_PRIMARY
              )
            ), 
            value: "/delete-post"
          )
        ];
      },
      onSelected: (route) {
        if(route == "/delete-post") {
          showAnimatedDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                height: 150.0,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.0),
                    Icon(
                      Icons.delete,
                      color: ColorResources.WHITE,
                    ),
                    SizedBox(height: 10.0),
                    Text(getTranslated("DELETE_POST", context),
                      style: poppinsRegular.copyWith(
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(getTranslated("NO", context),
                            style: poppinsRegular,
                          )
                        ), 
                        StatefulBuilder(
                          builder: (BuildContext context, Function s) {
                          return ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              ColorResources.ERROR
                            ),
                          ),
                          onPressed: () async { 
                          s(() => deletePostBtn = true);
                            try {         
                              await feedState.deletePost(feedState.post.body.id);               
                              s(() => deletePostBtn = false);
                              Navigator.of(context, rootNavigator: true).pop(); 
                              Navigator.of(context).pop();             
                            } catch(e) {
                              s(() => deletePostBtn = false);
                              print(e); 
                            }
                          },
                          child: deletePostBtn 
                          ? Loader(
                            color: ColorResources.WHITE,
                          )
                          : Text(getTranslated("YES", context),
                              style: poppinsRegular.copyWith(
                                fontSize: 9.0.sp
                              ),
                            )
                          );
                        })
                      ],
                    ) 
                  ])
                )
              );
            },
          );
        }
      },
    );
  }

}
