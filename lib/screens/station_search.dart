import 'package:flutter/material.dart';
import 'package:tfl/widgets/global_actions.dart';
import 'package:tfl/widgets/station_search.dart' as StationSearchWidget;

class StationSearch extends StatefulWidget {
  @override
  _StationSearchState createState() => _StationSearchState();
}

class _StationSearchState extends State<StationSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the StationSearch object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Search Station"),
        ),
        body: StationSearchWidget.StationSearch());
  }
}
