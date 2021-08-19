import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:filesize/filesize.dart';
import 'package:readmore/readmore.dart';
import 'package:better_player/better_player.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/models/feed/feedmedia.dart';

class PostVideoComponent extends StatefulWidget {
  final FeedMedia media;
  final String caption;

  PostVideoComponent(
    this.media,
    this.caption
  );

  @override
  _PostVideoComponentState createState() => _PostVideoComponentState();
}

class _PostVideoComponentState extends State<PostVideoComponent> {
  BetterPlayerController betterPlayerController;
  BetterPlayerDataSource betterPlayerDataSource;
  BetterPlayerConfiguration betterPlayerConfiguration = BetterPlayerConfiguration(
    autoPlay: false,
    looping: false,
    fit: BoxFit.fitHeight,
    autoDispose: true,
    aspectRatio: 16 / 9,    
  );
  ReceivePort _port = ReceivePort();
  Uint8List bytes;
  bool download = false;
  String downloadText = "";
  String checkPath = "";
  int progress = 0;
  bool progressRun = false;

  Future downloadFile(String url) async {
    Dio dio = Dio();
    try {  
      // PermissionStatus status = await Permission.storage.status;
      // if(!status.isGranted) {
      //   await Permission.storage.request();
      // }
      String dir = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
      await dio.download(url, "$dir/${widget.media.path}", onReceiveProgress: (received, total) {
        setState(() {
          download = true;
          downloadText = ((received / total * 100).toStringAsFixed(0) + "%");
        });
      });
     
      ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS).then((dir) => {
        setState(() => checkPath = "$dir/${widget.media.path}"),
        betterPlayerDataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.file, checkPath),
          betterPlayerController = BetterPlayerController(
          betterPlayerConfiguration,
          betterPlayerDataSource: betterPlayerDataSource
        )
      });   

      setState(() { 
        download = false;
        downloadText = "Completed";
      });
    } catch (e) {
      print(e);
    }
  }

  static downloadingCallback(id, status, progress)  {
    SendPort send = IsolateNameServer.lookupPortByName("downloader_send_port");
    send.send([id, status, progress]);
  }

  void initState() {
    super.initState();
    bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadingCallback); 
    Platform.isIOS 
    ? getApplicationDocumentsDirectory().then((dir) {
        setState(() => checkPath = "$dir/${widget.media.path.split('/').last}");
        betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file, checkPath);
        betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: betterPlayerDataSource
      );
    }) 
    : ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS).then((dir) {
      setState(() => checkPath = "$dir/${widget.media.path.split('/').last}");
      betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file, checkPath);
        betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: betterPlayerDataSource
      );
    });
  }

  void dispose() {
    unbindBackgroundIsolate();
    super.dispose();
  }

  void bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      unbindBackgroundIsolate();
      bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic message) {
      DownloadTaskStatus _downloadingTaskStatus = message[1];
      int _progress = message[2];
      if(_downloadingTaskStatus == DownloadTaskStatus.running) {
        setState(() {
          progress = _progress;
          progressRun = true;
        });
      }
      if(_downloadingTaskStatus == DownloadTaskStatus.complete) {       
        Platform.isIOS 
        ? getApplicationDocumentsDirectory().then((dir) {
            setState(() {
              progressRun = false;
              checkPath = "$dir/${widget.media.path.split('/').last}";
            });
              betterPlayerDataSource = BetterPlayerDataSource(
              BetterPlayerDataSourceType.file, checkPath);
              betterPlayerController = BetterPlayerController(
              betterPlayerConfiguration,
              betterPlayerDataSource: betterPlayerDataSource
            );
          })
        : ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS).then((dir) {
          setState(() {
            progressRun = false;
            checkPath = "$dir/${widget.media.path.split('/').last}";
          });
          betterPlayerDataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.file, checkPath);
              betterPlayerController = BetterPlayerController(
              betterPlayerConfiguration,
              betterPlayerDataSource: betterPlayerDataSource
            );
          });
        }
    });
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 70.0),
            child: ReadMoreText(widget.caption,
              style: poppinsRegular.copyWith(
                fontSize: 9.0.sp,
              ),
              trimLines: 2,
              colorClickableText: Colors.black,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Tampilkan Lebih',
              trimExpandedText: 'Tutup',
              moreStyle: poppinsRegular.copyWith(
                fontSize: 9.0.sp,
                fontWeight: FontWeight.bold
              ),
              lessStyle: poppinsRegular.copyWith(
                fontSize: 9.0.sp, 
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: 12.0),
          io.File(checkPath).existsSync() && progressRun == false ? 
          Container(
            height: 185.0,
            child: BetterPlayer(
              controller: betterPlayerController,
            ) 
          ) : Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Container(
                height: 185.0,
                color: ColorResources.BG_GREY,
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: ClipOval(
                    child: Material(
                      color: ColorResources.PRIMARY,
                      child: InkWell(
                        splashColor: Colors.white, 
                        child: SizedBox(
                          width: 56.0,
                          height: 56.0, 
                          child: progressRun 
                          ? Loader(
                            color: ColorResources.WHITE,
                          )
                          : Icon(
                              Icons.download_rounded,
                              color: Colors.white
                            )
                          ),
                          onTap: () async {
                            print(widget.media.path);
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
                                        Text("Unduh video ini ?",
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
                                                  fontSize: 9.0.sp,
                                                ),
                                              )
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  final status = await Permission.storage.request();
                                                  if(status.isGranted) {
                                                    Directory documentsIos = await getApplicationDocumentsDirectory();
                                                    String saveDir = Platform.isIOS ? documentsIos.path : await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
                                                    String url = '${AppConstants.BASE_URL_IMG}${widget.media.path}'; 
                                                    await FlutterDownloader.enqueue(
                                                      url: url, 
                                                      savedDir: saveDir,
                                                      fileName: basename(widget.media.path),
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
                                                      duration: Duration(seconds: 2),
                                                    );
                                                    Navigator.of(context, rootNavigator: true).pop();
                                                    Navigator.of(context).pop();    
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
                        ),
                      ),
                    ),
                ),
              ),
              Positioned.fill( 
                left: 10.0,
                bottom: 10.0,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: ColorResources.PRIMARY,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0)
                      )
                    ),
                    child: Text(
                      filesize(widget.media.fileLength),
                      style: poppinsRegular.copyWith(
                        fontSize: 9.0.sp,
                        color: Colors.white
                      )
                    )
                  ) 
                ) 
              ),
              progressRun ? Positioned.fill(
                bottom: 10.0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: ColorResources.PRIMARY,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0)
                    )
                  ),
                  child: Text(progress.toString(),
                    style: poppinsRegular.copyWith(
                      fontSize: 9.0.sp,
                      color: ColorResources.WHITE
                      )
                    ) 
                  )
                ) 
              )  : Container(),
            ]
          ),
        ],
      ) ,
    );
  }
}
