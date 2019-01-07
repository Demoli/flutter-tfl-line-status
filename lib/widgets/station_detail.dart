import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tfl/helpers/snakcbar.dart';
import 'package:tfl/models/app_state.dart';
import 'package:tfl/redux/actions.dart';
import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/status_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class StationDetail extends StatefulWidget {
  final stopPoint;

  StationDetail(this.stopPoint);

  @override
  _StationDetailState createState() => _StationDetailState();
}

class _StationDetailState extends State<StationDetail> {
  _StationDetailState();

  @override
  void initState() {
    // refresh every 30 seconds
    Timer(Duration(seconds: 30), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final lineFuture = TflApi().getLinesByStopPoint(widget.stopPoint['id']);

    return Container(
        child: Column(children: <Widget>[
      Card(
        child: Column(
          children: <Widget>[
            StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, appState) {
                final homeStation = appState.homeStation;
                final isHomeStation = homeStation != null &&
                    homeStation['id'] == widget.stopPoint['id'];

                final isFavourite = appState.favourites
                        .where((favourite) {
                          return widget.stopPoint['id'] == favourite['id'];
                        })
                        .toList()
                        .length >
                    0;

                return Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            width: 150,
                            child: Text(widget.stopPoint['name'] ??
                                widget.stopPoint['commonName'])),
                        Container(
                          width: 50,
                          child: FlatButton(
                            child: Icon(Icons.directions),
                            onPressed: () async {
                              final lat = widget.stopPoint['lat'];
                              final lon = widget.stopPoint['lon'];
                              final url =
                                  "https://www.google.com/maps/dir/?api=1&destination=$lat,$lon&travelmode=walking";
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                        ),
                        Container(
                          width: 50,
                          child: FlatButton(
                            child: Icon(Icons.refresh),
                            onPressed: () async {
                              setState(() {});
                            },
                          ),
                        ),
                        Container(
                            width: 50,
                            child: StoreConnector<AppState,
                                toggleFavouriteCallback>(
                              converter: (store) {
                                return (favourite) =>
                                    store.dispatch(ToggleFavourite(favourite));
                              },
                              builder:
                                  (context, toggleFavouriteCallback callback) {
                                return FlatButton(
                                  child: isFavourite
                                      ? Icon(Icons.favorite)
                                      : Icon(Icons.favorite_border),
                                  onPressed: () async {
                                    callback(widget.stopPoint);
                                  },
                                );
                              },
                            )),
                      ],
                    ),
                  ),
                  buildHomeButton(context, isHomeStation),
                ]);
              },
            ),
            FutureBuilder<List>(
                future: lineFuture,
                // a previously-obtained Future<String> or null
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
                                'Failed to load line data, please try again')));
                      }

                      final lineIdRegex = new RegExp(r"^[a-zA-Z-]+$");

                      final lineIds = snapshot.data
                          .where((line) {
                            final id = line['id'];
                            return lineIdRegex.hasMatch(id);
                          })
                          .map((line) => line['id'])
                          .toSet()
                          .toList();

                      return StatusIndicator(lineIds);
                  }
                })
          ],
        ),
      ),
    ]));
  }

  buildHomeButton(BuildContext context, bool isHomeStation) {
    if (isHomeStation) {
      return Text('');
    }
    return StoreConnector<AppState, SetHomeStationCallback>(
      converter: (store) {
        return (age) => store.dispatch(SetHomeStation(age));
      },
      builder: (context, SetHomeStationCallback callback) {
        return FlatButton(
          child: Text('Set as home station'),
          onPressed: () {
            callback(widget.stopPoint);
            final snackBar = SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Home Station Saved'),
                StoreConnector<AppState, UndoHomeStationCallback>(
                    converter: (store) {
                  return () => store.dispatch(UndoHomeStation());
                }, builder: (context, UndoHomeStationCallback callback) {
                  return FlatButton(
                      child: Text('Undo'),
                      onPressed: () {
                        callback();
                      });
                })
              ],
            ));
            Scaffold.of(context).showSnackBar(snackBar);
          },
        );
      },
    );
  }
}

typedef SetHomeStationCallback = Function(Map homeStation);
typedef UndoHomeStationCallback = Function();
typedef toggleFavouriteCallback = Function(Map station);
