import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../core/network/network.dart';

// create an instance
FirebaseMessaging messaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin fltNotification =
    FlutterLocalNotificationsPlugin();
FlutterLocalNotificationsPlugin rideNotification =
    FlutterLocalNotificationsPlugin();
bool isGeneral = false;
String latestNotification = '';
int id = 0;

void notificationTapBackground(NotificationResponse notificationResponse) {
  isGeneral = true;
}

var androidDetails = const AndroidNotificationDetails(
  '54321',
  'normal_notification',
  enableVibration: true,
  enableLights: true,
  importance: Importance.high,
  playSound: true,
  priority: Priority.high,
  visibility: NotificationVisibility.private,
);

const iosDetails = DarwinNotificationDetails(
    presentAlert: true, presentBadge: true, presentSound: true);

var generalNotificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

var androiInit =
    const AndroidInitializationSettings('@mipmap/ic_launcher'); //for logo
var iosInit = const DarwinInitializationSettings(
  defaultPresentAlert: true,
  defaultPresentBadge: true,
  defaultPresentSound: true,
);
var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

Future<void> initMessaging() async {
  await fltNotification.initialize(settings: initSetting);

  await FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message?.data != null) {
      if (message?.data['push_type'] == 'general') {
        latestNotification = message?.data['message'];
        isGeneral = true;
      }
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      if (message.data['push_type'].toString() == 'general') {
        latestNotification = message.data['message'];
        if (message.data['image'].isNotEmpty) {
          _showBigPictureNotificationURLGeneral(message.data);
        } else {
          _showGeneralNotification(message.data);
        }
      } else {
        showRideNotification(message.notification);
      }
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.data['push_type'].toString() == 'general') {
      latestNotification = message.data['message'];
      isGeneral = true;
    }
  });
}

Future<String> _downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final Response response = await DioProviderImpl().get(url);
  final File file = File(filePath);
  await file.writeAsBytes(Uint8List.fromList(response.data));
  return filePath;
}

Future<Uint8List> _getByteArrayFromUrl(String url) async {
  final Response response = await DioProviderImpl().get(url);
  return Uint8List.fromList(response.data);
}

Future<void> _showBigPictureNotificationURLGeneral(message) async {
  latestNotification = message['message'];
  if (Platform.isAndroid) {
    final ByteArrayAndroidBitmap bigPicture =
        ByteArrayAndroidBitmap(await _getByteArrayFromUrl(message['image']));
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(bigPicture);
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'notification_1',
      'general image notification',
      channelDescription: 'general notification with image',
      styleInformation: bigPictureStyleInformation,
      enableVibration: true,
      enableLights: true,
      importance: Importance.high,
      playSound: true,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
    );
    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    fltNotification.initialize(settings: initSetting,
        onDidReceiveNotificationResponse: notificationTapBackground,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
    await fltNotification.show(
        title: message['title'],body:  message['message'], notificationDetails: notificationDetails, id:  id++);
  } else {
    final String bigPicturePath = await _downloadAndSaveFile(
        Uri.parse(message['image']).toString(), 'bigPicture.jpg');
    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        attachments: <DarwinNotificationAttachment>[
          DarwinNotificationAttachment(
            bigPicturePath,
          )
        ]);

    final NotificationDetails notificationDetails =
        NotificationDetails(iOS: iosDetails);
    fltNotification.initialize(settings: initSetting,
        onDidReceiveNotificationResponse: notificationTapBackground,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
    await fltNotification.show(
       title:  message['title'],body:  message['message'],notificationDetails:  notificationDetails, id:  id++);
  }
  id = id++;
}

Future<void> _showGeneralNotification(message) async {
  latestNotification = message['message'];
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'notification_1',
    'general notification',
    channelDescription: 'general notification',
    enableVibration: true,
    enableLights: true,
    importance: Importance.high,
    playSound: true,
    priority: Priority.high,
    visibility: NotificationVisibility.public,
  );
  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true, presentBadge: true, presentSound: true);
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails, iOS: iosDetails);
  fltNotification.initialize(settings: initSetting,
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
  await fltNotification.show(
      title: message['title'],body:  message['message'], notificationDetails: notificationDetails, id:  id++);
  id = id++;
}

Future<void> showOtpNotification(message) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'notification_1',
    'ride notification',
    channelDescription: 'ride notification',
    enableVibration: true,
    enableLights: true,
    importance: Importance.high,
    playSound: true,
    priority: Priority.high,
    visibility: NotificationVisibility.public,
  );
  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails, iOS: iosDetails);
  rideNotification.initialize(settings: initSetting);
  await rideNotification.show(id:id++,title:  message.title.toString(),
    body:   message.body.toString(), notificationDetails: notificationDetails);
  id = id++;
}

Future<void> showRideNotification(message) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'notification_1',
    'ride notification',
    channelDescription: 'ride notification',
    enableVibration: true,
    enableLights: true,
    importance: Importance.high,
    playSound: true,
    priority: Priority.high,
    visibility: NotificationVisibility.public,
  );
  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails, iOS: iosDetails);
  rideNotification.initialize(settings: initSetting);
  await rideNotification.show(id:id++, title: message.title.toString(),
     body:  message.body.toString(),notificationDetails:  notificationDetails);
  id = id++;
}
