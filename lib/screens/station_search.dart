import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tfl/screens/station_detail_screen.dart';
import 'package:tfl/tfl/api.dart';

class StationSearch extends StatefulWidget {
  @override
  _StationSearchState createState() => _StationSearchState();
}

class _StationSearchState extends State<StationSearch> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  String _selectedCity;

//  String selectedStation;

//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//  final TextEditingController _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
//                    return stations
//                        .where((item) => item['id'].length >= 10)
//                        .toList();
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
