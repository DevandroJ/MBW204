import 'dart:collection';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/event.dart';
import 'package:mbw204_club_ina/data/repository/event.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';

enum EventStatus { idle, loading, loaded, error, empty }
enum EventJoinStatus { idle, loading, loaded, error, empty }

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

  EventJoinStatus _eventJoinStatus = EventJoinStatus.idle;
  EventJoinStatus get eventJoinStatus => _eventJoinStatus;
  
  List<EventData> _eventData = [];
  List<EventData> get eventData => [..._eventData];

  void setStateEventStatus(EventStatus eventStatus) {
    _eventStatus = eventStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateEventJoinStatus(EventJoinStatus eventJoinStatus) {
    _eventJoinStatus = eventJoinStatus;
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
          createEvent[DateFormat("yyyy-MM-dd").parse(_eventData[i].eventDate.toString())] = [
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