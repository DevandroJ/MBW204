import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/data/repository/feed.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/loader.dart';

class CreatePostImageCameraScreen extends StatefulWidget {
  final PickedFile file;

  CreatePostImageCameraScreen(
    this.file
  );

  @override
  _CreatePostImageCameraScreenState createState() => _CreatePostImageCameraScreenState();
}

class _CreatePostImageCameraScreenState extends State<CreatePostImageCameraScreen> {
  GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();
  FeedState feedState = getIt<FeedState>(); 
  TextEditingController captionTextEditingController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    File file = File(widget.file.path);
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
                          Uint8List bytes = file.readAsBytesSync();
                          String digest = sha256.convert(bytes).toString();
                          String imageHashBackground = base64Url.encode(HEX.decode(digest)); 
                          await FeedService.shared.uploadMedia(body, imageHashBackground, file);
                          await feedState.sendPostImageCamera(caption, file, null);
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
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 200.0,
                            child: Image.file(
                              file,
                              fit: BoxFit.fill,
                            )
                          ),
                        ]
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
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
                    ],
                  ),
                ),
              ]
            )
          )
        ]
      )
    );
  }
}
