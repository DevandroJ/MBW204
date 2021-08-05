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
    androidInitializationSettings = AndroidInitializationSettings('@drawable/ic_notification');
    iosInitializationSettings = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: (int id, String title, String body, String payload) {
        return showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          ),
        );
      },
    );
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