import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/inbox.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';

enum InboxStatus { loading, loaded, error, empty}

class InboxProvider with ChangeNotifier {
  int readCount = 0;

  InboxStatus _inboxStatus = InboxStatus.loading;
  InboxStatus get inboxStatus => _inboxStatus;

  List<InboxModelData> _inboxes = [];
  List<InboxModelData> get inboxes => [..._inboxes];

  void setStateInboxStatus(InboxStatus inboxStatus) {
    _inboxStatus = inboxStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future getInboxes(BuildContext context, String type) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL}/data/inbox?type=$type");
      InboxModel inboxModel = InboxModel.fromJson(json.decode(res.data));
      _inboxes = [];
      _inboxes.addAll(inboxModel.body);
      readCount = _inboxes.where((el) => el.read == false).length;
      setStateInboxStatus(InboxStatus.loaded);
      if(_inboxes.isEmpty) {
        setStateInboxStatus(InboxStatus.empty);
      }
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      setStateInboxStatus(InboxStatus.error);
    } catch(e) {
      print(e);
      setStateInboxStatus(InboxStatus.error);
    }
  }

  Future updateInbox(BuildContext context, String inboxId, String type) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.put("${AppConstants.BASE_URL}/data/inbox/$inboxId", data: {
        "read": true
      });
      getInboxes(context, type);
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
    } catch(e) {
      print(e);
    }
  }

}