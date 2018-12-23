import 'package:flutter/material.dart';
import 'package:tfl/screens/home_screen.dart';
import 'package:tfl/screens/station_search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TFL Line Status',
      initialRoute: '/search',
      routes: {
        '/': (context) => HomeScreen(),
        '/search': (context) => StationSearch(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
