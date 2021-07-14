import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:hex/hex.dart';

import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/data/repository/feed.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';

class CreatePostImageScreen extends StatefulWidget {
  final List<File> files;
  final String groupId;
  CreatePostImageScreen({
    this.files,
    this.groupId
  });
  @override
  _CreatePostImageScreenState createState() => _CreatePostImageScreenState();
}

class _CreatePostImageScreenState extends State<CreatePostImageScreen> {
  FeedState feedState = getIt<FeedState>(); 
  TextEditingController captionTextEditingController = TextEditingController();
  int current = 0;
  bool isLoading = false;
  bool validateC = false;

  Widget displaySinglePictures() {
    File file = File(widget?.files?.first?.path);
    return Container(
      height: 180.0,
      child: Image.file(file,
        fit: BoxFit.fitHeight,
        width: double.infinity,
      )
    );
  }

  Widget displayListPictures() {
    List<File> listFile = widget.files.map((file) => File(file.path)).toList();
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() => current = index);
              }
            ),
            items: listFile.map((i) {
              File demoImage = File(i.path);
              return Builder(
                builder: (BuildContext context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200.0,
                        child: Image.file(
                          demoImage,
                          fit: BoxFit.fill,
                        )
                      ),
                    ]
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: listFile.map((i) {
              int index = listFile.indexOf(i);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: current == index
                  ? Color.fromRGBO(0, 0, 0, 0.9)
                  : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
          )
        ]
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
                          if(widget.files.length > 1) {
                            for (int i = 0; i < widget.files.length; i++) {
                              String body = await FeedService.shared.getMediaKey(); 
                              File files = File(widget.files[i].path);
                              Uint8List bytes = widget.files[i].readAsBytesSync();
                              String digestFile = sha256.convert(bytes).toString();
                              String imageHash = base64Url.encode(HEX.decode(digestFile)); 
                              await FeedService.shared.uploadMedia(body, imageHash, files);
                            }
                          } else {
                            String body = await FeedService.shared.getMediaKey(); 
                            Uint8List bytes = widget.files[0].readAsBytesSync();
                            File files = File(widget.files[0].path);
                            String digestFile = sha256.convert(bytes).toString();
                            String imageHash = base64Url.encode(HEX.decode(digestFile)); 
                            await FeedService.shared.uploadMedia(body, imageHash, files);
                          }
                          await feedState.sendPostImage(caption, widget.files, widget.groupId);          
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
                  Column(
                    children: [
                      if(widget.files.length > 1)
                        displayListPictures()
                      else 
                        displaySinglePictures()
                    ],
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    maxLines: 4,
                    controller: captionTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Caption",
                      errorText: validateC ? "Caption can`t null or empty" : null,
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