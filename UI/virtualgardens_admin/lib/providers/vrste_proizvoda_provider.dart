import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:virtualgardens_admin/models/jedinice_mjere.dart';
import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_admin/providers/auth_provider.dart';
import 'package:virtualgardens_admin/providers/base_provider.dart';

class VrsteProizvodaProvider extends BaseProvider<VrstaProizvoda> {
  VrsteProizvodaProvider() : super("api/VrsteProizvoda");

  @override
  VrstaProizvoda fromJson(data) {
    // TODO: implement fromJson
    return VrstaProizvoda.fromJson(data);
  }
}
