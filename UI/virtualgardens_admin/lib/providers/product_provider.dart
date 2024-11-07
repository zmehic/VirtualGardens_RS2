import 'package:http/http.dart' as http;
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/providers/base_provider.dart';

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
}
