import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tfl/models/home_station.dart';
import 'dart:async';

import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/station_detail.dart';

class NearestStation extends StatefulWidget {
  @override
  _NearestStationState createState() => _NearestStationState();
}

class _NearestStationState extends State<NearestStation> {

  Geolocator geolocator;

  Future<Position> locationFuture;

  Map homeStation;

  _NearestStationState() {

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

              final stopPointFuture = TflApi().getStopPointsByLocation(
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
