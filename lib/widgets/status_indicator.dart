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

class Expandable {
  bool isExpanded = false;
  Map data;

  Expandable(this.data);
}

class _StatusIndicatorState extends State<StatusIndicator> {
  List items = [];

  bool snapshotLoaded = false;

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
              snapshotLoaded = false;
              return Text('Awaiting result...');
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshotLoaded) {
                final data = snapshot.data;

                snapshot.data.forEach((item) {
                  items.add(Expandable(item));
                });
                snapshotLoaded = true;
              }

              return ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    items[index].isExpanded = !items[index].isExpanded;
                  });
                },
                children: items.map((item) {
                  return createListView(item);
                }).toList(),
              );
          }
        });
  }

  ExpansionPanel createListView(Expandable expandable) {
    final item = expandable.data;

    if (item == null) {
      return null;
    }

    int bgColor = 0XFF76FF03;
    bool showWarning = false;

    final lineStatuses = item['lineStatuses'];
    List reasons = [];

    lineStatuses.forEach((status) {
      if (status['statusSeverityDescription'] != 'Good Service') {
        bgColor = 0XFFB71C1C;
        showWarning = true;
        reasons.add(status['reason']);
      }
    });

    return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return GestureDetector(
              onTap: () {
                expandable.isExpanded = !expandable.isExpanded;
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    item['name'],
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                (showWarning
                    ? Icon(
                        Icons.warning,
                        color: Color(bgColor),
                      )
                    : Icon(
                        Icons.check,
                        color: Color(bgColor),
                      ))
              ]));
        },
        isExpanded: expandable.isExpanded,
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[Text(reasons.join('\n\n'))],
              ),
            )
          ],
        ));
  }
}
