import 'package:flutter/material.dart';
import 'package:tfl/models/home_station.dart';
import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/status_indicator.dart';

class StationDetail extends StatefulWidget {
  final stopPoint;

  StationDetail(this.stopPoint);

  @override
  _StationDetailState createState() => _StationDetailState();
}

class _StationDetailState extends State<StationDetail> {
  bool isHomeStation = false;

  Future<Map> homeStationFuture;

  @override
  Widget build(BuildContext context) {
    final lineFuture = TflApi().getLinesByStopPoint(widget.stopPoint['id']);

    homeStationFuture = HomeStation().get();

    homeStationFuture.then((onValue) {
      if (onValue != null) {
        if (onValue['id'] == widget.stopPoint['id']) {
          isHomeStation = true;
        }
      }
    });

    return Container(
        child: ListView(shrinkWrap: true, children: <Widget>[
      Card(
        child: Column(
          children: <Widget>[
            FutureBuilder<Map>(
                future: homeStationFuture,
                builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return ListView(shrinkWrap: true, children: <Widget>[
                        ListTile(
                          leading: isHomeStation ? Icon(Icons.home) : null,
                          title: Text(widget.stopPoint['name'] ??
                              widget.stopPoint['commonName']),
                        ),
                        buildHomeButton(context),
                      ]);
                  }
                }),
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
                        return Text('Error: ${snapshot.error}');
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

  buildHomeButton(BuildContext context) {
    if (isHomeStation) {
      return Text('');
    }

    return RaisedButton(
        child: Text('Set as home station'),
        onPressed: () {
          HomeStation().set(widget.stopPoint);

          final snackBar = SnackBar(content: Text('Station saved'));
          Scaffold.of(context).showSnackBar(snackBar);
        });
  }
}
