import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
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
  GlobalKey<ScaffoldMessengerState> globalKey= GlobalKey<ScaffoldMessengerState>();
  FeedState feedState = getIt<FeedState>(); 
  ScrollController  scrollController = ScrollController();
  TextEditingController captionController = TextEditingController();
  bool isLoading = false;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool inner) {
          return [
            SliverAppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              title: Text('Create Post', 
                style: poppinsRegular.copyWith(
                  color: Colors.black
                )
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: isLoading ? () {} : () => Navigator.of(context).pop(),
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
                            String caption = captionController.text;
                            if(caption.trim().isEmpty) {
                              ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
                                SnackBar(
                                  backgroundColor: ColorResources.ERROR,
                                  content: Text("Caption wajib diisi",
                                    style: poppinsRegular,
                                  )
                                )
                              );
                              setState(() => isLoading = false);
                              return;
                            }
                            if(caption.trim().isNotEmpty) {
                              if(caption.trim().length < 10) {
                                ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
                                  SnackBar(
                                    backgroundColor: ColorResources.ERROR,
                                    content: Text("Minimal Caption 10 Karakter",
                                      style: poppinsRegular,
                                    )
                                  )
                                );
                                setState(() => isLoading = false);
                                return;
                              }
                            } 
                            if(caption.trim().length > 1000) {
                              ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
                                SnackBar(
                                  backgroundColor: ColorResources.ERROR,
                                  content: Text("Maksimal Caption 1000",
                                    style: poppinsRegular,
                                  )
                                )
                              );
                              setState(() => isLoading = false);
                              return;
                            }
                            await feedState.sendPostText(caption, widget.groupId);                 
                            setState(() => isLoading = false);
                            ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
                              SnackBar(
                                backgroundColor: ColorResources.SUCCESS,
                                content: Text("Postingan berhasil dibuat",
                                  style: poppinsRegular,
                                )
                              )
                            );
                            Navigator.of(context).pop();
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
                          child:isLoading 
                          ? Loader(
                              color: ColorResources.WHITE,
                            ) 
                          : Text('Post',
                            textAlign: TextAlign.center,
                            style: poppinsRegular.copyWith(
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
                controller: captionController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  hintText: "Tulis post",
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}