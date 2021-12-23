import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_app1/helper/authenticate.dart';
import 'package:chat_app1/helper/helperfunctions.dart';
import 'package:chat_app1/views/chat_room_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'key1',
      channelName: 'Kanal İsmi',
      channelDescription: "Kanal Açıklaması",
      defaultColor: const Color(0XFF9050DD),
      ledColor: Colors.white,
      playSound: true,
      enableLights: true,
      enableVibration: true,
    ),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((val) {
      setState(() {
        if (val != null) {
          userIsLoggedIn = val;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'DuyguVeEren',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xff145C9E),
          scaffoldBackgroundColor: Colors.grey[900],
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: userIsLoggedIn ? const ChatRoom() : const Authenticate());
  }
}
