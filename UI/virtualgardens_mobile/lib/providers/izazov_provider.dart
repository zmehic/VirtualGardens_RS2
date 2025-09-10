import 'package:virtualgardens_mobile/models/izazov.dart';
import 'package:virtualgardens_mobile/models/izazov_kategorija.dart';
import 'package:virtualgardens_mobile/models/recenzija.dart';
import 'package:virtualgardens_mobile/models/statistika.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/base_provider.dart';
import 'dart:convert';

import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/base_provider.dart';
import 'package:http/http.dart' as http;

class IzazovProvider extends BaseProvider<Izazov> {
  IzazovProvider() : super("api/Izazovi");

  @override
  Izazov fromJson(data) {
    return Izazov.fromJson(data);
  }

  Future<List<IzazovKategorija>> getKategorije() async {
    var endpoint = "api/Izazovi/izazovi";

    var url = "${BaseProvider.baseUrl}$endpoint";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<IzazovKategorija> result = [];

      for (var item in data) {
        result.add(IzazovKategorija.fromJson(item));
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
    // print("response: ${response.request} ${response.statusCode}, ${response.body}");
  }

  Future<List<Statistika>> getStatistika({dynamic filter}) async {
    var endpoint = "api/Izazovi/statistika";

    var url = "${BaseProvider.baseUrl}$endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<Statistika> result = [];

      for (var item in data) {
        result.add(Statistika.fromJson(item));
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
    // print("response: ${response.request} ${response.statusCode}, ${response.body}");
  }

  Future<bool> duplicate({dynamic request}) async {
    var endpoint = "api/Izazovi/duplicate";

    var url = "${BaseProvider.baseUrl}$endpoint";

    if (request != null) {
      var queryString = getQueryString(request);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception("Unknown error");
    }
    // print("response: ${response.request} ${response.statusCode}, ${response.body}");
  }

  Future<bool> insertIzazov(dynamic request) async {
    var endpoint = "api/Izazovi/peer";

    var url = "${BaseProvider.baseUrl}$endpoint";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<bool> end({dynamic request}) async {
    var endpoint = "api/Izazovi/end";

    var url = "${BaseProvider.baseUrl}$endpoint";

    if (request != null) {
      var queryString = getQueryString(request);
      url = "$url?$queryString";
    }
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<bool> begin({dynamic request}) async {
    var endpoint = "api/Izazovi/begin";

    var url = "${BaseProvider.baseUrl}$endpoint";

    if (request != null) {
      var queryString = getQueryString(request);
      url = "$url?$queryString";
    }
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Unknown error");
    }
  }
}
