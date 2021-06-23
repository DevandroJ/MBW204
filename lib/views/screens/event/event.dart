import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/providers/event.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';

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
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: ColorResources.GRAY_LIGHT_PRIMARY,
        title: Text("Event",
          style: poppinsRegular.copyWith(
            color: ColorResources.BLACK,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
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
              margin: EdgeInsets.only(top: 30.0),
              child: Column(
                children: [

                  Consumer<EventProvider>(
                    builder: (BuildContext context, EventProvider eventProvider, Widget child) {
                      if(eventProvider.eventStatus == EventStatus.loading) 
                        return Expanded(
                          child: Loader(
                            color: ColorResources.BTN_PRIMARY_SECOND,
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
                          selectedColor: ColorResources.BTN_PRIMARY_SECOND,
                          todayColor: ColorResources.BTN_PRIMARY_SECOND.withOpacity(0.3),
                          markersColor: ColorResources.YELLOW_PRIMARY,
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
                            color: ColorResources.BTN_PRIMARY_SECOND,
                          ),
                        );
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: eventProvider.events.length,
                            itemBuilder: (BuildContext context, int  i) {

                              
                              
                              // return ListView.builder(
                              //   physics: NeverScrollableScrollPhysics(),
                              //   shrinkWrap: true,
                              //   itemCount: eventProvider.events[i].length,
                              //   itemBuilder: (BuildContext context, int z) { 


                                return Card(
                                  elevation: 0.3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorResources.BTN_PRIMARY_SECOND,
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
                                              height: 330.0,
                                              padding: EdgeInsets.all(8.0),
                                              child: SingleChildScrollView(
                                                child: Container(
                                                  margin: EdgeInsets.all(12.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl: "${AppConstants.BASE_URL_FEED_IMG}/${eventProvider.events[i][0]["path"].toString()}",
                                                        imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                                                          return Container(
                                                            width: double.infinity,
                                                            height: 200.0,
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                image: imageProvider
                                                              )
                                                            ),
                                                          );
                                                        },
                                                        placeholder: (BuildContext context, dynamic url) {
                                                          return Center(
                                                            child: SizedBox(
                                                              width: 18.0,
                                                              height: 18.0,
                                                              child: CircularProgressIndicator(),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      ListTile(
                                                        dense: true,
                                                        leading: Text("Description :",
                                                          style: poppinsRegular.copyWith(
                                                            fontSize: 12.0
                                                          )
                                                        ),
                                                        title: Text(eventProvider.events[i][0]["description"].toString(),
                                                          style: poppinsRegular.copyWith(
                                                            fontSize: 12.0
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 5.0),
                                                      ListTile(
                                                        dense: true,
                                                        leading: Text("Location :",
                                                          style: poppinsRegular.copyWith(  
                                                            fontSize: 12.0                                                       
                                                          )
                                                        ),
                                                        title: Text(eventProvider.events[i][0]["location"].toString(),
                                                          style: poppinsRegular.copyWith(
                                                            fontSize: 12.0
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Flexible(
                                                            child: ListTile(
                                                            dense: true,
                                                              leading: Text("Start :",
                                                                style: poppinsRegular.copyWith(
                                                                  fontSize: 12.0
                                                                )
                                                              ),
                                                              title: Text(eventProvider.events[i][0]["start"].toString(),
                                                                style: poppinsRegular.copyWith(
                                                                  fontSize: 12.0
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Text("-"),
                                                          Flexible(
                                                            child: ListTile(
                                                              dense: true,
                                                              leading: Text("End :",
                                                                style: poppinsRegular.copyWith(
                                                                  fontSize: 12.0
                                                                )
                                                              ),
                                                              title: Text(eventProvider.events[i][0]["end"].toString(),
                                                                style: poppinsRegular.copyWith(
                                                                  fontSize: 12.0
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
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
                                          Text(eventProvider.events[i][0]["description"].toString(),
                                           style: poppinsRegular.copyWith(
                                              color: ColorResources.getWhiteToBlack(context)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));


                              //   },
                              // );

                              
                            },
                          ),
                        )
                      );
                    },
                  )


                ],
              ),
            )
          ],
        ),
      )
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