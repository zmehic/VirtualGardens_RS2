import 'dart:convert';

import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/base_provider.dart';
import 'package:http/http.dart' as http;

class NarudzbaProvider extends BaseProvider<Narudzba> {
  NarudzbaProvider() : super("api/Narudzbe");

  @override
  Narudzba fromJson(data) {
    return Narudzba.fromJson(data);
  }

  Future<List<String>> CheckOrderValidity({int? orderid}) async {
    var endpoint = "api/Narudzbe/CheckOrderValidity/$orderid";

    var url = "${BaseProvider.baseUrl}$endpoint";

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

  Future narudzbeState({String? action, int? id}) async {
    var endpoint = "api/Narudzbe/$id/$action";

    var url = "${BaseProvider.baseUrl}$endpoint";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
    if (isValidResponse(response)) {
    } else {
      throw Exception("Unknown error");
    }
  }
}
