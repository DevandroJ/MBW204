import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/inbox.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/views/screens/inbox/detail.dart';

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: getTranslated('INBOX', context), isBackButtonExist: false),

            Consumer<InboxProvider>(
              builder: (BuildContext context, InboxProvider inboxProvider, Widget child) {
                if(inboxProvider.inboxStatus == InboxStatus.loading)
                  return Expanded(
                    child: Container(),
                  );
                if(inboxProvider.inboxStatus == InboxStatus.empty) 
                  return Expanded(
                    child: Center(
                      child: Text(getTranslated("NO_INBOX_AVAILABLE", context)),
                    ),
                  );
                
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
                    child: RefreshIndicator(
                      key: refreshIndicatorKey,
                      backgroundColor: ColorResources.getPrimaryToBlack(context),
                      color: ColorResources.getWhiteToBlack(context),
                      onRefresh: () {
                        return Provider.of<InboxProvider>(context, listen: false).getInboxes(context);    
                      },
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: inboxProvider.inboxes.length,
                        itemBuilder: (BuildContext context, int i) {

                          return Column(
                            children: [
                              Card(
                                elevation: 3.0,
                                child: Container(
                                  child: ListTile(
                                    onTap: () {
                                      Future.delayed(Duration.zero, () async {
                                        await Provider.of<InboxProvider>(context, listen: false).updateInbox(context, inboxProvider.inboxes[i].inboxId);
                                      });
                                      if(inboxProvider.inboxes[i].subject == "Emergency") {
                                        Provider.of<ProfileProvider>(context, listen: false).getSingleUser(context, inboxProvider.inboxes[i].senderId);

                                        showAnimatedDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                  
                                            return Dialog(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 330.0,
                                                  child: Consumer<ProfileProvider>(
                                                    builder: (BuildContext context, ProfileProvider profileProvider, Widget child) {
                                                      return Column(
                                                        children: [

                                                          SizedBox(height: 20.0),

                                                          Container(
                                                            child: profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                            ? SizedBox(
                                                                width: 18.0,
                                                                height: 18.0,
                                                                child: CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<Color>(ColorResources.getPrimaryToWhite(context)),
                                                                ),
                                                              )
                                                            : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                            ? CircleAvatar(
                                                                backgroundColor: Colors.transparent,
                                                                backgroundImage: NetworkImage("assets/images/profile.png"),
                                                                radius: 30.0,
                                                              )
                                                            : CachedNetworkImage(
                                                              imageUrl: "${AppConstants.BASE_URL_IMG}${profileProvider.getSingleUserProfilePic}",
                                                              imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                                                                return CircleAvatar(
                                                                  backgroundColor: Colors.transparent,
                                                                  backgroundImage: imageProvider,
                                                                  radius: 30.0,
                                                                );
                                                              },
                                                              errorWidget: (BuildContext context, String url, dynamic error) {
                                                                return CircleAvatar(
                                                                  backgroundColor: Colors.transparent,
                                                                  backgroundImage: AssetImage("assets/images/profile.png"),
                                                                  radius: 30.0,
                                                                );
                                                              },
                                                              placeholder: (BuildContext context, String text) => SizedBox(
                                                                width: 18.0,
                                                                height: 18.0,
                                                                child: CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<Color>(ColorResources.getPrimaryToWhite(context)),
                                                                ),
                                                              ),
                                                            )  
                                                          ),

                                                          SizedBox(height: 16.0),

                                                          Container(
                                                            width: double.infinity,
                                                            margin: EdgeInsets.only(left: 16.0, right: 16.0),
                                                            child: Card(
                                                              elevation: 3.0,
                                                              child: Padding(
                                                                padding: EdgeInsets.all(8.0),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text("Nama"),
                                                                        Text(profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                                        ? "..." 
                                                                        : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                                        ? "..." 
                                                                        : profileProvider.singleUserData.fullname)
                                                                      ]
                                                                    ),
                                                                    SizedBox(height: 12.0),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text("No HP"),
                                                                        Text(profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                                        ? "..." 
                                                                        : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                                        ? "..." 
                                                                        : profileProvider.singleUserData.phoneNumber)
                                                                      ]
                                                                    ),
                                                                  ],
                                                                )
                                                              ),
                                                            ),
                                                          ),

                                                          Container(
                                                            width: double.infinity,
                                                            margin: EdgeInsets.only(left: 16.0, right: 16.0),
                                                            child: Card(
                                                              elevation: 3.0,
                                                              child: Padding(
                                                                padding: EdgeInsets.all(8.0),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [

                                                                    Text(inboxProvider.inboxes[i].body,
                                                                      textAlign: TextAlign.justify,
                                                                      style: TextStyle(
                                                                        height: 1.4
                                                                      ),
                                                                    ),

                                                                    SizedBox(height: 10.0),

                                                                    FractionallySizedBox(
                                                                      widthFactor: 1.0,
                                                                      child: Container(
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            RaisedButton(
                                                                              elevation: 3.0,
                                                                              color: ColorResources.GREEN,
                                                                              onPressed: profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                                              ? () {} 
                                                                              : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                                              ? () {}
                                                                              : () async {
                                                                                try {
                                                                                  await launch("whatsapp://send?phone=${profileProvider.getSingleUserPhoneNumber}");
                                                                                } catch(e) {
                                                                                  print(e);
                                                                                }
                                                                              },
                                                                              child: Text(profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                                                ? "..."
                                                                                : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                                                ? "..."
                                                                                : "Whatsapp",
                                                                                style: TextStyle(
                                                                                  color: ColorResources.WHITE
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            RaisedButton(
                                                                              elevation: 3.0,
                                                                              color: ColorResources.BLUE,
                                                                              onPressed: profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                                              ? () {} 
                                                                              : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                                              ? () {}
                                                                              : () async {
                                                                                try {
                                                                                  await launch("tel:${profileProvider.getSingleUserPhoneNumber}");
                                                                                } catch(e) {
                                                                                  print(e);
                                                                                }
                                                                              },
                                                                              child: Text(profileProvider.singleUserDataStatus == SingleUserDataStatus.loading 
                                                                                ? "..."
                                                                                : profileProvider.singleUserDataStatus == SingleUserDataStatus.error 
                                                                                ? "..."
                                                                                : "Phone",
                                                                                style: TextStyle(
                                                                                  color: ColorResources.WHITE
                                                                                ),
                                                                              )
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                    
                                                                  
                                                                  ],
                                                                )
                                                              ),
                                                            ),
                                                          )
                                              
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                              
                                          },
                                          animationType: DialogTransitionType.scale,
                                          curve: Curves.fastOutSlowIn,
                                          duration: Duration(seconds: 1),
                                        );
                                      } else {
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => InboxDetailScreen(
                                            type: inboxProvider.inboxes[i].type,
                                            body: inboxProvider.inboxes[i].body,
                                            subject: inboxProvider.inboxes[i].subject,
                                            field1: inboxProvider.inboxes[i].field1,
                                            field2: inboxProvider.inboxes[i].field2,
                                            field5: inboxProvider.inboxes[i].field5,
                                            field6: inboxProvider.inboxes[i].field6
                                          )),
                                        );
                                      }
                                    },
                                    isThreeLine: true,
                                    dense: true,
                                    leading: Icon(
                                      inboxProvider.inboxStatus == InboxStatus.loading  
                                      ? Icons.label
                                      : inboxProvider.inboxStatus == InboxStatus.error 
                                      ? Icons.label
                                      : inboxProvider.inboxes[i].subject == "Emergency" 
                                      ? Icons.dangerous : Icons.phone_android,
                                      color: ColorResources.getPrimaryToWhite(context),
                                    ),
                                    trailing: Icon(
                                      inboxProvider.inboxStatus == InboxStatus.loading 
                                    ? Icons.mark_as_unread 
                                    : inboxProvider.inboxStatus == InboxStatus.error 
                                    ? Icons.mark_as_unread 
                                    : inboxProvider.inboxes[i].read 
                                    ? Icons.mark_chat_read 
                                    : Icons.mark_as_unread,
                                      color: ColorResources.getPrimaryToWhite(context),
                                    ),
                                    title: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5.0),
                                      child: Text(
                                        inboxProvider.inboxStatus == InboxStatus.loading 
                                      ? "..."
                                      : inboxProvider.inboxStatus == InboxStatus.error 
                                      ? "..." 
                                      : inboxProvider.inboxes[i].subject),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 2.0),
                                          child: Text(inboxProvider.inboxStatus == InboxStatus.loading 
                                          ? "..."
                                          : inboxProvider.inboxStatus == InboxStatus.error 
                                          ? "..."
                                          : inboxProvider.inboxes[i].body,
                                            overflow: inboxProvider.inboxes[i].subject == "Emergency" 
                                          ? TextOverflow.fade
                                          : TextOverflow.ellipsis,
                                            style: TextStyle(
                                              height: 1.6
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 6.0),
                                          child: Text(inboxProvider.inboxStatus == InboxStatus.loading 
                                          ? "..."
                                          : inboxProvider.inboxStatus == InboxStatus.error 
                                          ? "..."
                                          : DateFormat('dd MMM yyyy kk:mm').format(inboxProvider.inboxes[i].created.add(Duration(hours: 7))),
                                            style: TextStyle(
                                              fontSize: 11.0
                                            ),
                                          ),
                                        )
                                      ],
                                    ) 
                                  ),
                                ),
                              ),
                              Divider()
                            ]
                          );
                          
                        },
                      ),
                    ),
                  ),
                ); 
              },
            )

          ],
        ),
      ),
    );
  }
}