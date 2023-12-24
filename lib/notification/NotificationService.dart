import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../Screens/BottomNavigationScreen/viechleOwner_side_custom_navigationbar.dart';



class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
        _handleNotificationButton(payload.id.toString());
      },
    );
  }
  Future<void> _handleNotificationButton(String? payload) async {
    if (payload != null) {
      if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
        NotificationService.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ViechleOwnerSideCustom_BottomBar(selectedIndex: 0,),
          ),
        );
      }
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    String? body,
    String? userType,
  }) async {

      final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'com.agt.com',
        'com.agt.com',
        importance: Importance.max,
        priority: Priority.high,
      );

      NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: 'type,$userType',
      );
  }

}
