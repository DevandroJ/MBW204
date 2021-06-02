import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/utils/loader.dart';

class CreatePostLink extends StatefulWidget {
  final String groupId;

  CreatePostLink({
    this.groupId
  });

  @override
  _CreatePostLinkState createState() => _CreatePostLinkState();
}

class _CreatePostLinkState extends State<CreatePostLink> {
  FeedState feedState = getIt<FeedState>(); 
  ScrollController scrollController = ScrollController();
  TextEditingController captionTextEditingController = TextEditingController();
  TextEditingController urlTextEditingController = TextEditingController();
  bool validateCaption = false;
  bool validateUrl = false;
  bool validateUrlEmpty = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool inner) {
          return [
            SliverAppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              title: Text('Embedded Media', 
                style: TextStyle(
                  color: Colors.black
                )
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorResources.BLACK,
                ),
                onPressed: isLoading ? () {} : () {
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                Container(
                  margin: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: isLoading ? () {} : () async {
                          setState(() => isLoading = true);
                          try {
                            if(captionTextEditingController.text.trim().isEmpty) {
                              setState(() => validateCaption = true);
                              setState(() => isLoading = false);
                              throw CustomException();
                            } else {
                              setState(() => validateCaption = false);
                            }
                            if(urlTextEditingController.text.trim().isEmpty) {
                              setState(() => validateUrlEmpty = true);
                              setState(() => isLoading = false);
                              throw CustomException();
                            } else {
                              setState(() => validateUrl = true);
                            }
                            bool validURL = Uri.parse(urlTextEditingController.text.trim()).isAbsolute;
                            if(!validURL) {
                              setState(() => validateUrl = true);
                              throw CustomException();
                            }
                            await feedState.sendPostLink(captionTextEditingController.text, urlTextEditingController.text, widget.groupId);  
                            setState(() => isLoading = false);
                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return Center(
                                  child: Container(
                                    color: ColorResources.WHITE,
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.check,
                                      size: 18.0,
                                      color: ColorResources.GREEN,
                                    ),
                                  ),
                                );
                              },
                              animationType: DialogTransitionType.scale,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(seconds: 1),
                            );
                            Future.delayed(Duration(seconds: 1), () => Navigator.of(context, rootNavigator: true).pop());
                            Future.delayed(Duration(seconds: 2), () => Navigator.of(context).pop());
                          } on CustomException catch(_) {
                            setState(() => isLoading = false);
                          } catch(_) {
                            setState(() => isLoading = false);
                          }
                        },
                        child: Container(
                          width: isLoading ? null : 80.0,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: ColorResources.PRIMARY,
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: isLoading ? Loader(
                            color: ColorResources.WHITE,
                          ) : Text('Post',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      )
                    ]
                  ),
                )
              ],
              centerTitle: false,
              floating: true,
            )
          ];
        },  
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                child: TextField(
                  maxLines: 4,
                  controller: captionTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Caption",
                    errorText: validateCaption ? "Caption tidak boleh kosong" : null,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                child: TextField(
                  controller: urlTextEditingController,
                  decoration: InputDecoration(
                    hintText: "http://example.com",
                    errorText: validateUrlEmpty
                    ? "URL tidak boleh kosong" 
                    : validateUrl 
                    ? "Invalid Format URL eg : http://google.com" 
                    : null,
                  ),
                ),
              ),
            ],
          ) 
        ),
      )
    );
  }
}

