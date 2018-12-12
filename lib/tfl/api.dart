import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:core';
import 'dart:async';

class TflApi {
  final String url = "api.tfl.gov.uk";

  final String appId = 'fe639503';

  final String appKey = 'fbe79c3976b5e59d5bea01312932bcab';

  Future<Map> getLineStatus(String id) async {
    final response = await this._getRequest('/line/district/status');

    final Map result = jsonDecode(response.body).removeLast();

    return result;
  }

  Future<List> getStopPoints(lat, lon) async {
    try {
      final geoParams = {
        'stopTypes': 'NaptanMetroStation',
        'lat': lat.toString(),
        'lon': lon.toString(),
        'radius': '2000'
      };
      final response = await this._getRequest('/StopPoint', params: geoParams);
      final result = jsonDecode(response.body);
      return result['stopPoints'];
    } catch (error) {
      throw error;
    }
  }

  Future<List> getLinesByStopPoint(String naptanId) async {
    try {
      final response = await this._getRequest('/StopPoint/$naptanId/Route');
      final result = jsonDecode(response.body);
      return result['stopPoints'];
    } catch (error) {
      throw error;
    }
  }

  Future<http.Response> _getRequest(path, {Map<String, String> params}) {
    if (params == null) {
      params = {};
    }
    params.addAll({'app_id': appId, 'app_key': appKey});

    final uri = Uri.https(url, path, params);
    final headers = {'Content-Type': 'application/json'};

    final request = http.get(uri, headers: headers);

    request.catchError((error) {
      throw error;
    });

    return request;
  }
}
