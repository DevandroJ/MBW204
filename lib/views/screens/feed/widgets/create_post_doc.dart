import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:filesize/filesize.dart';
import 'package:sizer/sizer.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';

import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/data/repository/feed.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';

class CreatePostDocScreen extends StatefulWidget {
  final FilePickerResult files;
  final String groupId;
  CreatePostDocScreen({
    this.files,
    this.groupId
  });
  @override
  _CreatePostDocScreenState createState() => _CreatePostDocScreenState();
}

class _CreatePostDocScreenState extends State<CreatePostDocScreen> {
  GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();
  FeedState feedState = getIt<FeedState>(); 
  TextEditingController captionTextEditingController = TextEditingController();
  bool isLoading = false;
  Color color;

  Widget displaySingleDoc() {
    File file = File(widget.files.files.single.path);
    switch (basename(file.path).split('.').last) {
      case 'pdf':
        setState(() => color = Colors.red[300]);
      break;
      case 'ppt':
        setState(() => color = Colors.red[300]);
      break;
      case 'pptx':
        setState(() => color = Colors.red[300]);
      break;
      case 'txt':
        setState(() => color = Colors.blueGrey[300]);
      break;
      case 'xls':
        setState(() => color = Colors.green[300]);
      break;
      case 'xlsx':
        setState(() => color = Colors.green[300]);
      break;
        case 'doc':
        setState(() => color = Colors.green[300]);
      break;
      case 'docx':
        setState(() => color = Colors.green[300]);
      break;
      default:
    }
    return Container(
      width: 200.0,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filename : ${basename(file.path)}', 
            style: poppinsRegular.copyWith(
              color: ColorResources.WHITE,
              fontSize: 9.0.sp
            ) 
          ),
          SizedBox(height: 6.0),
          Text('Size : ${filesize(file.lengthSync())}', 
            style: poppinsRegular.copyWith(
              color: ColorResources.WHITE,
              fontSize: 9.0.sp
            ) 
          ),
        ],
      ) 
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
                color: ColorResources.BLACK 
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
                                    style: poppinsRegular.copyWith(
                                      fontSize: 9.0.sp
                                    ),
                                  )
                                )
                              );
                              setState(() => isLoading = false);
                              return;
                            }
                          } 
                          String body = await FeedService.shared.getMediaKey(); 
                          File files = File(widget.files.files[0].path);
                          Uint8List bytesFiles = files.readAsBytesSync();
                          String digestFile = sha256.convert(bytesFiles).toString();
                          String imageHash = base64Url.encode(HEX.decode(digestFile)); 
                          await FeedService.shared.uploadMedia(body, imageHash, files);
                          await feedState.sendPostDoc(caption, widget.files, widget.groupId);
                          setState(() => isLoading = false);
                          ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(
                            SnackBar(
                              backgroundColor: ColorResources.SUCCESS,
                              content: Text("Postingan berhasil dibuat",
                                style: poppinsRegular.copyWith(
                                  color: ColorResources.WHITE,
                                  fontSize: 9.0.sp
                                ),
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
                          ) 
                        : Text('Post',
                          textAlign: TextAlign.center,
                          style: poppinsRegular.copyWith(
                            color: ColorResources.WHITE,
                            fontSize: 9.0.sp
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
              height: MediaQuery.of(context).size.height - 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(widget.files != null)
                    displaySingleDoc(),
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
                ],
              ),
            )
          )
        ]
      ),
    );
  }
}