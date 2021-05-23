import 'dart:convert';

import 'package:covid_app/widgets/addRequest.dart';
import 'package:covid_app/widgets/chatScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/screens/splashScreen.dart';
import 'package:covid_app/screens/signupScreen.dart';
import 'package:covid_app/screens/loginScreen.dart';
import 'package:covid_app/screens/homeScreen.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message');
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ),
      payload: message.data['payload']);
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future selectNotification(String payload) async {
    if (payload != null) {
      var data = jsonDecode(payload);
      await navigatorKey.currentState.push(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ChatScreen(uid1: data['uid1'], uid2: data['uid2'])),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    precacheImage(AssetImage('assets/images/bg.jpg'), context);
    precacheImage(AssetImage('assets/images/icon.png'), context);
    precacheImage(AssetImage('assets/images/headbg.png'), context);

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      flutterLocalNotificationsPlugin.show(
          message.data.hashCode,
          message.data['title'],
          message.data['body'],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
            ),
          ),
          payload: message.data['payload']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayOpacity: 1,
        overlayColor: Color(0x55000000),
        overlayWidget: Center(
          child: SpinKitCircle(
            //color: Theme.of(context).primaryColor,
            color: Colors.blueGrey,
          ),
        ),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => SplashScreen(),
            '/signup': (context) => DoubleBack(
                message: 'Press back again to close', child: SignupScreen()),
            '/login': (context) => DoubleBack(
                message: 'Press back again to close', child: LoginScreen()),
            '/home': (context) => DoubleBack(
                message: 'Press back again to close', child: HomeScreen()),
            '/addRequest': (context) => AddRequest(),
          },
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            primaryColor: Colors.blueGrey,
            primaryColorLight: Colors.blueGrey[100],
            //To use hex => Color(0xff_HEX_)
            //define default font family here,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}
