import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/constant.dart';

class AllMemberScreen extends StatefulWidget {
  @override
  _AllMemberScreenState createState() => _AllMemberScreenState();
}

class _AllMemberScreenState extends State<AllMemberScreen> {
  FeedState groupsState = getIt<FeedState>();

  void initState() {
    super.initState();
    (() async {
      await groupsState.fetchAllMember();
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text('All Member', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          // actions: [
          //   // IconButton(
          //   //   color: Colors.black,
          //   //   onPressed: () {},
          //   //   icon: Icon(Icons.search),
          //   // )
          // ],
        ),
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: Observer(builder: (_) {
                if (groupsState.allMemberStatus == AllMemberStatus.empty) {
                  return Center(child: Text('There is no members yet'));
                }
                if (groupsState.allMemberStatus == AllMemberStatus.loading) {
                  return Center(child: CupertinoActivityIndicator());
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: (BuildContext context, int i) {
                    return Divider();
                  },
                  itemCount: groupsState.allMemberList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      title: Text(groupsState.allMemberList[i].nickname),
                      subtitle: Text('Text'),
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage("${AppConstants.BASE_URL_IMG}${groupsState.allMemberList[i].profilePic.path}"),
                        radius: 20.0,
                      ),
                    );
                  },
                );
              })),
        ));
  }
}
