import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
import 'package:video_player/video_player.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/data/repository/feed.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

class CreatePostVideoScreen extends StatefulWidget {
  final File file;
  final String groupId;
  CreatePostVideoScreen({
    this.file,
    this.groupId
  });
  @override
  _CreatePostVideoScreenState createState() => _CreatePostVideoScreenState();
}

class _CreatePostVideoScreenState extends State<CreatePostVideoScreen> {
  GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();
  FeedState feedState = getIt<FeedState>(); 
  TextEditingController captionTextEditingController = TextEditingController();
  bool isLoading = false;
  VideoPlayerController videoPlayerController;

  void initState() {
    super.initState();
    File file = File(widget.file.path);
    videoPlayerController = VideoPlayerController.file(file);
  }

  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  Widget displaySingleVideo() {
    return Chewie(
      controller: ChewieController(
        videoPlayerController: videoPlayerController,
        autoInitialize: true,
        looping: false,
        autoPlay: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: CustomScrollView(
        slivers: [

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
                          String body = await FeedService.shared.getMediaKey(); 
                          File file = File(widget.file.path);
                          Uint8List bytesFiles = file.readAsBytesSync();
                          String digestFile = sha256.convert(bytesFiles).toString();
                          String imageHash = base64Url.encode(HEX.decode(digestFile)); 
                          await FeedService.shared.uploadMedia(body, imageHash, file);
                          await feedState.sendPostVideo(caption, file, widget.groupId);
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
                        child: isLoading 
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
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  Container(
                    height: 185.0,
                    child: displaySingleVideo()
                  ),
                  SizedBox(height: 10.0),
                  TextField(
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
                ]
              ),
            )
          )
        ]
      ),
    );
  }
}