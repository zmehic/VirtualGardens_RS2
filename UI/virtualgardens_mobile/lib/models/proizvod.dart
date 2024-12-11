import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_mobile/models/jedinice_mjere.dart';
import 'package:virtualgardens_mobile/models/vrsta_proizvoda.dart';

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
  JediniceMjere? jedinicaMjere;
  VrstaProizvoda? vrstaProizvoda;

  Proizvod(
      {this.proizvodId,
      this.naziv,
      this.opis,
      this.dostupnaKolicina,
      this.slika,
      this.cijena,
      this.vrstaProizvodaId,
      this.jedinicaMjereId,
      this.slikaThumb,
      this.jedinicaMjere,
      this.vrstaProizvoda});

  factory Proizvod.fromJson(Map<String, dynamic> json) =>
      _$ProizvodFromJson(json);

  Map<String, dynamic> toJson() => _$ProizvodToJson(this);
}
