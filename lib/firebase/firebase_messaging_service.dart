import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted notification permission');
      } else {
        debugPrint('User declined or has not accepted permission');
      }
    } else {
      debugPrint(
          'Notification permission already granted or denied: ${settings.authorizationStatus}');
    }
  }

  // Initialize Local Notifications (For Foreground Notifications)
  Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint("Handling a background message: ${message.messageId}");
  }

  // Listen for Incoming Messages
  void onMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Foreground message received: ${message.notification?.title}");

      _showNotification(message);
    });
  }

  // Show Notification using Flutter Local Notifications
  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // ID
      'High Importance Notifications', // Title
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? 'No message body',
      platformChannelSpecifics,
    );
  }

  Future<void> initialize() async {
    await requestPermission();
    await initLocalNotifications();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    onMessageListener();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message clicked!");
    });

    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCM Token: $token");
  }
}
