library tfl_di;

import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/home_station.dart';
import 'package:tfl/widgets/nearest_station.dart';
import 'package:tfl/widgets/station_detail.dart';
import 'package:tfl/widgets/station_search.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tfl/models/home_station_model.dart';

void configureInjector([String name = "default"]) {
  Injector injector = Injector.getInjector(name);

  // TFL API
  injector.map<TflApi>((i) => new TflApi(), isSingleton: true);

  // Models
  injector.map<HomeStationModel>((i) => new HomeStationModel(),
      isSingleton: true);

  // widgets
  injector.map<NearestStation>((i) => new NearestStation(
      i.get<TflApi>(), new Geolocator(), i.get<HomeStationModel>()));
  injector.map<StationSearch>((i) => new StationSearch(i.get<TflApi>()));
  injector.map<HomeStation>((i) => new HomeStation(i.get<HomeStationModel>()));

  injector.mapWithParams<StationDetail>((i, p) => new StationDetail(
      p['stopPoint'], p['homeStationModel'] ?? i.get<HomeStationModel>()));
}