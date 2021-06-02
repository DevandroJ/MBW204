import 'package:android_intent/android_intent.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:mbw204_club_ina/providers/location.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/providers/sos.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';
import 'package:mbw204_club_ina/views/screens/more/webview.dart';

class SosScreen extends StatefulWidget {
  final bool isBacButtonExist;
  SosScreen({this.isBacButtonExist = true});

  @override
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {

  Future checkGps() async {
    if(!(await Geolocator.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(context: context, builder: (BuildContext context) => AlertDialog(
          title: Text("Can't get your location now"),
          content: Text("Are you want to activate GPS"),
          actions: [
            TextButton(
              child: Text("Activate"),
                onPressed: () {
                  AndroidIntent intent = AndroidIntent(
                    action: "android.settings.LOCATION_SOURCE_SETTINGS"
                  );
                  intent.launch();
                  Navigator.of(context).pop();
                }
              )
            ],
          )
        );
      }
    }
  }

  Future gpsService() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      checkGps();
      return null;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<LocationProvider>(context, listen: false).getCurrentPosition(context);
    Provider.of<SosProvider>(context, listen: false).initSosList();

    submit(String type, String body) async {
      try {
        String userId = Provider.of<ProfileProvider>(context, listen: false).getUserId;
        String sender = Provider.of<ProfileProvider>(context, listen: false).getUserFullname;
        String phoneNumber = Provider.of<ProfileProvider>(context, listen: false).getUserPhoneNumber;
        String address = Provider.of<LocationProvider>(context, listen: false).getCurrentNameAddress; 
        double lat = Provider.of<LocationProvider>(context, listen: false).getCurrentLat;
        double long = Provider.of<LocationProvider>(context, listen: false).getCurrentLong;
        String geoPosition = "${lat.toString()} , ${long.toString()}"; 
        await Provider.of<SosProvider>(context, listen: false).insertSos(context, userId, geoPosition, type, body, address, sender, phoneNumber);
      } catch(e) {
        print(e);
      } 
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              
              CustomAppBar(title: getTranslated('PANIC_BUTTON', context), isBackButtonExist: false),

              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
                  child: ListView.builder(
                    itemCount: Provider.of<SosProvider>(context, listen: false).sosList.length,
                    itemBuilder: (BuildContext context, int i) {
                      
                      String name = Provider.of<SosProvider>(context, listen: false).sosList[i].name;
                      String desc = Provider.of<SosProvider>(context, listen: false).sosList[i].desc;
                      String icon = Provider.of<SosProvider>(context, listen: false).sosList[i].icon;
                      String type = Provider.of<SosProvider>(context, listen: false).sosList[i].type;

                      return Card(
                        elevation: 3.0,
                        child: ListTile(
                          onTap: i == 3 
                          ? () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(
                              title: getTranslated('MANUAL_GUIDE', context),
                              url: 'https://www.miniusa.com/owners/tools-support/owner-manuals.html',
                            )));
                          } 
                          : () => {
                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return Consumer<SosProvider>(
                                  builder: (BuildContext context, SosProvider sosProvider, Widget child) {
                                    return ClassicGeneralDialogWidget(
                                      titleText: 'Sebar Berita ?',
                                      contentText: 'Anda akan ditegur apabila menyalahgunakan SOS tanpa informasi yang benar',
                                      positiveText: sosProvider.sosConfirmStatus == SosConfirmStatus.loading ? '...' : 'Ya, Lakukan',
                                      negativeText: 'Tidak',
                                      onPositiveClick: () => submit(type, desc),
                                      onNegativeClick: () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                              },
                              animationType: DialogTransitionType.scale,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(seconds: 1),
                            )
                          },
                          isThreeLine: true,
                          dense: true,
                          leading: Image.asset(icon,
                            width: 32.0,
                            height: 32.0,
                          ),
                          title: Text(name),
                          subtitle: Text(desc),
                        ),
                      );
                    }
                  ),
                ),
              )

            ],
          ),
        ) 
      )
    );
  }
}