import 'package:virtualgardens_admin/models/ponuda.dart';
import 'package:virtualgardens_admin/providers/helper_providers/base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PonudeProvider extends BaseProvider<Ponuda> {
  PonudeProvider() : super("api/Ponude");

  @override
  Ponuda fromJson(data) {
    return Ponuda.fromJson(data);
  }

  Future allowedActions({int? id}) async {
    var endpoint = "api/Ponude/$id/allowedActions";
    var baseUrl = BaseProvider.baseUrl;

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

  Future ponudeState({String? action, int? id}) async {
    var endpoint = "api/Ponude/$id/$action";
    var baseUrl = BaseProvider.baseUrl;

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
