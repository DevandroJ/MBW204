import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/images.dart';
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
        title: Text("Message",
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

          Column(
            children: [

              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                        margin: EdgeInsets.only(top: i == 0 ? 0 : 15.0),
                        child: ListTile(
                          onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen())),
                          dense: true,
                          title: Text("FSHN Boutique",
                            softWrap: true,
                            style: poppinsRegular,
                          ),
                          trailing: Text("8:12 AM",
                            softWrap: true,
                            style: poppinsRegular.copyWith(
                              fontSize: 11.0
                            ),
                          ),
                          subtitle: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit…...",
                            softWrap: true,
                            style: poppinsRegular.copyWith(
                              fontSize: 13.0
                            ),
                          ),
                          leading: Container(
                            child: CachedNetworkImage(
                              imageUrl: "https://cdn0-production-images-kly.akamaized.net/0r0vo4waPk9g2ZOtSePxceTuoyE=/640x480/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/706185/original/Daniel-Radcliffe-140710.gif",
                              imageBuilder: (BuildContext context, ImageProvider imageProvider) => CircleAvatar(
                                backgroundImage: imageProvider,
                                radius: 30.0,
                              ),
                              placeholder: (context, string) => SizedBox(
                                width: 18.0,
                                height: 18.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(ColorResources.BTN_PRIMARY),
                                ),
                              ),
                              filterQuality: FilterQuality.medium,
                            ),
                          ),
                        ),
                      );
                    }, 
                  ),
                ),
              )

            ],
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