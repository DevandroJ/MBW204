import 'dart:ui';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:ext_storage/ext_storage.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/models/feed/feedmedia.dart';
import 'package:permission_handler/permission_handler.dart';

class PostDocComponent extends StatefulWidget {
  final List<FeedMedia> medias;

  PostDocComponent(
    this.medias,
  );

  @override
  _PostDocComponentState createState() => _PostDocComponentState();
}

class _PostDocComponentState extends State<PostDocComponent> {

  String type;
  Color color;

  static downloadingCallback(id, status, progress) {

  }

  @override 
  void initState() {
    super.initState();
    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {

    switch (basename(widget.medias[0].path).split('.').last) {
      case "pdf":
        setState(() => type = "PDF");
        setState(() => color = Colors.red[300]);
      break;
      case "ppt":
        setState(() => type = "PPT");
        setState(() => color = Colors.red[300]);
      break;
      case "pptx":
        setState(() => type = "PPTX");
        setState(() => color = Colors.red[300]);
      break;
      case "txt":
        setState(() => type = "TXT");
        setState(() => color = Colors.blueGrey[300]);
      break;
      case "xls": 
        setState(() => type = "XLS");
        setState(() => color = Colors.green[300]);
      break;
      case "xlsx": 
        setState(() => type = "XLSX");
        setState(() => color = Colors.green[300]);
      break;
      case "doc":
        setState(() => type = "DOC");
        setState(() => color = Colors.blue[300]);
      break;
      case "docx":
        setState(() => type = "DOCX");
        setState(() => color = Colors.blue[300]);
      break;
      default:
    }
    return Container(
      height: 56.0,
      margin: EdgeInsets.only(left: 16.0, right: 16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: Row(
        children: [ 
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 12.0),
              child: Text(type,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: ColorResources.WHITE
                ),
              ),
            )
          ),
          Expanded(
            child: Text(widget.medias[0].path.split('/').last,
              style: TextStyle(
                fontSize: 15.0,
                color: ColorResources.WHITE
              )
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () async {
                showAnimatedDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        height: 140.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10.0),
                            Icon(Icons.download_rounded),
                            SizedBox(height: 10.0),
                            Text("Unduh dokumen ini ?",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:  MaterialStateProperty.all<Color>(ColorResources.ERROR)
                                  ),
                                  onPressed: () => Navigator.of(context).pop(), 
                                  child: Text("Tidak")
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      final status = await Permission.storage.request();
                                      if(status.isGranted) {
                                        String downloadDir = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
                                        String url = '${AppConstants.BASE_URL_IMG}${widget.medias[0].path}'; 
                                        await FlutterDownloader.enqueue(
                                          url: url, 
                                          savedDir: downloadDir,
                                          fileName: basename(widget.medias[0].path),
                                          openFileFromNotification: true,
                                          showNotification: true,
                                        );   
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
                                        Future.delayed(Duration(seconds: 1), () => Navigator.of(context).pop());
                                      } else {
                                        print("Permission denied");
                                      }
                                    } catch(e) {
                                      print(e);
                                    }
                                  },
                                  child: Text("Ya"),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  animationType: DialogTransitionType.scale,
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(seconds: 1),
                );       
              },
              color: ColorResources.WHITE,
              icon: Icon(Icons.arrow_circle_down),
            ),
          )
        ],
      )
    );
  }
}