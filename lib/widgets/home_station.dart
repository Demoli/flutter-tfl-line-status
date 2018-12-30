import 'package:flutter/material.dart';
import 'package:tfl/widgets/nearest_station.dart';
import 'package:tfl/models/home_station.dart' as HomeStationModel;
import 'package:tfl/widgets/station_detail.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';


class HomeStation extends StatefulWidget {
  @override
  _HomeStationState createState() => _HomeStationState();
}

class _HomeStationState extends State<HomeStation> {
  @override
  Widget build(BuildContext context) {
    final homeStationFuture = HomeStationModel.HomeStation().get();

    return FutureBuilder<Map>(
        future: homeStationFuture,
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final station = snapshot.data;

              if (station == null) {
                return Injector.getInjector().get<NearestStation>();
              }

              return StationDetail(station);
          }
        });
  }
}
