import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/data/models/chat/list_chat.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/providers/chat.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

class ChatInput extends StatefulWidget {
  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  
  bool isSend = false;
  String val;
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
    Provider.of<ChatProvider>(context, listen: false).inputMsgController.addListener(() {
      if( Provider.of<ChatProvider>(context, listen: false).inputMsgController.text.trim().length >= 1) {
        setState(() => isSend = true); 
      } else {
        setState(() => isSend = false); 
      }
    });
  }

  @override 
  void dispose() {
    Provider.of<ChatProvider>(context, listen: false).inputMsgController.dispose();
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
                      onTap: () => Timer(Duration(milliseconds: 300),() => Provider.of<ChatProvider>(context, listen: false).scrollController.jumpTo(Provider.of<ChatProvider>(context, listen: false).scrollController.position.maxScrollExtent)),
                      onChanged: (_val) => setState(() => val = _val),
                      controller: Provider.of<ChatProvider>(context, listen: false).inputMsgController,
                      decoration: InputDecoration(
                        hintText: getTranslated("TYPE_MESSAGE", context),
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
                  if( Provider.of<ChatProvider>(context, listen: false).inputMsgController.text.trim() == "") {
                    return;
                  }
                  try {
                    Map<String, dynamic> basket = Provider.of(context, listen: false);
                    ListChatData listChatData = basket["listChatData"];
                    await Provider.of<ChatProvider>(context, listen: false).sendMessageToConversations(context, val, listChatData);
                  } catch(e) {
                    print(e);
                  }
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