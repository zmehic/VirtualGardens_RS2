import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_admin/models/uloga.dart';
import 'package:virtualgardens_admin/models/zaposlenici.dart';

part 'nalozi.g.dart';

@JsonSerializable()
class Nalog {
  int nalogId;
  String brojNaloga;
  DateTime datumKreiranja;
  int zaposlenikId;
  bool zavrsen;
  Zaposlenik zaposlenik;

  Nalog({
    required this.nalogId,
    required this.brojNaloga,
    required this.datumKreiranja,
    required this.zaposlenikId,
    required this.zavrsen,
    required this.zaposlenik,
  });

  factory Nalog.fromJson(Map<String, dynamic> json) => _$NalogFromJson(json);

  Map<String, dynamic> toJson() => _$NalogToJson(this);
}
