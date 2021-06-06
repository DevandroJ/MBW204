import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/screens/inbox/inbox.dart';

class ChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Agam",
          style: poppinsRegular.copyWith(
            color: ColorResources.BLACK
          ),
        ),
        elevation: 0.0,
        backgroundColor: ColorResources.GRAY_LIGHT_PRIMARY,
        leading: InkWell(
          child:  Icon(
            Icons.arrow_back,
            color: ColorResources.BLACK,
          ),
            onTap: () =>  Navigator.push(context,  MaterialPageRoute(builder: (context) => InboxScreen()),
          )
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: true 
                    ? MainAxisAlignment.start  
                    : MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: true 
                          ? Colors.grey[300] 
                          : Theme.of(context).accentColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                            bottomLeft: !true ? Radius.circular(12.0) : Radius.circular(0),
                            bottomRight: true ? Radius.circular(12.0) : Radius.circular(0),
                          ),
                        ),
                        // width: 120.0,
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 8.0,
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: true 
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                              children: [
                                Text("Arif",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: true
                                    ? Colors.black
                                    : Theme.of(context).accentTextTheme.headline6.color,
                                  ),
                                ),
                                Container(
                                  width: "halo semuanya".length >= 50 ? 300.0 : null,
                                  margin: EdgeInsets.only(top: 4.0),
                                  child: Text("halo semuanya",
                                    style: TextStyle(
                                      color: true
                                      ? Colors.black
                                      : Theme.of(context).accentTextTheme.headline6.color,
                                      height: 1.7
                                    ),
                                    textAlign: true 
                                    ? TextAlign.end
                                    : TextAlign.start,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  child: Text("2021-12-02",
                                    style: TextStyle(
                                      color: true
                                      ? Colors.black
                                      : Theme.of(context).accentTextTheme.headline6.color
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      ),
                    ],
                  ),

                  Positioned(
                    top: 0.0,
                    right: true ? null : 0.0,
                    left: true ? 0.0 : null,
                    child: CachedNetworkImage(
                      imageUrl: "https://akcdn.detik.net.id/community/media/visual/2021/05/29/aksi-panggung-abdee-slank_169.jpeg?w=700&q=90",
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: imageProvider,
                          radius: 15.0,
                        );
                      },
                      errorWidget: (context, url, error) {
                        return CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/images/avatar.png'),
                          radius: 15.0,
                        );
                      },
                    )
                  )
              
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 8.0, right: 8.0),
                padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 8.0, right: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(
                        Icons.image
                      ),
                      onPressed: () {}
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) => {},
                      ),
                    ),
                    IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(
                        Icons.send,
                      ),
                      onPressed: () {}
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
      
    


    );
  }
}