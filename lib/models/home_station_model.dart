import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomeStationModel {
  Future<Map> get() async {
    Map station;

    try {
      await SharedPreferences.getInstance().then((onValue) {
        final stationString = onValue.getString('home_station');
        if (stationString != null) {
          station = jsonDecode(stationString);
        }
      });
    } catch (exception, stacktrace) {
      throw exception;
    }

    return station;
  }

  set(Map station) async {
    await SharedPreferences.getInstance().then((onValue) {
      onValue.setString('home_station', jsonEncode(station));
    });
  }
}
