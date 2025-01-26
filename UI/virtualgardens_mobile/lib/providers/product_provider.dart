import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:virtualgardens_mobile/models/proizvod.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/base_provider.dart';

class ProductProvider extends BaseProvider<Proizvod> {
  ProductProvider() : super("Proizvodi");

  @override
  Proizvod fromJson(data) {
    return Proizvod.fromJson(data);
  }

  Future<List<Proizvod>> recommend(int id) async {
    var endpoint = "Proizvodi/$id/recommend";

    var url = "${BaseProvider.baseUrl}$endpoint";

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
