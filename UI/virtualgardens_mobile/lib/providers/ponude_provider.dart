import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/models/ponuda.dart';
import 'package:virtualgardens_mobile/providers/base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PonudeProvider extends BaseProvider<Ponuda> {
  PonudeProvider() : super("api/Ponude");

  @override
  Ponuda fromJson(data) {
    return Ponuda.fromJson(data);
  }

  Future AllowedActions({int? id}) async {
    var endpoint = "api/Ponude/$id/allowedActions";

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
      throw Exception("Unknown error");
    }
  }

  Future<Narudzba> addOfferToOrder({int? ponudaId, int? narudzbaId}) async {
    var endpoint = "api/Ponude/addOfferToOrder/$ponudaId/$narudzbaId";

    var url = "${BaseProvider.baseUrl}$endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return Narudzba.fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future ponudeState({String? action, int? id}) async {
    var endpoint = "api/Ponude/$id/$action";

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
