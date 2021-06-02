import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:filesize/filesize.dart';
import 'package:crypto/crypto.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';

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
  FeedState groupsState = getIt<FeedState>(); 
  bool isLoading = false;
  bool validateC = false;
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0
            ) 
          ),
          SizedBox(height: 6.0),
          Text('Size : ${filesize(file.lengthSync())}', 
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0
            ) 
          ),
        ],
      ) 
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: isLoading ? () {} : () async {
                        setState(() => isLoading = true);
                        try {
                          String body = await FeedService.shared.getMediaKey(); 
                          File files = File(widget.files.files[0].path);
                          Uint8List bytesFiles = files.readAsBytesSync();
                          String digestFile = sha256.convert(bytesFiles).toString();
                          String imageHash = base64Url.encode(HEX.decode(digestFile)); 
                          await FeedService.shared.uploadMedia(body, imageHash, files);
                          await groupsState.sendPostDoc(widget.files, widget.groupId);
                       
                          setState(() => isLoading = false);
                            // var alert = await alertComponent(context, "New Post Created", "Success", "success");
                            // alert.show();
                            // Future.delayed(Duration(seconds: 1), () {
                            //   alert.dismiss();
                            //   Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) =>
                            //       FeedIndex(),
                            //     ),
                            //   );     
                            // });
                         
                            // var alert = await alertComponent(context, "There is something wrong", "Failed", "error");
                            // alert.show();
                            // Future.delayed(Duration(seconds: 1), () {
                            //   alert.dismiss();
                            //   Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) =>
                            //       FeedIndex(),
                            //     ),
                            //   );     
                            // });
                          
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
              height: MediaQuery.of(context).size.height - 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(widget.files != null)
                    displaySingleDoc()
                ],
              ),
            )
          )
        ]
      ),
    );
  }
}