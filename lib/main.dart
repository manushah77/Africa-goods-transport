import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'Screens/SplashScreen/splash_screen.dart';
import 'notification/NotificationService.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyCiAAN35FWazkKUflmQcuTfQjgjYLA3XrM',
    appId: '1:60559464031:android:1ae44714fd904a64c1adea',
    messagingSenderId: '60559464031',
    projectId: 'africagoodstransport',
  ));

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  await _firebaseMessaging.requestPermission();
  _firebaseMessaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  String? token = await _firebaseMessaging.getToken();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  print("FCM Token: $token");

  // Subscribe to topic
  await FirebaseMessaging.instance.subscribeToTopic('all');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    if (message.notification != null) {
      notify(message);
    }
  });

  runApp(MyApp());
}

Future<void> notify(RemoteMessage message) async {

  final NotificationService _notificationService = NotificationService();
  await _notificationService.init();


  await _notificationService.showNotification(
    id: 0,
    title: 'Africa Goods Transport',
    userType: 'Vehicle Owner',
    body: 'Attention! There is request near you',
  );

}

// @pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  notify(message);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // home: VehicleOwnerCompleteProfileOne(),

    );
  }
}
