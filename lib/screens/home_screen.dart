import 'package:flutter/material.dart';
import 'package:tfl/widgets/favourites.dart';
import 'package:tfl/widgets/home_station.dart';
import 'package:tfl/widgets/nearest_station.dart';
import 'package:tfl/widgets/station_search.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              // Here we take the value from the HomeScreen object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text("Home and Nearest Stations"),
              bottom: TabBar(tabs: [
                Tab(child: Text('Home')),
                Tab(child: Text('Nearest')),
                Tab(child: Text('Favourites')),
              ]),
            ),
            body: TabBarView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Injector.getInjector().get<StationSearch>(),
                    Injector.getInjector().get<HomeStation>(),
                  ],
                ),
                Injector.getInjector().get<NearestStation>(),
                Column(
                  children: <Widget>[
                    Injector.getInjector().get<StationSearch>(),
                    Injector.getInjector().get<Favourites>(),
                  ],
                ),
              ],
            )));
  }
}
