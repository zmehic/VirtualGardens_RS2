import 'package:json_annotation/json_annotation.dart';

part 'proizvod.g.dart';

@JsonSerializable()
class Proizvod {
  int? proizvodId;
  String? naziv;
  String? opis;
  int? dostupnaKolicina;
  String? slika;
  double? cijena;
  int? vrstaProizvodaId;
  int? jedinicaMjereId;
  String? slikaThumb;

  Proizvod({this.proizvodId, this.naziv});

  factory Proizvod.fromJson(Map<String, dynamic> json) =>
      _$ProizvodFromJson(json);

  Map<String, dynamic> toJson() => _$ProizvodToJson(this);
}
