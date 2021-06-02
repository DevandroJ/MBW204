import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:hex/hex.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:video_player/video_player.dart';

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
  FeedState feedState = getIt<FeedState>(); 
  TextEditingController captionTextEditingController = TextEditingController();
  bool isLoading = false;
  bool validateC = false;
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
      body: CustomScrollView(
        slivers: [

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
                          String caption = captionTextEditingController.text;
                          if(caption.trim() == "") {
                            setState(() => validateC = true);
                            setState(() => isLoading = false);
                            throw Exception();
                          } 
                          String body = await FeedService.shared.getMediaKey(); 
                          File file = File(widget.file.path);
                          Uint8List bytesFiles = file.readAsBytesSync();
                          String digestFile = sha256.convert(bytesFiles).toString();
                          String imageHash = base64Url.encode(HEX.decode(digestFile)); 
                          await FeedService.shared.uploadMedia(body, imageHash, file);
                          await feedState.sendPostVideo(caption, file, widget.groupId);
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
                        } on Exception catch(_) {
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
                      errorText: validateC ? "Caption tidak boleh kosong" : null,
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
