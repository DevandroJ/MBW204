import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/utils/loader.dart';

class CreatePostText extends StatefulWidget {
  final String groupId;

  CreatePostText({
    this.groupId
  });

  @override
  _CreatePostTextState createState() => _CreatePostTextState();
}

class _CreatePostTextState extends State<CreatePostText> {
  FeedState feedState = getIt<FeedState>(); 
  ScrollController  scrollController = ScrollController();
  TextEditingController postTextEditingController = TextEditingController();
  int current = 0;
  bool validateN = false;
  bool isLoading = false;
  var alert;

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
              title: Text('Create Post', 
                style: TextStyle(
                  color: Colors.black
                )
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
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
                            if(postTextEditingController.text.trim().isEmpty) {
                              setState(() => validateN = true);
                              setState(() => isLoading = false);
                              throw CustomException();
                            }
                            await feedState.sendPostText(postTextEditingController.text, widget.groupId);                 
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
                          } catch(e) {
                            setState(() => isLoading = false);
                            print(e);
                          }
                        },
                        child: Container(
                          width: isLoading ? null : 80.0,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: ColorResources.PRIMARY,
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                          child:isLoading ? Loader(
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
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                maxLines: 4,
                controller: postTextEditingController,
                decoration: InputDecoration(
                  errorText: validateN ? "Caption tidak boleh kosong" : null,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

