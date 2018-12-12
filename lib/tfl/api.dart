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

  Future<http.Response> _getRequest(path, {Map<String, String> params}) {
    if (params == null) {
      params = {};
    }
    params.addAll({'app_id': appId, 'app_key': appKey});

    final uri = Uri.https(url, path, params);
    final headers = {'Content-Type': 'application/json'};

    return http.get(uri, headers: headers);
  }
}
