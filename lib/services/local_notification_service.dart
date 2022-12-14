import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path;
import 'package:timezone/timezone.dart' as tz;

int id = 0;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

class LocalNotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;

  Future<void> initialiseSettings(
      void Function(NotificationResponse)? onTapNotification) async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        // didReceiveLocalNotificationStream.add(
        //   ReceivedNotification(
        //     id: id,
        //     title: title,
        //     body: body,
        //     payload: payload,
        //   ),
        // );
      },
      notificationCategories: darwinNotificationCategories,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onTapNotification

        //     (response) {
        //   Logger.d('onDidReceiveNotificationResponse id', response.id);
        //   Logger.d('onDidReceiveNotificationResponse', response.payload);
        // }

        // onDidReceiveBackgroundNotificationResponse: (response) {
        //   Logger.d(
        //       'onDidReceiveBackgroundNotificationResponse', response.toString());
        // },
        // onDidReceiveNotificationResponse: onTapNotification,
        // onDidReceiveNotificationResponse: onTapNotification,
        );
  }

  Future<void> showNotification({
    required RemoteMessage message,
  }) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            playSound: true,
            icon: 'launch_background',
          ),
          iOS: const DarwinNotificationDetails(
            categoryIdentifier: darwinNotificationCategoryPlain,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  Future<void> showNotificationMediaStyle({
    required RemoteMessage message,
  }) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    final imageUrl = message.data['imageUrl'] as String?;
    final String? largeIconPath = imageUrl != null
        ? await _downloadAndSaveFile(message.data['imageUrl'], 'largeIcon')
        : null;

    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            playSound: true,
            icon: 'launch_background',
            largeIcon: largeIconPath != null
                ? FilePathAndroidBitmap(largeIconPath)
                : null,
          ),
          iOS: const DarwinNotificationDetails(
            categoryIdentifier: darwinNotificationCategoryPlain,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }

    // final String largeIconPath =
    //     await _downloadAndSaveFile(mediaUrl, 'largeIcon');
    // final id = Random().nextInt(100);

    // final AndroidNotificationDetails androidPlatformChannelSpecifics =
    //     AndroidNotificationDetails(
    //   'media channel id',
    //   'media channel name',
    //   channelDescription: 'media channel description',
    //   largeIcon: FilePathAndroidBitmap(largeIconPath),
    //   styleInformation: const MediaStyleInformation(),
    // );
    // final NotificationDetails platformChannelSpecifics =
    //     NotificationDetails(android: androidPlatformChannelSpecifics);
    // await flutterLocalNotificationsPlugin.show(
    //   title,
    //   body,
    //   platformChannelSpecifics,
    //   payload: payload,
    // );
  }

  Future<void> sheduledNotification({
    required DateTime time,
    required String channelId,
    required String channelName,
    required String channelDescription,
    required int id,
    required String title,
    required String message,
  }) async {
    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      message,
      tz.TZDateTime.from(time, tz.local),

      //  tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          // channelDescription,
          priority: Priority.high,
          importance: Importance.max,
        ),
        iOS: const DarwinNotificationDetails(
          categoryIdentifier: darwinNotificationCategoryPlain,
        ),
        // iOS: const IOSNotificationDetails(
        //   subtitle: 'Reminder',
        // ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> showBigPictureNotification() async {
    var bigPictureStyleInformation = const BigPictureStyleInformation(
      DrawableResourceAndroidBitmap('chat_icon'),
      largeIcon: DrawableResourceAndroidBitmap('chat_icon'),
      contentTitle: 'flutter devs',
      summaryText: 'summaryText',
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id', 'big text channel name',
        //  'big text channel description',
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: null);
    await flutterLocalNotificationsPlugin.show(
      0,
      'big text title',
      'silent body',
      platformChannelSpecifics,
      payload: 'big image notifications',
    );
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await path.getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
