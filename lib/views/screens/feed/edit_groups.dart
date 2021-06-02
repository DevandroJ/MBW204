import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hex/hex.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/data/repository/feed.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/screens/feed/feed_index.dart';

// import 'package:mbw204_club_ina/views/screens/feed/widgets/alert_component.dart';

class EditGroupScreen extends StatefulWidget {
  final String groupId;
  EditGroupScreen(this.groupId);
  @override
  _EditGroupsScreenState createState() => _EditGroupsScreenState();
}

class _EditGroupsScreenState extends State<EditGroupScreen> {
  FeedState groupsState = getIt<FeedState>();
  ScrollController scrollController = ScrollController();
  TextEditingController descController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  bool validateD = false;
  bool validateN = false;
  File fileBackground;
  String pathBackground;
  File fileProfile;
  String pathProfile;

  void changeBackground() async {
    ImageSource imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Select Image Source",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                MaterialButton(
                  child: Text("Camera",
                      style: TextStyle(color: ColorResources.PRIMARY)),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text(
                    "Gallery",
                    style: TextStyle(color: ColorResources.PRIMARY),
                  ),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));
    if (imageSource != null) {
      FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowCompression: true,
          allowedExtensions: ['jpeg', 'jpg', 'png', 'gif']);
      if (result != null) {
        if (result.files.single.size > 51200) {
          // alertComponent(context, 'Image too large, max : 50 MB',
          //     'There is something wrong', 'error');
          setState(() => fileBackground = null);
        }
        setState(() => fileBackground = File(result.files.single.path));
      }
    }
  }

  void changeProfile() async {
    ImageSource imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Select Image Source",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                MaterialButton(
                  child: Text("Camera",
                      style: TextStyle(color: ColorResources.PRIMARY)),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text(
                    "Gallery",
                    style: TextStyle(color: ColorResources.PRIMARY),
                  ),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));
    if (imageSource != null) {
      FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowCompression: true,
          allowedExtensions: ['jpeg', 'jpg', 'png', 'gif']);
      if (result != null) {
        if (result.files.single.size > 51200) {
          // alertComponent(context, 'Image too large, max : 50 MB',
          //     'There is something wrong', 'error');
          setState(() => fileProfile = null);
        }
        setState(() => fileProfile = File(result.files.single.path));
      }
    }
  }

  void cancelProfile() {
    setState(() => fileProfile = null);
  }

  void cancelBackground() {
    setState(() => fileBackground = null);
  }

  void initState() {
    super.initState();
    (() async {
      await groupsState.fetchGroup(widget.groupId);
    })();
    nameController =
        TextEditingController(text: groupsState.singleGroup.body.name);
    descController =
        TextEditingController(text: groupsState.singleGroup.body.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          if (groupsState.singleGroupStatus == SingleGroupStatus.loading) {
            return Center(
                child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(),
            ));
          }
          if (groupsState.singleGroupStatus == SingleGroupStatus.empty) {
            return Center(child: Text('Belum ada group'));
          }
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                brightness: Brightness.light,
                backgroundColor: Colors.white,
                title:
                    Text('Ubah Group', style: TextStyle(color: Colors.black)),
                leading: IconButton(
                  icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: isLoading
                      ? () {}
                      : () {
                          Navigator.of(context).pop();
                        },
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.only(right: 8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () async {
                                setState(() => isLoading = true);
                                try {
                                  if (descController.text.trim() == "") {
                                    setState(() => validateD = true);
                                    setState(() => isLoading = false);
                                    throw Error();
                                  } else {
                                    setState(() => validateD = false);
                                  }
                                  if (nameController.text.trim() == "") {
                                    setState(() => validateN = true);
                                    setState(() => isLoading = false);
                                    throw Error();
                                  } else {
                                    setState(() => validateN = false);
                                  }
                                  String bodyBackground =
                                      await FeedService.shared.getMediaKey();
                                  String bodyProfile =
                                      await FeedService.shared.getMediaKey();
                                  String desc = descController.text;
                                  String name = nameController.text;
                                  if (fileProfile?.path != null) {
                                    Uint8List bytesProfile =
                                        fileProfile.readAsBytesSync();
                                    String digestProfile =
                                        sha256.convert(bytesProfile).toString();
                                    String imageHashProfile = base64Url
                                        .encode(HEX.decode(digestProfile));
                                    await FeedService.shared.uploadMedia(
                                        bodyProfile,
                                        imageHashProfile,
                                        fileProfile);
                                  }
                                  if (fileBackground?.path != null) {
                                    Uint8List bytesBackground =
                                        fileBackground.readAsBytesSync();
                                    String digestBackground = sha256
                                        .convert(bytesBackground)
                                        .toString();
                                    String imageHashBackground = base64Url
                                        .encode(HEX.decode(digestBackground));
                                    await FeedService.shared.uploadMedia(
                                        bodyBackground,
                                        imageHashBackground,
                                        fileBackground);
                                  }
                                  final response =
                                      await groupsState.updateGroup(
                                          widget.groupId,
                                          desc,
                                          name,
                                          fileProfile,
                                          fileBackground);
                                  if (response.statusCode == 200) {
                                    setState(() => isLoading = false);
                                    // var alert = await alertComponent(context,
                                    //     'Group updated', 'Success', 'sucess');
                                    // alert.show();
                                    // Future.delayed(Duration(milliseconds: 1000),
                                    //     () {
                                    //   alert.dismiss();
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => FeedIndex(),
                                    //     ),
                                    //   );
                                    // });
                                  } else {
                                    setState(() => isLoading = false);
                                    // var alert = await alertComponent(
                                    //     context,
                                    //     'There is something wrong',
                                    //     'Failed',
                                    //     'error');
                                    // alert.show();
                                    Future.delayed(Duration(milliseconds: 1000),
                                        () {
                                      // alert.dismiss();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FeedIndex(),
                                        ),
                                      );
                                    });
                                  }
                                } catch (error) {
                                  print(error);
                                }
                              },
                              child: Container(
                                width: isLoading ? null : 100.0,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: isLoading
                                    ? SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ))
                                    : Text(
                                        'Update',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ))
                        ]),
                  )
                ],
                centerTitle: false,
                floating: true,
              ),
              SliverToBoxAdapter(
                  child: Stack(
                      overflow: Overflow.visible,
                      alignment: Alignment.center,
                      children: [
                    InkWell(
                        onTap: changeBackground,
                        child: fileBackground == null
                            ? Stack(
                                overflow: Overflow.visible,
                                alignment: Alignment.center,
                                children: [
                                    Container(
                                        height: 150.0,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.fitWidth,
                                                alignment: Alignment.center,
                                                image: groupsState
                                                            .singleGroup
                                                            .body
                                                            .background
                                                            ?.path ==
                                                        null
                                                    ? AssetImage('assets/logo.png')
                                                    : NetworkImage('${AppConstants.BASE_URL_IMG}${groupsState.singleGroup.body.background.path}')))),
                                    Positioned(
                                        child: IconButton(
                                            color: Colors.black,
                                            icon: Icon(Icons.camera_alt),
                                            onPressed: changeBackground))
                                  ])
                            : Stack(
                                overflow: Overflow.visible,
                                alignment: Alignment.center,
                                children: [
                                    Container(
                                        height: 150.0,
                                        child: Image.file(
                                          fileBackground,
                                          fit: BoxFit.fitWidth,
                                          alignment: Alignment.topCenter,
                                        )),
                                    Positioned(
                                        child: RawMaterialButton(
                                            elevation: 0.0,
                                            fillColor: Colors.red,
                                            child: Text(
                                              'X',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white),
                                            ),
                                            padding: EdgeInsets.all(8.0),
                                            shape: CircleBorder(),
                                            onPressed: cancelBackground))
                                  ])),
                    Positioned(
                      top: 20.0,
                      left: 20.0,
                      child: InkWell(
                        onTap: changeProfile,
                        child: Container(
                            child: fileProfile == null
                                ? Stack(
                                    overflow: Overflow.visible,
                                    alignment: Alignment.center,
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 48.0,
                                          backgroundImage: groupsState
                                                      .singleGroup
                                                      .body
                                                      .profilePic
                                                      ?.path ==
                                                  null
                                              ? AssetImage('assets/logo.png')
                                              : NetworkImage('${AppConstants.BASE_URL_IMG}${groupsState.singleGroup.body.profilePic.path}')),
                                      Positioned(
                                          child: IconButton(
                                              color: Colors.black,
                                              icon: Icon(Icons.camera_alt),
                                              onPressed: changeProfile))
                                    ],
                                  )
                                : Stack(
                                    overflow: Overflow.visible,
                                    alignment: Alignment.center,
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 48.0,
                                          child: Image.file(
                                            fileProfile,
                                            fit: BoxFit.cover,
                                          )),
                                      Positioned(
                                          child: RawMaterialButton(
                                              elevation: 0.0,
                                              fillColor: Colors.red,
                                              child: Text(
                                                'X',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white),
                                              ),
                                              padding: EdgeInsets.all(8.0),
                                              shape: CircleBorder(),
                                              onPressed: cancelProfile))
                                    ],
                                  )),
                      ),
                    )
                  ])),
              SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
                    child: TextField(
                      controller: nameController,
                      maxLines: 1,
                      decoration: InputDecoration(
                          errorText: validateN ? "Name required" : null,
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: "Name"),
                    )),
              ),
              SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
                    child: TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        errorText: validateD ? "Description required" : null,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.black)),
                        hintText: "Description",
                      ),
                    )),
              ),
            ],
          );
        },
      ),
    );
  }
}
