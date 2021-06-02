import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:crypto/crypto.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:hex/hex.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/data/repository/feed.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

class CreatePostImageCameraScreen extends StatefulWidget {
  final PickedFile file;

  CreatePostImageCameraScreen(
    this.file
  );

  @override
  _CreatePostImageCameraScreenState createState() => _CreatePostImageCameraScreenState();
}

class _CreatePostImageCameraScreenState extends State<CreatePostImageCameraScreen> {
  FeedState feedState = getIt<FeedState>(); 
  TextEditingController captionTextEditingController = TextEditingController();
  bool validateC = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    File file = File(widget.file.path);
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
                          Uint8List bytes = file.readAsBytesSync();
                          String digest = sha256.convert(bytes).toString();
                          String imageHashBackground = base64Url.encode(HEX.decode(digest)); 
                          await FeedService.shared.uploadMedia(body, imageHashBackground, file);
                          await feedState.sendPostImageCamera(caption, file, null);
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
                        } on Exception catch(e) {
                          setState(() => isLoading = false);
                          print(e);
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
                        child: isLoading ? SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
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
                            errorText: validateC ? "Caption can`t null or empty" : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
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