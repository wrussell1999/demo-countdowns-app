import 'package:flutter/material.dart';
import 'landing.dart';
import 'create.dart';
import 'join.dart';
import 'live.dart';
import 'controls.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LandingPage.route,
      routes: {
        LandingPage.route: (context) => LandingPage(),
        CreatePage.route: (context) => CreatePage(),
        JoinPage.route: (context) => JoinPage(),
        LivePage.route: (context) => LivePage(),
        ControlsPage.route: (context) => ControlsPage()
      },
      debugShowCheckedModeBanner: false,
      title: 'Demo Countdown',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LandingPage()
    );
  }
}