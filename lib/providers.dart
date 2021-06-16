import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'container.dart' as c;

import 'package:mbw204_club_ina/providers/chat.dart';
import 'package:mbw204_club_ina/providers/nearmember.dart';
import 'package:mbw204_club_ina/providers/region.dart';
import 'package:mbw204_club_ina/providers/event.dart';
import 'package:mbw204_club_ina/providers/fcm.dart';
import 'package:mbw204_club_ina/providers/sos.dart';
import 'package:mbw204_club_ina/providers/news.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/providers/inbox.dart';
import 'package:mbw204_club_ina/providers/location.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/providers/banner.dart';
import 'package:mbw204_club_ina/providers/category.dart';
import 'package:mbw204_club_ina/providers/localization.dart';
import 'package:mbw204_club_ina/providers/onboarding.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/providers/splash.dart';
import 'package:mbw204_club_ina/providers/theme.dart';
import 'package:mbw204_club_ina/providers/media.dart';
import 'package:mbw204_club_ina/providers/checkin.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider(create: (_) => c.getIt<AuthProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<ChatProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<CategoryProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<SosProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<CheckInProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<EventProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<MediaProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<WarungProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<NewsProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<LocationProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<InboxProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<BannerProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<FcmProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<OnBoardingProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<ProfileProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<SplashProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<PPOBProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<NearMemberProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<RegionProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<LocalizationProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<ThemeProvider>()),
  
  Provider.value(value: Map<String, dynamic>())
];
