import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_mobile/models/narudzbe.dart';
import 'package:virtualgardens_mobile/models/zaposlenici.dart';

part 'nalozi.g.dart';

@JsonSerializable()
class Nalog {
  int nalogId;
  String brojNaloga;
  DateTime datumKreiranja;
  int zaposlenikId;
  bool zavrsen;
  Zaposlenik? zaposlenik;
  List<Narudzba> narudzbes;

  Nalog({
    required this.nalogId,
    required this.brojNaloga,
    required this.datumKreiranja,
    required this.zaposlenikId,
    required this.zavrsen,
    this.zaposlenik,
    this.narudzbes = const [],
  });

  factory Nalog.fromJson(Map<String, dynamic> json) => _$NalogFromJson(json);

  Map<String, dynamic> toJson() => _$NalogToJson(this);
}
