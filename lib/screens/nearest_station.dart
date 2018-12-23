import 'package:flutter/material.dart';
import 'package:tfl/widgets/nearest_station.dart';
import 'package:tfl/widgets/global_actions.dart';

class NearestStationScreen extends StatefulWidget {
  @override
  _NearestStationScreenState createState() => _NearestStationScreenState();
}

class _NearestStationScreenState extends State<NearestStationScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: GlobalActions(context),
        // Here we take the value from the StationSearch object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Nearest Station"),
      ),
          body: NearestStation()
    );
  }
}
