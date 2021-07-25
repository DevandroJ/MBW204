import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';

class PreviewImageScreen extends StatefulWidget {
  PreviewImageScreen({
    this.img
  });
  final String img;

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  @override
  initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: 'Image',
          child: CachedNetworkImage(
            imageUrl: widget.img,
            imageBuilder: (context, imageProvider) => PhotoView(
              initialScale: PhotoViewComputedScale.contained * 1.1,
              imageProvider: imageProvider,
            ),
            placeholder: (context, url) => Shimmer.fromColors(
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
      ),
    );
  }
}