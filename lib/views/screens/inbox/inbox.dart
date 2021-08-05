import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/chat.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/chat/chat.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: ColorResources.GRAY_LIGHT_PRIMARY,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ColorResources.BLACK,  
          )
        ),
        title: Text("Chats",
          style: poppinsRegular.copyWith(
            color: ColorResources.BLACK,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Stack(
        children: [

          ClipPath(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 160.0,
              color: ColorResources.GRAY_LIGHT_PRIMARY
            ),
            clipper: CustomClipPath(),
          ),

          Container(
            margin: EdgeInsets.only(top: 20.0),
            alignment: Alignment.center,
            child: Container(
              height: 100.0,
              child: Image.asset(
                Images.wheel_btn
              ),
            ),
          ),

          Consumer<ChatProvider>(
            builder: (BuildContext context, ChatProvider chatProvider, Widget child) {
              if(chatProvider.listChatStatus == ListChatStatus.loading) {
                return Loader(
                  color: ColorResources.BTN_PRIMARY_SECOND,
                );
              } 
              if(chatProvider.listChatStatus == ListChatStatus.error) {
                return Center(
                  child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                    style: poppinsRegular,
                  )
                );
              }
              return Container(
                margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                child: RefreshIndicator(
                  backgroundColor: ColorResources.BTN_PRIMARY,
                  color: ColorResources.WHITE,
                  onRefresh: () => Provider.of<ChatProvider>(context, listen: false).fetchListChat(context),
                  child: ListView.builder(
                    itemCount: chatProvider.listChatData.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                        margin: EdgeInsets.only(top: i == 0 ? 0 : 15.0),
                        child: ListTile(
                          onTap: () { 
                            Map<String, dynamic> basket = Provider.of(context, listen: false);
                            basket.addAll({
                              "listChatData": chatProvider.listChatData[i]
                            }); 
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                          },
                          dense: true,
                          title: Text(chatProvider?.listChatData[i]?.displayName ?? "-",
                            softWrap: true,
                            style: poppinsRegular,
                          ),
                          trailing: chatProvider?.listChatData[i].group
                          ? SizedBox() 
                          : Text(DateFormat('dd MMM yyyy kk:mm').format(DateTime.parse(chatProvider.listChatData[i].updated).add(Duration(hours: 7))),
                            softWrap: true,
                            style: poppinsRegular.copyWith(
                              fontSize: 11.0
                            ),
                          ),
                          subtitle: Text(chatProvider?.listChatData[i]?.latestConversation?.content?.text ?? "",
                            softWrap: true,
                            style: poppinsRegular.copyWith(
                              fontSize: 13.0
                            ),
                          ),
                          leading: Container(
                            child: CachedNetworkImage(
                              imageUrl: "${AppConstants.BASE_URL_IMG}${chatProvider?.listChatData[i]?.profilePic?.path}",
                              imageBuilder: (BuildContext context, ImageProvider imageProvider) => CircleAvatar(
                                backgroundImage: imageProvider,
                                radius: 30.0,
                              ),
                              placeholder: (BuildContext context, String string) => Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorResources.BLACK,
                                    width: 0.5
                                  ),
                                  borderRadius: BorderRadius.circular(50.0)
                                ),
                                child: SvgPicture.asset('assets/images/svg/user.svg',
                                  width: 30.0,
                                  height: 30.0,
                                ),
                              ),
                              errorWidget: (BuildContext context, String url, dynamic error) {
                                return Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorResources.BLACK,
                                      width: 0.5
                                    ),
                                    borderRadius: BorderRadius.circular(50.0)
                                  ),
                                  child: SvgPicture.asset('assets/images/svg/user.svg',
                                    width: 30.0,
                                    height: 30.0,
                                  ),
                                );
                              },
                              filterQuality: FilterQuality.medium,
                            ),
                          ),
                        ),
                      );
                    }, 
                  ),
                ),
              );
            },
          )

        ],
      ),
     
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 140);
    path.quadraticBezierTo(size.width / 2, size.height, 
    size.width, size.height - 140);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}