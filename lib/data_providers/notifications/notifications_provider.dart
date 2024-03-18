/*Prasish*/

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

class NotificationsProvider {
  final FlutterLocalNotificationsPlugin _notif;
  NotificationsProvider(this._notif);

  static Future<NotificationsProvider> load() async {
    FlutterLocalNotificationsPlugin notif = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification_icon');
    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: "Open Time Tracker");

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux,
            macOS: initializationSettingsDarwin);
    await notif.initialize(initializationSettings);

    return NotificationsProvider(notif);
  }

  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      bool result = await _notif
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(sound: true, alert: true, badge: true) ??
          false;
      return result;
    } else if (Platform.isMacOS) {
      bool result = await _notif
              .resolvePlatformSpecificImplementation<
                  MacOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(sound: true, alert: true, badge: true) ??
          false;
      return result;
    } else {
      return true;
    }
  }

  Future<void> displayRunningTimersNotification(
      String? title, String? body) async {
    // print("displaying notification");
    if (!await requestPermissions()) {
      // print("no permissions, quitting");
      return;
    }

    const darwin = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: false,
      badgeNumber: null,
    );

    const android = AndroidNotificationDetails(
        "com.yourcompanyname.yourappname.runningtimersnotification",
        "Running Timers",
        channelDescription:
            "Notification indicating that timers are currently running",
        priority: Priority.low,
        importance: Importance.low,
        showWhen: true);

    const linux = LinuxNotificationDetails();

    NotificationDetails details = const NotificationDetails(
        iOS: darwin, android: android, macOS: darwin, linux: linux);

    await _notif.show(0, title, body, details);
  }

  Future<void> removeAllNotifications() async {
    await _notif.cancelAll();
  }
}
