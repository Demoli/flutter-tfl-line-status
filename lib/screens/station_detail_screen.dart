import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:tfl/widgets/station_detail.dart';


class StationDetailScreen extends StatefulWidget {
  final stopPoint;

  StationDetailScreen(this.stopPoint);

  @override
  _StationDetailScreenState createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends State<StationDetailScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the StationSearch object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Station Details"),
        ),
        body: Injector.getInjector().get<StationDetail>(
            additionalParameters: {'stopPoint': widget.stopPoint})
    );
  }
}
