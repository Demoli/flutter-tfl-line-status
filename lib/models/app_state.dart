import 'dart:convert';

class AppState {
  Map homeStation;

  Map previousHomeStation;

  List favourites;

  AppState({this.homeStation, this.previousHomeStation, this.favourites}) {
    if (favourites == null) {
      this.favourites = List();
    }
  }

  static AppState fromJson(dynamic json) {
    if (json == null) {
      return AppState();
    }
    return AppState(
        homeStation: jsonDecode(json["homeStation"]),
        favourites: json['favourites'] != null ? jsonDecode(json['favourites']) : []);
  }

  dynamic toJson() {
    return {
      'homeStation': jsonEncode(homeStation),
      'favourites': jsonEncode(favourites)
    };
  }

  copyWith({Map homeStation, Map previousHomeStation, List favourites}) {
    return AppState(
        homeStation: homeStation ?? this.homeStation,
        previousHomeStation: previousHomeStation,
        favourites: favourites ?? this.favourites);
  }
}
