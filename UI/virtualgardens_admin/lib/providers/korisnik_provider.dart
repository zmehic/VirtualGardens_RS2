import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:virtualgardens_admin/models/korisnici.dart';
import 'package:virtualgardens_admin/providers/helper_providers/auth_provider.dart';
import 'package:virtualgardens_admin/providers/helper_providers/base_provider.dart';

class KorisnikProvider extends BaseProvider<Korisnik> {
  KorisnikProvider() : super("api/Korisnici");

  @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }

  Future login({dynamic filter, String? username, String? password}) async {
    var endpoint = "api/Korisnici/login?username=$username&password=$password";
    var baseUrl = BaseProvider.baseUrl;

    var url = "$baseUrl$endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);

    var response = await http.post(uri);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      AuthProvider.username = fromJson(data).korisnickoIme;
      AuthProvider.password = password;
      AuthProvider.korisnikId = fromJson(data).korisnikId;

      for (var item in fromJson(data).korisniciUloges) {
        if (item.uloga.naziv == "Admin") {
          break;
        } else {
          throw Exception(
              "Ne možete pristupiti interfejsu kupca putem desktop aplikacije");
        }
      }
    } else {
      throw Exception("Unknown error");
    }
  }
}
