import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/providers/chat.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

class ChatInput extends StatefulWidget {
  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController inputMsgController = TextEditingController();
  bool isSend = false;

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
                onPressed: () { 
                  
                },
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
                ? () { 
                  if(inputMsgController.text.trim() == "") {
                    return;
                  }
                  Provider.of<ChatProvider>(context, listen: false).sendMessage(inputMsgController.text);
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