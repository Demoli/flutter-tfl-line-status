import 'package:flutter/material.dart';
import 'package:tfl/tfl/api.dart';

class StatusIndicator extends StatefulWidget {
  Future<Map> statusFuture;

  StatusIndicator() {
    statusFuture = TflApi().getLineStatus('district');
  }

  @override
  _StatusIndicatorState createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RaisedButton(
          child: Text('Refresh'),
          onPressed: () {
            this.setState(() {
              widget.statusFuture = TflApi().getLineStatus('district');
            });
          },
        ),
        Center(
            child: FutureBuilder<Map>(
                future: widget.statusFuture,
                // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
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
                      final lineStatus = data['lineStatuses']
                          .removeLast()['statusSeverityDescription'];

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

                      return Container(
                        decoration: BoxDecoration(color: Color(bgColor)),
                        child: Text(statusText,
                            style: TextStyle(
                                color: Color(0xFF000000), fontSize: 80)),
                      );
                  }
                  return null; // unreachable
                })),
      ],
    );
  }
}
