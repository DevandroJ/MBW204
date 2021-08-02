import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/data/repository/chat.dart';
import 'package:mbw204_club_ina/data/repository/history_activity.dart';
import 'package:mbw204_club_ina/providers/history_activity.dart';
import 'package:mbw204_club_ina/mobx/feed.dart';
import 'package:mbw204_club_ina/providers/chat.dart';
import 'package:mbw204_club_ina/providers/region.dart';
import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/providers/sos.dart';
import 'package:mbw204_club_ina/providers/fcm.dart';
import 'package:mbw204_club_ina/providers/location.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/providers/banner.dart';
import 'package:mbw204_club_ina/providers/category.dart';
import 'package:mbw204_club_ina/providers/checkin.dart';
import 'package:mbw204_club_ina/providers/localization.dart';
import 'package:mbw204_club_ina/providers/news.dart';
import 'package:mbw204_club_ina/providers/onboarding.dart';
import 'package:mbw204_club_ina/providers/profile.dart';
import 'package:mbw204_club_ina/providers/splash.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/providers/inbox.dart';
import 'package:mbw204_club_ina/providers/media.dart';
import 'package:mbw204_club_ina/providers/event.dart';
import 'package:mbw204_club_ina/providers/nearmember.dart';

import 'package:mbw204_club_ina/data/repository/nearmember.dart';
import 'package:mbw204_club_ina/data/repository/event.dart';
import 'package:mbw204_club_ina/data/repository/media.dart';
import 'package:mbw204_club_ina/data/repository/checkin.dart';
import 'package:mbw204_club_ina/data/repository/sos.dart';
import 'package:mbw204_club_ina/data/repository/auth.dart';
import 'package:mbw204_club_ina/data/repository/banner.dart';
import 'package:mbw204_club_ina/data/repository/category.dart';
import 'package:mbw204_club_ina/data/repository/notification.dart';
import 'package:mbw204_club_ina/data/repository/onboarding.dart';
import 'package:mbw204_club_ina/data/repository/profile.dart';
import 'package:mbw204_club_ina/data/repository/splash.dart';

final getIt = GetIt.instance;
GlobalKey<NavigatorState> navigator;

Future<void> init() async {
  getIt.registerSingleton(() => navigator);

  // MobX
  getIt.registerSingleton<FeedState>(FeedState());

  // Api
  getIt.registerLazySingleton(() => AuthRepo(sharedPreferences: getIt()));
  getIt.registerLazySingleton(() => CheckInRepo(sharedPreferences: getIt()));
  getIt.registerLazySingleton(() => CategoryRepo());
  getIt.registerLazySingleton(() => SosRepo());
  getIt.registerLazySingleton(() => BannerRepo());
  getIt.registerLazySingleton(() => NearMemberRepo(sharedPreferences: getIt()));
  getIt.registerLazySingleton(() => ChatRepo(sharedPreferences: getIt()));
  getIt.registerLazySingleton(() => EventRepo(sharedPreferences: getIt()));
  getIt.registerLazySingleton(() => OnBoardingRepo());
  getIt.registerLazySingleton(() => MediaRepo());
  getIt.registerLazySingleton(() => NotificationRepo());
  getIt.registerLazySingleton(() => HistoryActivityRepo(sharedPreferences: getIt()));
  getIt.registerLazySingleton(() => ProfileRepo(sharedPreferences: getIt()));
  getIt.registerLazySingleton(() => SplashRepo(sharedPreferences: getIt()));

  // Provider
  getIt.registerFactory(() => AuthProvider(authRepo: getIt()));
  getIt.registerFactory(() => ChatProvider(chatRepo: getIt(), sharedPreferences: getIt()));
  getIt.registerFactory(() => CategoryProvider(categoryRepo: getIt()));
  getIt.registerFactory(() => SosProvider(sosRepo: getIt()));
  getIt.registerFactory(() => CheckInProvider(checkInRepo: getIt()));
  getIt.registerFactory(() => BannerProvider(bannerRepo: getIt()));
  getIt.registerFactory(() => LocationProvider(sharedPreferences: getIt()));
  getIt.registerFactory(() => OnBoardingProvider(onboardingRepo: getIt()));
  getIt.registerFactory(() => MediaProvider(mediaRepo: getIt()));
  getIt.registerFactory(() => PPOBProvider(sharedPreferences: getIt()));
  getIt.registerFactory(() => NewsProvider());
  getIt.registerFactory(() => NearMemberProvider(nearMemberRepo: getIt(), sharedPreferences: getIt()));
  getIt.registerFactory(() => WarungProvider());
  getIt.registerFactory(() => InboxProvider());
  getIt.registerFactory(() => FcmProvider());
  getIt.registerFactory(() => RegionProvider());
  getIt.registerFactory(() => EventProvider(eventRepo: getIt()));
  getIt.registerFactory(() => HistoryActivityProvider(historyActivityRepo: getIt()));
  getIt.registerFactory(() => ProfileProvider(profileRepo: getIt()));
  getIt.registerFactory(() => SplashProvider(splashRepo: getIt()));
  getIt.registerFactory(() => LocalizationProvider(sharedPreferences: getIt()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
}
