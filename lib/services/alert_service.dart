import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AlertService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(settings);

    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    final androidPlugin =
        notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();
  }

static Future<void> scheduleAlert({
  required int id,
  required String title,
  required String body,
  required DateTime dateTime,
}) async {
  final tz.TZDateTime scheduledDate =
      tz.TZDateTime.from(dateTime, tz.local);

  print("================================");
  print("Notification ID: $id");
  print("Current Time: ${tz.TZDateTime.now(tz.local)}");
  print("Scheduled Time: $scheduledDate");
  print("Title: $title");
  print("================================");

  await notifications.zonedSchedule(
    id,
    title,
    body,
    scheduledDate,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'paisamate_alerts',
        'PaisaMate Alerts',
        channelDescription: 'EMI, Loan and Bill reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );

  print("Scheduled successfully");

  final pending = await notifications.pendingNotificationRequests();

  print("Pending notifications: ${pending.length}");

  for (final p in pending) {
    print("Pending -> ID: ${p.id}, Title: ${p.title}");
  }
}

  static Future<void> showTestNotification() async {
    await notifications.show(
      0,
      'Test Notification',
      'Notifications are working!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'paisamate_alerts',
          'PaisaMate Alerts',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<void> cancelAlert(int id) async {
    await notifications.cancel(id);
  }

  static Future<void> cancelAllAlerts() async {
    await notifications.cancelAll();
  }
}