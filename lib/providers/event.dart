import 'dart:collection';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:mbw204_club_ina/data/models/event.dart';
import 'package:mbw204_club_ina/data/models/event_search.dart';
import 'package:mbw204_club_ina/data/repository/event.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';

enum EventStatus { idle, loading, loaded, error, empty }
enum EventJoinStatus { idle, loading, loaded, error, empty }
enum EventSearchStatus { idle, loading, loaded, error, empty }
 
class EventProvider with ChangeNotifier {
  final EventRepo eventRepo;

  EventProvider({
    this.eventRepo
  });

  List _events = [];
  List get events => [..._events];
  Map<DateTime, List> createEvent = HashMap();

  EventStatus _eventStatus = EventStatus.loading;
  EventStatus get eventStatus => _eventStatus;

  EventSearchStatus _eventSearchStatus = EventSearchStatus.idle;
  EventSearchStatus get eventSearchStatus => _eventSearchStatus;

  EventJoinStatus _eventJoinStatus = EventJoinStatus.idle;
  EventJoinStatus get eventJoinStatus => _eventJoinStatus;
  
  List<EventData> _eventData = [];
  List<EventData> get eventData => [..._eventData];

  List<EventSearchData> _eventSearchData = [];
  List<EventSearchData> get eventSearchData => [..._eventSearchData];

  void setStateEventStatus(EventStatus eventStatus) {
    _eventStatus = eventStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateEventJoinStatus(EventJoinStatus eventJoinStatus) {
    _eventJoinStatus = eventJoinStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateEventSearchStatus(EventSearchStatus eventSearchStatus) {
    _eventSearchStatus = _eventSearchStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void getEvent(BuildContext context) async {
    try {
      setStateEventStatus(EventStatus.loading);
      List<EventData> eventData = await eventRepo.getEvent(context);
      if(eventData == null) {
        setStateEventStatus(EventStatus.empty);
      } else {
        _eventData.addAll(eventData);
        setStateEventStatus(EventStatus.loaded);
        for (int i = 0; i < _eventData.length; i++) {
          for (int z = 0; z < _eventData[i].arrayEventDate.length; z++) {
            createEvent[DateFormat("yyyy-MM-dd").parse(_eventData[i].arrayEventDate[z].toString())] = [
              [{
                "event_id": _eventData[i].eventId,
                "user_joined": _eventData[i].userJoined,
                "description": _eventData[i].description,
                "location": _eventData[i].location,
                "summary": _eventData[i].summary,
                "start": _eventData[i].start,
                "end": _eventData[i].end,
                "path": _eventData[i].path
              }]
            ];
            DateTime dateNow = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
            _events = createEvent[dateNow] ?? [];
          }
        }
      }
      if(_eventData.isEmpty) {
        setStateEventStatus(EventStatus.empty);
      }
    } on ServerErrorException catch(_) {
      setStateEventStatus(EventStatus.error);
    } catch(e) {
      print(e);
    }
  }

  void changeEvent(BuildContext context, List events) {
    _events = events;
    notifyListeners();
  }

  Future getEventSearch(BuildContext context, String query) async {
    try {
      setStateEventSearchStatus(EventSearchStatus.loading);
      List<EventSearchData> eventSearchData = await eventRepo.getEventSearchData(context, query);
      _eventSearchData = eventSearchData;
      setStateEventSearchStatus(EventSearchStatus.loaded);
      if(_eventSearchData.isEmpty) {
        setStateEventSearchStatus(EventSearchStatus.empty);
      }
    } catch(e) {
      setStateEventSearchStatus(EventSearchStatus.error);
      print(e);
    }
  }

  Future eventJoin(BuildContext context, int eventId) async {
    try {
      setStateEventJoinStatus(EventJoinStatus.loading);
      await eventRepo.joinEvent(context, eventId);
      Fluttertoast.showToast(
        msg: "Anda telah bergabung",
        toastLength: Toast.LENGTH_LONG,
      );
      getEvent(context);
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
      setStateEventJoinStatus(EventJoinStatus.loaded);
    } catch(e) {
      setStateEventJoinStatus(EventJoinStatus.error);
      print(e);
    }
  }

}