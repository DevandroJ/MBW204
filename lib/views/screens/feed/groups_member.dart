import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:mbw204_club_ina/container.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/utils/constant.dart';

class GroupsMemberScreen extends StatefulWidget {
  final String groupId;

  GroupsMemberScreen({this.groupId});

  @override
  _GroupsMemberScreenState createState() => _GroupsMemberScreenState();
}

class _GroupsMemberScreenState extends State<GroupsMemberScreen> {
  FeedState groupsState = getIt<FeedState>();

  void initState() {
    super.initState();
    (() async {
      await groupsState.fetchAllGroupsMember(widget.groupId);
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
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: Observer(builder: (_) {
              if (groupsState.groupsMemberStatus ==
                  GroupsMemberStatus.loading) {
                return Center(child: CupertinoActivityIndicator());
              }
              if (groupsState.groupsMemberStatus ==
                  GroupsMemberStatus.empty) {
                return Center(child: Text('Belum ada member'));
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                separatorBuilder: (BuildContext context, int i) {
                  return Divider();
                },
                itemCount: groupsState.groupsMemberList.length,
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                    title:
                        Text(groupsState.groupsMemberList[i].user.nickname),
                    subtitle: Text('Text'),
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage("${AppConstants.BASE_URL_IMG}${groupsState.groupsMemberList[i].user.profilePic.path}"),
                      radius: 20.0,
                    ),
                  );
                },
              );
            }
          )
        ),
      )
    );
  }
}
