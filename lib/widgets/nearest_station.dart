import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tfl/models/home_station.dart';
import 'dart:async';

import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/station_detail.dart';
import 'package:tfl_di/tfl_di.dart';

class NearestStation extends StatefulWidget {

  final TflApi api;

  @override
  _NearestStationState createState() => _NearestStationState(this.api);

  NearestStation(this.api);
}

class _NearestStationState extends State<NearestStation> {

  TflApi api;

  Geolocator geolocator;

  Future<Position> locationFuture;

  Map homeStation;

  _NearestStationState(this.api) {

    HomeStation().get().then((onValue) {
      homeStation = onValue;
    });

    geolocator = Geolocator();

    locationFuture = geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
        future: locationFuture,
        builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final position = snapshot.data;

              final stopPointFuture = api.getStopPointsByLocation(
                  position.latitude, position.longitude);

              return FutureBuilder<List>(
                  future: stopPointFuture,
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        final stopPoints = snapshot.data;

                        final closest = stopPoints.removeAt(0);

                        if(homeStation != null && closest['id'] == homeStation['id']) {
                          return Text('');
                        }

                        return StationDetail(closest);
                    }
                  });
          }
        });
  }
}
