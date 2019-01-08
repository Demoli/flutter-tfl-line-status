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
    return StoreConnector<AppState, List>(
      converter: (store) {
        return store.state.favourites;
      },
      builder: (context, favourites) {
        if (Favourites == null || favourites.length == 0) {
          return Center(
            child: Text('No Favourites'),
          );
        }

        return Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: favourites.length,
              itemBuilder: (context, index) {
                return Injector.getInjector().get<StationDetail>(
                    additionalParameters: {'stopPoint': favourites[index]});
              }),
        );
      },
    );
  }
}
