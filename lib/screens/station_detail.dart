import 'package:flutter/material.dart';
import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/status_indicator.dart';

class StationDetail extends StatefulWidget {
  final stopPoint;

  StationDetail(this.stopPoint);

  @override
  _StationDetailState createState() => _StationDetailState();
}

class _StationDetailState extends State<StationDetail> {
  @override
  Widget build(BuildContext context) {
    final lineFuture = TflApi().getLinesByStopPoint(widget.stopPoint['id']);

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the StationSearch object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Station Details"),
        ),
        body: Container(
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          FutureBuilder<List>(
              future: lineFuture,
              // a previously-obtained Future<String> or null
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Text('Finding lines for closest station');
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    final lineIdRegex = new RegExp(r"^[a-zA-Z]+$");

                    final lineIds = snapshot.data
                        .where((line) {
                          final id = line['id'];
                          return lineIdRegex.hasMatch(id);
                        })
                        .map((line) => line['id'])
                        .toSet()
                        .toList();

                    return Column(
                      children: <Widget>[
                        Text(widget.stopPoint['name'] ?? widget.stopPoint['commonName']),
                        StatusIndicator(lineIds)
                      ],
                    );
                }
              })
        ])));
  }
}
