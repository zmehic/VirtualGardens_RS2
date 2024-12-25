import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:virtualgardens_mobile/models/korisnici.dart';
import 'package:virtualgardens_mobile/providers/auth_provider.dart';
import 'package:virtualgardens_mobile/providers/base_provider.dart';

class KorisnikProvider extends BaseProvider<Korisnik> {
  KorisnikProvider() : super("api/Korisnici");

  @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }

  Future login({dynamic filter, String? username, String? password}) async {
    var endpoint = "api/Korisnici/login?username=$username&password=$password";
    var baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://10.0.2.2:7011/");

    var url = "$baseUrl$endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      AuthProvider.username = fromJson(data).korisnickoIme;
      AuthProvider.password = password;
      AuthProvider.korisnikId = fromJson(data).korisnikId;

      for (var item in fromJson(data).korisniciUloges) {
        if (item.uloga.naziv == "Kupac") {
          break;
        } else {
          throw Exception("Not authorized");
        }
      }
    } else {
      throw Exception("Unknown error");
    }
    // print("response: ${response.request} ${response.statusCode}, ${response.body}");
  }
}
