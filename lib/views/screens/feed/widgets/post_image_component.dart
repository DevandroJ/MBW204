import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/helpers/show_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shimmer/shimmer.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/data/models/feed/feedmedia.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/preview_image.dart';

class PostImageComponent extends StatefulWidget {
  final List<FeedMedia> medias;
  final String caption;

  PostImageComponent(
    this.medias,
    this.caption
  );

  @override
  _PostImageComponentState createState() => _PostImageComponentState();
}

class _PostImageComponentState extends State<PostImageComponent> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    if(widget.medias.length > 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(height: 8.0),
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              onPageChanged: (int i, CarouselPageChangedReason reason) {
               setState(() => current = i);
              }
            ),
            items: widget.medias.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            PreviewImageScreen(
                              img: '${AppConstants.BASE_URL_IMG}${i.path}',
                            )
                          ));
                        },
                        onLongPress: () async {
                          showAnimatedDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (ctx) {
                              return Dialog(
                                child: Container(
                                height: 50.0,
                                padding: EdgeInsets.all(10.0),
                                margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                                child: StatefulBuilder(
                                  builder: (BuildContext c, Function s) {
                                  return ElevatedButton(
                                    onPressed: () async { 
                                      Directory documentsIos = await getApplicationDocumentsDirectory();
                                      String saveDir = Platform.isIOS ? documentsIos.path : await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
                                      String url = '${AppConstants.BASE_URL_IMG}${i.path}'; 
                                      await FlutterDownloader.enqueue(
                                        url: url, 
                                        savedDir: saveDir, 
                                        fileName: basename(i.path),
                                        openFileFromNotification: true,
                                        showNotification: true,
                                      ); 
                                      Navigator.of(context).pop();
                                      ShowSnackbar.snackbar(context, "Gambar telah disimpan pada $saveDir", "", ColorResources.SUCCESS);
                                    },
                                    child: Text("Unduh Gambar", 
                                      style: poppinsRegular.copyWith(
                                        fontSize: 9.0.sp
                                      ),
                                    ),                           
                                  );
                                })
                                )
                              );
                            },
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: "${AppConstants.BASE_URL_IMG}${i.path}",
                          imageBuilder: (context, imageProvider) => Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (BuildContext context, String url) => Shimmer.fromColors(
                            highlightColor: Colors.white,
                            baseColor: Colors.grey[200],
                            child: Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                              width: double.infinity,
                              height: 200.0,
                              color: Colors.grey
                            )  
                          ),
                        ),
                      )
                    ]
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.medias.map((i) {
              int index = widget.medias.indexOf(i);
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
          ),
        ]
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 250.0,
          margin: EdgeInsets.only(left: 70.0),
          child: ReadMoreText(widget.caption,
            style: poppinsRegular.copyWith(
              color: ColorResources.BLACK,
              fontSize: 9.0.sp
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
        SizedBox(height: 8.0),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PreviewImageScreen(
                img: '${AppConstants.BASE_URL_IMG}${widget.medias[0].path}',
              );
            }));
          },
          onLongPress: () {
            showAnimatedDialog(
              context: context,
              barrierDismissible: true,
              builder: (ctx) {
                return Dialog(
                  child: Container(
                  height: 50.0,
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                  child: StatefulBuilder(
                    builder: (BuildContext c, Function s) {
                    return ElevatedButton(
                      onPressed: () async { 
                        Directory documentsIos = await getApplicationDocumentsDirectory();
                        String saveDir = Platform.isIOS ? documentsIos.path : await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
                        String url = '${AppConstants.BASE_URL_IMG}${widget.medias[0].path}'; 
                        await FlutterDownloader.enqueue(
                          url: url, 
                          savedDir: saveDir, 
                          fileName: basename(widget.medias[0].path),
                          openFileFromNotification: true,
                          showNotification: true,
                        ); 
                        Navigator.of(context).pop();
                        ShowSnackbar.snackbar(context, "Gambar telah disimpan pada $saveDir", "", ColorResources.SUCCESS);
                      },
                      child: Text("Unduh Gambar", 
                        style: poppinsRegular.copyWith(
                          fontSize: 9.0.sp
                        ),
                      ),                           
                    );
                  })
                  )
                );
              },
            );
          },
          child: CachedNetworkImage(
            imageUrl: "${AppConstants.BASE_URL_IMG}${widget.medias[0].path}",
            imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
              width: double.infinity,
              height: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (BuildContext context, String url) => Shimmer.fromColors(
              highlightColor: Colors.white,
              baseColor: Colors.grey[200],
              child: Container(
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.all(0.0),
                width: double.infinity,
                height: 200.0,
                color: Colors.grey
              )  
            ),
          ),
        ),
      ]
    );
  }
}