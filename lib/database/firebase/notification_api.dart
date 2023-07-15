import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../models/user/device_token.dart';
import '../../utilities/app_key.dart';

class NotificationAPI {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> deviceToken() async =>
      Platform.isMacOS ? '' : await _messaging.getToken();

  Future<bool> sendSubsceibtionNotification({
    required List<MyDeviceToken> deviceToken,
    required String messageTitle,
    required String messageBody,
    required List<String> data,
  }) async {
    try {
      if (deviceToken.isEmpty) return false;
      const String fcmToken = AppKey.fcm;
      log('FCM token: $fcmToken');
      for (int i = 0; i < deviceToken.length; i++) {
        if (deviceToken[i].token.isEmpty) continue;
        log('Receiver Devive Token: ${deviceToken[i].token}');
        final Map<String, String> headers = <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$fcmToken',
        };
        final http.Request request = http.Request(
          'POST',
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
        );
        request.body = json.encode(<String, dynamic>{
          'to': deviceToken[i].token,
          'priority': 'high',
          'notification': <String, String>{
            'title': messageTitle,
            'body': messageBody,
          }
        });
        request.headers.addAll(headers);
        final http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          if (kDebugMode) {
            debugPrint(await response.stream.bytesToString());
          }
          log('Notification send to: ${deviceToken[i].token}');
        } else {
          log('ERROR in FCM');
        }
      }
      return true;
    } catch (e) {
      log('ERROR in FCM: ${e.toString()}');
      return false;
    }
  }

  //
  // INIT
  //
  static final FlutterLocalNotificationsPlugin _localNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _messaging.requestPermission();
    //  final BehaviorSubject<String?> onNotification =
    //     BehaviorSubject<String?>();
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentSound: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // await localNotificationPlugin.initialize(initializationSettings);
    await FlutterLocalNotificationsPlugin().initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // onNotification.add(details.payload);
        if (kDebugMode) {
          debugPrint('notification payload :${details.payload!} ');
          debugPrint('notification payload :${details.id} ');
          debugPrint('notification payload :${details.payload} ');
        }
      },
    );
    await _localNotificationPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint('Message data: ${message.data}');
      }
      if (message.notification != null) {
        _notificationDetails();
        showNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload:
              '${message.data['key1']}-${message.data['key2']}-${message.data['key3']}',
        );
      }
    });
  }

  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel Id', 'channel Name',
          playSound: true, importance: Importance.max),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
      ),
    );
  }

  static showNotification({
    required String title,
    required String body,
    required String payload,
    int id = 0,
  }) async {
    await _localNotificationPlugin.show(id, title, body, _notificationDetails(),
        payload: payload);
  }

  static Future<void> cancelNotification(int id) async {
    await _localNotificationPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _localNotificationPlugin.cancelAll();
  }
}
