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

  bool initialPositionLocked = false;

  Stream<Position> locationFuture;

  Stream<Position> locationUpdate;

  Position lastPosition;

  final HomeStationModel homeStationModel;

  Map homeStation;

  _NearestStationState(this.api, this.geolocator, this.homeStationModel) {
    locationUpdate = geolocator.getPositionStream(new LocationOptions(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20));
  }

  @override
  void initState() {
    locationUpdate.listen((position) {
      final samePosition = lastPosition != null &&
          (position.latitude == lastPosition.latitude &&
              position.longitude == lastPosition.longitude);

      if (initialPositionLocked && !samePosition) {
        lastPosition = position;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    homeStationModel.get().then((onValue) {
      homeStation = onValue;
    });

    locationFuture = geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .asStream();

    return StreamBuilder<Position>(
        stream: locationFuture,
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

              initialPositionLocked = true;

              final position = snapshot.data;

              return renderStopPoints(position);
          }
        });
  }

  Widget renderStopPoints(Position position) {
    final stopPointFuture =
        api.getStopPointsByLocation(position.latitude, position.longitude);

    return FutureBuilder<List>(
        future: stopPointFuture,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
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

              if (homeStation != null && closest['id'] == homeStation['id']) {
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
}
