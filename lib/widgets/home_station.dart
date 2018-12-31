import 'package:flutter/material.dart';
import 'package:tfl/models/app_state.dart';
import 'package:tfl/widgets/station_detail.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HomeStation extends StatefulWidget {
  @override
  _HomeStationState createState() => _HomeStationState();
}

class _HomeStationState extends State<HomeStation> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map>(
      converter: (store) {
        return store.state.homeStation;
      },
      builder: (context, homeStation) {

        if (homeStation == null) {
          return Text('');
        }

        return Injector.getInjector().get<StationDetail>(
            additionalParameters: {'stopPoint': homeStation});
      },
    );
  }
}
