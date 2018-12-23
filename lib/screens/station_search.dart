import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tfl/screens/station_detail_screen.dart';
import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/global_actions.dart';

class StationSearch extends StatefulWidget {
  @override
  _StationSearchState createState() => _StationSearchState();
}

class _StationSearchState extends State<StationSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: GlobalActions(context),
          // Here we take the value from the StationSearch object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Search Station"),
        ),
        body: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    autofocus: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Station Name'),
                  ),
                  suggestionsCallback: (pattern) async {
                    final stations =
                        await TflApi().searchStationByName(pattern);

                    return stations;
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion['name']),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => StationDetailScreen(suggestion)));
                  },
                ),
              ],
            )));
  }
}
