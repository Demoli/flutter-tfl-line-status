import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tfl/models/home_station.dart';
import 'dart:async';

import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/station_detail.dart';

class NearestStation extends StatefulWidget {
  Future<Position> locationFuture;

  Map homeStation;

  NearestStation() {

    HomeStation().get().then((onValue) {
      homeStation = onValue;
    });

    locationFuture =
        Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  _NearestStationState createState() => _NearestStationState();
}

class _NearestStationState extends State<NearestStation> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
        future: widget.locationFuture,
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

                        if(widget.homeStation != null && closest['id'] == widget.homeStation['id']) {
                          return Text('');
                        }

                        return StationDetail(closest);
                    }
                  });
          }
        });
  }
}
