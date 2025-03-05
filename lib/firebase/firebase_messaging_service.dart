import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/features/search/services/search_services.dart';
import 'package:amazon_clone/main.dart';
import 'package:amazon_clone/model/product.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final SearchServices _searchServices = SearchServices();

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

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        _navigateToProductDetails(response.payload!);
      }
    });
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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      String? productId = message.data['productId'];
      if (productId != null) {
        _navigateToProductDetails(productId);
      }
    });
  }

  // Show Notification using Flutter Local Notifications
  static Future<void> _showNotification(RemoteMessage message) async {
    String? productId = message.data['productId'];

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
      payload: productId,
    );
  }

  Future<void> initialize() async {
    await requestPermission();
    await initLocalNotifications();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    onMessageListener();

    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCM Token: $token");
  }

  void _navigateToProductDetails(String productId) async {
    Product product = await _searchServices.fetchProductSearchedByID(
      context: navigatorKey.currentContext!,
      productId: productId,
    );

    navigatorKey.currentState?.pushNamed(
      ProductDetailsScreen.routeName,
      arguments: product,
    );
  }
}
