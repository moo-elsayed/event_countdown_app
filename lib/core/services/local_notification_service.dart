import 'dart:async';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../features/home/data/event_model.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =
      StreamController();

  // 1.setup

  static onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

  static Future<void> init() async {
    // Create the notification channel for Android 8.0 and above
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'basic_channel', // Channel ID
      'Basic Notifications', // Channel Name
      description: 'This channel is used for basic notifications',
      importance: Importance.high, // Set importance to high to ensure sound
      playSound: true, // Ensure sound is played
      sound: null,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onTap,
      onDidReceiveNotificationResponse: onTap,
    );

    // Create and register the notification channel for Android 8.0 and above
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // Request notification permissions (needed for Android 13+ and iOS)
  static Future<void> requestPermissions() async {
    // Request permissions for Android (API 33+)
    if (await Permission.notification.isDenied) {
      // Use permission_handler to request notification permission
      await Permission.notification.request();
    }

    // Check if notifications are enabled using flutter_local_notifications
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      final isEnabled = await androidImplementation.areNotificationsEnabled();

      // Notify the user if notifications are disabled in settings
      if (isEnabled == false) {
        // Add logic to show a message to the user if notifications are disabled.
        log('Notifications are disabled in system settings.');
      }
    }
  }

  // 2.basic notification

  static void showBasicNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'basic_channel_2', // New unique Channel ID
          'Basic Notifications', // Channel Name
          channelDescription:
              'This channel is used for basic notifications with sound',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          sound: null,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Basic Notification',
      'body',
      notificationDetails,
      payload: 'basic',
    );

    log('Notification displayed');
  }

  // 3.repeated notification

  static void showRepeatedNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'repeated_channel_2', // New unique Channel ID
          'Repeated Notifications', // Channel Name
          channelDescription: 'This channel is used for repeated notifications',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          sound: null,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(
      1, // Notification ID (use a unique ID for each notification)
      'Repeated Notification', // Notification Title
      'body', // Notification Body
      RepeatInterval.everyMinute,
      // Repeat Interval (you can change this to everyMinute, everyHour, etc.)
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exact,
      payload: 'repeated',
    ); //Allow notification to show even when the app is in the background);

    log('Notification displayed');
  }

  // 4.scheduled notification

  static Future<List<int>> showScheduledNotification({
    required EventModel event,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'scheduled_channel_3',
          'Scheduled Notifications',
          channelDescription:
              'This channel is used for scheduled notifications',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          sound: null,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    DateTime now = DateTime.now();

    List<Duration> offsets = [
      const Duration(days: 1),
      const Duration(hours: 1),
      const Duration(minutes: 5),
      const Duration(minutes: 0),
    ];

    int notificationId = 100; // start from 100 to avoid overlap

    int baseId = event.hashCode;
    int i = 0;
    List<int> scheduledIds = [];

    for (var offset in offsets) {
      final scheduledDateTime = event.dateTime.subtract(offset);

      // Only schedule if the notification time is in the future
      if (scheduledDateTime.isAfter(now)) {
        final id = baseId + i;
        await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId++,
          '${event.title} - ${offsetMessage(offset)}!',
          event.note ?? '',
          tz.TZDateTime.from(scheduledDateTime, tz.local),
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: 'scheduled',
        );
        log('Notification scheduled for: $scheduledDateTime');
        scheduledIds.add(id);
        i++;
      } else {
        log('Skipped notification for offset $offset (already passed)');
      }
    }

    return scheduledIds;
  }

  static String offsetMessage(Duration offset) {
    if (offset.inMinutes == 0) return context.tr('notification.now');
    if (offset.inMinutes == 5) return context.tr('notification.in_5_minutes');
    if (offset.inHours == 1) return context.tr('notification.in_1_hour');
    if (offset.inDays == 1) return context.tr('notification.in_1_day');
    return context.tr('notification.now'); // fallback
  }

  static void cancelNotification({required int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
