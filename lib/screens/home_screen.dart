import 'package:flutter/material.dart';
import 'package:tfl/widgets/global_actions.dart';
import 'package:tfl/widgets/home_station.dart';
import 'package:tfl/widgets/nearest_station.dart';
import 'package:tfl/widgets/station_search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the HomeScreen object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Home and Nearest Stations"),
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            StationSearch(),
            HomeStation(),
            NearestStation(),
          ],
        ));
  }
}
