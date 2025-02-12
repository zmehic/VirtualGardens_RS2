import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/models/ponuda.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PonudeProvider extends BaseProvider<Ponuda> {
  PonudeProvider() : super("api/Ponude");

  @override
  Ponuda fromJson(data) {
    return Ponuda.fromJson(data);
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
}
