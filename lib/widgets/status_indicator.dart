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
          final lineStatus =
              item['lineStatuses'].removeLast()['statusSeverityDescription'];

          int bgColor = 0xFF66FF00;
          String statusText = 'Good to go';

          switch (lineStatus) {
            case "Minor Delays":
              bgColor = 0xFFFF9900;
              statusText = "Minor delays, consider staying home";
              break;
            case 'Severe Delays':
              bgColor = 0xFFFF3300;
              statusText = "Severe delays, just stay home";
              break;
            case 'Suspended':
            case 'Part Suspended':
              bgColor = 0xFFFF3300;
              statusText = "Suspended, just give up";
              break;
          }

          return Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Color(bgColor)),
                child: Column(
                  children: <Widget>[
                    Text(item['name']),
                    Text(statusText,
                        style:
                            TextStyle(color: Color(0xFF000000), fontSize: 20))
                  ],
                ),
              )
            ],
          );
        });
  }
}
