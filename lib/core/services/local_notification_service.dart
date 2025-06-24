// import 'dart:async';
// import 'dart:developer';
// import 'package:easy_localization/easy_localization.dart' as context;
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../features/home/data/event_model.dart';
//
// class LocalNotificationService {
//   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   static StreamController<NotificationResponse> streamController =
//       StreamController();
//
//   // 1.setup
//
//   static onTap(NotificationResponse notificationResponse) {
//     streamController.add(notificationResponse);
//   }
//
//   static Future<void> init() async {
//     // Create the notification channel for Android 8.0 and above
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'basic_channel', // Channel ID
//       'Basic Notifications', // Channel Name
//       description: 'This channel is used for basic notifications',
//       importance: Importance.high, // Set importance to high to ensure sound
//       playSound: true, // Ensure sound is played
//       sound: null,
//     );
//
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//           iOS: DarwinInitializationSettings(),
//         );
//
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveBackgroundNotificationResponse: onTap,
//       onDidReceiveNotificationResponse: onTap,
//     );
//
//     // Create and register the notification channel for Android 8.0 and above
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);
//   }
//
//   // Request notification permissions (needed for Android 13+ and iOS)
//   static Future<void> requestPermissions() async {
//     // Request permissions for Android (API 33+)
//     if (await Permission.notification.isDenied) {
//       // Use permission_handler to request notification permission
//       await Permission.notification.request();
//     }
//
//     // Check if notifications are enabled using flutter_local_notifications
//     final androidImplementation = flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >();
//
//     if (androidImplementation != null) {
//       final isEnabled = await androidImplementation.areNotificationsEnabled();
//
//       // Notify the user if notifications are disabled in settings
//       if (isEnabled == false) {
//         // Add logic to show a message to the user if notifications are disabled.
//         log('Notifications are disabled in system settings.');
//       }
//     }
//   }
//
//   // 2.basic notification
//
//   static void showBasicNotification() async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'basic_channel_2', // New unique Channel ID
//           'Basic Notifications', // Channel Name
//           channelDescription:
//               'This channel is used for basic notifications with sound',
//           importance: Importance.high,
//           priority: Priority.high,
//           playSound: true,
//           sound: null,
//         );
//
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//     );
//
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'Basic Notification',
//       'body',
//       notificationDetails,
//       payload: 'basic',
//     );
//
//     log('Notification displayed');
//   }
//
//   // 3.repeated notification
//
//   static void showRepeatedNotification() async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'repeated_channel_2', // New unique Channel ID
//           'Repeated Notifications', // Channel Name
//           channelDescription: 'This channel is used for repeated notifications',
//           importance: Importance.high,
//           priority: Priority.high,
//           playSound: true,
//           sound: null,
//         );
//
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//     );
//
//     await flutterLocalNotificationsPlugin.periodicallyShow(
//       1, // Notification ID (use a unique ID for each notification)
//       'Repeated Notification', // Notification Title
//       'body', // Notification Body
//       RepeatInterval.everyMinute,
//       // Repeat Interval (you can change this to everyMinute, everyHour, etc.)
//       notificationDetails,
//       androidScheduleMode: AndroidScheduleMode.exact,
//       payload: 'repeated',
//     ); //Allow notification to show even when the app is in the background);
//
//     log('Notification displayed');
//   }
//
//   // 4.scheduled notification
//
//   static Future<List<int>> showScheduledNotification({
//     required EventModel event,
//   }) async {
//     final notificationDetails = const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'event_channel',
//         'Event Notifications',
//         channelDescription: 'Notifications related to upcoming events',
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//       iOS: DarwinNotificationDetails(),
//     );
//
//     DateTime now = DateTime.now();
//     List<Duration> offsets = [
//       const Duration(days: 1),
//       const Duration(hours: 1),
//       const Duration(minutes: 5),
//     ];
//
//     List<int> ids = [];
//     for (int i = 0; i < offsets.length; i++) {
//       final scheduledTime = event.dateTime.subtract(offsets[i]);
//
//       if (scheduledTime.isAfter(now)) {
//         final id = event.hashCode + i;
//         await flutterLocalNotificationsPlugin.zonedSchedule(
//           id,
//           '${event.title} - ${offsetMessage(offsets[i])}',
//           event.note ?? '',
//           tz.TZDateTime.from(scheduledTime, tz.local),
//           notificationDetails,
//           androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//           payload: 'event',
//         );
//         ids.add(id);
//       }
//     }
//
//     return ids;
//   }
//
//   static String offsetMessage(Duration offset) {
//     if (offset.inMinutes == 0) return context.tr('notification.now');
//     if (offset.inMinutes == 5) return context.tr('notification.in_5_minutes');
//     if (offset.inHours == 1) return context.tr('notification.in_1_hour');
//     if (offset.inDays == 1) return context.tr('notification.in_1_day');
//     return context.tr('notification.now'); // fallback
//   }
//
//   static void cancelNotification({required int id}) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }
//
//
// }



import 'dart:async';
import 'dart:developer';
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
    // Initialize timezone data
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Create the notification channel for Android 8.0 and above
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'event_channel', // Match the channel ID used in scheduled notifications
      'Event Notifications', // Channel Name
      description: 'Notifications for upcoming events',
      importance: Importance.max, // Use max importance for better delivery
      playSound: true,
      enableVibration: true,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
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

    // Request permissions after initialization
    await requestPermissions();
  }

  // Request notification permissions (needed for Android 13+ and iOS)
  static Future<bool> requestPermissions() async {
    bool permissionGranted = true;

    // Request permissions for Android (API 33+)
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      permissionGranted = status.isGranted;
    }

    // For iOS, request permissions through flutter_local_notifications
    final iosImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
    >();

    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Check if notifications are enabled using flutter_local_notifications
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
    >();

    if (androidImplementation != null) {
      final isEnabled = await androidImplementation.areNotificationsEnabled();
      if (isEnabled == false) {
        log('Notifications are disabled in system settings.');
        permissionGranted = false;
      }
    }

    return permissionGranted;
  }

  // Show immediate notification for when event time arrives
  static Future<void> showEventNotification({required EventModel event}) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'event_channel',
      'Event Notifications',
      channelDescription: 'Notifications for upcoming events',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      ticker: 'Event Starting',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      event.hashCode, // Use event hashcode as unique ID
      '🎉 ${event.title}',
      context.tr('notification.event_starting_now'),
      notificationDetails,
      payload: 'event_now_${event.hashCode}',
    );

    log('Event notification shown for: ${event.title}');
  }

  // Scheduled notifications with 4 different times (1 day, 1 hour, 5 minutes, and at event time)
  static Future<List<int>> showScheduledNotification({
    required EventModel event,
  }) async {
    final notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'event_channel',
        'Event Notifications',
        channelDescription: 'Notifications for upcoming events',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    DateTime now = DateTime.now();

    // Define notification offsets - including 0 for event time
    List<Duration> offsets = [
      const Duration(days: 1),    // 1 day before
      const Duration(hours: 1),   // 1 hour before
      const Duration(minutes: 5), // 5 minutes before
      const Duration(seconds: 0), // At event time
    ];

    List<int> ids = [];

    for (int i = 0; i < offsets.length; i++) {
      final scheduledTime = event.dateTime.subtract(offsets[i]);

      // Only schedule if the time is in the future
      if (scheduledTime.isAfter(now.add(const Duration(seconds: 1)))) {
        final id = event.hashCode + i;

        try {
          await flutterLocalNotificationsPlugin.zonedSchedule(
            id,
            '${getNotificationIcon(offsets[i])} ${event.title}',
            getNotificationBody(event, offsets[i]),
            tz.TZDateTime.from(scheduledTime, tz.local),
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            // uiLocalNotificationDateInterpretation:
            // UILocalNotificationDateInterpretation.absoluteTime,
            payload: 'event_${offsets[i].inSeconds}_${event.hashCode}',
          );

          ids.add(id);
          log('Scheduled notification for ${event.title} at $scheduledTime (${offsetMessage(offsets[i])})');
        } catch (e) {
          log('Error scheduling notification: $e');
        }
      }
    }

    if (ids.isEmpty) {
      log('No notifications scheduled for ${event.title} - all times are in the past');
    }

    return ids;
  }

  // Get appropriate icon for notification based on time offset
  static String getNotificationIcon(Duration offset) {
    if (offset.inSeconds == 0) return '🎉';
    if (offset.inMinutes == 5) return '⏰';
    if (offset.inHours == 1) return '⏳';
    if (offset.inDays == 1) return '📅';
    return '🔔';
  }

  // Get notification body text
  static String getNotificationBody(EventModel event, Duration offset) {
    String timeMessage = offsetMessage(offset);
    String eventNote = event.note?.isNotEmpty == true ? '\n${event.note}' : '';

    if (offset.inSeconds == 0) {
      return context.tr('notification.event_starting_now') + eventNote;
    } else {
      return timeMessage + eventNote;
    }
  }

  static String offsetMessage(Duration offset) {
    if (offset.inSeconds == 0) return context.tr('notification.event_starting_now');
    if (offset.inMinutes == 5) return context.tr('notification.in_5_minutes');
    if (offset.inHours == 1) return context.tr('notification.in_1_hour');
    if (offset.inDays == 1) return context.tr('notification.in_1_day');
    return context.tr('notification.now'); // fallback
  }

  static Future<void> cancelNotification({required int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    log('Cancelled notification with ID: $id');
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    log('Cancelled all notifications');
  }

  // Get all pending notifications (for debugging)
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  // Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
    >();

    if (androidImplementation != null) {
      return await androidImplementation.areNotificationsEnabled() ?? false;
    }

    return true; // Assume enabled for iOS
  }
}
