import 'package:flutter/material.dart';
import 'package:tfl/screens/home_screen.dart';
import 'package:tfl_di/tfl_di.dart';

void main() {
  configureInjector();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TFL Line Status',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
//        '/nearest': (context) => NearestStationScreen(),
//        '/search': (context) => StationSearch(),
//        '/sandbox': (context) => SandboxScreen()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
