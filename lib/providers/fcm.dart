import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmProvider with ChangeNotifier {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  Future initializing(BuildContext context) async {
    androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    iosInitializationSettings = IOSInitializationSettings();
    initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void initFcm(BuildContext context) {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('BroadcastID', 'Broadcast', 'Broadcast',
          priority: Priority.high,
          importance: Importance.max,
          enableLights: true,
          playSound: true,
          enableVibration: true,
        );
        IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
        NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
        await flutterLocalNotificationsPlugin.show(0, message['notification']['title'].toString(), message['notification']['body'].toString(), notificationDetails);
        return Future.value(true);
      },
    );
    firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
      sound: true,
      alert: true,
      badge: true,
    ));
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {});
  }

}