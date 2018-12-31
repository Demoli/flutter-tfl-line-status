import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tfl/tfl/api.dart';

class StatusIndicator extends StatefulWidget {
  final List lineIds;

  final TflApi api;

  StatusIndicator(this.lineIds, {this.api});

  @override
  _StatusIndicatorState createState() => _StatusIndicatorState(this.lineIds, (this.api ?? TflApi()));
}

class Expandable {
  bool isExpanded = false;
  Map data;

  Expandable(this.data);
}

class _StatusIndicatorState extends State<StatusIndicator> {
  final lineIds;

  TflApi api;

  List items = [];

  bool snapshotLoaded = false;

  static Timer refresh;

  static Future<List> statusFuture;

  _StatusIndicatorState(this.lineIds, this.api) {
    initFuture();

    if (refresh == null) {
      refresh = new Timer.periodic(Duration(minutes: 30), (Timer t) {
        reloadFuture();
      });
    }
  }

  void initFuture() {
    statusFuture = api.getLineStatus(lineIds);
  }

  void reloadFuture() {
    initFuture();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: statusFuture,
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

              if (!snapshotLoaded) {
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
                children: <Widget>[
                  Text(reasons.length > 0
                      ? reasons.join('\n\n')
                      : 'Good Service')
                ],
              ),
            )
          ],
        ));
  }
}
