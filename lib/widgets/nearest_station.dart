import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/station_detail.dart';
import 'package:tfl/widgets/status_indicator.dart';

class NearestStation extends StatefulWidget {
  Future<Position> locationFuture;

  NearestStation() {
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
              return Text('Getting location...');
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
                        return Text('Finding closest station');
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        final stopPoints = snapshot.data;

                        final closest = stopPoints.removeAt(0);

                        return StationDetail(closest);
                    }
                  });
          }
        });
  }
}
