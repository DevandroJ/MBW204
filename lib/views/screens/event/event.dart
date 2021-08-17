import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:mbw204_club_ina/data/models/event.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
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
            fontSize: 10.0.sp
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
                              EventData eventData = eventProvider.events[i];
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
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl: "${AppConstants.BASE_URL_FEED_IMG}/${eventData.path}",
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
                                                      leading: Text("Deskripsi :",
                                                        style: poppinsRegular.copyWith(
                                                          fontSize: 9.0.sp
                                                        )
                                                      ),
                                                      title: Text(eventData.description,
                                                        style: poppinsRegular.copyWith(
                                                          fontSize: 9.0.sp
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.0),
                                                    ListTile(
                                                      dense: true,
                                                      leading: Text("Lokasi :",
                                                        style: poppinsRegular.copyWith(  
                                                          fontSize: 9.0.sp                                                       
                                                        )
                                                      ),
                                                      title: Text(eventData.location,
                                                        style: poppinsRegular.copyWith(
                                                          fontSize: 9.0.sp
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Flexible(
                                                          child: ListTile(
                                                          dense: true,
                                                            leading: Text("Mulai :",
                                                              style: poppinsRegular.copyWith(
                                                                fontSize: 9.0.sp
                                                              )
                                                            ),
                                                            title: Text(eventData.start,
                                                              style: poppinsRegular.copyWith(
                                                                fontSize: 9.0.sp
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: ListTile(
                                                            dense: true,
                                                            leading: Text("Selesai :",
                                                              style: poppinsRegular.copyWith(
                                                                fontSize: 9.0.sp
                                                              )
                                                            ),
                                                            title: Text(eventData.end,
                                                              style: poppinsRegular.copyWith(
                                                                fontSize: 9.0.sp
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Consumer<EventProvider>(
                                                      builder: (BuildContext context, EventProvider eventProvider, Widget child) {
                                                        return Container(
                                                          width: double.infinity,
                                                          child: eventData.userJoined 
                                                          ? TextButton(
                                                            style: TextButton.styleFrom(
                                                              backgroundColor: ColorResources.DIM_GRAY
                                                            ),
                                                            onPressed: null,
                                                            child: Text("Anda telah bergabung",
                                                              style: poppinsRegular.copyWith(
                                                                color: ColorResources.WHITE,
                                                                fontSize: 9.0.sp
                                                              ),
                                                            ),                            
                                                          )
                                                          : TextButton(
                                                            style: TextButton.styleFrom(
                                                              backgroundColor: ColorResources.BTN_PRIMARY_SECOND
                                                            ),
                                                            onPressed: () async => await eventProvider.eventJoin(context, eventProvider.events[i][0]["event_id"]),
                                                            child: eventProvider.eventJoinStatus == EventJoinStatus.loading 
                                                            ? Loader(
                                                                color: ColorResources.YELLOW_PRIMARY,
                                                              ) 
                                                            : Text(getTranslated("JOIN", context),
                                                              style: poppinsRegular.copyWith(
                                                                color: ColorResources.WHITE,
                                                                fontSize: 9.0.sp
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
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
                                        Text(eventData.description,
                                          style: poppinsRegular.copyWith(
                                            color: ColorResources.WHITE,
                                            fontSize: 9.0.sp
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                              
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