import 'dart:convert';

class AppState {
  final Map homeStation;

  final Map previousHomeStation;

  AppState({this.homeStation, this.previousHomeStation});

  static AppState fromJson(dynamic json) {
    if (json == null) {
      return AppState();
    }
    return AppState(homeStation: jsonDecode(json["homeStation"]));
  }

  dynamic toJson() => {'homeStation': jsonEncode(homeStation)};
}
