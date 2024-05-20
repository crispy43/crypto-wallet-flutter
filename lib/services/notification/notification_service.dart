import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Initialization Settings for Android
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialization Settings for iOS
    const initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    // InitializationSettings for initializing settings for both platforms (Android & iOS)
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static requestIOSPermissions() {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> sampleNotification() async {
    await _flutterLocalNotificationsPlugin.show(
      0,
      'sample title',
      'sample body',
      _notificationSpecifics,
      payload: 'item x',
    );
  }
}

// *
const _androidNotificationDetails = AndroidNotificationDetails(
  'channel ID',
  'channel name',
  channelDescription: 'channel description',
  playSound: true,
  priority: Priority.high,
  importance: Importance.high,
  ticker: 'ticker',
  icon: '@mipmap/ic_launcher',
);

// *
const _notificationSpecifics = NotificationDetails(
  android: _androidNotificationDetails,
  iOS: IOSNotificationDetails(),
);
