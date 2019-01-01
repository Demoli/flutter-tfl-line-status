import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tfl/helpers/snakcbar.dart';
import 'package:tfl/models/app_state.dart';
import 'dart:async';

import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/station_detail.dart';

class NearestStation extends StatefulWidget {
  final TflApi api;

  final Geolocator geolocator;

  @override
  _NearestStationState createState() =>
      _NearestStationState(this.api, this.geolocator);

  NearestStation(this.api, this.geolocator);
}

class _NearestStationState extends State<NearestStation> {
  TflApi api;

  Geolocator geolocator;

  bool initialPositionLocked = false;

  Stream<Position> locationFuture;

  Stream<Position> locationUpdate;

  Position lastPosition;

  Map homeStation;

  _NearestStationState(this.api, this.geolocator) {
    locationUpdate = geolocator.getPositionStream(new LocationOptions(
        accuracy: LocationAccuracy.high, distanceFilter: 20));
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

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 15, bottom: 5),
            child: Text('Nearest Station',
                style: Theme.of(context).textTheme.headline)),
        FutureBuilder<List>(
            future: stopPointFuture,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return SnackBarHelper(SnackBar(
                        content: Text(
                            'Failed to load nearest station data, please try again')));
                  }

                  final stopPoints = snapshot.data;

                  if (stopPoints.length == 0) {
                    return Text(
                        "No stations within 2km, please check location settings, or call for a taxi");
                  }

                  final closest = stopPoints.removeAt(0);

                  return StoreConnector<AppState, Map>(
                    converter: (store) => store.state.homeStation,
                    builder: (context, homeStation) {
                      final isHomeStation = homeStation != null &&
                          homeStation['id'] == closest['id'];

                      if (isHomeStation) {
                        return Text('');
                      }

                      return Injector.getInjector().get<StationDetail>(
                          additionalParameters: {'stopPoint': closest});
                    },
                  );
              }
            })
      ],
    );
  }
}
