import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
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
  GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();
  FeedState feedState = getIt<FeedState>(); 
  ScrollController scrollController = ScrollController();
  TextEditingController captionTextEditingController = TextEditingController();
  TextEditingController urlTextEditingController = TextEditingController();
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
              title: Text('Embedded Media', 
                style: poppinsRegular.copyWith(
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
                            String caption = captionTextEditingController.text;
                            String url = urlTextEditingController.text;
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
                            if(url.trim().isEmpty) {
                              ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
                                SnackBar(
                                  backgroundColor: ColorResources.ERROR,
                                  content: Text("URL wajib diisi",
                                    style: poppinsRegular,
                                  )
                                )
                              );
                              setState(() => isLoading = false);
                              return;
                            } 
                            bool validURL = Uri.parse(url.trim()).isAbsolute;
                            if(!validURL) {
                              ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
                                SnackBar(
                                  backgroundColor: ColorResources.ERROR,
                                  content: Text("Format URL salah. Contoh : http://google.com",
                                    style: poppinsRegular,
                                  )
                                )
                              );
                              setState(() => isLoading = false);
                              return;
                            }
                            await feedState.sendPostLink(caption, url, widget.groupId);  
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
                          child: isLoading 
                          ? Loader(
                            color: ColorResources.WHITE,
                          ) : Text('Post',
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
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                  ),
                ),
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                child: TextField(
                  controller: urlTextEditingController,
                  decoration: InputDecoration(
                    hintText: "http://example.com",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
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


