import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
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
  InputPostComponent(
    this.groupId
  );
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
        style: TextStyle(
          color: ColorResources.PRIMARY,
          fontWeight: FontWeight.bold, 
        ),
      ),
      actions: [
        MaterialButton(
          child: Text("Kamera",
            style: TextStyle(
              color: Colors.black
            )
          ),
          onPressed: () => Navigator.pop(context, ImageSource.camera),
        ),
        MaterialButton(
          child: Text("Galeri",
            style: TextStyle(color: Colors.black),
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
        imageQuality: 60
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
        materialOptions: MaterialOptions(
          actionBarColor: "#8a8a96",
          statusBarColor: "#CFCFE1"
        )
      );
      resultList.forEach((imageAsset) async {
        String filePath = await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);
        File compressedFile = await FlutterNativeImage.compressImage(filePath,
          quality: 60, 
          percentage: 60
        );
        setState(() => files?.add(File(compressedFile?.path))); 
      });
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreatePostImageScreen(
        groupId: widget.groupId,
        files: files.length != 0 ? files : [],
      )));
    }
  }

  void postLink() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostLink()));
  }

  void uploadVid() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    for (int i = 0; i < result.files.length; i++) {
      if(result.files[i].size > 51200) {
        Fluttertoast.showToast(
          backgroundColor: ColorResources.ERROR,
          textColor: ColorResources.WHITE,
          fontSize: 14.0,
          msg: "Video terlalu besar, maksimal : 50 MB"
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
        if(result.files[i].size > 51200) {
          Fluttertoast.showToast(
            backgroundColor: ColorResources.ERROR,
            textColor: ColorResources.WHITE,
            fontSize: 14.0,
            msg: "Dokumen terlalu besar, maksimal : 50 MB"
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
                        child: Loader(
                          color: ColorResources.PRIMARY
                        ),
                        radius: 20.0,
                      ),
                      errorWidget: (BuildContext context, String url, dynamic error) => CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/images/profile.png'),
                        radius: 20.0,
                      )
                    );
                  }
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    focusNode: FocusNode(canRequestFocus: false),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      hintText: getTranslated("WRITE_POST", context)
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
