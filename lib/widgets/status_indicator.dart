import 'package:flutter/material.dart';
import 'package:tfl/tfl/api.dart';

class StatusIndicator extends StatefulWidget {
  Future<List> statusFuture;
  List stationIds;

  StatusIndicator(List stationIds) {
    statusFuture = TflApi().getLineStatus(stationIds);

    this.stationIds = stationIds;
  }

  @override
  _StatusIndicatorState createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: widget.statusFuture,
        // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('Awaiting result...');
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final data = snapshot.data;

              return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [createListView(data)]);
          }
        });
  }

  Widget createListView(List data) {
    return ListView.builder(
        itemCount: data.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final item = data[index];
          final lineStatus = item['lineStatuses'].removeLast();

          final severity = lineStatus['statusSeverityDescription'];

          int bgColor = 0XFF76FF03;
          int txtColor = 0XFF000000;

          switch (severity) {
            case "Minor Delays":
            case 'Severe Delays':
            case 'Suspended':
            case 'Part Suspended':
            case 'Part Closure':
              bgColor = 0XFFB71C1C;
              txtColor = 0XFFFFFFFF;
              break;
          }

          return Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Color(bgColor)),
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Text(item['name'],
                        style:
                            TextStyle(color: Color(txtColor), fontSize: 20)),
                    Text(severity,
                        style:
                            TextStyle(color: Color(txtColor), fontSize: 25)),
                    Text(lineStatus['reason'] ?? "",
                        style:
                            TextStyle(color: Color(0xFFFFFFFF), fontSize: 15))
                  ],
                ),
              )
            ],
          );
        });
  }
}
