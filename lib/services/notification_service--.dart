import 'package:examdates/models/NotificationContent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Local Notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationServiceSil {
  /* FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin; */
  List<PendingNotificationRequest> pendingNotificationRequests =
      new List<PendingNotificationRequest>();

  NotificationServiceSil();

  Future<void> init(Function onSelectNotification) async {
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
    tz.initializeTimeZones();
    getPendingNotfs();
  }

  Future<List<PendingNotificationRequest>> getPendingNotfs() {
    return flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  void show() async {
    var android = new AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription");
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, "title", "body", platform,
        payload: "custom payload");
  }

  void addSchedule(NotificationContent notificationContent) async {
    var androidDetails = new AndroidNotificationDetails(
      notificationContent.id.toString(),
      notificationContent.title,
      notificationContent.body,
      importance: Importance.max,
      priority: Priority.high,
      color: Colors.blue,
      playSound: true,
    );
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iSODetails);
    //var time = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 30));
    var str = notificationContent.date;
    var time = tz.TZDateTime.from(str, tz.local);
    flutterLocalNotificationsPlugin.zonedSchedule(
      notificationContent.id,
      notificationContent.title,
      notificationContent.body,
      time,
      generalNotificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> zonedScheduleNotification(NotificationContent not) async {
    var d = new DateTime(not.date.year, not.date.month, not.date.day,
        not.beforeTime.hour, not.beforeTime.minute);
    var dStr = d.toString();
    var time = tz.TZDateTime.parse(tz.local, dStr);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      not.id,
      not.title,
      not.body,
      time,
      NotificationDetails(
        android:
            AndroidNotificationDetails(not.id.toString(), not.title, not.body),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: not.id.toString(),
    );
  }
}

NotificationServiceSil notificationService = new NotificationServiceSil();
