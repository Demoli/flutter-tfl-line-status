import 'package:flutter/material.dart';
import 'package:tfl/widgets/global_actions.dart';

class SandboxScreen extends StatefulWidget {
  @override
  _SandboxScreenState createState() => _SandboxScreenState();
}

class _SandboxScreenState extends State<SandboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: GlobalActions(context),
          // Here we take the value from the HomeScreen object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Sandbox"),
        ),
        body: Sandbox());
  }
}

class Sandbox extends StatefulWidget {
  @override
  _SandboxState createState() => _SandboxState();
}

class MyItem {
  MyItem({this.isExpanded: false, this.header, this.body});

  bool isExpanded;
  final String header;
  final String body;
}

class _SandboxState extends State<Sandbox> {
  List<MyItem> _items = <MyItem>[new MyItem(header: 'header', body: 'body')];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
          ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                FlatButton(
                  child: const Text('LISTEN'),
                  onPressed: () {
                    /* ... */
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
//  Widget build(BuildContext context) {
//    return new ListView(
//      children: [
//        ExpansionPanelList(
//          expansionCallback: (int index, bool isExpanded) {
//            setState(() {
//              _items[index].isExpanded = !_items[index].isExpanded;
//            });
//          },
//          children: _items.map((MyItem item) {
//            return new ExpansionPanel(
//              headerBuilder: (BuildContext context, bool isExpanded) {
//                return GestureDetector(onTap: () {
//                  item.isExpanded = !item.isExpanded;
//                  setState(() {
//
//                  });
//                },
//                    child: Text(item.header)
//                );
//              },
//              isExpanded: item.isExpanded,
//              body: new Container(
//                child: new Text("body"),
//              ),
//            );
//          }).toList(),
//        ),
//      ],
//    );
//  }
}
