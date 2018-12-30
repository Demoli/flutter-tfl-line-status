library tfl_di;

import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/nearest_station.dart';
import 'package:tfl/widgets/station_detail.dart';
import 'package:tfl/widgets/station_search.dart';
import 'package:geolocator/geolocator.dart';

void configureInjector([String name = "default"]) {
  Injector injector = Injector.getInjector(name);

  // TFL API
  injector.map<TflApi>((i) => new TflApi(), isSingleton: true);

  // widgets
  injector.map<NearestStation>((i) => new NearestStation(i.get<TflApi>(), new Geolocator()));
  injector.map<StationSearch>((i) => new StationSearch(i.get<TflApi>()));
}
