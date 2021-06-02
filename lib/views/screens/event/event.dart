import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/providers/event.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  CalendarController calendarController;

  @override
  void initState() {
    super.initState();
    calendarController = CalendarController();
  }

  @override 
  void dispose() {
    calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<EventProvider>(context, listen: false).getEvent(context);
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            
            CustomAppBar(title: getTranslated("EVENT", context), isBackButtonExist: true),

            Expanded(
              child: Column(
                children: [

                  Consumer<EventProvider>(
                    builder: (BuildContext context, EventProvider eventProvider, Widget child) {
                      if(eventProvider.eventStatus == EventStatus.loading) 
                        return Expanded(
                          child: Loader(
                            color: ColorResources.getPrimaryToWhite(context),
                          ),
                        );
                      return TableCalendar(
                        events: eventProvider.createEvent,
                        onDaySelected: (DateTime date, List events, List holidays) {
                          eventProvider.changeEvent(context, events);
                        },  
                        calendarController: calendarController,
                        onVisibleDaysChanged: (DateTime first, DateTime last, CalendarFormat format) {},
                        onCalendarCreated: (DateTime first, DateTime last, CalendarFormat format) {},
                        calendarStyle: CalendarStyle(
                          selectedColor: ColorResources.PRIMARY,
                          todayColor: ColorResources.PRIMARY.withOpacity(0.3),
                          markersColor: ColorResources.YELLOW,
                          outsideDaysVisible: false,
                        ),
                      );
                    },
                  ),

                  Consumer<EventProvider>(
                    builder: (BuildContext context, EventProvider eventProvider, Widget child) {
                      if(eventProvider.eventStatus == EventStatus.loading) 
                        return Expanded(
                          child: Loader(
                            color: ColorResources.getPrimaryToWhite(context),
                          ),
                        );
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                          child: ListView.builder(
                            itemCount: eventProvider.events.length,
                            itemBuilder: (BuildContext context, int  i) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: eventProvider.events[i].length - 1,
                                itemBuilder: (BuildContext context, int z) {  
                                return Card(
                                  elevation: 0.3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorResources.getPrimaryToWhite(context),
                                      borderRadius: BorderRadius.circular(5.0)
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        showAnimatedDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                          return Dialog(
                                            child: Container(
                                              height: 250.0,
                                              padding: EdgeInsets.all(8.0),
                                              child: Container(
                                                margin: EdgeInsets.all(12.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Description : "),
                                                    Text(eventProvider.events[i][z])
                                                  ],
                                                ),
                                              )
                                            ),
                                          );
                                        },
                                        animationType: DialogTransitionType.scale,
                                        curve: Curves.fastOutSlowIn,
                                        duration: Duration(seconds: 1),
                                      );
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(eventProvider.events[i][z],
                                           style: titilliumRegular.copyWith(
                                              color: ColorResources.getWhiteToBlack(context)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                                },
                              );
                            },
                          ),
                        )
                      );
                    },
                  )

                  

                ],
              )
            )

          ],
        ),
      )
    );
  }
}