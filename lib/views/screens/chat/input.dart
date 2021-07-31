import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/providers/chat.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

class ChatInput extends StatefulWidget {
  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController inputMsgController = TextEditingController();
  bool isSend = false;
  File _file;

  void pickImage() async {
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pilih sumber gambar",
          style: poppinsRegular.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.teal
          ),
        ),
        actions: [
          MaterialButton(
            child: Text(
              "Camera",
              style: TextStyle(color: ColorResources.PRIMARY),
            ),
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
      )
    );

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource, maxHeight: 720);
      if (file != null) {
        setState(() => _file = file);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    inputMsgController.addListener(() {
      if(inputMsgController.text.trim().length >= 1) {
        setState(() => isSend = true); 
      } else {
        setState(() => isSend = false); 
      }
    });
  }

  @override 
  void dispose() {
    inputMsgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 12 / 2
      ),
      decoration: BoxDecoration(
        color: ColorResources.GRAY_LIGHT_PRIMARY,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32.0,
            color: ColorResources.BLACK.withOpacity(0.2)
          )
        ]
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              child: IconButton(
                onPressed: () => pickImage(),
                icon: Icon(
                  Icons.image,
                  size: 20.0,
                ),
              ),
            ),
            Expanded(
              child: Container(
              height: 50.0, 
              decoration: BoxDecoration(
                color: ColorResources.WHITE,
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Row(
                children: [
                  SizedBox(width: 20.0),
                  Expanded(
                    child: TextField(
                      controller: inputMsgController,
                      decoration: InputDecoration(
                        hintText: "Type Message",
                        border: InputBorder.none
                      ),
                    )
                  ),
                ]),
              )
            ),
            Container(
              child: IconButton(
                onPressed: isSend 
                ? () async { 
                    if(inputMsgController.text.trim() == "") {
                      return;
                    }
                    try {
                      await Provider.of<ChatProvider>(context, listen: false).sendMessageToConversations(context);
                    } catch(e) {
                      print(e);
                    }
                    inputMsgController.text = "";
                  } 
                : null,
                  icon: Icon(
                    Icons.send,
                    size: 20.0,
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}