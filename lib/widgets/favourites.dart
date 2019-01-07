import 'package:flutter/material.dart';
import 'package:tfl/models/app_state.dart';
import 'package:tfl/widgets/station_detail.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map>(
      converter: (store) {
//        return store.state.favourites;
      },
      builder: (context, Favourites) {

        if (Favourites == null) {
          return Text('');
        }

        return Injector.getInjector().get<StationDetail>(
            additionalParameters: {'stopPoint': Favourites});
      },
    );
  }
}
