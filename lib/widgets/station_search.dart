import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tfl/screens/station_detail_screen.dart';
import 'package:tfl/tfl/api.dart';

class StationSearch extends StatefulWidget {
  final TflApi api;

  StationSearch(this.api);

  @override
  _StationSearchState createState() => _StationSearchState(this.api);
}

class _StationSearchState extends State<StationSearch> {
  TflApi api;

  _StationSearchState(this.api);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Station Name'),
              ),
              suggestionsCallback: (pattern) async {
                final stations = await api.searchStationByName(pattern);

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
        ));
  }
}
