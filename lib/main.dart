import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mbw204_club_ina/providers/chat.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import 'localization/app_localization.dart';
import 'container.dart' as core;
import 'package:timeago/timeago.dart' as timeago;

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/providers/localization.dart';
import 'package:mbw204_club_ina/providers.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/views/screens/splash/splash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  timeago.setLocaleMessages('id', CustomLocalDate());
  await FlutterDownloader.initialize();
  await core.init();
  runApp(MultiProvider(
    providers: providers,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override 
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state); 
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    basket.addAll({
      "state": state
    });
    /* Lifecycle */
    // - Resumed (App in Foreground)
    // - Inactive (App Partially Visible - App not focused)
    // - Paused (App in Background)
    // - Detached (View Destroyed - App Closed)
    // if(state == AppLifecycleState.resumed) {
    //   print("==== RETURN BACK TO APP ====");
    // }
    // if(state == AppLifecycleState.paused) {
      Provider.of<ChatProvider>(context, listen: false).notifyChat(context);
    // }
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    AppConstants.languages.forEach((language) {
      locals.add(Locale(language.languageCode, language.countryCode));
    });
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return MaterialApp(
          title: 'MB W204 Club INA',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: ColorResources.BTN_PRIMARY,
            backgroundColor: ColorResources.BTN_PRIMARY
          ),
          locale: Provider.of<LocalizationProvider>(context).locale,
          localizationsDelegates: [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: locals,
          home: SplashScreen(),
        );         
      },
    );
  }
}
