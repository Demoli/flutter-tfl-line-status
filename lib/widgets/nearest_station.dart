import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:tfl/tfl/api.dart';
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
        // a previously-obtained Future<String> or null
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

              final stopPointFuture =
                  TflApi().getStopPoints(position.latitude, position.longitude);

              return FutureBuilder<List>(
                  future: stopPointFuture,
                  // a previously-obtained Future<String> or null
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

                        final lineFuture =
                            TflApi().getLinesByStopPoint(closest['naptanId']);

                        return Container(
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                              Text(closest['commonName']),
                              FutureBuilder<List>(
                                  future: lineFuture,
                                  // a previously-obtained Future<String> or null
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List> snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.active:
                                      case ConnectionState.waiting:
                                        return Text(
                                            'Finding lines for closest station');
                                      case ConnectionState.done:
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }

                                        final lineIds = snapshot.data
                                            .map((line) => line['lineId'])
                                            .toSet()
                                            .toList();

                                        return StatusIndicator(lineIds);
                                    }
                                  })
                            ]));
                    }
                  });
          }
        });
  }
}
