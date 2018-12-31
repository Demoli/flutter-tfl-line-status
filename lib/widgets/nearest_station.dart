import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tfl/models/home_station_model.dart';
import 'dart:async';

import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/station_detail.dart';

class NearestStation extends StatefulWidget {
  final TflApi api;

  final Geolocator geolocator;

  final HomeStationModel homeStationModel;

  @override
  _NearestStationState createState() =>
      _NearestStationState(this.api, this.geolocator, this.homeStationModel);

  NearestStation(this.api, this.geolocator, this.homeStationModel);
}

class _NearestStationState extends State<NearestStation> {
  TflApi api;

  Geolocator geolocator;

  Future<Position> locationFuture;

  final HomeStationModel homeStationModel;

  Map homeStation;

  _NearestStationState(this.api, this.geolocator, this.homeStationModel);

  @override
  Widget build(BuildContext context) {
    homeStationModel.get().then((onValue) {
      homeStation = onValue;
    });

    locationFuture =
        geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

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

                        if (homeStation != null &&
                            closest['id'] == homeStation['id']) {
                          return Text('');
                        }

                        return Injector.getInjector().get<StationDetail>(
                            additionalParameters: {
                              'stopPoint': closest,
                              'homeStationModel': homeStationModel
                            });
                    }
                  });
          }
        });
  }
}
