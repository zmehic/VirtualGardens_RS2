import 'dart:convert';

import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class NarudzbaProvider extends BaseProvider<Narudzba> {
  NarudzbaProvider() : super("api/Narudzbe");

  @override
  Narudzba fromJson(data) {
    return Narudzba.fromJson(data);
  }

  Future AllowedActions({int? id}) async {
    var endpoint = "api/Narudzbe/$id/allowedActions";
    var baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://10.0.2.2:7011/");

    var url = "$baseUrl$endpoint";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    List<String> lista = [];
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      for (var element in data) {
        lista.add(element.toString());
      }

      return lista;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<List<String>> CheckOrderValidity({int? orderid}) async {
    var endpoint = "api/Narudzbe/CheckOrderValidity/$orderid";
    var baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://10.0.2.2:7011/");

    var url = "$baseUrl$endpoint";

    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);
    List<String> lista = [];
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      for (var element in data) {
        lista.add(element.toString());
      }

      return lista;
    } else {
      throw Exception("Error with checking validity");
    }
  }

  Future MonthlyStatistics({int year = 2024}) async {
    var endpoint = "api/Narudzbe/MonthlyStatistics?year=${year}";
    var baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://localhost:7011/");

    var url = "$baseUrl$endpoint";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    List<int> lista = [];
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      for (var element in data) {
        lista.add(element);
      }

      return lista;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future narudzbeState({String? action, int? id}) async {
    var endpoint = "api/Narudzbe/$id/$action";
    var baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://10.0.2.2:7011/");

    var url = "$baseUrl$endpoint";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
    if (isValidResponse(response)) {
    } else {
      throw Exception("Unknown error");
    }
  }
}
