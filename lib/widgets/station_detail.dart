import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tfl/helpers/snakcbar.dart';
import 'package:tfl/models/app_state.dart';
import 'package:tfl/redux/actions.dart';
import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/status_indicator.dart';

class StationDetail extends StatefulWidget {
  final stopPoint;

  StationDetail(this.stopPoint);

  @override
  _StationDetailState createState() => _StationDetailState();
}

class _StationDetailState extends State<StationDetail> {
  _StationDetailState();

  BuildContext _snackBarContext;



  @override
  Widget build(BuildContext context) {
    _snackBarContext = context;

    final lineFuture = TflApi().getLinesByStopPoint(widget.stopPoint['id']);

    return Container(
        child: ListView(shrinkWrap: true, children: <Widget>[
      Card(
        child: Column(
          children: <Widget>[
            StoreConnector<AppState, Map>(
              converter: (store) => store.state.homeStation,
              builder: (context, homeStation) {
                final isHomeStation = homeStation != null &&
                    homeStation['id'] == widget.stopPoint['id'];

                return ListView(shrinkWrap: true, children: <Widget>[
                  ListTile(
                    leading: isHomeStation
                        ? Icon(Icons.home)
                        : Icon(Icons.location_on),
                    title: Text(widget.stopPoint['name'] ??
                        widget.stopPoint['commonName']),
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
                        return SnackBarHelper(SnackBar(content: Text('Failed to load line data, please try again')));
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
        return RaisedButton(
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
                    },
                    builder: (context, UndoHomeStationCallback callback) {
                      return FlatButton(child: Text('Undo'), onPressed: () {
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
