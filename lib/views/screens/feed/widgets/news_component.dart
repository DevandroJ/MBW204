import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/data/models/feed/feedposttype.dart';
import 'package:mbw204_club_ina/data/models/feed/groups.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/screens/feed/post_detail.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/post_doc_component.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/post_image_component.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/post_link_component.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/post_text_component.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/post_video_component.dart';

class NewsComponent extends StatefulWidget {
  final int i;
  final List<GroupsBody> groupsBody;
   
  NewsComponent({
    this.i,
    this.groupsBody
  });

  @override
  _NewsComponentState createState() => _NewsComponentState();
}

class _NewsComponentState extends State<NewsComponent> {
  FeedState feedState = getIt<FeedState>();
  bool deletePostBtn = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailScreen(postId: widget.groupsBody[widget.i].id))),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            ListTile(
              dense: true,
              leading: CachedNetworkImage(
                imageUrl: "${AppConstants.BASE_URL_FEED_IMG}/${widget.groupsBody[widget.i].user.profilePic.path}",
                imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                  return CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: imageProvider,
                    radius: 20.0,
                  );                 
                },
                placeholder: (BuildContext context, String url) {
                  return CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Loader(
                      color: ColorResources.PRIMARY
                    ),
                    radius: 20.0,
                  );   
                
                },
                errorWidget: (BuildContext context, url, error) {
                  return CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                    radius: 20.0 ,
                  );      
                },
              ),
              title: Text(widget.groupsBody[widget.i].user.nickname,
                style: poppinsRegular.copyWith(
                  color: ColorResources.BLACK
                ),
              ),
              subtitle: Text(timeago.format((DateTime.parse(widget.groupsBody[widget.i].created).toLocal()), locale: 'id'),
                style: poppinsRegular.copyWith(
                  fontSize: 12.0,
                  color: Colors.grey
                ),
              ),
              trailing: Provider.of<ProfileProvider>(context, listen: false).getUserId == widget.groupsBody[widget.i].user.userId 
              ? grantedDeletePost(context) 
              : SizedBox()
            ),
            
            if(widget.groupsBody[widget.i].postType == PostType.TEXT) 
              PostTextComponent(widget.groupsBody[widget.i].content),
            if(widget.groupsBody[widget.i].postType == PostType.LINK)
              PostLinkComponent(url: widget.groupsBody[widget.i].content.url),
            if(widget.groupsBody[widget.i].postType == PostType.DOCUMENT)
              PostDocComponent(widget.groupsBody[widget.i].content.medias),
            if(widget.groupsBody[widget.i].postType == PostType.IMAGE)
              PostImageComponent(widget.groupsBody[widget.i].content.medias, widget.groupsBody[widget.i].content.caption),
            if(widget.groupsBody[widget.i].postType == PostType.VIDEO)
              PostVideoComponent(widget.groupsBody[widget.i].content.medias[0], widget.groupsBody[widget.i].content.caption),
            
            SizedBox(height: 8.0),

            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(widget.groupsBody[widget.i].numOfLikes.toString(), 
                            style: poppinsRegular.copyWith(
                              color: ColorResources.BLACK,
                              fontSize: 15.0
                            )
                          ),
                        ),
                        InkWell(
                          onTap: () => feedState.like(widget.groupsBody[widget.i].id, "POST"),
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.thumb_up,
                              size: 16.0,
                              color: widget.groupsBody[widget.i].liked.isNotEmpty ? ColorResources.BLUE : ColorResources.BLACK
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text('${widget.groupsBody[widget.i].numOfComments.toString()} ${getTranslated("COMMENT", context)}',
                    style: poppinsRegular.copyWith(
                      fontSize: 14.0
                    ),
                  )
                ]
              )
            ), 
        ],  
      ),
    ),
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
                    Icon(Icons.delete,
                      color: ColorResources.BLACK,
                    ),
                    SizedBox(height: 10.0),
                    Text(getTranslated("DELETE_POST", context),
                      style: poppinsRegular.copyWith(
                        fontSize: 16.0,
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
                                await feedState.deletePost(widget.groupsBody[widget.i].id);               
                                s(() => deletePostBtn = false);
                                Navigator.of(context, rootNavigator: true).pop();             
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
                              style: poppinsRegular,
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
