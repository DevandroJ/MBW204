import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/data/models/chat_message.dart';
import 'package:mbw204_club_ina/providers/chat.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/screens/chat/input.dart';

class ChatBody extends StatefulWidget {

  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Consumer<ChatProvider>(
              builder: (BuildContext context, ChatProvider chatProvider, Widget child) {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: chatProvider.chatMessage.length,
                  itemBuilder: (BuildContext context, int i) => Message(
                    message: chatProvider.chatMessage[i]
                  ),
                );
              },
            ),
          )
        ),
        ChatInput()
      ],
    );
  }
}

class Message extends StatelessWidget {
  const Message({
    Key key,
    @required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: message.isSender 
      ? MainAxisAlignment.start 
      : MainAxisAlignment.end,
      children: [       
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Container(
            margin: EdgeInsets.only(top: 15.0),
            padding: EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 15.0
            ),
            decoration: BoxDecoration(
              color: ColorResources.GRAY_LIGHT_PRIMARY,
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: Text(message.text,
              style: poppinsRegular,
            ),
          ),
        )
      ],
    );
  }
}