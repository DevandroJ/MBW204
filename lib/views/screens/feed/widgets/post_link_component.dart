import 'package:flutter/material.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:url_launcher/url_launcher.dart';

class PostLinkComponent extends StatelessWidget {
  final dynamic url;

  PostLinkComponent({
    this.url
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
      child: FlutterLinkPreview(
        url: url,
        bodyStyle: TextStyle(
          fontSize: 18.0,
        ),
        titleStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        builder: (info) {
          if (info is WebInfo) {
            return InkWell(
              onTap: () async => await launch(url),
              child: SizedBox(
                height: 350.0,
                child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  if(info.image != null)
                    Expanded(
                      child: Image.network(
                        info.image,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                      child: Text(
                      info.title,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if(info.description != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(info.description),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      if (info is WebImageInfo) {
        return InkWell(
          onTap: () async => await launch(url),
          child: SizedBox(
            height: 350.0,
            child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              info.image,
              fit: BoxFit.cover,
              width: double.maxFinite,
              ),
            ),
          ),
        );
      } else if (info is WebVideoInfo) {
      return InkWell(
        onTap: () async =>  await launch(url),
          child: SizedBox(
            height: 350.0,
            child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              info.image,
              fit: BoxFit.cover,
              width: double.maxFinite,
            )),
          ),
        );
      }
      return Loader(
        color: ColorResources.PRIMARY,
      );
      }),
    );
  }
}
