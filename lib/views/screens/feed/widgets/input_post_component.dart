import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/create_post_link.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/create_post_doc.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/create_post_image.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/create_post_image_camera.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/create_post_text.dart';
import 'package:mbw204_club_ina/views/screens/feed/widgets/create_post_video.dart';

class InputPostComponent extends StatefulWidget {
  final String groupId;
  final GlobalKey<ScaffoldMessengerState> globalKey;
  InputPostComponent({
    this.groupId,
    this.globalKey
  });
  @override
  _InputPostComponentState createState() => _InputPostComponentState();
}

class _InputPostComponentState extends State<InputPostComponent> {
  ImageSource imageSource;
  List<Asset> images = [];
  List<Asset> resultList = [];
  List<File> files = [];

  void uploadPic() async {
    imageSource = await showDialog<ImageSource>(context: context, builder: (context) => 
      AlertDialog(
        title: Text("Pilih Sumber Gambar",
        style: poppinsRegular.copyWith(
          fontSize: 10.0.sp,
          color: ColorResources.PRIMARY,
          fontWeight: FontWeight.bold, 
        ),
      ),
      actions: [
        MaterialButton(
          child: Text("Kamera",
            style: poppinsRegular.copyWith(
              fontSize: 9.0.sp,
              color: ColorResources.BLACK
            )
          ),
          onPressed: () => Navigator.pop(context, ImageSource.camera),
        ),
        MaterialButton(
          child: Text("Galeri",
            style: poppinsRegular.copyWith(
              fontSize: 9.0.sp,
              color: ColorResources.BLACK
            ),
          ),
          onPressed: () => Navigator.pop(context, ImageSource.gallery)
          )
        ],
      )
    );
    if(imageSource == ImageSource.camera) {
      PickedFile pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxHeight: 480.0, 
        maxWidth: 640.0,
        imageQuality: 70
      );
      if(pickedFile != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
          CreatePostImageCameraScreen(
            pickedFile
          )),
        ); 
      }
    }
    if(imageSource == ImageSource.gallery) {
      files = [];
      resultList = await MultiImagePicker.pickImages(
        maxImages: 8,
        enableCamera: false, 
        selectedAssets: images,
      );
      resultList.forEach((imageAsset) async {
        String filePath = await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);
        File compressedFile = await FlutterNativeImage.compressImage(filePath,
          quality: 70, 
          percentage: 70
        );
        setState(() => files?.add(File(compressedFile?.path))); 
      });
      Future.delayed(Duration(seconds: 1),() {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreatePostImageScreen(
          groupId: widget.groupId,
          files: files,
        )));
      });
    }
  }

  void postLink() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostLink()));
  }

  Future uploadVid() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    for (int i = 0; i < result.files.length; i++) {
      print(result.files[i].size);
      if(result.files[i].size > 50000000) {
        ScaffoldMessenger.of(widget.globalKey.currentContext).showSnackBar(
          SnackBar(
            backgroundColor: ColorResources.ERROR,
            content: Text("Maksimal 50 MB",
              style: poppinsRegular,
            )
          )
        );
        return;
      } 
    }
    File file = File(result.files.single.path);
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
      CreatePostVideoScreen(
        groupId: widget.groupId,
        file: file
      )
    ));        
  }

   void uploadDoc() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf","doc","docx","xls","xlsx","ppt","ppt","pptx","txt"],
      allowCompression: true,
    );
    if(result != null) {
      for (int i = 0; i < result.files.length; i++) {
        if(result.files[i].size > 50000000) {
          ScaffoldMessenger.of(widget.globalKey.currentContext).showSnackBar(
            SnackBar(
              backgroundColor: ColorResources.ERROR,
              content: Text("Maksimal 50 MB",
                style: poppinsRegular,
              )
            )
          );
          return;
        } 
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
        CreatePostDocScreen(
          groupId: widget.groupId,
          files: result
        ),
      ));     
    }
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<ProfileProvider>(context, listen: false).getUserProfile(context);

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
        child: Column(
          children: [
            Row(
              children: [ 
                Consumer<ProfileProvider>(
                  builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                    return CachedNetworkImage(
                    imageUrl: "${AppConstants.BASE_URL_IMG}${profileProvider.getUserProfilePic}",
                      imageBuilder: (BuildContext context, imageProvider) => CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: imageProvider,
                        radius: 20.0,
                      ),
                      placeholder: (BuildContext context, String url) => CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                        radius: 20.0,
                      ),
                      errorWidget: (BuildContext context, String url, dynamic error) => CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                        radius: 20.0,
                      )
                    );
                  }
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      hintText: "Tulis post",
                    ),
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute( builder: (context) =>
                          CreatePostText(
                            groupId: widget.groupId
                          )
                        ),
                      );
                    },
                  ),
                )
              ]
            ),
            Container(
              height: 56.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: uploadPic,
                    icon: Icon(
                      Icons.image,
                      color: ColorResources.BTN_PRIMARY
                    ),
                  ),
                  IconButton(
                    onPressed: uploadVid,
                    icon: Icon(
                      Icons.video_call,
                      color: ColorResources.BTN_PRIMARY,
                    ),
                  ),
                  IconButton(
                    onPressed: postLink, 
                    icon: Icon(
                      Icons.attach_file,
                      color: ColorResources.BTN_PRIMARY,
                    ),
                    
                  ),
                  IconButton(
                    onPressed: uploadDoc,
                    icon: Icon(
                      Icons.picture_as_pdf,
                      color: ColorResources.BTN_PRIMARY,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}