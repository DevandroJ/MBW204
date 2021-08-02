import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/data/models/chat/list_conversation.dart';
import 'package:mbw204_club_ina/views/screens/chat/input.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/providers/chat.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';

class ChatBody extends StatefulWidget {

  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Map<String, dynamic> basket = Provider.of(context, listen: false);
      Provider.of<ChatProvider>(context, listen: false).fetchListConversations(context, basket["conversationId"]);
    }); 
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider chatProvider, Widget child) {
        if(chatProvider.getListConversations == GetListConversations.loading) {
          return Loader(
            color: ColorResources.BTN_PRIMARY_SECOND,
          );
        }
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Consumer<ChatProvider>(
                  builder: (BuildContext context, ChatProvider chatProvider, Widget child) {
                    return RefreshIndicator(
                      onRefresh: () {
                        return Provider.of<ChatProvider>(context, listen: false).fetchListConversations(context, basket["conversationId"]);
                      },
                      backgroundColor: ColorResources.BTN_PRIMARY,
                      color: ColorResources.WHITE,
                      child: ListView.builder(
                        reverse: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: chatProvider.listConversationsData.length,
                        itemBuilder: (BuildContext context, int i) => Message(
                          message: chatProvider.listConversationsData[i]
                        ),
                      ),
                    );
                  },
                ),
              )
            ),
            ChatInput()
          ],
        );
      },
    );

  }
}

class Message extends StatelessWidget {
  const Message({
    Key key,
    @required this.message,
  }) : super(key: key);

  final ListConversationData message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: message.fromMe 
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
            child: Text(message.content.text,
              style: poppinsRegular,
            ),
          ),
        )
      ],
    );
  }
}