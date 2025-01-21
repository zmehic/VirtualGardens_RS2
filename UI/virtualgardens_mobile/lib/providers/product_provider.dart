import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:virtualgardens_mobile/models/proizvod.dart';
import 'package:virtualgardens_mobile/providers/base_provider.dart';

class ProductProvider extends BaseProvider<Proizvod> {
  ProductProvider() : super("Proizvodi");

  @override
  Proizvod fromJson(data) {
    return Proizvod.fromJson(data);
  }

  Future recalculatequantiy() async {
    var endpoint = "Proizvodi/recalculate";
    var baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://localhost:7011/");

    var url = "$baseUrl$endpoint";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
    } else {
      throw Exception("Unknown error");
    }
    // print("response: ${response.request} ${response.statusCode}, ${response.body}");
  }

  Future<List<Proizvod>> recommend(int id) async {
    var endpoint = "Proizvodi/$id/recommend";
    var baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://10.0.2.2:7011/");

    var url = "$baseUrl$endpoint";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    List<Proizvod> lista = [];
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      for (var element in data) {
        lista.add(Proizvod.fromJson(element));
      }

      return lista;
    } else {
      throw Exception("Unknown error");
    }
  }
}
