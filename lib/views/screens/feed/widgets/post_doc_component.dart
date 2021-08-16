import 'dart:ui';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/data/models/feed/feedmedia.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';

class PostDocComponent extends StatefulWidget {
  final List<FeedMedia> medias;
  final String caption;
  final GlobalKey<ScaffoldMessengerState> globalKey;

  PostDocComponent({
    this.medias,
    this.caption,
    this.globalKey
  });

  @override
  _PostDocComponentState createState() => _PostDocComponentState();
}

class _PostDocComponentState extends State<PostDocComponent> {

  String type;
  Color color;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(widget.caption,
            style: poppinsRegular.copyWith(
              fontSize: 9.0.sp
            ),
          ),
        ),
        SizedBox(height: 12.0),
        Container(
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
                    style: poppinsRegular.copyWith(
                      fontSize: 9.0.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.WHITE
                    ),
                  ),
                )
              ),
              Expanded(
                child: Text(widget.medias[0].path.split('/').last,
                  style: poppinsRegular.copyWith(
                    fontSize: 9.0.sp,
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
                                  style: poppinsRegular.copyWith(
                                    fontSize: 10.0.sp,
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
                                      child: Text("Tidak",
                                        style: poppinsRegular.copyWith(
                                          fontSize: 9.0.sp
                                        ),
                                      )
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
                                            ScaffoldMessenger.of(widget.globalKey.currentContext).showSnackBar(
                                              SnackBar(
                                                backgroundColor: ColorResources.SUCCESS,
                                                content: Text("Berhasil mengunduh",
                                                  style: poppinsRegular.copyWith(
                                                    fontSize: 9.0.sp
                                                  ),
                                                )
                                              )
                                            );
                                            Navigator.of(context, rootNavigator: true).pop();
                                          } else {
                                            ScaffoldMessenger.of(widget.globalKey.currentContext).showSnackBar(
                                              SnackBar(
                                                backgroundColor: ColorResources.ERROR,
                                                content: Text("Akses tidak diizinkan",
                                                  style: poppinsRegular.copyWith(
                                                    fontSize: 9.0.sp
                                                  ),
                                                )
                                              )
                                            );
                                          }
                                        } catch(e) {
                                          print(e);
                                        }
                                      },
                                      child: Text("Ya",
                                        style: poppinsRegular.copyWith(
                                          fontSize: 9.0.sp
                                        ),
                                      ),
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
        )
      ],
    );
  
  }
}