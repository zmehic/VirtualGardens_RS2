import 'dart:convert';
import 'package:virtualgardens_admin/models/narudzbe.dart';
import 'package:virtualgardens_admin/models/statistics_dtos/statistics.dart';
import 'package:virtualgardens_admin/providers/helper_providers/base_provider.dart';
import 'package:http/http.dart' as http;

class NarudzbaProvider extends BaseProvider<Narudzba> {
  NarudzbaProvider() : super("api/Narudzbe");

  @override
  Narudzba fromJson(data) {
    return Narudzba.fromJson(data);
  }

  Future allowedActions({int? id}) async {
    var endpoint = "api/Narudzbe/$id/allowedActions";
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

  Future monthlyStatistics({int year = 2024}) async {
    var endpoint = "api/Narudzbe/MonthlyStatistics?year=$year";
    var baseUrl = BaseProvider.baseUrl;

    var url = "$baseUrl$endpoint";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      StatisticsDTO statisticsDTO = StatisticsDTO.fromJson(data);

      return statisticsDTO;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future narudzbeState({String? action, int? id}) async {
    var endpoint = "api/Narudzbe/$id/$action";
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
