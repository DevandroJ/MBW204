import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:ionicons/ionicons.dart';

import 'package:mbw204_club_ina/data/models/chat/list_conversation.dart';
import 'package:mbw204_club_ina/views/screens/chat/input.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/providers/chat.dart';
import 'package:mbw204_club_ina/data/models/chat/list_chat.dart';
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
      ListChatData listChatData = basket["listChatData"];
      Provider.of<ChatProvider>(context, listen: false).fetchListConversations(context, listChatData.id);
    }); 
  }

  @override
  Widget build(BuildContext context) {
   
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider chatProvider, Widget child) {
        if(chatProvider.listConversationsStatus == ListConversationsStatus.loading) {
          return Loader(
            color: ColorResources.BTN_PRIMARY_SECOND,
          );
        }
        List<ListConversationData> data = chatProvider.listConversationsData.reversed.toList();
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                child: Consumer<ChatProvider>(
                  builder: (BuildContext context, ChatProvider chatProvider, Widget child) {
                    Map<String, dynamic> basket = Provider.of(context, listen: false);
                    ListChatData listChatData = basket["listChatData"];
                    return RefreshIndicator(
                      onRefresh: () { 
                        return Future.delayed(Duration(seconds: 1), () {
                          Provider.of<ChatProvider>(context, listen: false).setStateListConversationsStatus(ListConversationsStatus.refetch);
                          Provider.of<ChatProvider>(context, listen: false).fetchListConversations(context, listChatData.id);
                        });
                      },
                      backgroundColor: ColorResources.BTN_PRIMARY,
                      color: ColorResources.WHITE,
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: Provider.of<ChatProvider>(context, listen: false).scrollController,
                        itemCount: data.length + 1,
                        itemBuilder: (BuildContext context, int i) {
                          if(i == data.length) {
                            return Container(
                              height: 70.0,
                            );
                          }
                          return Message(
                            chatProvider: chatProvider,
                            message: data[i],
                            key: ValueKey(data[i].id),
                          );   
                        }
                      ),
                    );
                  },
                ),
              ),
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
    @required this.chatProvider,
    @required this.message,
  }) : super(key: key);

  final ListConversationData message;
  final ChatProvider chatProvider;

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
            child: Text(message.content.text ?? "",
              style: poppinsRegular,
            ),
          ),
        ),
        SizedBox(width: 8.0),
        Container(
          margin: EdgeInsets.only(top: 12.0),
          child: InkWell(
            onTap: message.messageStatus == "UNDELIVERED" ? () {
              showAnimatedDialog(
                context: context, 
                builder: (BuildContext context) {
                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 150.0,
                      child: Dialog(
                        child: Container(
                          margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Text("Message not sent, Retry ?",
                                style: poppinsRegular.copyWith(
                                  fontSize: 16.0
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(), 
                                    child: Text("Cancel",
                                      style: poppinsRegular.copyWith(
                                        color: ColorResources.ERROR
                                      ),
                                    )
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context, rootNavigator: true).pop();
                                      Map<String, dynamic> basket = Provider.of(context, listen: false);
                                      await Provider.of<ChatProvider>(context, listen: false).sendMessageToConversations(context, Provider.of<ChatProvider>(context, listen: false).inputMsgController.text, basket["listChatData"]);
                                    }, 
                                    child: Text("Ok",
                                      style: poppinsRegular.copyWith(
                                        color: ColorResources.SUCCESS
                                      ),
                                    )
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ); 
                }
              );
            } : null,
            child: message.fromMe 
            ? Container()
            : Icon(
              message.messageStatus == "UNDELIVERED"
              ? Icons.error 
              : message.messageStatus == "SENT" 
              ? Ionicons.hourglass_outline 
              : message.messageStatus == "READ" 
              ? Ionicons.checkmark_done
              : message.messageStatus == "DELIVERED" 
              ? Ionicons.checkmark
              : null, 
              color: message.messageStatus == "UNDELIVERED" 
              ? ColorResources.ERROR 
              : message.messageStatus == "SENT" || message.messageStatus == "DELIVERED"
              ? ColorResources.BLACK 
              : message.messageStatus == "READ" 
              ? ColorResources.SUCCESS 
              : null,
              size: 20.0,
            ),
          ),
        )
      ],
    );
  }
}