import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import 'localization/app_localization.dart';
import 'container.dart' as core;
import 'package:timeago/timeago.dart' as timeago;

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

class MyApp extends StatelessWidget {
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
