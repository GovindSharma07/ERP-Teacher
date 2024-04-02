import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  //FCM instance
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  //for showing notifications in active state
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //Initialize local notification
  Future<void> localNotificationInit(RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitializationSettings = const DarwinInitializationSettings();

    await _localNotificationsPlugin.initialize(
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings),
        onDidReceiveNotificationResponse: (payLoad) {
      //handleMessage( message);
    });
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(Random.secure().nextInt(10000).toString(),
            "High Importance Notification",
            importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            androidNotificationChannel.id, androidNotificationChannel.name,
            importance: Importance.max,
            channelDescription: "Testing Purpose For Now",
            priority: Priority.high,
            ticker: "ticker");

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _localNotificationsPlugin.show(1, message.notification!.title.toString(),
          message.notification!.body.toString(), notificationDetails);
    });
  }

  //listen FCM
  void firebaseMessageInit() {
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        if (Platform.isAndroid) {
          localNotificationInit(message);
        }
        showLocalNotification(message);
      }
    });
  }

  //handling notification permissions
  void requestsNotificationPermission() async {
    //asking for the permission for notification
    NotificationSettings notificationSettings =
        await _messaging.requestPermission(
            alert: true,
            announcement: true,
            badge: true,
            carPlay: true,
            provisional: true,
            criticalAlert: true,
            sound: true);

    //if permission denied by user , open notification settings
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.denied) {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  //getting device token for sending cloud messaging
  Future<String> getToken() async {
    String? token = await _messaging.getToken(
        vapidKey:
            "BB0AHLrJeC3aGs_7SdirFcktjdhDA7DlDoFwjhTiIiNDMC4bHA7ictOKc5T8Vhva-FEZPX1GAEOgPmttf0GK7os");

    return token!;
  }

/* //handle interaction for ios
  Future<void> setupInteractMessage(BuildContext context) async {
    //when app is in terminated state
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(context, message);
    });
  }*/

//handle message for android
//void handleMessage(RemoteMessage message) {}
}
